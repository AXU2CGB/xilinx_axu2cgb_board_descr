//#############################################################################
//# Function: Power supply header switch                                      #
//#############################################################################


module std_pwr_gate
(
	input  npower, // active low power on
	input  vdd, // input supply
	output vddg     // gated output supply
);

`ifdef TARGET_SIM
   assign vddg = ((vdd===1'b1) && (npower===1'b0)) ? 1'b1 : 1'bX; 		  
`endif


endmodule // std_pwr_gate
