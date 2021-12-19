//#############################################################################
//# Function:  Positive edge-triggered static inverting D-type flop-flop with #
//             async active low set and scan input                            # 
//#############################################################################

module std_sdffsqn #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	si,
	input [DW-1:0] 	se,
	input [DW-1:0] 	clk,
	input [DW-1:0] 	nset,
	output logic [DW-1:0] qn
);

always_ff @(posedge clk, negedge nset) begin
	if(!nset) begin
		qn <= 'b0;   
	end else begin
		qn <= se ? ~si : ~d;
	end
end

endmodule
