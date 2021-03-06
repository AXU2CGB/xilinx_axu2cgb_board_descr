//#############################################################################
//# Function: 2 Input Nand Gate                                               # 
//#############################################################################

module std_nand2
(
	input  a,
	input  b, 
	output z
);

assign z = ~(a & b);

endmodule
