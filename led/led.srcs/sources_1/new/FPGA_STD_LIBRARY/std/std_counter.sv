//#############################################################################
//# Function: Generic counter                                                 #
//#############################################################################

module std_counter #(parameter DW   = 32)  // width of data inputs
(
	//inputs
	input 	    clk, // clk input
	input 	    nreset, // reset n
	input 	    in, // input to count
	input 	    en, // enable counter
	input 	    dir,//0=increment, 1=decrement
	input 	    autowrap, //auto wrap around
	input 	    load, // load counter
	input [DW-1:0]  load_data, // input data to load
	//outputs
	output logic [DW-1:0] count, // count value
	output logic 	    wraparound, // wraparound indicator
	output logic 	    carry, // carry indicator
	output logic 	    zero // zero indicator
);

// local variables
logic [DW-1:0]   count_in;

//Select count direction
assign count_in[DW-1:0] = dir ? (count[DW-1:0] - in) : (count[DW-1:0] + in);

// counter
always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		count <= '0;
	end else begin
		if(load) begin
			count[DW-1:0] <= load_data[DW-1:0];
		end else if (en & ~(wraparound & autowrap)) begin
			count[DW-1:0] <= count_in[DW-1:0];
		end
	end
end


// counter expired
assign carry = (~dir & (&count[DW-1:0]));
assign zero = (dir & ~(|count[DW-1:0]));
assign wraparound = (carry | zero); //(dir & en & ~(|count[DW-1:0])) | (~dir & en & (&count[DW-1:0]));

endmodule // std_counter

