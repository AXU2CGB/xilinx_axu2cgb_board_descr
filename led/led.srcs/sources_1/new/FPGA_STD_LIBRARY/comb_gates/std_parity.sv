//#############################################################################
//# Function: Calculates parity value for                                     #
//#############################################################################


module std_parity #( parameter DW = 2,  /* data width*/  parameter TYPE = "EVEN" /*EVEN, ODD*/) 
(
	input [DW-1:0] in,  // data input
	output 	   out // calculated parity bit
);

generate
	if(TYPE == "EVEN") begin
		assign  out = ^in[DW-1:0];
	end else begin 
		assign  out = ~(^in[DW-1:0]);
	end
endgenerate


endmodule // std_parity




