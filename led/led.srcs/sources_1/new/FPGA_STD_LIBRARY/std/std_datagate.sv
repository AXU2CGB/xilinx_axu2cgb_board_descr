//#############################################################################
//# Function: Low power data gate                                             #
//#############################################################################
  
module std_datagate #(parameter DW = 32, /* width of data inputs*/ parameter N  = 3   /* min quiet time before shutdown*/)
( 
	input 	     clk, // clock
	input		 nreset, // reset n
	input 	     en,  // data valid
	input [DW-1:0]  din, // data input
	output [DW-1:0] dout // data output    
);

logic [N-1:0]    enable_pipe;   
logic 	  enable;

always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		enable_pipe <= '0;
	end else begin
		enable_pipe[N-1:0] <= {enable_pipe[N-2:0], en};
	end
end

//Mask to 0 if no valid for last N cycles
assign enable = en | (|enable_pipe[N-1:0]);

assign dout[DW-1:0] = {(DW){enable}} & din[DW-1:0];
  
endmodule // std_datagate
