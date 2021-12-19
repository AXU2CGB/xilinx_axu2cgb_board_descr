/*********************NOT RECOMRNDED!!!!!! simple edge detector *******************************************************************************/
module std_simple_edge_detector #(parameter BIT_WIDTH = 1)
(
	input logic  i_clk,                // Input signal for clock
	input logic  i_reset,               // Input signal for clock
	
	input logic  [(BIT_WIDTH - 1) : 0] i_signal,  // Input signal for which positive edge has to be detected
	
	output logic [(BIT_WIDTH - 1) : 0] o_posedge,    // Output signal that gives a pulse when a positive edge occurs
	output logic [(BIT_WIDTH - 1) : 0] o_negedge,    // Output signal that gives a pulse when a negative edge occurs
	output logic [(BIT_WIDTH - 1) : 0] o_bothedge    // Output signal that gives a pulse when a both edge occurs
);

//edge detection --------------------------------------
logic   [(BIT_WIDTH - 1) : 0] r0_input  = '0;     // first delay register

always_ff @(posedge i_clk, negedge i_reset) begin
	if(~i_reset) begin
		r0_input  <= '0;
	end else begin
		r0_input <= i_signal;
	end
end

assign o_posedge 	 = ~r0_input &  i_signal;
assign o_negedge 	 =  r0_input & ~i_signal;
assign o_bothedge 	 =  o_posedge | o_negedge;

endmodule: std_simple_edge_detector
/****************************************************************************************************************************/