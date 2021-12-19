//#############################################################################
//# Function:  Positive edge-triggered static D-type flop-flop with async     #
//#            active low preset and scan input.                              #
//#############################################################################

module std_sdffsq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	si,
	input [DW-1:0] 	se,
	input [DW-1:0] 	clk,
	input [DW-1:0] 	nset,
	output logic [DW-1:0] q
);

always_ff @(posedge clk, negedge nset) begin
	if(!nset) begin
		q <= {DW{1'b1}};
	end else begin
		q <= se ? si : d;
	end
end

endmodule
