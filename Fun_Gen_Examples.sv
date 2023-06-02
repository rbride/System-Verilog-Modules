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
///   GENERATE CONSTRUCTS   ///////////////////////////
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

Generate and endgernate can be used to define generate region, tho this is optional. and can be left to be contextually determined by parser */



///////////////////////////////////////////////////////
///   LOOP GENERATE CONSTRUCTS   //////////////////////
///////////////////////////////////////////////////////
/*
Allows a generate block to be instatiated multiple times using for loop syntax. Loop Index variable is declared a genvar Declaration 
prior to itsuse in a loop scheme

The genvar is not to be referenced anywhere other than inside the loop. all params inside the generate are implicit localparams decls
Its not possible to have two nested loop generate constructs that use the same genvar.

generate blocks inside the loop construct can be named or unnamed. 

if the generate block is named it is declared as an array of generate block instances which use the genvar value as its index value
*/

//Example of legal and illegal generate loop page 789 
module mod_a;
    genvar i;
    // the generate and endgenerate keywords are not required
    
    for ( i=0; i<5; i++ ) begin : a //naming the loop a
        for ( i=0; i<5; i++ ) begin : b
            ...     // error using "i" as loop index for 
            ...     // Two nested generate loops will cause an error need to make another genvar
        end
    end
endmodule 

module mod_b;
    genvar i;
    logic a;

    for ( i=1; i<0; i++ )  begin : a
        ...     //Error because the block name conflicts with the variable a
    end
endmodule

module mod_c;
    genvar i;

    for ( i=1; i<5; i++ ) begin : a 
        ...
    end

    for ( i=10; i<15; i++ ) begin : a
        ...         //Error because the block conflicts with previous loop 
        ...         // regardless of the fact that the indices are unique
    end
endmodule

// Example 2 from page 790, A parameterized gray-code-to-binary-code coverter module using a loop
// to generate continous assignments
module gray2bin1 (bin, gray);
    parameter SIZE = 8;     //This module is parameterizable by changing the input param
    output [SIZE-1:0] bin;
    input [SIZE-1:0] gray;

    genvar i; 
    generate
        for ( i=0; i<SIZE; i++) begin : bitnum
            assign bin[i] = ^gray[SIZE-1:i];
            // i refers to the implicityly defined localparam whose 
            // value in each instance of the generate block is
            // the value of the genvar when its elaborated 
        end
    endgenerate 
endmodule

// Paramterized modules of ripple addders using a loop to generate SV gate primitives. The example below
// Uses a two-dimensional net declaration outsie of the genrate loop to make the connections between the gate primitives

module ripple_adder_gen1 ( co, sum, a, b, ci );
    parameter SIZE = 4;
    output [SIZE-1:0] sum;
    output            co;
    input  [SIZE-1:0] a, b;
    input             ci;
    wire   [SIZE  :0] c;
    wire   [SIZE-1:0] t [1:3];
    
    genvar i;

    assign c[0] = ci

    // Hierarchical gate instance names are:
    // xor gates: bitnum[0].g1    bitnum[1].g1    bitnum[2].g1    bitnum[3].g1
    //            bitnum[0].g2    bitnum[1].g2    bitnum[2].g2    bitnum[3].g2
    // and gates: bitnum[0].g3    bitnum[1].g3    bitnum[2].g3    bitnum[3].g3    
    //            bitnum[0].g4    bitnum[1].g4    bitnum[2].g4    bitnum[3].g4
    // or gates:  bitnum[0].g5    bitnum[1].g5    bitnum[2].g5    bitnum[3].g5
    // Generated instances are connected with the
    // The multidimensional nets t[1][3:0]     t[2][3:0]     t[3][3:0]      (12 nets total)    

    for ( i=0; i<SIZE; i++ ) begin : bitnum 
        xor g1 ( t[1][i],   a[i],       b[i]    );
        xor g2 ( sum[i],    t[1][i],    c[i]    );
        and g3 ( t[2][i],   a[i],       b[i]    );
        and g4 ( t[3][i],   t[1][i],    c[i]    );
        or  g5 ( c[i+1],    t[2][i],    t[3][i] );
    end

    assign co = c[SIZE];

endmodule    


// Second parametrized module of a ripple adder which instead uses a net declared within the generate loop
module addergen1 (co, sum, a, b, ci);
    parameter SIZE = 4;
    output [SIZE-1:0] sum;
    output co;
    input [SIZE-1:0] a, b;
    input ci;
    wire [SIZE :0] c;
    
    genvar i;
    
    assign c[0] = ci;
        // Hierarchical gate instance names are:
        // xor gates: bitnum[0].g1 bitnum[1].g1 bitnum[2].g1 bitnum[3].g1
        // bitnum[0].g2 bitnum[1].g2 bitnum[2].g2 bitnum[3].g2
        // and gates: bitnum[0].g3 bitnum[1].g3 bitnum[2].g3 bitnum[3].g3
        // bitnum[0].g4 bitnum[1].g4 bitnum[2].g4 bitnum[3].g4
        // or gates: bitnum[0].g5 bitnum[1].g5 bitnum[2].g5 bitnum[3].g5
        // Gate instances are connected with nets named:
        // bitnum[0].t1 bitnum[1].t1 bitnum[2].t1 bitnum[3].t1
        // bitnum[0].t2 bitnum[1].t2 bitnum[2].t2 bitnum[3].t2
        // bitnum[0].t3 bitnum[1].t3 bitnum[2].t3 bitnum[3].t3
    for(i=0; i<SIZE; i=i+1) begin : bitnum
        wire t1, t2, t3;
        
        xor g1 ( t1,        a[i],   b[i]);
        xor g2 ( sum[i],    t1,     c[i]);
        and g3 ( t2,        a[i],   b[i]);
        and g4 ( t3,        t1,     c[i]);
        or  g5 ( c[i+1],    t2,     t3);
    
    end
    assign co = c[SIZE];

endmodule 