//#############################################################################
//# Function: msb ==> lsb converter                                      #
//#############################################################################

module std_bitreverse #(parameter DW = 32 /* width of data inputs*/)
(
	input [DW-1:0]  in, // data input
	output logic [DW-1:0] out // bit reversed output
);

always_comb begin
	for (integer i = 0; i < DW; i = i + 1) begin
		out[i] <= in[DW-1-i]; 
	end
end	   
   
endmodule // std_bitreverse






