//#############################################################################
//# Function: Glitch Free Low power clock gate circuit                        #
//#############################################################################

module std_clockgate 
(
	input  clk, // clock input 
	input  rstn, // reset n input 
	input  te, // test enable   
	input  en, // enable (from positive edge FF)
	output eclk // enabled clock output
);

logic     en_sh;
logic     en_sl;
//Stable low/valid rising edge enable
assign   en_sl = en | te;

//Stable high enable signal
std_lat0_reg lat0
(
	.clk (clk),
	.nreset(rstn),
	.in  (en_sl),
	.out (en_sh)
);

assign eclk =  clk & en_sh;
	
endmodule // std_clockgate


