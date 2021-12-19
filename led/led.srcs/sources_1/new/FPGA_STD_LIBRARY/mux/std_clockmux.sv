//#############################################################################
//# Function: Clock mux                                                       #
//#############################################################################

module std_clockmux #(parameter N = 1)    // number of clock inputs
(
	input [N-1:0] en, // one hot enable vector (needs to be stable!)
	input [N-1:0] clkin,// one hot clock inputs (only one is active!) 
	output 	  clkout 
);


assign clkout = |(clkin[N-1:0] & en[N-1:0]);

endmodule // std_clockmux


