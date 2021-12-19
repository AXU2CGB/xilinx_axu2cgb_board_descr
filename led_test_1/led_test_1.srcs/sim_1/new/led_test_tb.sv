`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////


module led_test_tb;

// Inputs
logic sys_clk;
logic rst_n ;
// Outputs
logic[3:0] led;

// Instantiate the Unit Under Test (UUT)

led_test uut 
(
    .i_clk(sys_clk),
    .i_rst_n(rst_n),
    .o_led(led)
);

initial begin
    // Initialize Inputs
    sys_clk = 0;
    rst_n = 0;
    #1000;
    rst_n = 1;
end

//Create clock
always #20 sys_clk =~ sys_clk;


endmodule
