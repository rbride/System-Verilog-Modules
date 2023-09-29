// https://docs.xilinx.com/r/en-US/pg182-gtwizard-ultrascale/Receiver-Module

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Northeastern UN LAB
// Engineer: Ryan Bride
// Module Name: RS Layer and Interconnect
// Revision 2: Wrapper Around the GTY Block 
// Additional Comments:
//      Basic interconnect between a Dummy mac and The PCS 

//////////////////////////////////////////////////////////////////////////////////
module Wrapper #
(
    parameter TX_LANES = 2,
    parameter RX_LANES = 2,
    parameter DATA_WIDTH = 64,
    parameter HEADER_WIDTH = 2,
    localparam CONTROL_WIDTH = 8,
    localparam BUS_WIDTH = (DATA_WIDTH+HEADER_WIDTH)*2
)
(
    input CLK,
    input ready,
    input [127:0] TX_D,
    input [15:0] TX_C,
    
    output [131:0] TX_O,
    output [3:0] errors
);
PCS TXPCS ( .TX_CLK(CLK), .READY(ready), 
            .TX_D(TX_D), .TX_C(TX_C),
            .TX_PMA_Out(TX_O),
            .temp_error_outputs(errors)
           );



endmodule