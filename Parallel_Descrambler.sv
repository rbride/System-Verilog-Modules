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

//Implements a LFSR next state. Shifts bits, Input data is xord with lfsr feedback 
//Computes A set of bit masks, then uses bit masks to select bits for XORing to compute the next state
module Descrambler_64bit(
    input CLK,
    input rst,
    input wire [63:0] Sr_In, //Scrambled Data as input
    output wire [63:0] D_UnS  //The Unscrambled data as the output
    );
    
    reg [57:0] lfsr_state_reg; //The Saved state of the 
    wire [57:0] lfsr_state_out; //Output of those registers

    //Set State in of LFSR to State Out every posedge CLK

endmodule

//Set FEED_FORWARD to 0 (off) for scrambling, 1 for Descrambling
//LFSR_WIDTH localparam because always g(x) = x^58 + x^39 + 1
//Potentially add Param Option to reverse lsb to msb bits ordering
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

endfunction


endmodule 



//       lfsr #(
//         .LFSR_WIDTH(58),
//         .LFSR_POLY(58'h8000000001),
//         .LFSR_CONFIG("FIBONACCI"),
//         .LFSR_FEED_FORWARD(0),
//         .REVERSE(1),
//         .DATA_WIDTH(64),
//         .STYLE("LOOP")
//     ) 
//     scrambler_inst (
//     .data_in(encoded_tx_data),
//     .state_in(scrambler_state_reg),
//     .data_out(scrambled_data),
//     .state_out(scrambler_state)
//     );
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