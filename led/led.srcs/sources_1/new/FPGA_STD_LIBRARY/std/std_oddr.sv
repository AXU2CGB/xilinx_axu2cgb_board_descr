//#############################################################################
//# Function: Dual data rate output buffer                                    #
//#############################################################################


module std_oddr #(parameter DW  = 1) // width of data inputs
(
	input 	    clk, // clock input
	input 	    nreset, // reset n input
	input [DW-1:0]  din1, // data input1 ==> negedge
	input [DW-1:0]  din2, // data input2 ==> posedge
	output [DW-1:0] out   // ddr output
);

// reset -----------------------------------------------------------------------
logic reset_synced;
std_rsync (.clk(~clk), .nrst_in(nreset), .nrst_out(reset_synced));
//------------------------------------------------------------------------------


//regs("sl"=stable low, "sh"=stable high)
logic [DW-1:0]     din2_sh;

always_ff @(negedge clk, negedge reset_synced) begin
	if(reset_synced) begin
		din2_sh[DW-1:0] <= '0;
	end else begin
		din2_sh[DW-1:0] <= din2[DW-1:0];
	end
end

assign out[DW-1:0] = ~clk ? din1[DW-1:0] : din2_sh[DW-1:0];

endmodule // std_oddr


