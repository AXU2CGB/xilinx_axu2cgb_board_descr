module std_pmos
(
	input  g,
	input  s,
	inout  d
);

// Primitive Device (out,in,ctrlr)
pmos p (d, s, g);

endmodule
