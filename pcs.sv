`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride (For Northeastern UN LAB)
// Create Date: 02/28/2023 05:12:55 PM 
// Module Name: PCS
// Revision: 7, I lost count
// Additional Comments:
//      TODO: Instead of Removing the REVERSE function from the scrambler
//      Just use and XOR as a mux to gate the output of the scrambler
//      to the PMA if the scrambler is turned off, I could just make another
//      flag to output from the scrambler like the scrambler enable, 
//      This will add another 3.07692307692 ns delay (Boot up, I.e. you pay less cost
//      the longer its up, its a cycle on delay. ) Total Delay with this add
//      Will be 3.07692307692*4 = 12.308 Is Jover. 
//////////////////////////////////////////////////////////////////////////////////
/* At the moment there might be an issue where the scrambler assumes msb is 64, but the data is
going in as lsb is 64 and MSB is 0 I already have the reverse function, but tis what tis turning reverse on to 
compensate, the reverse is on  */
module PCS #
(
    parameter LANES = 2,
    parameter DATA_WIDTH = 64,
    parameter HEADER_WIDTH = 2,
    localparam CONTROL_WIDTH = 8,
    localparam BUS_WIDTH = (DATA_WIDTH+HEADER_WIDTH)*LANES
)
(
    input TX_CLK,
    input READY, 
    //output RX_CLK, //Bruh I gotta drive the RX clock, FATTEST L 
    input logic [DATA_WIDTH*LANES-1:0] TX_D,
    input logic [CONTROL_WIDTH*LANES-1:0] TX_C,
    
    output reg [BUS_WIDTH-1:0] ENCODER_OUT,
    
    output [BUS_WIDTH-1:0] TX_PMA_Out,
    output [3:0] temp_error_outputs
);

reg enable_ecoder;
reg enable_scrambler;

wire [BUS_WIDTH-1:0] encoder_data_to_scramb; 

initial begin
    enable_scrambler = 1'b0;
    enable_ecoder = 1'b0;
end

always @(posedge TX_CLK) begin
    ENCODER_OUT <= encoder_data_to_scramb;
end

always @* begin
    if(READY) begin
        enable_ecoder = '1;
    end else begin
        enable_ecoder = '0;
    end
end
  
//Generate 2 Encoder Lanes to take care of the 128 bit DATA Input
generate 
    genvar i;
    for (i=0; i<LANES; i++) begin : GenEncoder
        Encoder_66b_64b #(.DATA_WIDTH(DATA_WIDTH), .HEADER_WIDTH(HEADER_WIDTH), .REVERSE(0) )
           u0(.CLK(TX_CLK),
              .enable(enable_encoder),
              .data_bits(TX_D[64*(i+1)-1 -: 64]),
              .control_bits(TX_C[8*(i+1)-1 -: 8]),  
              .encoded_data(encoder_data_to_scramb[66*i +: 66]),
              .enable_scrambler(enable_scrambler)
        );
                     
    end : GenEncoder
endgenerate

//Generate 2 Scrambler Lanes to Go with the two encoder lanes
generate 
    genvar q;
    for(q=0; q<LANES; q++) begin : GenScramb
        Scrambler_64b #( .REVERSE(1'b0) )
            u0(.CLK(TX_CLK), 
               .enable(enable_scrambler),
               .data_in(encoder_data_to_scramb[(66*q)+2 +:64]),
               .header_in(encoder_data_to_scramb[(66*q) +: 2]),
               .data_out(TX_PMA_Out[66*q +: 66])
         );  
             
    end : GenScramb
endgenerate

endmodule    