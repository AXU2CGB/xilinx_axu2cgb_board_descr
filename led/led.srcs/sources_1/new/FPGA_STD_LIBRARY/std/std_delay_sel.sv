//#############################################################################
//# Function: Delays input signal by N clock cycles                           #
//#############################################################################

module std_delay_sel #(
	parameter N        = 1,               // width of data
	parameter MAXDELAY = 4,               // maximum delay cycles
	parameter M        = $clog2(MAXDELAY) // delay selctor
)
(
	input 	   clk, //clock input
	input 	   nreset, //reset_n
	input [N-1:0]  in, // input vector
	input [M-1:0]  sel, // delay selector
	output [N-1:0] out  // output vector
);


//Delay pipeline
logic [N-1:0]     sync_pipe [MAXDELAY-1:0] = '{default:'0};
genvar 	    i;

generate
	always_ff @(posedge clk, negedge nreset) begin
		if(!nreset) begin
			sync_pipe[0] <= '0;
		end else begin
			sync_pipe[0] <= in[N-1:0];
		end
	end
	for(i=1;i<MAXDELAY;i=i+1) begin: gen_pipe
		always_ff @(posedge clk, negedge nreset) begin
			if(!nreset) begin
				sync_pipe[i] <= '0;
			end else begin
				sync_pipe[i] <= sync_pipe[i-1];
			end
		end		
	end
endgenerate

//Delay selector
assign out[N-1:0] = sync_pipe[sel[M-1:0]];

endmodule