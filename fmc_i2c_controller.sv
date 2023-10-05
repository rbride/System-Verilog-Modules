`resetall
`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride 
// Create Date: 09/04/2023 11:58:18 AM
// Module Name: fmc_i2c_controller
// Target Devices:FPGA Connected to FMC424 Board 
// Description: 
//      Master I2C Controller that Connects to and controls FMC424 add on board
// Revision 1 - Initial Design  
//////////////////////////////////////////////////////////////////////////////////

module fmc_i2c_controller(
    input wire CLK,
    output wire SCL,
    output wire SDA
);
      //I2C addresses of Slave modules of FMC484

localparam[6:0]
    SI5338B_ADR   = 7'b1110000,
     //Wether you are talking to Module A or B is determ by selection bit of CLPD
    QSFP_MOD      = 7'b1010000;    
    //CLPD has various
        
endmodule

`resetall