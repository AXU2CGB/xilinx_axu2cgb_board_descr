//#############################################################################
//# Function: Inverter                                                        #
//#############################################################################

module std_inv #(parameter DW = 1 ) // array width
(
	input [DW-1:0]  a,
	output [DW-1:0] z
);

assign z = ~a;

endmodule
