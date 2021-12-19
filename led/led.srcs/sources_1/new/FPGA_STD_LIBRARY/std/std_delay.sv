//#############################################################################
//# Function: Delays input signal by N clock cycles                           #
//#############################################################################

module std_delay  #(
	parameter DW = 1, /* width of data*/ 
	parameter N  = 1  /* clock cycle delay by*/,
	parameter RESET_SYNC = 0
)

(
	input 	    clk,//clock input
	input 	    nreset,//clock input
	
	input [DW-1:0]  in, // input
	output [DW-1:0] out // output
);

// reset sync selection -------------------------------------------------------------------------------------------
logic reset_sync;

generate
	if(RESET_SYNC) begin
		std_rsync #(.PS(2)) reset_sync (.clk(clk), .nrst_in(nreset), .nrst_out(reset_sync));
	end else begin
		assign reset_sync = nreset;
	end
endgenerate
//------------------------------------------------------------------------------------------------------------------

logic [DW-1:0] sync_pipe [N-1:0] = '{default:'0};

always_ff @(posedge clk, negedge reset_sync) begin
	if(!reset_sync) begin
		sync_pipe[0] <= '0;
	end else begin
		sync_pipe[0] <= in[DW-1:0];
	end
end

genvar 	    i;
generate
	for(i=1;i<N;i=i+1) begin: gen_pipe
	
		always_ff @(posedge clk, negedge reset_sync) begin
			if(!reset_sync) begin
				sync_pipe[i] <= '0;
			end else begin
				sync_pipe[i] <= sync_pipe[i-1];
			end
		end
	
	end
endgenerate

assign out[DW-1:0] = sync_pipe[N-1];

endmodule // std_delay



