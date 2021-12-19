//#############################################################################
//# Function: Negative edge-triggered static D-type flop-flop                 #
//#############################################################################

module std_dffnq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	clk,
	output logic [DW-1:0] q
);

always_ff @(negedge clk) begin
	q <= d;
end


endmodule
