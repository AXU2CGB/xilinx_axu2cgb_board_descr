//// Design
//// D flip-flop
//module std_io_reg_ena
//(
//	input clk,
//	input clrn,
//	input ena,
//	input drv,
//	input data,
//	inout bidir_reg_io
//);

//// Tri-state registers are registers on inout ports.  As with any
//// registers, their output can be updated synchronously or asynchronously.
//always_ff @(posedge clk, negedge clrn) begin
//	if (~clrn) begin
//		bidir_reg_io <= 1'bZ;
//	end else if(ena) begin
//		bidir_reg_io <= drv ? data : 1'bZ;
//	end
//end

//endmodule: std_io_reg_ena