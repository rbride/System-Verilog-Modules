module mux_sync(
    input wire clk_src,
    input wire clk_dst,
    input reg [15:0] data_in,
    output reg [15:0] data_out,
    input wire wr_en
);
//Assume the wr_en is not flip flopped for some reason, but the data already is.
reg wr_en_src_ff;
reg dff1;   reg dff2;

always @(posedge clk_src) begin
    wr_en_src_ff <= wr_en;    
end

always @(posedge clk_dst) begin
    dff1 <= wr_en_src_ff
    dff2 <= dff1;

    if(dff2) 
        data_out <= data_in;
    else 
        data_out <= data_out;
end

endmodule
