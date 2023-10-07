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
//for reference upon completion for hookup
//https://docs.xilinx.com/r/en-US/ug571-ultrascale-selectio/SelectIO-Interface-Attributes-and-Constraints
module fmc_i2c_controller(
    input wire CLK,
    input wire en_fmc_board,
    inout wire SCL_PIN,
    inout wire SDA_PIN
);
    //3 Wires used for SCL and SDA
    wire scl_in, scl_out, scl_t;
    wire sda_in, sda_out, sda_t;
    //Create I/O Buffer For SCL PIN
    IOBUF scl_buf(
        .O(scl_out),
        .I(scl_in),
        .IO(SCL_PIN),
        .T(scl_t)
    );
    //Create I/O Buffer 
      
    //I2C addresses of Slave modules of FMC484
    localparam[6:0]
    SI5338B_ADR   = 7'b1110000,
     //Wether you are talking to Module A or B is determ by selection bit of CLPD
    QSFP_MOD      = 7'b1010000;    
    //CLPD has various
    
    
    
        
endmodule
`resetall