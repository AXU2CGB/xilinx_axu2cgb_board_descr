//#############################################################################
//# Function: 2:1 Clock Mux                                                   #
//#############################################################################

module std_clockmux2 #(parameter N    = 1       /*vector width*/)
(
	input [N-1:0]  en0, // clkin0 enable (stable high)
	input [N-1:0]  en1, // clkin1 enable (stable high)
	input [N-1:0]  clkin0, // clock input
	input [N-1:0]  clkin1, // clock input
	output [N-1:0] clkout // clock output
);

assign clkout[N-1:0] = (en0[N-1:0] & clkin0[N-1:0]) | (en1[N-1:0] & clkin1);

endmodule //std_clockmux2