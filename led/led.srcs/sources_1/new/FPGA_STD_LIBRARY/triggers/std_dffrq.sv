//#############################################################################
//# Function:  Positive edge-triggered static D-type flop-flop with async     #
//#            active low reset.                                              #
//#############################################################################

module std_dffrq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	clk,
	input [DW-1:0] 	nreset,
	output logic [DW-1:0] q
);

always_ff @(posedge clk or negedge nreset) begin
	if(!nreset) begin
		q <= 'b0;
	end else begin
		q <= d;
	end
end

endmodule
