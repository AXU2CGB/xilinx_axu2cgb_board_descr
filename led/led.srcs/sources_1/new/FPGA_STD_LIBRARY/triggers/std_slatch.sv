module std_slatch
(
	input d,
	input ena,
	output logic q
);

// Update the variable only when updates are enabled
always_latch begin : latch_ff
	if (ena) begin
		q <= d;
	end
end : latch_ff

endmodule: std_slatch