//#############################################################################
//# Function: 2 Input And Gate                                                #
//#############################################################################

module std_and2  #(parameter N  = 1 /*block width*/)
(
	input [N-1:0]  a,
	input [N-1:0]  b,
	output [N-1:0] z
);

assign z = a & b;

endmodule
