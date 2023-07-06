`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride
// Create Date: 05/05/2023 02:57:01 PM
// Design Name: 
// Module Name: scrambler_64bit
// Revision:
// Revision 2 - Reduced Register Usage, Reverse, and Enable Feature added 
// Additional Comments:
//      make a visual example of the intended appearence of said block a the 
//      theory of the timing diagram based on this Ideal design or whatever, 
//      and add it to you notes powerpoint Still needs Done
//////////////////////////////////////////////////////////////////////////////////

// By Default Scrambles Least Significant Bit First, LSB, Setting Reverse to 1 would Reverse this to MSB
// set to 7-64 for register and 65-128 for data in because it more so matches my truth 
module scrambler_64bit #
( 
    parameter REVERSE = 0
)
(
    input CLK,
    input eee_mode,
    input logic [128:65] data_in,
    output wire [64:1] data_out
);
    
    //Default the LFSR state register starting at all ones. 
    // Bottom 6 are 0's because it doesn't matter only the top 58 are used in computations 
    reg [64:1] s1_64 = { {58{1'b1}},  6'b000000 };
    //Reverse Option
    generate 
        genvar n;
        
        if ( REVERSE ) begin
            for ( n=0; n<65; n++ ) begin
                assign data_out[n] = s1_64[65-n-1];
            end
        end else begin
            assign data_out = s1_64;
        end
      
    endgenerate  
    
    always @(posedge CLK) begin
            if (eee_mode == 0) begin
                s1_64[1] <= s1_64[7] ^ s1_64[26] ^ data_in[65];
                s1_64[2] <= s1_64[8] ^ s1_64[27] ^ data_in[66]; 
                s1_64[3] <= s1_64[9] ^ s1_64[28] ^ data_in[67];
                s1_64[4] <= s1_64[10] ^ s1_64[29] ^ data_in[68];
                s1_64[5] <= s1_64[11] ^ s1_64[30] ^ data_in[69];
                s1_64[6] <= s1_64[12] ^ s1_64[31] ^ data_in[70];
                s1_64[7] <= s1_64[13] ^ s1_64[32] ^ data_in[71];
                s1_64[8] <= s1_64[14] ^ s1_64[33] ^ data_in[72];
                s1_64[9] <= s1_64[15] ^ s1_64[34] ^ data_in[73];
                s1_64[10] <= s1_64[16] ^ s1_64[35] ^ data_in[74];
                s1_64[11] <= s1_64[17] ^ s1_64[36] ^ data_in[75];
                s1_64[12] <= s1_64[18] ^ s1_64[37] ^ data_in[76];
                s1_64[13] <= s1_64[19] ^ s1_64[38] ^ data_in[77];
                s1_64[14] <= s1_64[20] ^ s1_64[39] ^ data_in[78];
                s1_64[15] <= s1_64[21] ^ s1_64[40] ^ data_in[79];
                s1_64[16] <= s1_64[22] ^ s1_64[41] ^ data_in[80];
                s1_64[17] <= s1_64[23] ^ s1_64[42] ^ data_in[81];
                s1_64[18] <= s1_64[24] ^ s1_64[43] ^ data_in[82];
                s1_64[19] <= s1_64[25] ^ s1_64[44] ^ data_in[83];
                s1_64[20] <= s1_64[26] ^ s1_64[45] ^ data_in[84];
                s1_64[21] <= s1_64[27] ^ s1_64[46] ^ data_in[85];
                s1_64[22] <= s1_64[28] ^ s1_64[47] ^ data_in[86];
                s1_64[23] <= s1_64[29] ^ s1_64[48] ^ data_in[87];
                s1_64[24] <= s1_64[30] ^ s1_64[49] ^ data_in[88];
                s1_64[25] <= s1_64[31] ^ s1_64[50] ^ data_in[89];
                s1_64[26] <= s1_64[32] ^ s1_64[51] ^ data_in[90];
                s1_64[27] <= s1_64[33] ^ s1_64[52] ^ data_in[91];
                s1_64[28] <= s1_64[34] ^ s1_64[53] ^ data_in[92];
                s1_64[29] <= s1_64[35] ^ s1_64[54] ^ data_in[93];
                s1_64[30] <= s1_64[36] ^ s1_64[55] ^ data_in[94];
                s1_64[31] <= s1_64[37] ^ s1_64[56] ^ data_in[95];
                s1_64[32] <= s1_64[38] ^ s1_64[57] ^ data_in[96];
                s1_64[33] <= s1_64[39] ^ s1_64[58] ^ data_in[97];
                s1_64[34] <= s1_64[40] ^ s1_64[59] ^ data_in[98];
                s1_64[35] <= s1_64[41] ^ s1_64[60] ^ data_in[99];
                s1_64[36] <= s1_64[42] ^ s1_64[61] ^ data_in[100];
                s1_64[37] <= s1_64[43] ^ s1_64[62] ^ data_in[101];
                s1_64[38] <= s1_64[44] ^ s1_64[63] ^ data_in[102];
                s1_64[39] <= s1_64[45] ^ s1_64[64] ^ data_in[103];
                s1_64[40] <= s1_64[46] ^ s1_64[7] ^ s1_64[26] ^ data_in[65] ^ data_in [104];
                s1_64[41] <= s1_64[47] ^ s1_64[8] ^ s1_64[27] ^ data_in[66] ^ data_in [105];
                s1_64[42] <= s1_64[48] ^ s1_64[9] ^ s1_64[28] ^ data_in[67] ^ data_in [106];
                s1_64[43] <= s1_64[49] ^ s1_64[10] ^ s1_64[29] ^ data_in[68] ^ data_in [107];
                s1_64[44] <= s1_64[50] ^ s1_64[11] ^ s1_64[30] ^ data_in[69] ^ data_in [108];
                s1_64[45] <= s1_64[51] ^ s1_64[12] ^ s1_64[31] ^ data_in[70] ^ data_in [109];
                s1_64[46] <= s1_64[52] ^ s1_64[13] ^ s1_64[32] ^ data_in[71] ^ data_in [110];
                s1_64[47] <= s1_64[53] ^ s1_64[14] ^ s1_64[33] ^ data_in[72] ^ data_in [111];
                s1_64[48] <= s1_64[54] ^ s1_64[15] ^ s1_64[34] ^ data_in[73] ^ data_in [112];
                s1_64[49] <= s1_64[55] ^ s1_64[16] ^ s1_64[35] ^ data_in[74] ^ data_in [113];
                s1_64[50] <= s1_64[56] ^ s1_64[17] ^ s1_64[36] ^ data_in[75] ^ data_in [114];
                s1_64[51] <= s1_64[57] ^ s1_64[18] ^ s1_64[37] ^ data_in[76] ^ data_in [115];
                s1_64[52] <= s1_64[58] ^ s1_64[19] ^ s1_64[38] ^ data_in[77] ^ data_in [116];
                s1_64[53] <= s1_64[59] ^ s1_64[20] ^ s1_64[39] ^ data_in[78] ^ data_in [117];
                s1_64[54] <= s1_64[60] ^ s1_64[21] ^ s1_64[40] ^ data_in[79] ^ data_in [118];
                s1_64[55] <= s1_64[61] ^ s1_64[22] ^ s1_64[41] ^ data_in[80] ^ data_in [119];
                s1_64[56] <= s1_64[62] ^ s1_64[23] ^ s1_64[42] ^ data_in[81] ^ data_in [120];
                s1_64[57] <= s1_64[63] ^ s1_64[24] ^ s1_64[43] ^ data_in[82] ^ data_in [121];
                s1_64[58] <= s1_64[64] ^ s1_64[25] ^ s1_64[44] ^ data_in[83] ^ data_in [122];
                s1_64[59] <= data_in[123] ^ s1_64[45] ^ data_in[84] ^ s1_64[7] ^ data_in[65];
                s1_64[60] <= data_in[124] ^ s1_64[46] ^ data_in[85] ^ s1_64[8] ^ data_in[66];
                s1_64[61] <= data_in[125] ^ s1_64[47] ^ data_in[86] ^ s1_64[9] ^ data_in[67];
                s1_64[62] <= data_in[126] ^ s1_64[48] ^ data_in[87] ^ s1_64[10] ^ data_in[68];
                s1_64[63] <= data_in[127] ^ s1_64[49] ^ data_in[88] ^ s1_64[11] ^ data_in[69];
                s1_64[64] <= data_in[128] ^ s1_64[50] ^ data_in[89] ^ s1_64[12] ^ data_in[70];
            end else begin
                s1_64 <= s1_64;
            end 
        end
endmodule
`resetall