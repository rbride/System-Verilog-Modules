`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ryan Bride 
// Simple Filter Based off of following
// https://www.latticesemi.com/-/media/LatticeSemi/Documents/WhitePapers/HM/ImprovingNoiseImmunityforSerialInterface.ashx?document_id=50728
// Frequency  N     filter time (ns)
//  60        3         50
//  80        4         50 
//  100       5         50
//  150       7         47
//  200       10        50
//////////////////////////////////////////////////////////////////////////////////
//require a minimum 50ns glitch filter time for i2c so for sake of not making another clock
//Will set n to 6 and use the pre-existing 156.25Mhz and will result in a 60~ NS filter time
//Which is fine, this is i2c, its 400khz.. or even 100khz, the period of the SCL is 2500ns
// meaning filter is 2.4% of a period. Certified irrelevant. 

module ff_filter#(
    parameter n = 6
)(
    input clk;
    input in;
    output reg out;
);
reg [n-1:0] shift_reg;
always @(posedge clk) begin
  shift_reg <= {shift_reg[n-2:0], in};   // shift register for input in.
  if      (&shift_reg)  out <= 1'b1;    //& = reduction AND
  else if (~|shift_reg) out <= 1'b0;    //~| = reduction NOR
end
endmodule