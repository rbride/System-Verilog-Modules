`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride 
// Create Date: 09/04/2023 11:58:18 AM
// Module Name: fmc_i2c_controller
// Target Devices:FPGA Connected to FMC424 Board 
// Description: 
//      Master I2C Controller that Connects to and controls FMC424 add on board
// Revision 1 - Initial Design  
//////////////////////////////////////////////////////////////////////////////////

module fmc_i2c_controller #(
    //I2C addresses of Slave modules of FMC484
    parameter SI5338B_ADR   = 7'b1110000,
     //Wether you are talking to Module A or B is determ by selection bit of CLPD
    parameter QSFP_MOD      = 7'b1010000    
    //CLPD has various
    )(
    
    
endmodule

module Parallel_LFSR #(
    parameter DATA_WIDTH = 64,
    parameter FEED_FORWARD = 0,  
    localparam LFSR_WIDTH = 58,
    // LFSR_Poly = 58'h8000000001 1 at the end for the +1 8 is for + 38 the highest val ignored
    localparam Polynom = 58'h8000000001
)(