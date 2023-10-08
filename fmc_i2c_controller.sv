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
//https://support.xilinx.com/s/article/61861?language=en_US
module fmc_i2c_controller(
    input wire CLK,
    //input wire en_fmc_board,
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
IOBUF sda_buf(
    .O(sda_out),
    .I(sda_in),
    .IO(SDA_PIN),
    .T(sda_t)
);


//CLPD Address
 //Last two Bits are guesses based on assumptions made of crappy docs change if does not work
localparam[7:0] CLPD_ADDR = 7'b01111_10; 

localparam [2:0]
    START_UP                        =   3'b000,
    IDLE                            =   3'b001,
    START                           =   3'b010,
    CLPD_ADDRESS_W                  =   3'b011,
    CLPD_ADDRESS_R                  =   3'b100,
    ACC_CLPD_CTRL_REG0              =   3'b101,
    TURN_ON_LED                     =   3'b110,
    TURN_OFF_LED                    =   3'b111;

reg [2:0]  

//State Machine    
always *@ begin

end

//
always @(posedge CLK)begin

end





endmodule

// //I2C addresses of Slave modules of FMC484
// localparam[6:0]
// SI5338B_ADR   = 7'b1110000,
//  //Wether you are talking to Module A or B is determ by selection bit of CLPD
// QSFP_MOD      = 7'b1010000;    
// //CLPD has various
// Frequency  N     filter time (ns)
//  60        3         50
//  80        4         50 
//  100       5         50
//  150       7         47
//  200       10        50