//#############################################################################
//# Function: Clock synchronizer                                              #
//#############################################################################

module std_dsync #(parameter PS = 2  /* number of sync stages*/)
(
	input  clk, // clock
	input  nreset, // clock
	input  din, // input data
	output dout    // synchronized data
);

logic [PS-1:0] sync_pipe = '0; 

always_ff @(posedge clk, negedge nreset) begin	 
	if(!nreset) begin
		sync_pipe[PS-1:0] <= 'b0;
	end else begin
		sync_pipe[PS-1:0] <= {sync_pipe[PS-2:0], din};
	end
end

assign dout = sync_pipe[PS-1];

endmodule // std_dsync


