`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride
// Create Date: 05/06/2023 05:56:43 PM
// Design Base: Modular Test Bench Base 1
// Description: 
//     Modular Test Bench Based on the Chip Verify description of a test bench setup
//     Used to Test Scrambler ( G(x) = x^58 + x^39 + 1 ) circuit implementation  
//
// Revision 1 - Initial test bench infastructure
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////
//  Top Level TestBench Module  //
//////////////////////////////////
module tb;
    reg clk;
    logic enable_myS;
    logic reset; 
    //logic tx_prb_disable; just disable for everything
    
    //Input for both Scramblers
    logic [63:0] Scramb_In_Test; 
    
    logic enable_scrambler;
    
    logic [63:0] my_scramb_data_out;
    
    /*
    logic [63:0] my_descramb_data_in;
    logic [63:0] my_descramb_data_out;
    */
    logic [63:0] ref_scramb_data_out;
    
    logic [63:0] ref_descramb_data_in_1;
    logic [63:0] ref_descramb_data_out_1;
    
    logic [63:0] ref_descramb_data_in_2;
    logic [63:0] ref_descramb_data_out_2;
    
    //logic [63:0] Desc_from_My;
    //logic [63:0] Desc_from_Ref;
    logic [63:0] inter;

    scrambler_64bit DUT0 ( .CLK(clk),
                           
                           .data_in(Scramb_In_Test), 
                           .data_out(my_scramb_data_out)
                           
             );
    
    /*Descrambler_64bit DUT1 ( .CLK(clk),
                             .rst(reset),
                             .Sr_In(my_descramb_data_in),
                             .D_UnS(inter)
                           ); */
    
    //Set Reverse to 1 and LFSR_FEED_FORWARD to 0 for scrambler 
    eth_phy_10g_tx_if #( .BIT_REVERSE(0), .FEED_FORWARD(0) )  
                            DUT2 ( .clk(clk), 
                                   .rst(reset), 
                                   .tx_prbs31_enable( 1'b0 ), 
                                   .encoded_tx_data(Scramb_In_Test),
                                   .serdes_tx_data(ref_scramb_data_out)                    
                                 );
                               
    //Set Reverse to 1??? maybe and LFSR_FEED_FORWARD to 1 for descrambler 
    eth_phy_10g_tx_if #( .BIT_REVERSE(0), .FEED_FORWARD(1) )  
                            DUT3 ( .clk(clk), 
                                   .rst(reset), 
                                   .tx_prbs31_enable( 1'b0 ), 
                                   .encoded_tx_data(ref_descramb_data_in_1),
                                   .serdes_tx_data(ref_descramb_data_out_1)                    
                                 );
    
    eth_phy_10g_tx_if #( .BIT_REVERSE(0), .FEED_FORWARD(1) )  
                            DUT4 ( .clk(clk), 
                                   .rst(reset), 
                                   .tx_prbs31_enable( 1'b0 ), 
                                   .encoded_tx_data(ref_descramb_data_in_2),
                                   .serdes_tx_data(ref_descramb_data_out_2)                    
                                 );
    
    /*generate 
        genvar n;
        for ( n=0; n<64; n++ ) begin
            assign my_descramb_data_out[n] = inter[64-n-1];
        end
    endgenerate 
    */
    always #5 clk = ~clk;
    always #10 std::randomize(Scramb_In_Test);
    
    //Assign Statements
    assign ref_descramb_data_in_2 = ref_scramb_data_out;
    assign ref_descramb_data_in_1 = my_scramb_data_out;
    
    //assign my_descramb_data_in = my_scramb_data_out;
    
    initial begin
        
        clk = 0;
        enable_myS = 1;
        reset = 0;
        Scramb_In_Test = 0;
        my_scramb_data_out = 0;
        enable_scrambler = 1'b0;
        ref_descramb_data_in_2 = { 64{1'b1}};
        ref_descramb_data_in_1 = { 64{1'b1}};
        //my_descramb_data_in =  { 64{1'b1}};

        
        
        //The Holy Starting Value that guides me #Blessed
        Scramb_In_Test = 64'h9bd3c750ce28aac0;    
        
                        
        //assign ref_scramb_data_in = Scramb_In_Test; 
        //assign my_scramb_data_in = Scramb_In_Test;
        
       

        #100;
        
        $finish; 
    end 
endmodule


`resetall