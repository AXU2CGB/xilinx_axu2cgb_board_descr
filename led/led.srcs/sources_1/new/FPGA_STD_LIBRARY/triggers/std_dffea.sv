module std_dffea
(
	input d,
	input clk,
	input clrn,
	input prn,
	input ena,
	input adata,
	input aload,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge aload, posedge clk) begin : d_aload_enable_flip_flop
		// The asynchronous reset signal has highest priority
		if (!clrn) begin
			q <= 1'b0;
		end else if (!prn) begin
			q <= 1'b1;
		end else if (aload) begin
		// Asynchronous load has next priority
			q <= adata;
		end else if (ena) begin
			q <= d;
		end
	end : d_aload_enable_flip_flop
	
`else
	
	dffea d_aload_enable_flip_flop 
	(
		.d(d), 
		.clk(clk), 
		.clrn(clrn), 
		.prn(prn), 
		.ena(ena), 
		.adata(adata), 
		.aload(aload), 
		.q(q)
	);
	
`endif

endmodule: std_dffea