module std_srffe
(
	input s,
	input r,
	input clk,
	input clrn,
	input prn,
	input ena,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin : sr_enable_flip_flop
		// The asynchronous reset signal has highest priority
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else if(ena) begin
			if(r) begin
				q <= 1'b0;
			end else if(s) begin
				q <= 1'b1;
			end
		end
	end : sr_enable_flip_flop
	
`else
	
	srffe sr_enable_flip_flop (
		.s(s), 
		.r(r), 
		.clk(clk), 
		.clrn(clrn), 
		.prn(prn),
		.ena(ena),
		.q(q)
	);
	
`endif

endmodule: std_srffe