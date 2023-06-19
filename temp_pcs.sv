`timescale 1ns / 1ps


module PCS(
    input [63:0] TXD,
    input [7:0] TXC,
    input TX_CLK,
    //input IS_UnitData_0,
    //input IS_UnitData_1,
    //input IS_UnitData_2,
    //input IS_UnitData_3,   
    output logic [63:0] test_out 
    );
    
    
    //For now set the header bits to always be data transmitting
    wire [1:0] header;
    assign header[1:0] = 2'b01;
        
    
    encoder_64_66b u1 (.data_in(TXD),
                       .s_header(header),
                       .encoded_data(test_out),
                       .CLK(TX_CLK));    
    
endmodule






module encoder_64_66b(
    input CLK,
    input [63:0] data_in,
    input [1:0] s_header,
    output logic [63:0] encoded_data
    );
    
    //Make all the Input Values store in a FF before it goes into scrambler
    //reg [63:0] ff_scrambler_data_in;
    //reg [63:0] ff_scrambler_data_out;

    //temp reset value
    wire zero_out;
    
    // Assume for the moment all blocks are all data blocks i.e. 01 for header
    // control blocks have 10 for header
    //assign encoded_data[1:0] = s_header[1:0];
    
    //assign encoded_data[65:2] = data_in[63:0];
    
    //always @(posedge CLK) begin
    //    ff_scrambler_data_in <= data_in;
    //end
    
    scrambler_64bit tx_scramb(.CLK(CLK),  
                              .data_in(data_in), 
                              .data_out( encoded_data[63:0] ));
        
endmodule


// make a visual example of the intended appearence of said block a the theory of the timing diagram based on this
// Ideal design or whatever, and add it to you notes powerpoint
module scrambler_64bit(
    input CLK,
    //input zero_out_scrambler,
    //set to 1-64 and 65-128 because it more so matches my table and 
    //to prevent confusion while I am building the block
    input logic [128:65] data_in,
    output reg [64:1] data_out
    );
    
    //latch the Data in to a Flip Flop 
    // Structures fine but do it so that is has the same structure as the Descrambler for parity. 
    wire [63:0] data_out_int;
    //Default the state register starting at all ones yeet gets exact same results as reference
    reg [64:1] s1_64 = { 64{1'b1}};
    
    //Reverse For Parity
    generate 
        genvar n;
        for ( n=0; n<65; n++ ) begin
            assign data_out_int[n] = s1_64[65-n-1];
        end
    
        assign data_out = data_out_int;
    endgenerate  
    
    always @(posedge CLK) begin
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
        end
endmodule
