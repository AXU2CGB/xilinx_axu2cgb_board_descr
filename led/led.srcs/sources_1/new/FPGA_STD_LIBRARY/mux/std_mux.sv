//#############################################################################
//# Function: "SIMPLE" N:1 MUX                                               #
//#############################################################################


module std_mux #( parameter DW  = 1, /* width of data inputs*/ parameter N = 2  /* number of inputs*/)
(
	input [$clog2(N) - 1:0]    sel, // select vector
	input [N*DW-1:0] in, // concatenated input {.., in1[DW-1:0], in0[DW-1:0]}
	output [DW-1:0]  out  // output
);

logic [N-1:0] [DW-1:0] in_mux;

assign in_mux = in;
assign out[DW-1:0] = in_mux[sel];

endmodule // std_mux



