//#############################################################################
//# Function: 2-Input Mux                                                     #
//#############################################################################

module std_mux2 #(parameter DW = 1 ) // array width
(
	input [DW-1:0]  d0,
	input [DW-1:0]  d1,
	input [DW-1:0]  s,
	output [DW-1:0] z
);

assign z = (d0 & ~s) | (d1 & s);

endmodule
