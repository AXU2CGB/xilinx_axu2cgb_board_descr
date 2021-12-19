module std_latch_clr
(
	input d,
	input clrn,
	input prn,
	input ena,
	output logic q
);

always_latch begin
	if (~clrn) begin
		// The reset signal overrides the hold signal; reset the value to 0
		q <= 1'b0;
	end else if (~prn) begin
		q <= 1'b1;
	end else if (ena) begin
		// Otherwise, change the variable only when updates are enabled
		q <= d;
	end
end

endmodule: std_latch_clr