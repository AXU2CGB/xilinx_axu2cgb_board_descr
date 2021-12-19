//#############################################################################
//# Function: 4:1 Clock Mux                                                   #
//#############################################################################

module std_clockmux4 #(parameter N    = 1 /*vector width*/)
(
	input [N-1:0]  en0, // clkin0 enable (stable high)
	input [N-1:0]  en1, // clkin1 enable (stable high)
	input [N-1:0]  en2, // clkin1 enable (stable high)
	input [N-1:0]  en3, // clkin1 enable (stable high)
	input [N-1:0]  clkin0, // clock input
	input [N-1:0]  clkin1, // clock input
	input [N-1:0]  clkin2, // clock input
	input [N-1:0]  clkin3, // clock input
	output [N-1:0] clkout // clock output
);

assign clkout[N-1:0] = (en0[N-1:0] & clkin0[N-1:0]) |
	(en1[N-1:0] & clkin1[N-1:0]) |
	(en2[N-1:0] & clkin2[N-1:0]) |
	(en3[N-1:0] & clkin3[N-1:0]);

endmodule//std_clockmux4