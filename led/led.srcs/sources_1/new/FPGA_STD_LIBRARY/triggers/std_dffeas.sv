module std_dffeas
(
	input d,
	input clk,
	input clrn,
	input prn,
	input ena,
	input asdata,
	input aload,
	input sclr,
	input sload,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge aload, posedge clk) begin : d_aload_enable_sclear_flip_flop
		// The asynchronous reset signal has highest priority
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else if (aload) begin
			// Asynchronous load has next priority
			q <= asdata;
		end else begin
			// At a clock edge, if asynchronous signals have not taken priority,
			// respond to the appropriate synchronous signal.
			// Check for synchronous reset, then synchronous load.
			// If none of these takes precedence, update the register output 
			// to be the register input.
			if (ena) begin
				if (sclr) begin
					q <= 1'b0;
				end else if (sload) begin
					q <= asdata;
				end else begin
					q <= d;
				end
			end
		end
	end : d_aload_enable_sclear_flip_flop
	
`else
	
	dffeas d_aload_enable_sclear_flip_flop 
	(
		.d(d), 
		.clk(clk), 
		.clrn(clrn),
		.prn(prn),
		.ena(ena), 
		.asdata(asdata),
		.aload(aload), 
		.sclr(sclr), 
		.sload(sload), 
		.q(q)
	); 
	
`endif

endmodule: std_dffeas