
module std_nmos
(
	input  g,
	input  s,
	inout  d
);

// Primitive Device (out,in,ctrlr)
nmos n (d, s, g);

endmodule

