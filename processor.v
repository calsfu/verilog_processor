module processor(clk, rst, start, bus, command);
	input clk, rst, start;
	wire addsub, done;
	wire[9:0] reg_enable_out,reg_enable_in;
	output[15:0] bus;
	wire[8:0] addr;
	output[22:0] command;
	
	//
	
	
	
	my_rom0	my_rom0_inst (
	.address ( addr ),
	.clock ( clk ),
	.q ( command )
	);
	my_fsm control(.clk(clk), .command(command), .addsub(addsub), .reg_enable_out(reg_enable_out), .reg_enable_in(reg_enable_in), .done(done));
	my_datapath datapath(.clk(clk), .addsub(addsub), .reg_enable_out(reg_enable_out), .reg_enable_in(reg_enable_in), .bus(bus), .data(command[15:0]));
	program_counter inst_pc(.clk(clk), .rst(rst) , .enable(done), .addr(addr));
	

	
endmodule