
//////////////////////////////////
//  Top Level TestBench Module  //
//////////////////////////////////
module tb;
    reg clk;
    logic [63:0] tx_in_test; logic [63:0] tx_out_test; logic [63:0] scram_out_s;
    logic enable_ss; logic b_in; logic b_out; logic enable_ps;
    logic [57:0] state_store;
    
    scrambler_para DUT1 ( .CLK(clk), 
                           .data_in(tx_in_test), 
                           .s1_64(tx_out_test),
                           .enable(enable_ps)
                           );
    
    serial_scrambler DUT2 ( .CLK(clk), 
                            .Bit_In(b_in), 
                            .Bit_Out(b_out), 
                            .enable(enable_ss),
                            .s(state_store)
                            );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; tx_in_test = 0; tx_out_test = 0;
        enable_ps = 0; enable_ss = 0; state_store = 0;
            
        #5; //Make some random ass data
        std::randomize(tx_in_test);
        enable_ps = 1;
        #10;
        enable_ps = 0;
        enable_ss = 1;
        for (int i = 0; i<64; i++) begin
            b_in = tx_in_test[i];
            state_store[i] = b_out;
            #10;        
        end
        enable_ss = 0;
        #50 $finish; 

    end 
endmodule

module serial_scrambler(
                        input CLK,
                        input Bit_In,
                        input enable,
                        output reg Bit_Out,
                        output reg [57:0] s
                        );

    //x^1 + x^58 + x^39
    assign feedback = { Bit_In ^ s[57]  ^ s[38]};
    assign Bit_Out = feedback;
   
    always @(posedge CLK) begin
        if (enable == 1'b1) begin 
            s <= { s[56], s[55], s[54], s[53], s[52], s[51], s[50], s[49], s[48],
                        s[47], s[46], s[45], s[44], s[43], s[42], s[41], s[40], s[39],
                        s[38], s[37], s[36], s[35], s[34], s[33], s[32], s[31], s[30],
                        s[29], s[28], s[27], s[26], s[25], s[24], s[23], s[22], s[21],
                        s[20], s[19], s[18], s[17], s[16], s[15], s[14], s[13], s[12],
                        s[11], s[10], s[9], s[8], s[7], s[6], s[5], s[4], s[3], s[2], 
                        s[1], s[0], feedback}; 

        end
    end
    
endmodule

module scrambler_para(
    input CLK,
    input enable,
    //input zero_out_scrambler,
    //set to 1-64 and 65-128 because it more so matches my table and 
    //to prevent confusion while I am building the block
    input logic [128:65] data_in,
    output reg [64:1] s1_64
    );
    
    always @(posedge CLK) begin
            if (enable == 1) begin 
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
        end
endmodule