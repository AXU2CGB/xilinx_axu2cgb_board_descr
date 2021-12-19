//#############################################################################
//# Function: Isolation (Low) buffer for multi supply domains                 #
//#############################################################################


module std_pwr_isolo #(parameter DW   = 1        /* width of data inputs*/) 
(
	input 	    iso,// active low isolation signal
	input [DW-1:0]  in, // input signal
	output [DW-1:0] out  // out = ~iso & in
);

assign out[DW-1:0] = {(DW){~iso}} & in[DW-1:0];
//assign out[N-1:0] = {(N){~iso}} | in[N-1:0];
 
endmodule // std_pwr_isolo
