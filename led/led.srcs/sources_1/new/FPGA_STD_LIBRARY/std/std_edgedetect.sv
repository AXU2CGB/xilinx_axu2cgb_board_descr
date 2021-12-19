//#########################################################################
//# SYNCHRONOUS EDGE DETECTOR
//#########################################################################

module std_edgedetect #(parameter DW = 1) // Width of vector
(
	input            clk,    // clk
	input            nreset,    // clk
	input [1:0] 	 cfg,    // 00=off, 01=posedge, 10=negedge,11=any   
	input [DW-1:0]   in,     // input data
	output [DW-1:0]  out    // output
);

// reset_inst ------------------------------------------------------------------------------
logic reset_synced;
std_rsync reset_inst (.clk(clk), .nrst_in(nreset), .nrst_out(reset_synced));
//------------------------------------------------------------------------------------------


//#####################################################################
//# BODY
//#####################################################################
logic [DW-1:0]    shadow_reg0;
logic [DW-1:0]    shadow_reg1;

logic [DW-1:0]    data_noedge;
logic [DW-1:0]    data_posedge;
logic [DW-1:0]    data_negedge;
logic [DW-1:0]    data_anyedge;

always_ff @(posedge clk, negedge reset_synced) begin
	if(!nreset) begin
		shadow_reg0[DW-1:0] <= '0;
		shadow_reg1[DW-1:0] <= '0;
	end else begin
		shadow_reg0[DW-1:0] <= in[DW-1:0];
		shadow_reg1[DW-1:0] <= shadow_reg0[DW-1:0];
	end
end

assign data_noedge[DW-1:0]  =  {(DW){1'b0}};
assign data_posedge[DW-1:0] =   shadow_reg0[DW-1:0] & ~shadow_reg1[DW-1:0];
assign data_negedge[DW-1:0] =  ~shadow_reg0[DW-1:0] &  shadow_reg1[DW-1:0];
assign data_anyedge[DW-1:0] =   shadow_reg0[DW-1:0] ^  shadow_reg1[DW-1:0];

std_oh_mux4 #(.DW(DW)) mux4 
(
	.out (out[DW-1:0]),
	.in0 (data_noedge[DW-1:0]),  .sel0 (cfg==2'b00),
	.in1 (data_posedge[DW-1:0]), .sel1 (cfg==2'b01),
	.in2 (data_negedge[DW-1:0]), .sel2 (cfg==2'b10),
	.in3 (data_anyedge[DW-1:0]), .sel3 (cfg==2'b11)
);


endmodule // std_edgedetect



