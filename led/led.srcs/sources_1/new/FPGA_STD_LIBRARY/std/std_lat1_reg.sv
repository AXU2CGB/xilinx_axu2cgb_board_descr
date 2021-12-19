//#############################################################################
//# Function: Achive high latch                                            #
//#############################################################################

module std_lat1_reg #(parameter DW = 1            /* data width*/, RST = 0) 
(
	input 	     clk, // clk, latch when clk=1
	input 	     nreset,
	input [DW-1:0]  in, // input data
	output [DW-1:0] out  // output data (stable/latched when clk=0)
);

logic [DW-1:0]      out_reg;

initial begin
	out_reg <= DW '(RST);
end

always_latch begin
	if(!nreset) begin
		out_reg[DW-1:0] <= DW '(RST);
	end else if (clk) begin
		out_reg[DW-1:0] <= in[DW-1:0];
	end
end

assign out[DW-1:0] = out_reg[DW-1:0];

endmodule // std_lat1_reg


