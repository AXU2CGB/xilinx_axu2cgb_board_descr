//#############################################################################
//# Function: Clock 'OR' gate                                                 #
//#############################################################################


module std_clockor #(parameter N    = 1)    // number of clock inputs
(
	input [N-1:0] clkin,// one hot clock inputs (only one is active!) 
	output 	  clkout 
);

assign clkout = |(clkin[N-1:0]);

endmodule // std_clockor


