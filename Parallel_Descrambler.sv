`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride 
// Create Date: 05/15/2023 08:21:31 PM
// Design Name: 40G/100Gb PCS 64 Bit Parallel Scrambler
// Module Name: Descrambler_64bit
// Description: 
//      First Generates a Mask based 
//
//////////////////////////////////////////////////////////////////////////////////

module Descrambler_64bit(
    input CLK,
    input rst,
    input wire [63:0] Sr_In, //Scrambled Data as input
    output wire [63:0] D_UnS  //The Unscrambled data as the output
    );

    reg [63:0] state_reg;
    reg [63:0] data_reg;
    assign state_reg = Sr_In;
    assign D_UnS = data_reg; 

    
    
    
    //Loop For Maintaining the LFSR States
    for(i=0; i<64; i++) begin 



    end        
    
    
    //Reset The State Registers when Given signal
    always @* begin
        if(rst == 1'b1) 
            state_reg <= 64'b0;
    end

endmodule