module std_stff #(parameter logic RESET_STATE = 1'b0)
(
	input t,
	input clk,
	input clrn,
	output logic q
);

// In Altera devices, register signals have a set priority.
// The HDL design should reflect this priority.
always_ff @(posedge clk, negedge clrn) begin : t_flip_flop
	// The asynchronous reset signal has highest priority
	if (~clrn) begin
		q <= RESET_STATE;
	end else if(t) begin
		q <= ~q;
	end
end : t_flip_flop


endmodule: std_stff