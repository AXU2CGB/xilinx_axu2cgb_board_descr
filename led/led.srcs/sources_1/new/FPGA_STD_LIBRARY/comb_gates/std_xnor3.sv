//#############################################################################
//# Function: 3-Input Exclusive-NOr Gate                                       #
//#############################################################################

module std_xnor3 #(parameter DW = 1 ) // array width
(
	input [DW-1:0]  a,
	input [DW-1:0]  b,
	input [DW-1:0]  c,
	output [DW-1:0] z
);

assign z =  ~(a ^ b ^ c);

endmodule
