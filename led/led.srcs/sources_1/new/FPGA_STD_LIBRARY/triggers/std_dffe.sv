module std_dffe
(
	input d,
	input clk,
	input clrn,
	input prn,
	input ena,
	output logic q
);

`ifdef NO_PRIMITIVES

	// Register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin : d_enable_flip_flop
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else if (ena) begin
			q <= d;
		end
	end : d_enable_flip_flop
	
`else
	
	dffe d_enable_flip_flop (.d(d), .clk(clk), .clrn(clrn), .prn(prn), .ena(ena), .q(q));
	
`endif

endmodule: std_dffe