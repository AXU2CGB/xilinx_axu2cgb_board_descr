//#############################################################################
//# Function: Converts an edge to a single cycle pulse                        #
//#############################################################################

module std_edge2pulse #( parameter DW = 1, /* width of data inputs*/ parameter TYPE = "BOTH_EDGE"/* BOTH_EDGE, NEG_EDGE, POS_EDGE */)
(
	input 	    clk, // clock  
	input 	    nreset, // async active low reset   
	input [DW-1:0]  in, // edge input
	output [DW-1:0] out     // one cycle pulse
);

logic [DW-1:0]    in_reg;   

always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		in_reg[DW-1:0]  <= 'b0;
	end else begin
		in_reg[DW-1:0]  <= in[DW-1:0];
	end
end

generate
	if(TYPE == "BOTH_EDGE") begin
		assign out[DW-1:0] = in_reg[DW-1:0] ^ in[DW-1:0];
	end else if(TYPE == "NEG_EDGE") begin
		assign out[DW-1:0] = in_reg[DW-1:0] & (~in[DW-1:0]);
	end else if(TYPE == "POS_EDGE") begin
		assign out[DW-1:0] = (~in_reg[DW-1:0]) & in[DW-1:0];
	end
endgenerate


endmodule // std_edge2pulse
