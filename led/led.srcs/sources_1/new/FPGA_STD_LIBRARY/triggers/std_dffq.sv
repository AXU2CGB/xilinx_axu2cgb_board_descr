//#############################################################################
//# Function: Positive edge-triggered static D-type flop-flop                 #
//#############################################################################

module oh_dffq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	clk,
	output logic [DW-1:0] q
);

always_ff @(posedge clk) begin
	q <= d;
end


endmodule
