//#############################################################################
//# Function: Generic Async FIFO                                              #
//# Based on article by Clifford Cummings,                                    #
//  "Simulation and Synthesis Techniques for Asynchronous FIFO Design"        #
//# (SNUG2002)                                                                #
//															   #
// Notes:                                                                     #
// Soft reference implementation always instantiated                          #
// Assumed to be optimized away in synthesis if needed                        #
//#############################################################################

module std_fifo_async #(
	parameter DW        = 104,      // FIFO width
	parameter DEPTH     = 32,       // FIFO depth (entries)
	parameter REG      = 1,         // Register fifo output
	parameter PROG_FULL = (DEPTH/2),// full threshold   
	parameter AW = $clog2(DEPTH)    // read count width
)
(
	input 	    nreset, // asynch active low reset for wr_clk, rd_clk
	input 	    wr_clk, // write clock   
	input 	    wr_en, // write enable
	input [DW-1:0]  din, // write data
	input 	    rd_clk, // read clock   
	input 	    rd_en, // read enable
	output [DW-1:0] dout, // read data
	output 	    empty, // fifo is empty
	output 	    full, // fifo is full
	output 	    prog_full, // fifo is "half empty"
	output [AW-1:0] rd_count, // NOT IMPLEMENTED 
	output [AW-1:0] wr_count // NOT IMPLEMENTED
);

//regs 
logic [AW:0]     wr_addr;       // extra bit for wraparound comparison
logic [AW:0] 	 wr_addr_ahead; // extra bit for wraparound comparison   
logic [AW:0] 	 rd_addr;  
logic [AW:0] 	 rd_addr_gray;
logic [AW:0] 	 wr_addr_gray;
logic [AW:0] 	 rd_addr_gray_sync;
logic [AW:0] 	 wr_addr_gray_sync;
logic [AW:0] 	 rd_addr_sync;
logic [AW:0] 	 wr_addr_sync;
logic 	 wr_nreset;
logic 	 rd_nreset;

//###########################
//# Full/empty indicators
//###########################

// uses one extra bit for compare to track wraparound pointers 
// careful clock synchronization done using gray codes
// could get rid of gray2bin for rd_addr_sync... 

// fifo indicators
assign empty    =  (rd_addr_gray[AW:0] == wr_addr_gray_sync[AW:0]);

// fifo full
assign full     =  (wr_addr[AW-1:0] == rd_addr_sync[AW-1:0]) & (wr_addr[AW] != rd_addr_sync[AW]);


// programmable full
assign prog_full = (wr_addr_ahead[AW-1:0] == rd_addr_sync[AW-1:0]) & (wr_addr_ahead[AW] != rd_addr_sync[AW]);

//###########################
//# Reset synchronizers
//###########################

std_rsync wr_rsync (.nrst_out (wr_nreset), .clk(wr_clk), .nrst_in	(nreset));
std_rsync rd_rsync (.nrst_out (rd_nreset), .clk(rd_clk), .nrst_in	(nreset));


//###########################
//#write side address counter
//###########################

always_ff @(posedge wr_clk, negedge wr_nreset) begin
	if(!wr_nreset) begin
		wr_addr[AW:0]  <= 'b0;
	end else if(wr_en) begin
		wr_addr[AW:0]  <= wr_addr[AW:0] + 1'b1;
	end
end

//address lookahead for prog_full indicator
always_ff @(posedge wr_clk, negedge wr_nreset) begin
	if(!wr_nreset) begin
		wr_addr_ahead[AW:0] <= 'b0;   
	end else if(~prog_full) begin
		wr_addr_ahead[AW:0] <= wr_addr[AW:0] + PROG_FULL;
	end
end
//###########################
//# Synchronize to read clk
//###########################

// convert to gray code (only one bit can toggle)
std_bin2gray #(.DW(AW+1)) wr_b2g (.gray(wr_addr_gray[AW:0]), .bin(wr_addr[AW:0]));

// synchronize to read clock
std_delay  #(.DW(AW+1), .N(2))  wr_sync (.clk(rd_clk), .nreset(rd_nreset), .in(wr_addr_gray[AW:0]),	.out(wr_addr_gray_sync[AW:0]));

//###########################
//#read side address counter
//###########################

always_ff @( posedge rd_clk, negedge rd_nreset) begin
	if(!rd_nreset) begin
		rd_addr[AW:0] <= 'd0;   
	end else if(rd_en) begin
		rd_addr[AW:0] <= rd_addr[AW:0] + 'd1;
	end
end
//###########################
//# Synchronize to write clk
//###########################

//covert to gray (can't have multiple bits toggling)
std_bin2gray #(.DW(AW+1)) rd_b2g (.gray(rd_addr_gray[AW:0]), .bin(rd_addr[AW:0]));

//synchronize to wr clock
std_delay  #(.DW(AW+1), .N(2))  rd_sync (.clk(wr_clk), .nreset(wr_nreset), .in(rd_addr_gray[AW:0]),	.out(rd_addr_gray_sync[AW:0]));

//convert back to binary (for ease of use, rd_count)
std_gray2bin #(.DW(AW+1)) rd_g2b (.bin (rd_addr_sync[AW:0]), .gray(rd_addr_gray_sync[AW:0]));

//###########################
//#dual ported memory
//###########################
std_ram_dp #(
	.DW(DW),
	.DEPTH(DEPTH),
	.REG(REG),
	.DUALPORT(1)
)
fifo_mem
(
	// Outputs
	.rd_dout	(dout[DW-1:0]),
	// Inputs
	.wr_clk	(wr_clk),
	.wr_en	(wr_en),
	.wr_wem	({(DW){1'b1}}),
	.wr_addr	(wr_addr[AW-1:0]),
	.wr_din	(din[DW-1:0]),
	.rd_clk	(rd_clk),
	.rd_nreset(rd_nreset),
	.rd_en	(rd_en),
	.rd_addr	(rd_addr[AW-1:0])
);


endmodule // std_fifo_async


