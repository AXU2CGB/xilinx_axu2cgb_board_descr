module internal_reset_n #(parameter QUANTITY_OF_CLK_DOMAINS = 1)
(
	input    i_reset_n,                                  // input reset
	
	input  [(QUANTITY_OF_CLK_DOMAINS - 1):0] i_clk_domain,          // input clk domains
	output [(QUANTITY_OF_CLK_DOMAINS - 1):0] o_sync_async_reset_n   // output reset_n for each clk domains
);

// generating sync-async reset for each clk domain 
genvar i;
generate
	for(i = 0; i < QUANTITY_OF_CLK_DOMAINS; i++) begin : CLK_DOMAIN_RESET_GENERATE
		std_rsync #(.PS(3) /* number of sync stages*/) sync_async_reset_inst
		(
			.clk(i_clk_domain[i]),
			.nrst_in(i_reset_n),
			.nrst_out(o_sync_async_reset_n[i])
		);
	end
endgenerate

endmodule : internal_reset_n