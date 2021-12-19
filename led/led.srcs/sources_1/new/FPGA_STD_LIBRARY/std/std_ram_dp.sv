//#############################################################################
//# Function: Dual Ported Memory                                              #
//#############################################################################


module std_ram_dp  #(
	parameter DW      			= 104,          	// memory width
	parameter DEPTH   			= 32,           	// memory depth
	parameter REG     			= 1,            	// register output
	parameter DUALPORT			= 1,            	// limit dual port
	parameter AW      			= $clog2(DEPTH), 	// address width
	parameter INIT_FILE   		= "NULL"			//init file >> NULL or path to file
)
(
	// read-port
	input 	    rd_clk,// rd clock
	input 	    rd_nreset, //reset n
	input 	    rd_en, // memory access
	input [AW-1:0]  rd_addr, // address 
	output [DW-1:0] rd_dout, // data output   
	// write-port
	input 	    wr_clk,// wr clock
	input 	    wr_en, // memory access
	input [AW-1:0]  wr_addr, // address
	input [DW-1:0]  wr_wem, // write enable vector    
	input [DW-1:0]  wr_din // data input
);

logic [DW-1:0]       ram    [0:DEPTH-1] = '{default:'0};  
logic [DW-1:0]       rdata;
logic [AW-1:0]       dp_addr;


initial begin
	if(INIT_FILE != "NULL") begin
		$writememh(INIT_FILE, ram);
	end
end

//#########################################
//limiting dual port
//#########################################	

assign dp_addr[AW-1:0] = (DUALPORT==1) ? rd_addr[AW-1:0] : wr_addr[AW-1:0];

//#########################################
//write port
//#########################################	

always_ff @(posedge wr_clk) begin  
	for (integer i=0;i<DW;i=i+1) begin
		if (wr_en & wr_wem[i]) begin
			ram[wr_addr[AW-1:0]][i] <= wr_din[i];
		end
	end
end

//#########################################
//read port
//#########################################

assign rdata[DW-1:0] = ram[dp_addr[AW-1:0]];

//Configurable output register
logic [DW-1:0]        rd_reg = '0;

always_ff @(posedge rd_clk, negedge rd_nreset) begin
	if(!rd_nreset) begin
		rd_reg <= '0;
	end else if(rd_en) begin   
		rd_reg[DW-1:0] <= rdata[DW-1:0];
	end
end

//Drive output from register or RAM directly
assign rd_dout[DW-1:0] = (REG==1) ? rd_reg[DW-1:0] : rdata[DW-1:0];
 
endmodule // std_ram_dp

