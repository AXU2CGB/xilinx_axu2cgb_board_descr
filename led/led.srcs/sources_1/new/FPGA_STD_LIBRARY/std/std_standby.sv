//#############################################################################
//# Purpose: Low power standby state machine 								#
//#############################################################################


module std_standby #(parameter PD = 5,/* cycles to stay awake after "wakeup" */ parameter N  = 5, parameter SYNCRONIZE_RESET = 1)// cycles delay of irq_reset after posedge (RESULT DELAY = N + (SYNC_RESET * 2) + 1)
(
	//inputs
	input  clkin, //clock input
	input  nreset,//async active low reset
	input  testenable,//disable standby (static signal)
	input  wakeup, //wake up (level, active high)
	input  idle, //idle indicator
	//outputs
	output resetout,//synchronous one clock reset pulse
	output clkout //clock output
);

//  reset syncronizer--------------------------------------------------------------------------
logic reset_synced;
generate
	if(SYNCRONIZE_RESET == 0) begin
		assign reset_synced = nreset;
	end else begin
		std_rsync reset_sync (.clk(clkin), .nrst_in(nreset), .nrst_out(reset_synced));
	end
endgenerate
//---------------------------------------------------------------------------------------------

//Wire declarations
logic [PD-1:0]	wakeup_pipe;
logic 	delay_reset;
logic 	sync_reset_pulse;
logic 	wakeup_now;
logic 	clk_en;

//####################################################################
// -Creating an edge one clock cycle pulse on rising edge of reset
// -Event can be used to boot a CPU and any other master as an example
// -Given the clock dependancies, it was deemed safest to put this 
//  function here
//####################################################################

// Synchronizing reset to clock to avoid metastability
std_dsync #(.PS(2)) std_dsync_reset 
(
	//outputs
	.dout(delay_reset),
	//inputs
	.nreset(reset_synced),
	.din(reset_synced),
	.clk(clkin)
);

// Detecting all edge of delayed reset
std_both2pulse std_b2p
(
	//outputs
	.out	 (sync_reset_pulse),
	//inputs
	.clk	 (clkin),
	.nreset (reset_synced),
	.in	 (delay_reset)
);

// Delay irq event by N clock cycles
std_delay #(.N(N)) std_delay_rst 
(
	//outputs
	.out	 (resetout),
	//inputs
	.in	 (sync_reset_pulse),
	.clk	 (clkin)
);

//####################################################################
// Clock gating circuit for output clock
// EVent can be used to boot a CPU and aany other master as an example
//####################################################################

//Adding reset to wakeup signal
assign wakeup_now = sync_reset_pulse | wakeup;   

// Stay awake for PD cycles
always_ff @(posedge clkin , negedge reset_synced) begin
	if(!reset_synced) begin
		wakeup_pipe[PD-1:0] <= 'b0;   
	end else begin
		wakeup_pipe[PD-1:0] <= {wakeup_pipe[PD-2:0], wakeup_now};
	end
end

// Clock enable
assign  clk_en    =  wakeup /*immediate wakeup*/  |	(|wakeup_pipe[PD-1:0]) /*anything in pipe*/   |     ~idle /*core not in idle*/;

// Clock gating cell
std_clockgate std_out_clockgate
(
	.eclk(clkout),
	.clk(clkin),
	.rstn(reset_synced),
	.en(clk_en),
	.te(testenable)
);

endmodule // std_standby



	
