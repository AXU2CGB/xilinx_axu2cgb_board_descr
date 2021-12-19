//#############################################################################
//# Purpose: Serial to Parallel Converter                                     #
//#############################################################################


module std_ser2par #(
	parameter PW = 64, // parallel packet width
	parameter SW = 1,   // serial packet width
	parameter CW = $clog2(PW/SW)  // serialization factor (for counter)
)
(
	input 				clk, // sampling clock   
	input 	    		nreset, // async active low reset
	input [SW-1:0] 		din, // serial data
	output logic [PW-1:0] dout, // parallel data  
	input 		lsbfirst, // lsb first order
	input 		shift      // shift the shifter
);


always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		dout[PW-1:0] <= 'b0;
	end else if(shift & lsbfirst) begin
		dout[PW-1:0] <= {din[SW-1:0],dout[PW-1:SW]};
	end else if(shift) begin
		dout[PW-1:0] <= {dout[PW-SW-1:0],din[SW-1:0]};
	end
end

endmodule // std_ser2par
