module led_test
(
    input i_clk,
    input i_rst_n,
    (* MARK_DEBUG = "true" *)output logic [3:0] o_led
);

(* MARK_DEBUG = "true" *) logic [31:0] timer_cnt = '0;
always_ff @(posedge i_clk, negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_led <= '0;
        timer_cnt <= '0;
    end else if(timer_cnt >= 32'd10_000_000) begin
        o_led <= ~o_led;
        timer_cnt <= '0;
    end else begin
        o_led <= o_led;
        timer_cnt <= timer_cnt + 1'b1;
    end
end

endmodule
