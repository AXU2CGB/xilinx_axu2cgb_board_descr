module std_jkff
(
	input j,
	input k,
	input clk,
	input clrn,
	input prn,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin
		// The asynchronous reset signal has highest priority
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else begin
			unique case ({j,k})
				2'b00 :  q <= q;
				2'b01 :  q <= 0;
				2'b10 :  q <= 1;
				2'b11 :  q <= ~q;
			endcase
		end
	end
	
`else
	
	jkff jk_flip_flop (
		.j(j), 
		.k(k), 
		.clk(clk), 
		.clrn(clrn), 
		.prn(prn), 
		.q(q)
	);
	
`endif

endmodule: std_jkff