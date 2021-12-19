/*********************RECOMENDED GLITCH FREE edge detector *******************************************************************************/
module std_gf_edge_detector #(parameter BIT_WIDTH = 1, parameter logic IS_ASYNCRONOUS_INPUT = 0, parameter logic REGISTER_OUTPUT = 0)
(
	input logic  i_clk,                // Input signal for clock
	input logic  i_reset,               // Input signal for clock
	
	input logic  [(BIT_WIDTH - 1) : 0] i_signal,  // Input signal for which positive edge has to be detected
	
	output logic [(BIT_WIDTH - 1) : 0] o_posedge,    // Output signal that gives a pulse when a positive edge occurs
	output logic [(BIT_WIDTH - 1) : 0] o_negedge,    // Output signal that gives a pulse when a negative edge occurs
	output logic [(BIT_WIDTH - 1) : 0] o_bothedge    // Output signal that gives a pulse when a both edge occurs
);

// metastability compensation ----------------------------------------------

logic [(BIT_WIDTH - 1) : 0] signal_protected;

logic   [(BIT_WIDTH - 1) : 0] r0_input  = '0;     // first delay register
logic   [(BIT_WIDTH - 1) : 0] r1_input  = '0;     // second delay register

generate
	if(IS_ASYNCRONOUS_INPUT) begin
		logic   [(BIT_WIDTH - 1) : 0] r_metastability_protection  = '0;     // first delay for metastability
		
		always_ff @(posedge i_clk, negedge i_reset) begin
			if(~i_reset) begin
				r_metastability_protection  <= '0;
			end else begin
				r_metastability_protection <= i_signal;
			end
		end
		
		assign signal_protected = r_metastability_protection;
		
	end else begin
		assign signal_protected = i_signal;
	end
	
	if(REGISTER_OUTPUT) begin
		
		logic w_posedge;
		logic w_negedge;
		logic w_bothedge;
		
		assign w_posedge 	 = ~r1_input  &  r0_input;
		assign w_negedge 	 =  r1_input  & ~r0_input;
		assign w_bothedge  =  w_posedge |  w_negedge;
		
		always_ff @(posedge i_clk, negedge i_reset) begin
			if(~i_reset) begin
				o_posedge 	 <=  '0;
				o_negedge 	 <=  '0;
				o_bothedge 	 <=  '0;
			end else begin
				o_posedge 	 <=  w_posedge;
				o_negedge 	 <=  w_negedge;
				o_bothedge 	 <=  w_bothedge;
			end
		end
		
	end else begin
		
		assign o_posedge 	 = ~r1_input  &  r0_input;
		assign o_negedge 	 =  r1_input  & ~r0_input;
		assign o_bothedge    =  r1_input  ^  r0_input;
		
	end
endgenerate

//edge detection --------------------------------------

always_ff @(posedge i_clk, negedge i_reset) begin
	if(~i_reset) begin
		r0_input  <= '0;
		r1_input  <= '0;
	end else begin
		r0_input <= signal_protected;
		r1_input <= r0_input;
	end
end

endmodule: std_gf_edge_detector
/****************************************************************************************************************************/