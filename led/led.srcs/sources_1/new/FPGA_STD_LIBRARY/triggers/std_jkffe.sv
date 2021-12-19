module std_jkffe
(
	input j,
	input k,
	input clk,
	input clrn,
	input prn,
	input ena,
	output logic q
);

`ifdef NO_PRIMITIVES

	// In Altera devices, register signals have a set priority.
	// The HDL design should reflect this priority.
	always_ff @(negedge clrn, negedge prn, posedge clk) begin : jk_enable_flip_flop
		// The asynchronous reset signal has highest priority
		if (~clrn) begin
			q <= 1'b0;
		end else if (~prn) begin
			q <= 1'b1;
		end else if(ena) begin
			unique case ({j,k})
				2'b00 :  q <= q;
				2'b01 :  q <= 0;
				2'b10 :  q <= 1;
				2'b11 :  q <= ~q;
			endcase
		end
	end : jk_enable_flip_flop
	
`else
	
	jkffe jk_enable_flip_flop (
		.j(j), 
		.k(k), 
		.clk(clk), 
		.clrn(clrn), 
		.prn(prn),
		.ena(ena), 
		.q(q)
	);
	
`endif

endmodule: std_jkffe