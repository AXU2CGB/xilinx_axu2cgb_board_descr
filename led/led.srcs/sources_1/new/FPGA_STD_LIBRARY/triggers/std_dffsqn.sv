//#############################################################################
//# Function:  Positive edge-triggered static inverting D-type flop-flop with #
//             async active low set.                                          #
//#############################################################################

module std_dffsqn #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	clk,
	input [DW-1:0] 	nset,
	output logic [DW-1:0] qn
);

always @ (posedge clk or negedge nset) begin
	if(!nset) begin
		qn <= 'b0;
	end else begin
		qn <= ~d;
	end
end

endmodule
