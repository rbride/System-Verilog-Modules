`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Northeastern UN LAB
// Engineer: Ryan Bride
// Create Date: 03/24/2023 04:47:41 PM
// Module Name: encoder_64_66b
// Revision 3 - Added Encoding to this file
//////////////////////////////////////////////////////////////////////////////////

module Encoder_66b_64b #
(
    parameter DATA_WIDTH = 64,
    parameter HEADER_WIDTH = 2,
    parameter REVERSE = 0
)
(
    input CLK,
    input wire enable,
    input wire [63:0] data_bits,
    input wire [7:0] control_bits,
    output reg [65:0] encoded_data,
    output logic enable_scrambler
);

localparam [1:0]
    D_Hdr           =   2'b10, 
    Ctrl_Hdr        =   2'b01;

localparam [7:0]
    TxD_Term        =   8'hfd,
    TxD_Error       =   8'hfe,
    TxD_Start       =   8'hfb,
    TxD_Seq         =   8'h9c,
    TxD_Idle        =   8'h07,
    TxD_LPI         =   8'h06;

localparam [6:0]
    Idle_Char       =   7'h0,
    LPI_Char        =   7'h06,
    Error_Char      =   7'h1e;
// Block Type Field for Standard Control 66/64 Control Block
localparam [7:0] BTF_Std_Ctrl = 8'h1e;    

/* Function to Do the Encoding, its a function not a task because their should be no time that happens 
The Following Example is for The Encoding for the all Control blocks and LPI is the signal
Bits Number 
0   1    2   3   4   5   6   7   8   9    10  11  12  13  14  15  16   17  18  19  20  21  22  23  .... 59  60  61  62  63  64  65
1   0    0   1   1   1   1   0   0   0    0   1   1   0   0   0   0    0   1   1   0   0   0   0   ....  0   1   1   0   0  0   0    
HEADER |     BLOCK TYPE FIELD          |     LPI VALUE C_block 0     |      LPI Value C_block 1        |    LPI Value C_Block 7     

Possible Combinations if Control<7:0> = 0xff
All Idle, 
0x1e followed by 8, 7 bit Idle control chars
All LPI
0x1e followed by 8, 8 bit LPI Control Chars
Starting Terminate followed by All Idle
0x87, 7 0's ignored upon recieve, 8, 7 bit Idle Control Chars
*/  

always @(posedge CLK) begin
    if ( !enable ) begin
        enable_scrambler <= 1'b0;
        encoded_data <= 0;
    end else begin 
        enable_scrambler <= 1'b1;
        case(control_bits)
            8'hff   :   begin
                // All data_bits must be LPI or error TODO: Implement ERROR
                if (data_bits == {8{TxD_LPI}}) begin     
                    //encoded_data = { {8{7'h06}}, 8'h1e, 2'b01 };
                    encoded_data[65 -: 56] <= { 8{LPI_Char} }; //8, 7 Bit Control Data Blocks
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;                 
                //all Idle Char 
                end else if (data_bits == {8{TxD_Idle}}) begin
                    encoded_data[65 -: 56] <= { 8{Idle_Char} };
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl;
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                //Starting Terminate Followed by Idles
                end else if (data_bits == {{7{TxD_Idle}}, TxD_Term}) begin
                    // 7 Idle Chars plus 7 Padding bits 
                    encoded_data[65 -: 56] <= { {7{Idle_Char}}, 7'b0 };
                    encoded_data[2 +: 8]   <= 8'h87;
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;                    
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end         
            end
            8'h01   :   begin
                //Start on lane 0
                if (data_bits[0 +: 8] == TxD_Start) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'h78;
                    encoded_data[10 +: 56]  <= data_bits[63 -: 56];
                //Sequence on Lane 0 :)
                end else if (data_bits[0 +: 8] == TxD_Seq) begin
                    //Consist of control charcter followed by 3 data chars, followed by four zero data chars
                    //TODO: Haven't done so throws out all 0s
                    encoded_data[65:2] <= 64'b0;
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //its all data Just pass it through
            8'h0    :   begin
                encoded_data[0 +: 2]    <= D_Hdr;
                encoded_data[65 -: 64]  <= data_bits;
            end
            //Terminate on TxD<15:8>
            8'hFE   :   begin
                if (data_bits[63 -: 56] == {{6{TxD_Idle}}, TxD_Term} ) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'h99;
                    encoded_data[10 +: 8]   <= data_bits[0 +: 8];  //Single Data Octet Follows the Block Type Field 
                    encoded_data[65 -: 48]  <= {{6{Idle_Char}}, 6'b0}; 
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<23:16>
            8'hFC   :   begin
                if (data_bits[63 -: 48] == {{5{TxD_Idle}}, TxD_Term}) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hAA;
                    encoded_data[10 +: 16]  <= data_bits[0 +: 16]; 
                    encoded_data[65 -: 40]  <= {{5{Idle_Char}}, 5'b0}; 
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<31:24>
            8'hF8   :   begin
                if (data_bits[63 -: 40] == {{4{TxD_Idle}}, TxD_Term}) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hB4;
                    encoded_data[10 +: 24]  <= data_bits[0 +: 24];
                    encoded_data[65 -: 32]  <= {{4{Idle_Char}}, 4'b0};
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<39:32>
            8'hF0   :   begin
                if (data_bits[63 -: 32] == {{3{TxD_Idle}}, TxD_Term}) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hCC;
                    encoded_data[10 +: 32]  <= data_bits[0 +: 32];
                    encoded_data[65 -: 24]  <= {{3{Idle_Char}}, 3'b0};
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<47:40>
            8'hE0   :   begin
                if (data_bits[63 -: 24] == {{2{TxD_Idle}}, TxD_Term}) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hD2;
                    encoded_data[10 +: 40]  <= data_bits[0 +: 40];
                    encoded_data[65 -: 16]  <= {{2{Idle_Char}}, 2'b0};
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<55:48>
            8'hC0   :   begin
                if (data_bits[63 -: 16] == {TxD_Idle, TxD_Term}) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hE1;
                    encoded_data[10 +: 48]  <= data_bits[0 +: 48];
                    encoded_data[65 -: 8]   <= {Idle_Char, 1'b0}; 
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
            //Terminate on TxD<63:56>
                8'h80   :   begin
                if (data_bits[63 -: 8] == TxD_Term) begin
                    encoded_data[0 +: 2]    <= Ctrl_Hdr;
                    encoded_data[2 +: 8]    <= 8'hFF;
                    encoded_data[10 +: 56]  <= data_bits[0 +: 56];
                end else begin
                    //TODO: This Is invalid so indicate an Error
                    //Note Placeholder all errors throw a full set of Errors 
                    encoded_data[65 -: 56] <= {8{Error_Char}};
                    encoded_data[2 +: 8]   <= BTF_Std_Ctrl; 
                    encoded_data[0 +: 2]   <= Ctrl_Hdr;
                end
            end
        endcase
    end      
end 

endmodule