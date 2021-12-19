module std_slatch_clr #(parameter logic RESET_STATE = 1'b0)
(
	input d,
	input clrn,
	input ena,
	output logic q
);

always_latch begin
	if (~clrn) begin
		// The reset signal overrides the hold signal; reset the value to 0
		q <= RESET_STATE;
	end else if (ena) begin
		// Otherwise, change the variable only when updates are enabled
		q <= d;
	end
end



endmodule: std_slatch_clr