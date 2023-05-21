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
    input wire enable;
    input wire reset;
    output logic Bit_Out;
    //x^1 + x^58 + x^39; S stores current state
    reg [57:0] s;
    assign feedback = { Bit_In ^ s[57]  ^ s[38]};
    assign Bit_Out = feedback;

    always @(posedge CLK) begin
        if (reset == 1'b1) begin
            s <= 0;
        end
        else if (enable == 1'b1) begin
            s <= { s[56:0], feedback};
        end
    end
endmodule