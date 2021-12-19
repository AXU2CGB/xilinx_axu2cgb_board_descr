//#############################################################################
//# Function: Dual data rate input buffer (2 cycle delay)                     #
//#############################################################################


module std_iddr #(parameter DW = 2 /* width of data inputs*/)
(
	input 		clk, // clock
	input 		nreset, // reset n
	input 		ce0, // 1st cycle enable
	input 		ce1, // 2nd cycle enable
	input [DW-1:0] 	din, // data input sampled on both edges of clock
	output logic [2*DW-1:0] dout // iddr aligned
);

// reset sync ---------------------------------------------------------------------------------------------
logic pos_rst_synced;
std_rsync pos_sync_rst (.clk(clk), .nrst_in(nreset), .nrst_out(pos_rst_synced));

logic neg_rst_synced;
std_rsync neg_sync_rst (.clk(~clk), .nrst_in(nreset), .nrst_out(neg_rst_synced));
//----------------------------------------------------------------------------------------------------------

//regs("sl"=stable low, "sh"=stable high)
logic [DW-1:0]     din_sl;
logic [DW-1:0]     din_sh;
logic 		      ce0_negedge;

//########################
// Pipeline valid for negedge
//########################
always_ff @(negedge clk, negedge neg_rst_synced) begin
	if(!neg_rst_synced) begin
		ce0_negedge <= 1'b0;
	end else begin
		ce0_negedge <= ce0;
	end
end

//########################
// Dual edge sampling
//########################


// posedge registers------------
always_ff @(posedge clk, negedge pos_rst_synced) begin
	if(!pos_rst_synced) begin
		din_sl <= '0;
	end else if(ce0) begin
		din_sl[DW-1:0] <= din[DW-1:0];
	end
end

// negedge registers------------
always_ff @(negedge clk, negedge neg_rst_synced) begin
	if(!neg_rst_synced) begin
		din_sh <= '0;
	end else if(ce0_negedge) begin
		din_sh[DW-1:0] <= din[DW-1:0];
	end
end

//########################
// Aign pipeline
//########################


always_ff @(posedge clk, negedge pos_rst_synced) begin
	if(!pos_rst_synced) begin
		dout <= '0;
	end else if(ce1) begin
		dout[2*DW-1:0] <= {din_sh[DW-1:0], din_sl[DW-1:0]};
	end
end


endmodule // std_iddr



