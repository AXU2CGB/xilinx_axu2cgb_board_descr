//#############################################################################
//# Function:  D-type active-high transparent latch                           #
//#############################################################################

module std_latq #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	g,
	output logic [DW-1:0] q
);

always_latch begin
	if(g) begin
		q <= d;
	end
end

endmodule
