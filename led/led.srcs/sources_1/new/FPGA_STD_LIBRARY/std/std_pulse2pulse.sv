//#############################################################################
//# Function: Clock domain one cycle pulse transfer                           #
//            !!"din" pulse width must be 2x greater than clkout width!!!     #
//#############################################################################

module std_pulse2pulse #(parameter IN_PULSE_POLARITY = "HIGH"/*HIGH, LOW*/, parameter OUT_PULSE_POLARITY = "HIGH"/*HIGH, LOW*/)
(
	// in clk domain ------------------------------------ 
	input  nrstin, //input domain reset   
	input  clkin, //input clock
	input  din, //input pulse (one clock cycle)
	
	//out clk domain ------------------------------------
	input  nrstout, //output domain reset  
	input  clkout, //output clock       
	output dout    //output pulse (one clock cycle)
);

// reset -----------------------------------------------------------------------------------------
// in resed sync
logic in_rst_synced;
std_rsync in_reset_sync (.clk(clkin), .nrst_in(nrstin), .nrst_out(in_rst_synced));

// out reset sync
logic out_rst_synced;
std_rsync out_reset_sync (.clk(clkout), .nrst_in(nrstout), .nrst_out(out_rst_synced));
//--------------------------------------------------------------------------------------------------


// local wires
logic toggle_reg;
logic pulse_reg;
logic toggle;
logic toggle_sync;

//pulse to toggle
generate
	if(IN_PULSE_POLARITY == "LOW") begin
		assign toggle = din ? toggle_reg : ~toggle_reg;
	end else begin
		assign toggle = din ? ~toggle_reg : toggle_reg;
	end
endgenerate


always_ff @(posedge clkin, negedge in_rst_synced) begin
	if(!in_rst_synced) begin
		toggle_reg <= 1'b0;
	end else begin
		toggle_reg <= toggle;
	end
end

//metastability synchronizer
std_dsync sync
(
	.dout	(toggle_sync),
	.din      (toggle),
	.nreset   (out_rst_synced), 
	.clk      (clkout)
);

//toogle to pulse
always_ff @(posedge clkout, negedge out_rst_synced) begin
	if(!out_rst_synced) begin
		pulse_reg <= 1'b0;
	end else begin
		pulse_reg <= toggle_sync;
	end
end

generate
	if(OUT_PULSE_POLARITY == "LOW") begin
		assign dout = ~(pulse_reg ^ toggle_sync);
	end else begin
		assign dout = pulse_reg ^ toggle_sync;
	end
endgenerate

endmodule // std_pulse2pulse


