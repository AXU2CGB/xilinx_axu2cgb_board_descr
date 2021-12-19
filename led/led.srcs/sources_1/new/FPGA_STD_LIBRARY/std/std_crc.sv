//#############################################################################
//# Function: CRC combinatorial & table encoder wrapper                               #
//#############################################################################


module std_crc #(parameter TYPE    = "ETH",  /* type: "ETH", "OTHER"*/ parameter DW      = 8, parameter CW      = 32, parameter TABLE = 0)       // width of data
(
	input [DW-1:0]  data_in, // input data
	input [CW-1:0]  crc_state, // input crc state
	output [CW-1:0] crc_next // next crc state
);
   
generate
	if(TYPE=="ETH") begin
		if(DW==8) begin  	  
			std_crc32_8b crc
			(
				/*AUTOINST*/
				// Outputs
				.crc_next		(crc_next),
				// Inputs
				.data_in		(data_in),
				.crc_state		(crc_state)
			);
		end else if(DW==64) begin
			std_crc32_64b crc
			(
				/*AUTOINST*/
				// Outputs
				.crc_next		(crc_next),
				// Inputs
				.data_in		(data_in),
				.crc_state	(crc_state)
			);
		end

	end // if (TYPE=="ETH")      
endgenerate


endmodule // std_crc

