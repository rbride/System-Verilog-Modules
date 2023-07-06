`timescale 1ns / 1ps

module encoder_scrambler #
(
    parameter DATA_WIDTH = 128,
    parameter LANES = 2,
    parameter REVERSE = 0
)
(
    input clk,
    input eee_enable, //Disables Scrambler
    input [DATA_WIDTH-1:0] encoded_data_in,
    input [LANES*2-1:0] encoded_tx_header,
    output logic [DATA_WIDTH + (LANES*2-1) :0 ] scrambled_data
);
    
    wire [DATA_WIDTH-1:0] scramb_data_no_header; 
    
    //Generate the scramblers
    generate
        genvar i;
        for ( i=0; i<LANES; i++) begin:
            scrambler_64bit u0 #( .REVERSE(REVERSE) ) 
                    (   .CLK(clk),   
                        .data_in(encoded_data_in[ 64*(i+1)-1 : 64*i ]),
                        .data_out(scramb_data_no_header[ 64*(i+1)-1 : 64*i ]),
                        .eee_mode(eee_enable)
                    ); 
        end
    endgenerate

        
        
endmodule