//#############################################################################
//# Function: 3-Input Mux                                                     #
//#############################################################################

module std_mux3 #(parameter DW = 1 ) // array width
(
	input [DW-1:0]  d0,
	input [DW-1:0]  d1,
	input [DW-1:0]  d2,
	input [DW-1:0]  s0,
	input [DW-1:0]  s1,
	output [DW-1:0] z
);

assign z = (d0 & ~s0 & ~s1) | (d1 & s0  & ~s1) | (d2 & s1);

endmodule
