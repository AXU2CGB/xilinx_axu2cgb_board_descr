//#############################################################################
//# Function: Buffer that propagates "X" if power supply is invalid           #
//#############################################################################

module std_pwr_buf #( parameter DW = 1) // width of data inputs
(
	input 	   vdd, // supply (set to 1 if valid)
	input 	   vss, // ground (set to 0 if valid)
	input [DW-1:0]  in, // input signal
	output [DW-1:0] out    // buffered output signal
);
   
`ifdef TARGET_SIM   
   assign out[DW-1:0] = ((vdd===1'b1) && (vss===1'b0)) ? in[DW-1:0] : {(DW){1'bX}};
`else
   assign out[DW-1:0] = in[DW-1:0];
`endif

   
endmodule // std_pwr_buf