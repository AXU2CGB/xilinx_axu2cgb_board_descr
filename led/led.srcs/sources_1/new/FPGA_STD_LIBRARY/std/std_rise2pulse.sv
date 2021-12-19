//#############################################################################
//# Function: Converts a rising edge to a single cycle pulse                  #
//#############################################################################


module std_rise2pulse #(parameter DW = 1) // data width
(  
	input           clk,     // clock
	input 	      nreset, // async active low reset   
	input [DW-1:0]  in, // edge input
	output [DW-1:0] out     // one cycle pulse
);

logic [DW-1:0]    in_reg;

always_ff @(posedge clk, negedge nreset) begin 
	if(!nreset) begin
		in_reg[DW-1:0]  <= 'b0;
	end else begin
		in_reg[DW-1:0]  <= in[DW-1:0] ;
	end
end

assign out[DW-1:0]  = in[DW-1:0] & ~in_reg[DW-1:0] ;
   
endmodule // std_rise2pulse

