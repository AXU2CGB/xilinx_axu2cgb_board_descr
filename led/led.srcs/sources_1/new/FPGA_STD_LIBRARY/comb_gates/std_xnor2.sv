//#############################################################################
//# Function: 2-Input Exclusive-NOr Gate                                      #
//#############################################################################

module std_xnor2 #(parameter DW = 1 ) // array width
(
	input [DW-1:0]  a,
	input [DW-1:0]  b,
	output [DW-1:0] z
);

assign z =  ~(a ^ b);

endmodule
