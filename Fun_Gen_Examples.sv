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
/* 
The top level module first defines some interemiediate variables used in this example, and then assigns 
Constant values to the encoder and decoder inputs. The subroutine call of the generic encoder, ENCODER_F, 
uses the specialized class parameter value of 8 that represents the decoder width value for that specific instance
 of the encoder while at the same time passing the input encoded value, encoder_in thi
uses the static class resolution operator :: is used to access the encoder subroutine 
Same for the decoder but it adds a param value of 4 instead of
*/

///////////////////////////////////////////////////////
///    GENERATE CONSTRUCTS  ///////////////////////////
///////////////////////////////////////////////////////
/*      ### NOTES ###
 Generate constructs are used to either conditionally or multiply instantiate generate blocks into a model
 a generate block is a collection of one or more module items. 
 contains no decls, specparam decls, and does not specify blocks
 All declared params are local
 All other module items including other generate constructs are allowed
 
 Gernate Constructs provide the ability for parameter values to affect the structure of a design. 
 They also allow for modules with repetitive structures to be described more cocisely and make recusive instatiation possible

    Two types
        Loop Generate Constructs:
            Allow a single generate block to be instatiated into a model multiple times
        Conditional Generate Constructs: 
            Include if-generate and case-generate constructs, instatiate at most one generate block from a set
            of generate blocks defined by the code
        
Generate Schemes are evalutated during the design elaboration step, and even though the syntax may appear like behavior design
statments, they do not execute at simulation time. and determined completely before simulation begins. Therefore all the expressions
ina generate schemes shall be constant expressions deterministic at elboration time.

Like module instatiation, generate schemes instantiate a block with hierarchy the difference being that the genreate block can
call and execute upon stuff defined in the module above it that is instatiating it

Generate and endgernate can be used to define generate region, tho this is optional. and can be left to be contextually determined by parser

*/
