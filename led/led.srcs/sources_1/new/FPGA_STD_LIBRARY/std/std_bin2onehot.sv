//#############################################################################
//# Function: Binary to one hot encoder                                       #


module std_bin2onehot #(parameter  N  = 2, /* output vector width*/ parameter  NB = $clog2(N) /* binary encoded input*/)
(
	input [NB-1:0] in, // unsigned binary input  
	output [N-1:0] out   // one hot output vector
);

genvar 	    i;
generate
	for(i=0;i<N;i=i+1) begin: gen_onehot
	  assign out[i] = (in[NB-1:0] == i);
	end
endgenerate

endmodule // std_bin2onehot

