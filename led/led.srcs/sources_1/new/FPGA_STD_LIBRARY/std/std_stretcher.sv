//#############################################################################
//# Purpose: Stretches a pulse by DW+1 clock cycles                           #
//#          Adds one cycle latency                                           #
//#############################################################################


module std_stretcher #(parameter CYCLES = 3) // "wakeup" cycles
(
	input  clk, // clock
	input  in, // input pulse
	input  nreset, // async active low reset
	output out // stretched output pulse
);

logic [CYCLES-1:0] valid;

always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		valid[CYCLES-1:0] <='b0;   
	end else if(in) begin
		valid[CYCLES-1:0] <={(CYCLES){1'b1}};   
	end else begin
		valid[CYCLES-1:0] <={valid[CYCLES-2:0], 1'b0};
	end
end

assign out = valid[CYCLES-1];

endmodule // std_stretcher


  
