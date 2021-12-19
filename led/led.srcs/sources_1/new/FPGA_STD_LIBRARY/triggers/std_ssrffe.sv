module std_ssrffe #(parameter logic RESET_STATE = 1'b0)
(
	input s,
	input r,
	input clk,
	input clrn,
	input ena,
	output logic q
);

always_ff @( posedge clk, negedge clrn) begin : sr_enable_flip_flop
	// The asynchronous reset signal has highest priority
	if (~clrn) begin
		q <= RESET_STATE;
	end else if(ena) begin
		if(r) begin
			q <= 1'b0;
		end else if(s) begin
			q <= 1'b1;
		end
	end
end : sr_enable_flip_flop

endmodule: std_ssrffe