//#############################################################################
//# Function: Reset synchronizer (async assert, sync deassert)                #
//#############################################################################

module std_rsync #(parameter PS = 2 /* number of sync stages*/)
(
	input  clk,
	input  nrst_in,
	output nrst_out
);

logic [PS-1:0] sync_pipe = '0;

always_ff @(posedge clk, negedge nrst_in) begin		 
	if(!nrst_in) begin
		sync_pipe[PS-1:0] <= '0;
	end else begin
		sync_pipe[PS-1:0] <= {sync_pipe[PS-2:0], 1'b1};
	end
end

assign nrst_out = sync_pipe[PS-1];

endmodule // std_rsync

