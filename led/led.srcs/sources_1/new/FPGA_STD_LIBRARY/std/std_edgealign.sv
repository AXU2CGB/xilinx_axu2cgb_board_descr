//#############################################################################
//# Function: Aligns positive edge of slow clock to fast clock                #
//#           !!!Assumes clocks are aligned and synchronous!!!                #
//#############################################################################
/*
 *    ___________             ___________
 * __/           \___________/           \   SLOWCLK
 *    __    __    __    __    __    __ 
 *  _/  \__/  \__/  \__/  \__/  \__/  \__/   FASTCLK
 *        ___________              _________   
 *    ___/ 1     1   \_0_____0____/          CLK45
 *           ____________              ___   
 *    ______/    1     1 \___0____0___/      CLK90 
 * 
 * ____                  ______               
 *     \________________/      \________     FIRSTEDGE 
 * 
 */
module std_edgealign #(parameter DETECTION_TYPE = "POS_EDGE"/* BOTH_EDGE, NEG_EDGE, POS_EDGE */, ALIGN_TYPE = "POS_EDGE" /* NEG_EDGE, POS_EDGE */)
(
	// Outputs
	output logic firstedge,
	// Inputs
	input nreset_fast,
	input  fastclk,
	input  slowclk
);

// regs
logic 	  clk45;
logic 	  clk90;
logic det_edge_wire;
logic nreset_fast_synced;

std_rsync reset_sync
(
	.clk(fastclk),
	.nrst_in(nreset_fast),
	.nrst_out(nreset_fast_synced)
);


generate
	if(DETECTION_TYPE == "BOTH_EDGE") begin
		assign det_edge_wire = clk45 ^ clk90;
	end else if(DETECTION_TYPE == "NEG_EDGE") begin
		assign det_edge_wire = clk45 & ~clk90;
	end else if(DETECTION_TYPE == "POS_EDGE") begin
		assign det_edge_wire = ~clk45 & clk90;
	end
	
	if(ALIGN_TYPE == "NEG_EDGE") begin
		// clk 45
		always_ff @(posedge fastclk, negedge nreset_fast_synced) begin
			if(!nreset_fast_synced) begin
				clk45 <= 1'b0;
			end else begin
				clk45     <= slowclk;
			end
		end
		
		// clk 90
		always_ff @(negedge fastclk, negedge nreset_fast_synced) begin
			if(!nreset_fast_synced) begin
				clk90 <= 1'b0;
				firstedge <= 1'b0;
			end else begin
				clk90     <= clk45;
				firstedge <= det_edge_wire;
			end
		end
	end else begin
		// clk 45
		always_ff @(negedge fastclk, negedge nreset_fast_synced) begin
			if(!nreset_fast_synced) begin
				clk45 <= 1'b0;
			end else begin
				clk45     <= slowclk;
			end
		end
		
		// clk 90
		always_ff @(posedge fastclk, negedge nreset_fast_synced) begin
			if(!nreset_fast_synced) begin
				clk90 <= 1'b0;
				firstedge <= 1'b0;
			end else begin
				clk90     <= clk45;
				firstedge <= det_edge_wire;
			end
		end
	end
endgenerate



endmodule // std_edgealign




