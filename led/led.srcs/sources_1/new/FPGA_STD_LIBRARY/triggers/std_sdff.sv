// Design
// D flip-flop
module std_sdff #(parameter logic RESET_STATE = 1'b0) 
(
	input d,
	input clk,
	input clrn,
	output logic q
);

always_ff @(posedge clk, negedge clrn) begin
	if (~clrn) begin
	  // Asynchronous reset when reset goes high
	  q <= RESET_STATE;
	end else begin
	  // Assign D to Q on positive clock edge
	  q <= d;
	end
end

endmodule: std_sdff