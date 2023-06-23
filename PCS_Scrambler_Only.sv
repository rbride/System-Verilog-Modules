`timescale 1ns/1ps 
`default_nettype none
//Top Level Contains all units
module PCS 
(
    input CLK,
    input [127:0] Tx_Data_In,
    input [15:0] Tx_Cont_In, 
    //Output
)

endmodule

// By Default Scrambles Least Significant Bit First, LSB, Setting Reverse to 1 would Reverse this to MSB
// set to 7-64 for register and 65-128 for data in because it more so matches my truth 
module scrambler_64bit #
( 
    parameter REVERSE = 0,
    parameter ENABLE = 1  // Scrambling Disabled in EEE mode just pass through
)
(
    input CLK,
    input rst, //Resets the LFSR State Register
    input enable_scrambler, 
    input logic [128:65] data_in,
    output reg [63:0] data_out
);
    //Default the LFSR state register starting at all ones. 
    // Bottom 6 are 0's because it doesn't matter only the top 58 are used in computations 
    reg [64:7] s1_64 = { {58{1'b1}},  6'b000000 };
    
    generate 
        genvar n;
        //Reverse LSB -> MSB else just assign     
        if ( REVERSE ) begin
            for ( n=0; n<65; n++ ) begin
                assign data_out[n] = s1_64[65-n-1];
            end
        end else begin
            assign data_out = s1_64;
        end
    endgenerate  
   
    // Save the Next State
    assign s1_64[64:7] = data_out[63:6]; 

    always @(posedge CLK) begin
        if (rst == 1 ) begin
            //Reset the State Register to its initial Value of all 1's
            s1_64 = { {58{1'b1}},  6'b000000 };
        end

        if ( ENABLE == 0 ) begin
            //Pass Through
            data_out <= data_in;
        end else  begin            
            data_out[1] <= s1_64[7] ^ s1_64[26] ^ data_in[65];
            data_out[2] <= s1_64[8] ^ s1_64[27] ^ data_in[66]; 
            data_out[3] <= s1_64[9] ^ s1_64[28] ^ data_in[67];
            data_out[4] <= s1_64[10] ^ s1_64[29] ^ data_in[68];
            data_out[5] <= s1_64[11] ^ s1_64[30] ^ data_in[69];
            data_out[6] <= s1_64[12] ^ s1_64[31] ^ data_in[70];
            data_out[7] <= s1_64[13] ^ s1_64[32] ^ data_in[71];
            data_out[8] <= s1_64[14] ^ s1_64[33] ^ data_in[72];
            data_out[9] <= s1_64[15] ^ s1_64[34] ^ data_in[73];
            data_out[10] <= s1_64[16] ^ s1_64[35] ^ data_in[74];
            data_out[11] <= s1_64[17] ^ s1_64[36] ^ data_in[75];
            data_out[12] <= s1_64[18] ^ s1_64[37] ^ data_in[76];
            data_out[13] <= s1_64[19] ^ s1_64[38] ^ data_in[77];
            data_out[14] <= s1_64[20] ^ s1_64[39] ^ data_in[78];
            data_out[15] <= s1_64[21] ^ s1_64[40] ^ data_in[79];
            data_out[16] <= s1_64[22] ^ s1_64[41] ^ data_in[80];
            data_out[17] <= s1_64[23] ^ s1_64[42] ^ data_in[81];
            data_out[18] <= s1_64[24] ^ s1_64[43] ^ data_in[82];
            data_out[19] <= s1_64[25] ^ s1_64[44] ^ data_in[83];
            data_out[20] <= s1_64[26] ^ s1_64[45] ^ data_in[84];
            data_out[21] <= s1_64[27] ^ s1_64[46] ^ data_in[85];
            data_out[22] <= s1_64[28] ^ s1_64[47] ^ data_in[86];
            data_out[23] <= s1_64[29] ^ s1_64[48] ^ data_in[87];
            data_out[24] <= s1_64[30] ^ s1_64[49] ^ data_in[88];
            data_out[25] <= s1_64[31] ^ s1_64[50] ^ data_in[89];
            data_out[26] <= s1_64[32] ^ s1_64[51] ^ data_in[90];
            data_out[27] <= s1_64[33] ^ s1_64[52] ^ data_in[91];
            data_out[28] <= s1_64[34] ^ s1_64[53] ^ data_in[92];
            data_out[29] <= s1_64[35] ^ s1_64[54] ^ data_in[93];
            data_out[30] <= s1_64[36] ^ s1_64[55] ^ data_in[94];
            data_out[31] <= s1_64[37] ^ s1_64[56] ^ data_in[95];
            data_out[32] <= s1_64[38] ^ s1_64[57] ^ data_in[96];
            data_out[33] <= s1_64[39] ^ s1_64[58] ^ data_in[97];
            data_out[34] <= s1_64[40] ^ s1_64[59] ^ data_in[98];
            data_out[35] <= s1_64[41] ^ s1_64[60] ^ data_in[99];
            data_out[36] <= s1_64[42] ^ s1_64[61] ^ data_in[100];
            data_out[37] <= s1_64[43] ^ s1_64[62] ^ data_in[101];
            data_out[38] <= s1_64[44] ^ s1_64[63] ^ data_in[102];
            data_out[39] <= s1_64[45] ^ s1_64[64] ^ data_in[103];
            data_out[40] <= s1_64[46] ^ s1_64[7] ^ s1_64[26] ^ data_in[65] ^ data_in [104];
            data_out[41] <= s1_64[47] ^ s1_64[8] ^ s1_64[27] ^ data_in[66] ^ data_in [105];
            data_out[42] <= s1_64[48] ^ s1_64[9] ^ s1_64[28] ^ data_in[67] ^ data_in [106];
            data_out[43] <= s1_64[49] ^ s1_64[10] ^ s1_64[29] ^ data_in[68] ^ data_in [107];
            data_out[44] <= s1_64[50] ^ s1_64[11] ^ s1_64[30] ^ data_in[69] ^ data_in [108];
            data_out[45] <= s1_64[51] ^ s1_64[12] ^ s1_64[31] ^ data_in[70] ^ data_in [109];
            data_out[46] <= s1_64[52] ^ s1_64[13] ^ s1_64[32] ^ data_in[71] ^ data_in [110];
            data_out[47] <= s1_64[53] ^ s1_64[14] ^ s1_64[33] ^ data_in[72] ^ data_in [111];
            data_out[48] <= s1_64[54] ^ s1_64[15] ^ s1_64[34] ^ data_in[73] ^ data_in [112];
            data_out[49] <= s1_64[55] ^ s1_64[16] ^ s1_64[35] ^ data_in[74] ^ data_in [113];
            data_out[50] <= s1_64[56] ^ s1_64[17] ^ s1_64[36] ^ data_in[75] ^ data_in [114];
            data_out[51] <= s1_64[57] ^ s1_64[18] ^ s1_64[37] ^ data_in[76] ^ data_in [115];
            data_out[52] <= s1_64[58] ^ s1_64[19] ^ s1_64[38] ^ data_in[77] ^ data_in [116];
            data_out[53] <= s1_64[59] ^ s1_64[20] ^ s1_64[39] ^ data_in[78] ^ data_in [117];
            data_out[54] <= s1_64[60] ^ s1_64[21] ^ s1_64[40] ^ data_in[79] ^ data_in [118];
            data_out[55] <= s1_64[61] ^ s1_64[22] ^ s1_64[41] ^ data_in[80] ^ data_in [119];
            data_out[56] <= s1_64[62] ^ s1_64[23] ^ s1_64[42] ^ data_in[81] ^ data_in [120];
            data_out[57] <= s1_64[63] ^ s1_64[24] ^ s1_64[43] ^ data_in[82] ^ data_in [121];
            data_out[58] <= s1_64[64] ^ s1_64[25] ^ s1_64[44] ^ data_in[83] ^ data_in [122];
            data_out[59] <= data_in[123] ^ s1_64[45] ^ data_in[84] ^ s1_64[7] ^ data_in[65];
            data_out[60] <= data_in[124] ^ s1_64[46] ^ data_in[85] ^ s1_64[8] ^ data_in[66];
            data_out[61] <= data_in[125] ^ s1_64[47] ^ data_in[86] ^ s1_64[9] ^ data_in[67];
            data_out[62] <= data_in[126] ^ s1_64[48] ^ data_in[87] ^ s1_64[10] ^ data_in[68];
            data_out[63] <= data_in[127] ^ s1_64[49] ^ data_in[88] ^ s1_64[11] ^ data_in[69];
            data_out[64] <= data_in[128] ^ s1_64[50] ^ data_in[89] ^ s1_64[12] ^ data_in[70];
        end
    end
endmodule

`resetall