//#############################################################################
//# Function: Positive edge-triggered static D-type flop-flop with scan input #
//#############################################################################

module std_sdffq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	si,
	input [DW-1:0] 	se,
	input [DW-1:0] 	clk,
	output logic [DW-1:0] q
);

always_ff @(posedge clk) begin
	q <= se ? si : d;
end

endmodule
