module processor(clk, rst, start, bus, command, dig0, dig1, dig2, dig3);
	input clk, rst, start;
	wire[2:0] addsub;
	wire done, jmpen;
	wire[9:0] reg_enable_out;
	wire[10:0] reg_enable_in;
	output[15:0] bus;
	wire[8:0] addr, jmpaddr;
	
	output[24:0] command;
	output[6:0] dig0,dig1,dig2,dig3;
	
	hex_to_sevenseg_decoder diginst0(.bus(bus[15:12]), .command(command[24:20]), .hex(dig0));
	hex_to_sevenseg_decoder diginst1(.bus(bus[11:8]), .command(command[24:20]), .hex(dig1));
	hex_to_sevenseg_decoder diginst2(.bus(bus[7:4]), .command(command[24:20]), .hex(dig2));
	hex_to_sevenseg_decoder diginst3(.bus(bus[3:0]), .command(command[24:20]), .hex(dig3));
	
	my_rom0	my_rom0_inst (
	.address ( addr ),
	.clock ( clk ),
	.q ( command )
	);
	my_fsm control(.clk(clk), .command(command), .addsub(addsub), .reg_enable_out(reg_enable_out), .reg_enable_in(reg_enable_in), .done(done),.jmpen(jmpen));
	my_datapath datapath(.clk(clk), .addsub(addsub), .reg_enable_out(reg_enable_out), .reg_enable_in(reg_enable_in), .bus(bus), .data(command[15:0]), .addr(addr), .jmpaddr(jmpaddr));
	program_counter inst_pc(.clk(clk), .rst(rst) , .enable(done), .addr(addr),.jmpen(jmpen),.jmpaddr(jmpaddr));
	

	
endmodule