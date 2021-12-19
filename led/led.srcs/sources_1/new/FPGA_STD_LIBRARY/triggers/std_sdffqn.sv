//#############################################################################
//# Function: Positive edge-triggered inverting static D-type flop-flop       #
//#############################################################################

module std_sdffqn #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	si,
	input [DW-1:0] 	se,
	input [DW-1:0] 	clk, 
	output reg [DW-1:0] qn
);

always_ff @(posedge clk) begin
	qn <= se ? ~si : ~d;
end

endmodule
