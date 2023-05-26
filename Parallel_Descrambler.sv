
//Potentially might need to flip lsb and msb i.e. flip the bit order before it comes into the descrambler
module Descrambler_66_64(
    input CLK,
    //input enable,
    //input rst,
    input wire [63:0] Sr_In, //Scrambled Data as input
    output wire [63:0] D_UnS  //The Unscrambled data as the output
    );

    //You shouldn't need to set a initial state.
    reg [63:0] state_reg;
    
    reg [63:0] data_reg;
    assign state_reg = Sr_In;
    assign D_UnS = data_reg; 
    

   
    always @(posedge CLK) begin
        data_reg[0] <= state_reg[6] ^ state_reg[25] ^ Sr_In[0];
        data_reg[1] <= state_reg[7] ^ state_reg[26] ^ Sr_In[1];
        data_reg[2] <= state_reg[8] ^ state_reg[27] ^ Sr_In[2];
        data_reg[3] <= state_reg[9] ^ state_reg[28] ^ Sr_In[3];
        data_reg[4] <= state_reg[10] ^ state_reg[29] ^ Sr_In[4];
        data_reg[5] <= state_reg[11] ^ state_reg[30] ^ Sr_In[5];
        data_reg[6] <= state_reg[12] ^ state_reg[31] ^ Sr_In[6];
        data_reg[7] <= state_reg[13] ^ state_reg[32] ^ Sr_In[7];
        data_reg[8] <= state_reg[14] ^ state_reg[33] ^ Sr_In[8];
        data_reg[9] <= state_reg[15] ^ state_reg[34] ^ Sr_In[9];
        data_reg[10] <= state_reg[16] ^ state_reg[35] ^ Sr_In[10];
        data_reg[11] <= state_reg[17] ^ state_reg[36] ^ Sr_In[11];
        data_reg[12] <= state_reg[18] ^ state_reg[37] ^ Sr_In[12];
        data_reg[13] <= state_reg[19] ^ state_reg[38] ^ Sr_In[13];
        data_reg[14] <= state_reg[20] ^ state_reg[39] ^ Sr_In[14];
        data_reg[15] <= state_reg[21] ^ state_reg[40] ^ Sr_In[15];
        data_reg[16] <= state_reg[22] ^ state_reg[41] ^ Sr_In[16];
        data_reg[17] <= state_reg[23] ^ state_reg[42] ^ Sr_In[17];
        data_reg[18] <= state_reg[24] ^ state_reg[43] ^ Sr_In[18];
        data_reg[19] <= state_reg[25] ^ state_reg[44] ^ Sr_In[19];
        data_reg[20] <= state_reg[26] ^ state_reg[45] ^ Sr_In[20];
        data_reg[21] <= state_reg[27] ^ state_reg[46] ^ Sr_In[21];
        data_reg[22] <= state_reg[28] ^ state_reg[47] ^ Sr_In[22];
        data_reg[23] <= state_reg[29] ^ state_reg[48] ^ Sr_In[23];
        data_reg[24] <= state_reg[30] ^ state_reg[49] ^ Sr_In[24];
        data_reg[25] <= state_reg[31] ^ state_reg[50] ^ Sr_In[25];
        data_reg[26] <= state_reg[32] ^ state_reg[51] ^ Sr_In[26];
        data_reg[27] <= state_reg[33] ^ state_reg[52] ^ Sr_In[27];
        data_reg[28] <= state_reg[34] ^ state_reg[53] ^ Sr_In[28];
        data_reg[29] <= state_reg[35] ^ state_reg[54] ^ Sr_In[29];
        data_reg[30] <= state_reg[36] ^ state_reg[55] ^ Sr_In[30];
        data_reg[31] <= state_reg[37] ^ state_reg[56] ^ Sr_In[31];
        data_reg[32] <= state_reg[38] ^ state_reg[57] ^ Sr_In[32];
        data_reg[33] <= state_reg[39] ^ state_reg[58] ^ Sr_In[33];
        data_reg[34] <= state_reg[40] ^ state_reg[59] ^ Sr_In[34];
        data_reg[35] <= state_reg[41] ^ state_reg[60] ^ Sr_In[35];
        data_reg[36] <= state_reg[42] ^ state_reg[61] ^ Sr_In[36];
        data_reg[37] <= state_reg[43] ^ state_reg[62] ^ Sr_In[37];
        data_reg[38] <= state_reg[44] ^ state_reg[63] ^ Sr_In[38];
        data_reg[39] <= state_reg[45] ^ state_reg[6] ^ state_reg[25] ^ Sr_In[0] ^ Sr_In[39];
        data_reg[40] <= state_reg[46] ^ state_reg[7] ^ state_reg[26] ^ Sr_In[1] ^ Sr_In[40];
        data_reg[41] <= state_reg[47] ^ state_reg[8] ^ state_reg[27] ^ Sr_In[2] ^ Sr_In[41];
        data_reg[42] <= state_reg[48] ^ state_reg[9] ^ state_reg[28] ^ Sr_In[3] ^ Sr_In[42];
        data_reg[43] <= state_reg[49] ^ state_reg[10] ^ state_reg[29] ^ Sr_In[4] ^ Sr_In[43];
        data_reg[44] <= state_reg[50] ^ state_reg[11] ^ state_reg[30] ^ Sr_In[5] ^ Sr_In[44];
        data_reg[45] <= state_reg[51] ^ state_reg[12] ^ state_reg[31] ^ Sr_In[6] ^ Sr_In[45];
        data_reg[46] <= state_reg[52] ^ state_reg[13] ^ state_reg[32] ^ Sr_In[7] ^ Sr_In[46];
        data_reg[47] <= state_reg[53] ^ state_reg[14] ^ state_reg[33] ^ Sr_In[8] ^ Sr_In[47];
        data_reg[48] <= state_reg[54] ^ state_reg[15] ^ state_reg[34] ^ Sr_In[9] ^ Sr_In[48];
        data_reg[49] <= state_reg[55] ^ state_reg[16] ^ state_reg[35] ^ Sr_In[10] ^ Sr_In[49];
        data_reg[50] <= state_reg[56] ^ state_reg[17] ^ state_reg[36] ^ Sr_In[11] ^ Sr_In[50];
        data_reg[51] <= state_reg[57] ^ state_reg[18] ^ state_reg[37] ^ Sr_In[12] ^ Sr_In[51];
        data_reg[52] <= state_reg[58] ^ state_reg[19] ^ state_reg[38] ^ Sr_In[13] ^ Sr_In[52];
        data_reg[53] <= state_reg[59] ^ state_reg[20] ^ state_reg[39] ^ Sr_In[14] ^ Sr_In[53];
        data_reg[54] <= state_reg[60] ^ state_reg[21] ^ state_reg[40] ^ Sr_In[15] ^ Sr_In[54];
        data_reg[55] <= state_reg[61] ^ state_reg[22] ^ state_reg[41] ^ Sr_In[16] ^ Sr_In[55];
        data_reg[56] <= state_reg[62] ^ state_reg[23] ^ state_reg[42] ^ Sr_In[17] ^ Sr_In[56];
        data_reg[57] <= state_reg[63] ^ state_reg[24] ^ state_reg[43] ^ Sr_In[18] ^ Sr_In[57];
        data_reg[58] <= state_reg[7] ^ Sr_In[1] ^ state_reg[44] ^ Sr_In[19] ^ Sr_In[58];
        data_reg[59] <= state_reg[8] ^ Sr_In[2] ^ state_reg[45] ^ Sr_In[20] ^ Sr_In[59];
        data_reg[60] <= state_reg[9] ^ Sr_In[3] ^ state_reg[46] ^ Sr_In[21] ^ Sr_In[60];
        data_reg[61] <= state_reg[10] ^ Sr_In[4] ^ state_reg[47] ^ Sr_In[22] ^ Sr_In[61];
        data_reg[62] <= state_reg[11] ^ Sr_In[5] ^ state_reg[48] ^ Sr_In[23] ^ Sr_In[62];
        data_reg[63] <= state_reg[12] ^ Sr_In[6] ^ state_reg[49] ^ Sr_In[24] ^ Sr_In[63];
    end

endmodule
