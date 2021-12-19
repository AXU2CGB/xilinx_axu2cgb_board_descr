//#############################################################################
//# Function: Positive edge-triggered inverting static D-type flop-flop       #
//#############################################################################

module std_dffqn #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	clk,
	output logic [DW-1:0] qn
);

always_ff @(posedge clk) begin
	qn <= ~d;
end

endmodule
