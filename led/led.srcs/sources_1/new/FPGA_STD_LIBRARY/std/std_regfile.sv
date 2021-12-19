//#############################################################################
//# Function: Parametrized register file                                      #
//#############################################################################


module std_regfile #(
	parameter REGS  				= 8,          // number of registeres
	parameter RW    				= 16,         // register width
	parameter RP    				= 5,          // read ports
	parameter WP    				= 3,          // write prots
	parameter RAW   				= $clog2(REGS),// (derived) rf addr width
	parameter WRITE_PRIORITY	= "MSB",//write valid bus priority /*MSB, LSB, NONE*/
	parameter REG_INPUT    		= "NO",// register input>> NO, YES
	parameter REG_OUTPUT   		= "NO",// register output>> NO, YES
	parameter INIT_FILE   		= "NULL"//init file >> NULL or path to file
)

(
	//Control inputs
	input 	       clk,
	input 	       nreset,
	// Write Ports (concatenated)
	input [WP-1:0]     wr_valid, // write access
	input [WP*RAW-1:0] wr_addr, // register address
	input [WP*RW-1:0]  wr_data, // write data
	// Read Ports (concatenated)
	input [RP-1:0]     rd_valid, // read access
	input [RP*RAW-1:0] rd_addr, // register address
	output logic [RP*RW-1:0] rd_data, // output data
	
	// all register access
	output logic [REGS*RW-1:0] paralel_regs_acces
);

// reset syncronizer ----------------------------------------------------------------------------
logic reset_synced;
std_rsync rst_reg_sync (.clk(clk), .nrst_in(nreset), .nrst_out(reset_synced));
//-----------------------------------------------------------------------------------------------

logic [RW-1:0]       mem		[0:REGS-1] = '{default:'0};
logic [WP-1:0]       write_en 	[0:REGS-1];
logic [RW-1:0]       datamux 	[0:REGS-1];

genvar i,j;

initial begin
	if(INIT_FILE != "NULL") begin
		$writememh(INIT_FILE, mem);
	end
end

//TODO: Make an array of cells


generate
//#########################################
// write ports
//#########################################	
	
	//One hote write enables
	for(i=0;i<REGS;i=i+1) begin: gen_regwrite
		for(j=0;j<WP;j=j+1) begin: gen_wp
			assign write_en[i][j] = wr_valid[j] & (wr_addr[j*RAW+:RAW] == RAW '(i));
		end
	end
	
	//Multi Write-Port Mux
	for(i=0;i<REGS;i=i+1) begin: gen_wrmux
		std_oh_mux #(.DW(RW), .N(WP), .PRIORITY_TYPE(WRITE_PRIORITY)) iwrmux
		(
			.out (datamux[i][RW-1:0]),
			.sel (write_en[i][WP-1:0]),
			.in  (wr_data[WP*RW-1:0])
		);
	end
	
	if(REG_INPUT == "YES") begin
		
		logic [WP-1:0]       r0_write_en [0:REGS-1];
		logic [RW-1:0]       r0_datamux 	[0:REGS-1];
		
		//Memory Array Write
		for(i=0;i<REGS;i=i+1) begin: gen_reg
			
			always_ff @(posedge clk, negedge reset_synced) begin
				if(!reset_synced) begin
					r0_write_en[i] <= '0;
					r0_datamux[i] <= '0;
				end else begin
					r0_write_en[i] <= write_en[i];
					r0_datamux[i] <= datamux[i];
				end
			end
			
			always_ff @(posedge clk) begin
				if (|r0_write_en[i][WP-1:0]) begin
					mem[i] <= r0_datamux[i];
				end
			end
		end
		
	end else begin
		
		//Memory Array Write
		for(i=0;i<REGS;i=i+1) begin: gen_reg
			always_ff @(posedge clk) begin
				if (|write_en[i][WP-1:0]) begin
					mem[i] <= datamux[i];
				end
			end
		end
		
	end
	
	
//#########################################
// read ports
//#########################################
	if(REG_OUTPUT == "YES") begin
		
		for (i=0;i<RP;i=i+1) begin: gen_rdport
			always_ff @(posedge clk, negedge reset_synced) begin
				if(!reset_synced) begin
					rd_data[i*RW+:RW] <= '0;
				end else begin
					rd_data[i*RW+:RW] <= {(RW){rd_valid[i]}} & mem[rd_addr[i*RAW+:RAW]];
				end
			end
		end
		
	end else begin
		
		for (i=0;i<RP;i=i+1) begin: gen_rdport
			assign rd_data[i*RW+:RW] = {(RW){rd_valid[i]}} & mem[rd_addr[i*RAW+:RAW]];
		end
		
	end
	
	
	for(i=0;i<REGS;i=i+1) begin: gen_reg_acces
		assign paralel_regs_acces[i*RW+:RW] = mem[i];
	end
	
endgenerate




endmodule // std_regfile
