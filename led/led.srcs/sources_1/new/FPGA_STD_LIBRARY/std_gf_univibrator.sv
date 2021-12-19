/************ This is an glitch free univibrator to elongate input pulse **************/
module std_gf_univibrator #(parameter BIT_WIDTH = 6, parameter logic NEGEDGE = 1'b0)
(
	input 	logic i_clk,                        // Clocking
	input 	logic i_reset_n,                    // Reset Negative
	input	logic [(BIT_WIDTH - 1):0] i_data_pulse, // Quantity of elongated pulses
	input 	logic i_strobe,                     // An input strobe
	output 	logic o_out							// output signal
);
logic [(BIT_WIDTH - 1) : 0]  rCount = '0;
logic rS = 1'b0;
logic rR = 1'b0;

logic strobe;
generate	
	if(NEGEDGE) begin
		assign strobe = ~i_strobe;
		assign o_out = ~rR;
	end else begin
		assign strobe = i_strobe;
		assign o_out = rR;
	end
endgenerate

// latch input strobe --------------------------------------------------------------------------------------
always_ff @(posedge strobe, posedge rR) begin: input_strobe // Synchronization toward positive edge "i_Clk"
	if(rR)  rS <= 1'b0;
	else 	rS <= 1'b1;
end: input_strobe

// proceed strobe --------------------------------------------------------------------------------------
always_ff @(posedge i_clk, negedge i_reset_n) begin: OnePulse_label // Univibrator
	if(~i_reset_n) begin
		rCount 	<= '0;
		rR 		<= 1'b0;
	end else begin
		rCount <= rR ? (rCount - 1'b1) : i_data_pulse;
		rR <= rS ? 1'b1 : ((rCount == BIT_WIDTH'(0) & rR) ? 1'b0 : rR);
	end
end: OnePulse_label

endmodule : std_gf_univibrator
/**************************************************************************/