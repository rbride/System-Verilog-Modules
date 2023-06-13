`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride 
// Create Date: 05/15/2023 08:21:31 PM
// Design Name: 40G/100Gb PCS 64 Bit Parallel Scrambler
// Module Name: Descrambler_64bit
// Revision: 2
// Description: 
//      Rebase off of Alex Forencich Paramatized LSFR Applied for 
//      64 bit parallel g(x) = x^58 + x^39 + 1 scrambling and descrambling
//
//////////////////////////////////////////////////////////////////////////////////

/*
    Standard LFSR (Srambler)
        DIN (LSB first)
         |
         V
        (+)<---------------------------(+)<-----------------------------.
         |                              ^                               |
         |  .----.  .----.       .----. |  .----.       .----.  .----.  |
         +->|  0 |->|  1 |->...->| 38 |-+->| 39 |->...->| 56 |->| 57 |--'
         |  '----'  '----'       '----'    '----'       '----'  '----'
         V
        DOUT

    FEED Forward LFSR (Descrambler)
        DIN (LSB first)
         |
         |  .----.  .----.       .----.    .----.       .----.  .----.
         +->|  0 |->|  1 |->...->| 38 |-+->| 39 |->...->| 56 |->| 57 |--.
         |  '----'  '----'       '----' |  '----'       '----'  '----'  |
         |                              V                               |
        (+)<---------------------------(+)------------------------------'
         |
         V
        DOUT
*/

module Descrambler_64bit(
    input CLK,
    input rst,
    input wire [63:0] Sr_In, //Scrambled Data as input
    output wire [63:0] D_UnS  //The Unscrambled data as the output
    );
    
    reg [57:0] lfsr_state_reg; //The Saved state of the 
    wire [57:0] lfsr_state_out; //Output of those registers

    //Initialize the Sub Module Parallel Lfsr
    Parallel_LFSR #( 
            .DATA_WIDTH(64),
            .FEED_FORWARD(1)
    )
    Descramb_Inst (
        .data_in(Sr_In),
        .data_out(D_UnS),
        .lfsr_state_in(lfsr_state_reg),
        .lfsr_state_out(lfsr_state_out)
    );

    //Set State in of LFSR to State Out every posedge CLK
    always @(posedge CLK) begin
        lfsr_state_reg <= lfsr_state_out;
    end


endmodule

//Set FEED_FORWARD to 0 (off) for scrambling, 1 for Descrambling
//LFSR_WIDTH localparam because always g(x) = x^58 + x^39 + 1
module Parallel_LFSR #(
    parameter DATA_WIDTH = 64,
    parameter FEED_FORWARD = 0,  
    localparam LFSR_WIDTH = 58
)(
    input wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    input wire [LFSR_WIDTH-1:0] lfsr_state_in,
    output wire [LFSR_WIDTH-1:0] lfsr_state_out
);

//Works in two parts: statically computes a set of bit masks, then uses these bit masks to
//select bits for XORing to compute the next state.  
function [LFSR_WIDTH+DATA_WIDTH-1:0] lfsr_mask(input [31:0] index);
    reg [LFSR_WIDTH-1:0] lfsr_mask_state_in [LFSR_WIDTH-1:0]; //[0-57][0-57] array
    reg [DATA_WIDTH-1:0] lfsr_mask_data [LFSR_WIDTH-1:0];
    reg [LFSR_WIDTH-1:0] mask_output_state[DATA_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] mask_output_data[DATA_WIDTH-1:0];

    reg [LFSR_WIDTH-1:0] state_value;
    reg [DATA_WIDTH-1:0] data_value;

    reg [DATA_WIDTH-1:0] data_mask;

    interger i, j; //Index for arrays

    begin 
        //initialize bit masks
        for ( i=0; i<LFSR_WIDTH; i++ ) begin
            lfsr_mask_state_in[i] = 0;
            lfsr_mask_state_in[i][i] = 1'b1;
            lfsr_mask_data[i] = 0;
        end
        for ( i=0; i<DATA_WIDTH; i++ ) begin
            mask_output_state[i] = 0;
            if ( i<LFSR_WIDTH ) begin
                mask_output_state[i][i] = 1'b1;
            end
            output_mask_data[i] = 0;
        end

        //Shift register work
        for ( data_mask = {1'b1, {DATA_WIDTH-1{1'b0}}}; data_mask != 0; data_mask = data_mask >> 1) begin
            //Determine shif in value, if val in last FF xor with input data bit (Assumes MSB)
            state_value = lfsr_mask_state_in[LFSR_WIDTH-1];
            data_value = lfsr_mask_data[LFSR_WIDTH-1];
            data_value = data_value ^ data_mask;

            // LFSR_Poly = 58'h8000000001 1 at the end for the +1 8 is for + 38 the highest val ignored
            localparam Polynom = 58'h8000000001;
            //Add XOR inputs 
            for ( j=1; j<LFSR_WIDTH; j++ ) begin
                if (( Polynom >> j ) & 1 ) begin
                    state_value = lfsr_mask_state_in[j-1] ^ state_value;
                    data_value = lfsr_mask_data[j-1] ^ data_value;
                end
            end

            //Shift 
            for ( j=LFSR_WIDTH-1; j>0; j-- ) begin
                lfsr_mask_state_in[j] = lfsr_mask_state_in[j-1];
                lfsr_mask_data[j] = lfsr_mask_data[j-1];               
            end
            for ( j=DATA_WIDTH-1; j>0; j-- ) begin
                mask_output_state[j] = mask_output_state[j-1];
                output_mask_data[j] = output_mask_data[j-1];
            end
            
            mask_output_state[0] = state_value;
            output_mask_data[0] = data_value;

            if (FEED_FORWARD) begin 
                //Shift in new input data
                state_value = {LFSR_WIDTH{1'b0}};
                data_value = data_mask;
            end
            lfsr_mask_state_in[0] = state_value;
            lfsr_mask_data[0] = data_value;
        end
        
        if (index < LFSR_WIDTH) begin
            state_value = lfsr_mask_state_in[index];
            data_value = lfsr_mask_data[index]; 
        end else begin
            state_value = mask_output_state[index-LFSR_WIDTH];
            data_value = output_mask_data[index-LFSR_WIDTH];
        end
        lfsr_mask = { data_value, state_value };
    end
endfunction

genvar i;
generate 
    //Use nested loops to generate the necessary circuit
    for ( i=0; i<LFSR_WIDTH; i++ ) begin
        wire [LFSR_WIDTH+DATA_WIDTH-1:0] mask = lfsr_mask(i);
        //Register to store the current state
        reg state_reg;
        //Assign output of reg
        assign lfsr_state_out[i] = state_reg; 

        interger g;

        always @* begin
            state_reg = 1'b0;
            for ( g=0; g<LFSR_WIDTH; g++ ) begin
                if (mask[g] ) begin
                    state_reg = state_reg ^ lfsr_state_in[g];
                end
            end
            for ( g=0; g<DATA_WIDTH; g++ ) begin
                if (mask[g+LFSR_WIDTH]) begin
                    state_reg = state_reg ^ data_in[g];
                end
            end
        end
    end
    //Second Loop
    for ( i=0; i<DATA_WIDTH; i++ ) begin
        wire [LFSR_WIDTH+DATA_WIDTH-1:0] mask = lfsr_mask(i+LFSR_WIDTH);
        //Storage Register for data
        reg data_reg;
        //Assign output to the reg
        assign data_out[i] = data_reg;

        integer g;

        always @* begin
            data_reg = 1'b0;
            for ( g=0; g<LFSR_WIDTH; g++ ) begin
                if ( mask[g]) begin
                    data_reg = data_reg ^ lfsr_state_in[g];
                end
            end
            for ( g=0; g<DATA_WIDTH; g++ ) begin
                if (mask[g+LFSR_WIDTH]) begin
                    data_reg = data_reg ^ data_in[g];
                end
            end
        end
    end
    //Generate Process Ended
endgenerate

endmodule 