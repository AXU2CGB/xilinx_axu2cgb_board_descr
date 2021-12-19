 //#############################################################################
//# Function: Single Ported Memory                                            #
//#############################################################################


module std_ram_sp #(
	parameter DW      			= 32,          		// mem width
	parameter DEPTH   			= 32,           	// mem depth
	parameter REG     			= 1,            	// Register mem output
	parameter AW      			= $clog2(DEPTH), 	// rd_count width (derived)
	parameter INIT_FILE   		= "NULL"			//init file >> NULL or path to file
)
(
	// Memory interface (dual port)
	input 	   clk, //write clock
	input 	   nreset, //reset n
	input 	   wr_en, //write enable
	input 	   rd_en, //read enable
	input [DW-1:0]  wem, //per bit write enable
	input [AW-1:0] addr,//write address
	input [DW-1:0]  din, //write data
	output [DW-1:0] dout//read output data
);

 //#########################################
 // Generic RAM for synthesis
 //#########################################
 //local variables
logic [DW-1:0]        ram    [0:DEPTH-1] = '{default:'0};  
logic [DW-1:0] 	     rdata;

initial begin
	if(INIT_FILE != "NULL") begin
		$writememh(INIT_FILE, ram);
	end
end

//write port
always_ff @(posedge clk) begin
	for (integer i=0;i<DW;i=i+1) begin : write_gen
		if (wr_en & wem[i]) begin
			ram[addr[AW-1:0]][i] <= din[i];
		end
	end
end

//read port
assign rdata[DW-1:0] = ram[addr[AW-1:0]];

//Configurable output register
logic [DW-1:0] 	     rd_reg = '0;
always_ff @(posedge clk, negedge nreset) begin
	if(!nreset) begin
		rd_reg <= '0;
	end else if(rd_en) begin
		rd_reg[DW-1:0] <= rdata[DW-1:0];
	end
end

//Drive output from register or RAM directly
assign dout[DW-1:0] = (REG==1) ? rd_reg[DW-1:0] : rdata[DW-1:0];

endmodule // std_ram_sp
