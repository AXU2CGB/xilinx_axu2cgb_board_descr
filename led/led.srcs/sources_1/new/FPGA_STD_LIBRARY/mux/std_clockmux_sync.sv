//#############################################################################
//# Function: glitch free Clock mux 2 inputs                                  #
//#############################################################################

module std_gf_clockmux #(parameter N = 4, parameter DS = 2)    // number of clock inputs
(
	input			[N-1:0] sel, // enable vector (needs to be stable!)
	input			[N-1:0] clkin,// one hot clock inputs (only one is active!) 
	input 			nreset,
	
	output 	  		clkout 
);

logic [N-1:0] ena_sync;
logic [N-1:0] ena_in;
logic [N-1:0] clk_out_synced;

genvar i;
generate
	for(i=0; i<N; i=i+1) begin: gen_pipe
		std_delay #(.DW(1), .N(DS)) clk_sync1_inst
		(
			.clk(clkin[i]),//clock input
			.nreset(nreset),//clock input
			.in(ena_in[i]), // input
			.out(ena_sync[i]) // output
		);
	end
endgenerate

assign clk_out_synced[N-1:0] = clkin[N-1:0] & ena_sync[N-1:0];


// enable logic


always_comb begin
	ena_in[N-1:0] <= {N{1'b0}};
	
	for(int i = 0; i < N; i++) begin
		if(sel[i]) begin
			ena_in[i] <= ~(|(ena_sync & ~(1<<i)));
		end
	end
end

assign clkout = |clk_out_synced;

endmodule // std_clockmux

