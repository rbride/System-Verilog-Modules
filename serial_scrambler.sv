//////////////////////////////////////////////////////////////////////////////////
// Ryan Bride
// Description:
//     Simplistic Serial Scrambler Module, Designed for checking for implementation
//     into a testbench enviroment, to ensure equal outputs of a serial scrambler
//     scrambler designed for the following polynomial G(x) = x^58 + x^39 + 1 
//////////////////////////////////////////////////////////////////////////////////
module serial_scrambler(
                        CLK,
                        enable,
                        reset,
                        Bit_In,
                        Bit_Out, 
                        );
    //Define Outputs and Inputs
    input wire CLK;
    input wire Bit_In;
    input wire enable
    output logic Bit_Out;
    //x^1 + x^58 + x^39; S stores current state
    reg [57:0] s;
    assign feedback = { Bit_In ^ s[57]  ^ s[38]};
    assign Bit_Out = feedback;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            s <= 58'b0000000000000000000000000000000000000000000000000000000000; 
        end
        else if (enable == 1'b1) begin
            states <= { s[57]:, s[55], s[54], s[53], s[52], s[51], s[50], s[49], s[48],
                        s[47], s[46], s[45], s[44], s[43], s[42], s[41], s[40], s[39],
                        s[38], s[37], s[36], s[35], s[34], s[33], s[32], s[31], s[30],
                        s[29], s[28], s[27], s[26], s[25], s[24], s[23], s[22], s[21],
                        s[20], s[19], s[18], s[17], s[16], s[15], s[14], s[13], s[12],
                        s[11], s[10], s[9], s[8], s[7], s[6], s[5], s[4], s[3], s[2], 
                        s[1], s[0], feedback};
        end
    end
endmodule