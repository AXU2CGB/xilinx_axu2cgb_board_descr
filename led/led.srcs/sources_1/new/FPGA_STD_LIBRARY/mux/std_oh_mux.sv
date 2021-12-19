//#############################################################################
//# Function: "ONE HOT" N:1 MUX                                               #
//#############################################################################


module std_oh_mux #(parameter DW  = 1, /* width of data inputs*/ parameter N = 2  /* number of inputs*/, parameter PRIORITY_TYPE = "MSB" /*MSB, LSB, NONE*/)
(
	input [N-1:0]    sel, // select vector
	input [N*DW-1:0] in, // concatenated input {.., in1[DW-1:0], in0[DW-1:0]}
	output [DW-1:0]  out  // output
);

//local variable

logic [DW-1:0]  out_local;

genvar i;
generate

	if(PRIORITY_TYPE == "LSB") begin
		
		always_comb begin
			out_local[DW-1:0] <= {DW{1'b0}};
			
			for(int i = N; i != 0; i--) begin
				if(sel[i-1]) begin
					out_local[DW-1:0] <= in[(i*DW-1)-:DW];
				end
			end
		end
		
	end else if(PRIORITY_TYPE == "MSB") begin
		
		always_comb begin
			out_local[DW-1:0] <= {DW{1'b0}};
			
			for(int i = 0; i < N; i++) begin
				if(sel[i]) begin
					out_local[DW-1:0] <= in[((i+1)*DW-1)-:DW];
				end
			end
		end
	end else begin
		
		always_comb begin
			out_local[DW-1:0] = {DW{1'b0}};
			
			for (int i = 0; i < N; i++) begin
				out_local |= {(DW){sel[i]}} & in[((i+1)*DW-1)-:DW];
			end
		end
		
	end
	
endgenerate

assign out[DW-1:0] = out_local[DW-1:0];

endmodule // std_oh_mux



