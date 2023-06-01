// TODO: Review Automatic and other features
// Review the System functions in 20.8

//Example of a constant funtion to calculate the ceiling of the log base 2 quanity
//The constant function is clogb2, found on page 328 of the 1800-2017 std

module ram_model (address, write, chip_select, data);
    parameter data_width = 8; 
    parameter ram_depth = 256;
    //The value calculated by the constant function before simulation time
    localparam addr_width = clogb2(ram_depth); 
    input [addr_width-1:0] address;
    input write, chip_select;
    inout [data_width-1:0] data;

    //Define the Clogb2 function
    fucntion interger clogb2 (input [31:0] value);
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1)
            value = value >> 1;
    endfunction

    //Example of this value computed by constant function
    logic [data_width-1:0] data_store[0:ram_depth-1]; 
        // Rest of the Ram model

endmodule : ram_model

//example instantiation of this module would look like so
ram_model #(32, 421) ram_a(a_addr, a_wr, a_cs, a_data);

//Parameterized Task / Functions
//Using Static methods in classes, generic parameterizeds subroutines can be genereted 
//That produce a task or function that fits the parameter of the system that is defined upon its instantiation
//Example of a encodeer / decoder 
// PAGE 334         TODO: Why is there a $ infront of clog2
virtual class C#(parameter DECODE_W, parameter ENCODE_w = $clog2(DECODE_W));
    static function logic [ENCODE_W-1:0] ENCODER_f
            (input logic [DECODE_W-1:0] DecodeIn );
        ENCODER_f = '0;
        for (int i=0; i<DECODE_W; i++) begin
            if(DecodeIn[i]) begin
                ENCODER_f = i[ENCODE_W-1:0];
                break;
            end
        end
    endfunction

    static function logic [DECODE_W-1:0] DECODER_f
            (input logic [ENCODE_W-1:0] EncodeIn);
        DECODER_f = '0;
        DECODER_f[EncodeIn] = 1'b1;
    endfunction
endclass

//Each class c has two static subroutines ENCODER_f and DECODER_f. Each subroutine is paramterized by reusing the class 
//parameters DECODE_W and ENCODE_W. The default value of ENCODE_W is determiend by the system fucntion $clog2 
//which returns the ceiling of log base 2 of the arguement (the log rounded up to an interger value )
//These parameters are used to specify the size of the encoder and decoder

//Example use
module top();
    logic [7:0] encoder_in;
    logic [2:0] encoder_out;
    logic [1:0] decoder_in;
    logic [3:0] decoder_out;

    // Encoder adn Decoder input assignments
    assign encoder_in = 8'b0100_0000; //The underscore is just a seperator
    assign decoder_in = 2'b11;

    // Encoder and Decoder Function Calls
    assign encoder_out = C#(8)::ENCODER_f(encoder_in);
    assign decoder_out = C#(4)::DECODER_f(decoder_in);

    initial begin
        #50;
        $display("Encoder input = %b Encoder output = %b\n",
                encoder_in, encoder_out );
        $display("Decoder input = %b Decoder output = %b\n",
            decoder_in, decoder_out );
    end
endmodule 

