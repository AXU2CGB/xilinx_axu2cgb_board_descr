// Design
// D flip-flop enable
module std_sdffe #(parameter logic RESET_STATE = 1'b0)
(
	input d,
	input clk,
	input clrn,
	input ena,
	output logic q
);

always_ff @(posedge clk, negedge clrn) begin
	if (~clrn) begin
	  // Asynchronous reset when reset goes high
	  q <= RESET_STATE;
	end else if(ena) begin
	  // Assign D to Q on positive clock edge
	  q <= d;
	end
end

endmodule: std_sdffe