//#############################################################################
//# Purpose: Clock divider with 2 outputs                                     #
//           Secondary clock must be multiple of first clock                  #
//#############################################################################


module std_clockdiv #(parameter N = 2 /* data width*/)
(
	//inputs
	input 	 clk, // main clock
	input 	 nreset, // async active low reset (from oh_rsync)
	input 	 clkchange, // indicates a parameter change
	input 	 clken, // clock enable
	input [7:0]  clkdiv, // [7:0]=period (0==bypass, 1=div/2, 2=div/3, etc)
	input [15:0] clkphase0, // [7:0]=rising,[15:8]=falling
	input [15:0] clkphase1, // [7:0]=rising,[15:8]=falling
	//outputs
	output 	 clkout0, // primary output clock
	output 	 clkrise0, // rising edge match
	output 	 clkfall0, // falling edge match
	output 	 clkout1, // secondary output clock
	output 	 clkrise1, // rising edge match
	output 	 clkfall1, // falling edge match
	output 	 clkstable    // clock is guaranteed to be stable
);

// reset sync ------------------------------------------------------------------------
logic reset_synced;
std_rsync (.clk(clk), .nrst_in(nreset), .nrst_out(reset_synced));

logic reset_synced_neg;
std_rsync (.clk(~clk), .nrst_in(nreset), .nrst_out(reset_synced_neg));
//-------------------------------------------------------------------------------------

//regs
logic [7:0] counter;
logic	     clkout0_reg;
logic	     clkout1_reg;
logic	     clkout1_shift;
logic [2:0] period;
logic      period_match;
logic [3:0] clk1_sel;
logic [1:0] clk0_sel;

//###########################################
//# CHANGE DETECT (count 8 periods)
//###########################################

always_ff @(posedge clk, negedge reset_synced) begin
	if(!reset_synced) begin
		period[2:0] <= 'b0;
	end else if (clkchange) begin
		period[2:0] <='b0;
	end else if(period_match & ~clkstable) begin
		period[2:0] <= period[2:0] + 1'b1;
	end
end

assign clkstable = (period[2:0]==3'b111);

//###########################################
//# CYCLE COUNTER
//###########################################

always_ff @(posedge clk, negedge reset_synced) begin
	if (!reset_synced) begin
		counter[7:0]   <= 'b0;
	end else if(clken) begin
		if(period_match) begin
			counter[7:0] <= 'b0;
		end else begin
			counter[7:0] <= counter[7:0] + 1'b1;
		end
	end
end

assign period_match = (counter[7:0] == clkdiv[7:0]);

//###########################################
//# RISING/FALLING EDGE SELECTORS
//###########################################

assign clkrise0     = (counter[7:0] == clkphase0[7:0]);
assign clkfall0     = (counter[7:0] == clkphase0[15:8]);
assign clkrise1     = (counter[7:0] == clkphase1[7:0]);
assign clkfall1     = (counter[7:0] == clkphase1[15:8]);

//###########################################
//# CLKOUT0
//###########################################

always_ff @(posedge clk, negedge reset_synced) begin
	if(!reset_synced) begin
		clkout0_reg <= 1'b0;
	end else if(clkrise0) begin
		clkout0_reg <= 1'b1;
	end else if(clkfall0) begin
		clkout0_reg <= 1'b0;
	end
end

// clock mux
assign clk0_sel[1] =  (clkdiv[7:0]==8'd0);   // not implemented
assign clk0_sel[0] = ~(clkdiv[7:0]==8'd0);


// clock select needs to be stable high
std_clockmux2 #(.N(1)) mux_clk0
(
	.clkout(clkout0),
	.en0(clk0_sel[0]),
	.en1(clk0_sel[1]),
	.clkin0(clkout0_reg),
	.clkin1(clk)
);

//###########################################
//# CLKOUT1
//###########################################

always_ff @(posedge clk, negedge reset_synced) begin
	if(!reset_synced) begin
		clkout1_reg <= 1'b0;
	end else if(clkrise1) begin
		clkout1_reg <= 1'b1;
	end else if(clkfall1) begin
		clkout1_reg <= 1'b0;
	end 
end

// creating divide by 2 shifted clock with negedge
always_ff @(negedge clk, negedge reset_synced_neg) begin
	if(!reset_synced_neg) begin
		clkout1_shift <= 1'b0;
	end else begin
		clkout1_shift <= clkout1_reg;
	end
end

// clock mux
assign clk1_sel[3] =  1'b0;               // not implemented
assign clk1_sel[2] = (clkdiv[7:0]==8'd0); // div1 (bypass)
assign clk1_sel[1] = (clkdiv[7:0]==8'd1); // div2 clock
assign clk1_sel[0] = |clkdiv[7:1];        // all others

// clock select needs to be stable high

assign clk1_sel[3] =  1'b0;               // not implemented
assign clk1_sel[2] = (clkdiv[7:0]==8'd0); // div1 (bypass)
assign clk1_sel[1] = (clkdiv[7:0]==8'd1); // div2 clock
assign clk1_sel[0] = |clkdiv[7:1];        // all others


std_clockmux4 #(.N(1)) mux_clk1 
(
	.clkout(clkout1),
	.en0   (clk1_sel[0]),
	.en1   (clk1_sel[1]),
	.en2   (clk1_sel[2]),
	.en3   (clk1_sel[3]),
	.clkin0(clkout1_reg),
	.clkin1(clkout1_shift),
	.clkin2(clk),
	.clkin3(1'b0)
);

endmodule // std_clockdiv