`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2021 07:48:51 PM
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module led
(
    input sys_clk,
    input rst_n,
    output logic[3:0] led
);

logic[31:0] timer_cnt = '0;

always_ff @(posedge sys_clk, negedge rst_n) begin
    if(!rst_n) begin
            led <= 4'd0;
            timer_cnt <= '0;
    end else if(timer_cnt >= 32'd24_999_999) begin
            led <=~led;
            timer_cnt <= '0;
    end else begin
            led <= led;
            timer_cnt <= timer_cnt + 32'd1;
    end
end


std_reg0 REQ
( 
	.nreset(rst_n), //async active low reset
	.clk(sys_clk)//, // clk, latch when clk=0
	//input [DW-1:0]  in, // input data
	//output [DW-1:0] out  // output data (stable/latched when clk=1)
);

std_regfile REG_FILE

(
	//Control inputs
	.clk(sys_clk),
	.nreset(rst_n)
);


endmodule
