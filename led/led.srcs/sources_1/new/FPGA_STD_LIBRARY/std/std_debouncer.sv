//#############################################################################
//# Function: A digital debouncer circuit                                     #
//#############################################################################


module std_debouncer #( parameter BOUNCE     = 100,    /* bounce time (s)*/ parameter CLKPERIOD  = 0.00001 /* period (10ns=0.0001ms)*/)
(
	input  clk, // clock to synchronize to
	input  nreset, // syncronous active high reset
	input  noisy_in, // noisy input signal to filter
	output logic clean_out // clean signal to logic
);

//################################
//# wires/regs/ params
//################################     
localparam integer CW  = $clog2(BOUNCE/CLKPERIOD);// counter width needed
 
//regs
logic 	  noisy_reg;

logic 	  noisy_synced;
logic 	  nreset_synced;

logic 	  counter_carry;

logic change_detected;


// synchronize reset to clk
std_rsync rsync 
(
	.nrst_out (nreset_synced),
	.clk	  (clk),
	.nrst_in  (nreset)
);

// synchronize incoming signal
std_dsync dsync 
(
	.dout   (noisy_synced),
	.clk	(clk),
	.nreset (nreset_synced),
	.din	(noisy_in)
);

// detecting change in state on input
always_ff @(posedge clk, negedge nreset_synced) begin
	if(!nreset_synced) begin
		noisy_reg <= 1'b0;   
	end else begin
		noisy_reg <= noisy_synced;
	end
end

assign change_detected = noisy_reg ^ noisy_synced;

// synchronous counter "filter"
std_counter #(.DW(CW)) std_counter_debounce 
(
	.clk	  	(clk),
	.nreset		(nreset_synced),
	.in	  (1'b1),
	.en	  (1'b1),
	.dir(1'b0),
	.autowrap(1'b1),
	.load  	  (change_detected),
	.load_data ({(CW){1'b0}}),
	// Outputs
	.count	  (),
	.wraparound(),
	.carry	  (counter_carry),
	.zero	  ()//,
	// Inputs
);


// sample noisy signal safely
always_ff @(posedge clk, negedge nreset_synced) begin
	if(!nreset_synced) begin
		clean_out <= 'b0;   
	end else if(counter_carry) begin
		clean_out <= noisy_reg;   
	end
end

endmodule // std_debouncer
