//#############################################################################
//# Function: Two's complement adder/subtractor                               #
//#############################################################################

module std_add #(parameter DW = 1)
(
	input [DW-1:0]  a, //first operand
	input [DW-1:0]  b, //second operand
	input 	    opt_sub, //subtraction option
	input 	    cin, //carry in
	output [DW-1:0] sum, //sum output
	output 	    cout //carry output
);

logic [DW-1:0]   b_sub;

assign b_sub[DW-1:0] = {(DW){opt_sub}} ^ b[DW-1:0];

assign {cout, sum[DW-1:0]}  =	a[DW-1:0]     + 
								b_sub[DW-1:0] +
								opt_sub       +
								cin;
endmodule // std_add
