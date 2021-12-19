module std_timer #(parameter BIT_WIDTH = 8)
(
	// clk / reset / enable
	input logic     clk,
	input logic     clrn,
	input logic     sload,
	input logic 	ena,
	input logic 	dec,
	input logic [(BIT_WIDTH - 1) : 0] sdata,
	// out time
	output logic [(BIT_WIDTH - 1) : 0] q
);

// Simple TIMER

always_ff @(posedge clk, negedge clrn) begin
	if(~clrn) begin
		q <= '0;
	end else begin
		if(sload) begin
			q <= sdata;
		end else if(ena) begin
			q <= dec ? (q - 1'b1) : (q + 1'b1);
		end
	end
end

endmodule : std_timer
