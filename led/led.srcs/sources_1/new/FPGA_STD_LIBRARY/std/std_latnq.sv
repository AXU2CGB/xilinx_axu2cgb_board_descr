//#############################################################################
//# Function:  D-type active-low transparent latch                            #
//#############################################################################

module std_latnq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	gn,
	output logic [DW-1:0] q
);

always_latch begin
	if(!gn) begin
		q <= d;
	end
end

endmodule
