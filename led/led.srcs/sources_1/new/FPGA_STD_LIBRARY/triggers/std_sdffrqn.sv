//#############################################################################
//# Function:  Positive edge-triggered static inverting D-type flop-flop with #
//             async active low reset and scan input                          # 
//#############################################################################

module std_sdffrqn #(parameter DW = 1) // array width
(
	input [DW-1:0] 	d,
	input [DW-1:0] 	si,
	input [DW-1:0] 	se,
	input [DW-1:0] 	clk,
	input [DW-1:0] 	nreset,
	output logic [DW-1:0] qn
);

always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		qn <= {DW{1'b1}};
	end else begin
		qn <=  se ? ~si : ~d;
	end 
end

endmodule
