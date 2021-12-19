module std_latch
(
	input d,
	input ena,
	output logic q
);

`ifdef NO_PRIMITIVES

	// Update the variable only when updates are enabled
	always_latch begin : latch_ff
		if (ena) begin
			q <= d;
		end
	end : latch_ff
	
`else
	
	latch latch_ff (
		.d(d), 
		.ena(ena), 
		.q(q)
	);
	
`endif

endmodule: std_latch