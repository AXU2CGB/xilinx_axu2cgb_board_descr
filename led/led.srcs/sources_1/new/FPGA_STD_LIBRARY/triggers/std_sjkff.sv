module std_sjkff #(parameter logic RESET_STATE = 1'b0)
(
	input j,
	input k,
	input clk,
	input clrn,
	output logic q
);

always_ff @(posedge clk, negedge clrn) begin : jk_flip_flop
	// The asynchronous reset signal has highest priority
	if (~clrn) begin
		q <= RESET_STATE;
	end else begin
		unique case ({j,k})
			2'b00 :  q <= q;
			2'b01 :  q <= 0;
			2'b10 :  q <= 1;
			2'b11 :  q <= ~q;
		endcase
	end
end : jk_flip_flop
	

endmodule: std_sjkff