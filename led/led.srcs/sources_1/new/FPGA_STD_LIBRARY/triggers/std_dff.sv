module std_dff
(
	input d,
	input clk,
	input clrn,
	input prn,
	output logic q
);

`ifdef NO_PRIMITIVES

	// Register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin : d_flip_flop
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else begin
			q <= d;
		end
	end : d_flip_flop
	
`else
	
	dff d_flip_flop (.d(d), .clk(clk), .clrn(clrn), .prn(prn), .q(q));
	
`endif

endmodule: std_dff