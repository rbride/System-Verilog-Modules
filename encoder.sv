`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2023 04:47:41 PM
// Module Name: encoder_64_66b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Encoder_66b_64b #
(
    parameter DATA_WIDTH = 128,
    parameter LANES = 2,
    parameter REVERSE = 0
)
(
    input clk,
    input eee_enable, //Disables Scrambler
    input [DATA_WIDTH-1:0] encoded_data_in,
    input [LANES*2-1:0] tx_header,
    output logic [132-1 :0 ] scrambled_data
    //output wire [DATA_WIDTH-1:0] scramb_data_no_header
);
    
    //Cheap Fix Restructure and replace later
    integer g; 
    always @(posedge clk) begin
        for( g=1; g<LANES+1; g++) begin
            scrambled_data[ 65*(g-1)+1 -: 2] <= tx_header[2*(g)-1 -: 2]; 
        end
    end
    
     
    //Generate the scramblers
    generate
        genvar i;
        for ( i=0; i<LANES; i++) begin : Scramb
            scrambler_64bit  #( .REVERSE(REVERSE) ) 
                 u0 (   .CLK(clk),   
                        .data_in(encoded_data_in[ 64*(i+1)-1 -: 64 ]),
                        .data_out(scrambled_data[ 65*(i+1)+1 -: 64 ]),
                        .eee_mode(eee_enable)
                    ); 
        end
    endgenerate
             
endmodule