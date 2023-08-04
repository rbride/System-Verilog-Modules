`timescale 1ns / 1ps
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
class Data_Packet;
    rand bit [63:0] tx_data_in;
    //TXC isn't random because it doesn't need to be as of now
    bit [7:0] tx_ctrl;
    bit [63:0] tx_data_out;
    //Print Function is called by other Components, takes in a TAG to print
    function void print(string tag = "" );
        $display ("T=%0t [%s] Tx_Data_In=0b%0b b=0x%0b", $time, tag, tx_data_in, tx_data_out); 
    endfunction
    //Depending on setup might require a copy function
endclass

//Interface to connect verification components to the DUT using A virtual interface handle   
interface Data_Inf( input bit tx_clk );     
    logic [7:0]     _tx_ctrl;
    logic [63:0]    _tx_data_i;
    logic [63:0]    _tx_data_o;
    //More control logic signals to indicate data is ready or not 
    //Throw on a Clk Signal
    
endinterface

class Driver;
    virtual Data_Inf v_inf;
    event drv_done; 
    mailbox drv_mbox;

    task run();
        $display("T=%0t [Driver] starting ...", $time);
        //Try to get a new transcation every time then assign the packet contents to the interface
        //If the design is ready to accept a new transactions
        forever begin
            Data_Packet drv_pkt;
            $display ("T=%0t [Driver] waiting for item ...", $time);

            drv_mbox.get(drv_pkt);
            drv_pkt.print("Driver Packet");

            //Assign Values on the Virtual Interface to be the values in the current Packet
            v_inf._tx_ctrl <= drv_pkt.tx_ctrl; //Control Does nothing as of now//Design Example Which is an Adder, in combination logic without a clock
            v_inf._tx_data_i <= drv_pkt.tx_data_in;
            v_inf._tx_data_o <= drv_pkt.tx_data_out;

            //Put any info here if you have like a ready signal on the interface or whatever
            
        end
    endtask
endclass

class Monitor;
    virtual Data_Inf v_inf;
    mailbox scoreb_mbox;
    
    task run();
        $display ("T=%0t [Monitor] starting ...",  $time);
        //Check For Valid Transactions, if valid capture and send to Scoreboard
        forever begin
            Data_Packet m_pkt = new();
            @(posedge v_inf.tx_clk);
            #1;
            m_pkt.tx_data_out = v_inf._tx_data_o;
            m_pkt.tx_data_in = v_inf._tx_data_i;
            
            m_pkt.print("Monitor Packet");
            scoreb_mbox.put(m_pkt);
        end
    endtask
endclass

//Scoreboard to Check Data Integrity, Check to see if the Data on the TX out matches the expected
//Scrambled version of the data In.
class scoreboard;
    mailbox scoreb_mbox;
    bit [63:0] lfsr;
    
    task run();
        forever begin
            Data_Packet item = new();
            scoreb_mbox.get(item); 
            item.print("Packet Recieved By Scoreboard");
            assign lfsr = 0;
            for(int i=0;   ; i++ ); begin


            end
            
        
        end
    endtask
endclass

//////////////////////////////////
//  Top Level TestBench Module  //
//////////////////////////////////
module tb;
    reg clk;
    logic [63:0] tx_in_test;
    logic [63:0] tx_out_test;
    logic [7:0] lmao;
    PCS DUT ( .TX_CLK(clk), .TXD(tx_in_test), 
              .test_out(tx_out_test),
              .TXC(lmao));
       
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        tx_in_test = 0;
        tx_out_test = 0;
        
        #5; //Make some random ass data
        std::randomize(tx_in_test);
        #10;
        std::randomize(tx_in_test);
        #10;
        std::randomize(tx_in_test);
        #10;
        std::randomize(tx_in_test);
        #10;
        tx_in_test = 0;
        #50 $finish; 
    end 
endmodule

module serial_scrambler(
                        CLK,
                        Bit_In,
                        Bit_Out,
                        enable 
                        );
    //Define Outputs and Inputs
    input wire CLK;
    input wire Bit_In;
    input wire enable
    output logic Bit_Out;
    //x^1 + x^58 + x^39
    reg [57:0] s;
    assign feedback = { Bit_In ^ s[57]  ^ s[38]};
    assign Bit_Out = feedback;

    always @(posedge clk) begin
        if (enable == 1'b1) begin
            states <= { s[56], s[55], s[54], s[53], s[52], s[51], s[50], s[49], s[48],
                        s[47], s[46], s[45], s[44], s[43], s[42], s[41], s[40], s[39],
                        s[38], s[37], s[36], s[35], s[34], s[33], s[32], s[31], s[30],
                        s[29], s[28], s[27], s[26], s[25], s[24], s[23], s[22], s[21],
                        s[20], s[19], s[18], s[17], s[16], s[15], s[14], s[13], s[12],
                        s[11], s[10], s[9], s[8], s[7], s[6], s[5], s[4], s[3], s[2], 
                        s[1], s[0], feedback};
        end
    end
endmodule