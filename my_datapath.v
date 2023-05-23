module my_datapath(clk, rst, addsub, reg_enable_out,reg_enable_in, bus, data, addr, jmpaddr); //takes in clk and enable, spits out bus value. reg_val is not need in any other part

	input clk, rst;
	input[2:0] addsub;
	input[9:0] reg_enable_out;
	input[10:0] reg_enable_in;
	input[15:0] data;
	output[15:0] bus;
	input[8:0] addr; 
	wire[15:0] addrin;
	assign addrin = { 7'b0000000, addr};
	wire [15:0] reg_val [0:10];
	wire [15:0] aluval;
	output [15:0] jmpaddr;
	assign jmpaddr = reg_val[10];
	genvar j;
	generate
		for (j = 0;j < 9; j = j + 1) begin : gen_tribufs //i = 8 is G reg, i = 9 is extern
			tri_buf tri_inst(.a(reg_val[j]), .b(bus), .enable(reg_enable_out[j]), .clk(clk));
		end
	endgenerate
	
	genvar i;
	
	generate
		for (i = 0;i < 8; i = i + 1) begin : gen_regs //i = 8 is G reg, i = 9 is A, i= 10 is jmpaddr  and does not run in loop
			my_reg reg_inst(.x(bus), .enable(reg_enable_in[i]), .y(reg_val[i]), .clk(clk), .rst(rst));
		end
	endgenerate
	
	
	my_reg jmpreg(.x(addrin),.enable(reg_enable_in[10]),.y(reg_val[10]),.clk(clk),.rst(rst));
	
	my_reg greg(.x(aluval), .enable(reg_enable_in[8]), .y(reg_val[8]), .clk(clk), .rst(rst));	//have to seperate since does not take from bus

	my_reg areg(.x(bus), .enable(reg_enable_in[9]), .y(reg_val[9]), .clk(clk), .rst(rst));

	tri_buf external(.a(data), .b(bus), .enable(reg_enable_out[9]), .clk(clk));
	
	my_alu alu(.clk(clk), .a(reg_val[9]), .b(bus), .addsub(addsub), .y(aluval));
	
endmodule