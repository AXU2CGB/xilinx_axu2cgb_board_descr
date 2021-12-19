//#############################################################################
//# Function: Buffer                                                          #
//#############################################################################


module std_buffer #(parameter N = 1,  /* number of inputs*/ parameter SIZE = 1  /* size of buffer*/)
(
	input [N-1:0] in, // input
	output [N-1:0] out // output
);

assign out[N-1:0] = in[N-1:0];

endmodule // std_buffer



