//#############################################################################
//# Function: Synchronous FIFO                                                #
//#############################################################################

module std_fifo_sync #(
	parameter DW       = 8,            // FIFO width
	parameter DEPTH    = 4,            // FIFO depth
	parameter REG      = 1,            // Register fifo output
	parameter PROGFULL = DEPTH-1,      // programmable almost full level
	parameter AW       = $clog2(DEPTH) // count width (derived)
)
(
	//basic interface
	input 		clk, // clock
	input 		nreset, //async reset
	input 		clear, //clear fifo statemachine (sync)
	//write port
	input [DW-1:0] 	wr_din, // data to write
	input 		wr_en, // write fifo
	output 		wr_full, // fifo full
	output 		wr_almost_full, //one entry left
	output 		wr_prog_full, //programmable full level
	output logic [AW-1:0] wr_count, // pessimistic report of entries from wr side
	//read port
	output [DW-1:0] 	rd_dout, // output data (next cycle)
	input 		rd_en, // read fifo
	output 		rd_empty // fifo is empty
);

// reset sync ---------------------------------------------------------------------------------
logic reset_synced;
std_rsync fifo_reset_sync (.clk(clk), .nrst_in(nreset), .nrst_out(reset_synced));
//---------------------------------------------------------------------------------------------


//############################
//local wires
//############################
logic [AW:0]    wr_addr;
logic [AW:0]    rd_addr;
logic		   empty_reg;
logic 	       fifo_read;
logic 	       fifo_write;
logic 	       ptr_match;
logic 	       fifo_empty;

//#########################################################
// FIFO Control
//#########################################################

assign fifo_read   = rd_en & ~rd_empty;
assign fifo_write  = wr_en & ~wr_full;
assign wr_prog_full = (wr_count[AW-1:0] == PROGFULL);
assign ptr_match   = (wr_addr[AW-1:0] == rd_addr[AW-1:0]);
assign wr_full     = ptr_match & (wr_addr[AW]==!rd_addr[AW]);
assign fifo_empty  = ptr_match & (wr_addr[AW]==rd_addr[AW]);

always_ff @(posedge clk, negedge reset_synced) begin
	if(~reset_synced) begin
		wr_addr[AW:0]    <= 'd0;
		rd_addr[AW:0]    <= 'b0;
		wr_count[AW-1:0] <= 'b0;
	end else if(clear) begin
		wr_addr[AW:0]    <= 'd0;
		rd_addr[AW:0]    <= 'b0;
		wr_count[AW-1:0] <= 'b0;
	end else if(fifo_write & fifo_read) begin
		wr_addr[AW:0] <= wr_addr[AW:0] + 'd1;
		rd_addr[AW:0] <= rd_addr[AW:0] + 'd1;
	end else if(fifo_write) begin
		wr_addr[AW:0]    <= wr_addr[AW:0] + 'd1;
		wr_count[AW-1:0] <= wr_count[AW-1:0] + 'd1;
	end else if(fifo_read) begin
		rd_addr[AW:0]    <= rd_addr[AW:0] + 'd1;
		wr_count[AW-1:0] <= wr_count[AW-1:0] - 'd1;
	end
end

//Pipeline register to account for RAM output register
always_ff @(posedge clk, negedge reset_synced) begin
	if(~reset_synced) begin
		empty_reg <= 1'b1;
	end else begin
		empty_reg <= fifo_empty;
	end
end

assign rd_empty = (REG==1) ? empty_reg : fifo_empty;

//###########################
//# Memory Array
//###########################

std_ram_dp #(
	.DW(DW),
	.DEPTH(DEPTH),
	.REG(REG),
	.DUALPORT(1)
)
fifo_memory_dp
(
	.wr_wem			({(DW){1'b1}}),
	.wr_clk			(clk),
	.rd_clk			(clk),
	.rd_nreset		(reset_synced),
	/*AUTOINST*/
	// Outputs
	.rd_dout		(rd_dout[DW-1:0]),
	// Inputs
	.wr_en			(wr_en),
	.wr_addr		(wr_addr[AW-1:0]),
	.wr_din			(wr_din[DW-1:0]),
	.rd_en			(rd_en),
	.rd_addr		(rd_addr[AW-1:0])
);


endmodule // std_fifo_sync
