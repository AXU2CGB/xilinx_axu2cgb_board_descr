//#############################################################################
//# Function: Rising Edge Sampled Register                                    #
//#############################################################################

module std_reg1 #(parameter DW = 1 /* data width*/) 
(
	input        nreset, //async active low reset
	input 	     clk, // clk
	input 	     en, // write enable
	input [DW-1:0]  in, // input data
	output [DW-1:0] out  // output data (stable/latched when clk=1)
);

logic [DW-1:0]      out_reg;

always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		out_reg[DW-1:0] <= 'b0;
	end else if(en) begin
		out_reg[DW-1:0] <= in[DW-1:0];
	end
end

assign out[DW-1:0] = out_reg[DW-1:0];	   

endmodule // std_reg1





