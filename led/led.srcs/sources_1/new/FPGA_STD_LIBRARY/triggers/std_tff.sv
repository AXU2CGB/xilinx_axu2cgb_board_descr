module std_tff
(
	input t,
	input clk,
	input clrn,
	input prn,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin : t_flip_flop
		// The asynchronous reset signal has highest priority
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else if(t) begin
			q <= ~q;
		end
	end : t_flip_flop
	
`else

	tff t_flip_flop 
	(
		.t(t), 
		.clk(clk), 
		.clrn(clrn), 
		.prn(prn), 
		.q(q)
	);
	
`endif

endmodule: std_tff