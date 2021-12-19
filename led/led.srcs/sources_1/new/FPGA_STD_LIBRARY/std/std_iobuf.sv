//#############################################################################
//# Function: IO Buffer                                                       #
//#############################################################################

module std_iobuf #(parameter N    = 1 /* BUS WIDTH*/)
(
	//DATA
	input [N-1:0]  ie, //input enable
	input [N-1:0]  oe, //output enable
	output [N-1:0] out,//output to core
	input [N-1:0]  in, //input from core
	//BIDIRECTIONAL PAD
	inout [N-1:0]  pad
);

genvar 	   i;
generate
	
	//TODO: Model power signals
	for (i = 0; i < N; i = i + 1) begin : gen_buf
		assign pad[i] = oe[i] ? in[i] : 1'bZ;
		assign out[i] = ie[i] ? pad[i] : 1'b0;
	end
	
endgenerate

endmodule // std_iobuf


