//#############################################################################
//# Function: Parallel to Serial Converter                                    #
//#############################################################################


module std_par2ser #(
	parameter PW = 32, // parallel packet width
	parameter SW = 1,  // serial packet width
	parameter CW = $clog2(PW/SW)  // serialization factor
)
(
	input 	    clk, // sampling clock
	input 	    nreset, // async active low reset
	input [PW-1:0]  din, // parallel data
	output [SW-1:0] dout, // serial output data
	output 	    access_out,// output data valid
	input 	    load, // load parallel data (priority)
	input 	    shift, // shift data
	input [7:0]     datasize, // size of data to shift
	input 	    lsbfirst, // lsb first order
	input 	    fill, // fill bit
	input 	    wait_in, // wait input
	output 	    wait_out // wait output (wait in | serial wait)
);

// local wires
logic [PW-1:0]    	shiftreg;
logic [CW-1:0]    	count;
logic 	   			start_transfer;
logic 	  			busy;

// start serialization
assign start_transfer = load &  ~wait_in & ~busy;

//transfer counter
always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		count[CW-1:0] <= 'b0;
	end else if(start_transfer) begin
		count[CW-1:0] <= datasize[CW-1:0];  //one "SW sized" transfers
	end else if(shift & busy) begin
		count[CW-1:0] <= count[CW-1:0] - 1'b1;
	end
end

//output data is valid while count > 0
assign busy = |count[CW-1:0];

//data valid while shifter is busy
assign access_out = busy;

//wait until valid data is finished
assign wait_out  = wait_in | busy;

// shift register
always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		shiftreg[PW-1:0] <= 'b0;
	end else if(start_transfer) begin
		shiftreg[PW-1:0] <= din[PW-1:0];
	end else if(shift & lsbfirst) begin
		shiftreg[PW-1:0] <= {{(SW){fill}}, shiftreg[PW-1:SW]};
	end else if(shift) begin
		shiftreg[PW-1:0] <= {shiftreg[PW-SW-1:0],{(SW){fill}}};
	end
end

assign dout[SW-1:0] = lsbfirst ? shiftreg[SW-1:0] : shiftreg[PW-1:PW-SW];

endmodule // std_par2ser
