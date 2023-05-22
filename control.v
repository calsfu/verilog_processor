module control(clk, w, rx, ry, rst, func, data, reg_val0, reg_val1, bus, reg_enable_in, reg_enable_out, curr_state);
	input clk, rst, w;
	input [2:0] func; 
	input [3:0] data, rx, ry;
	
	output[3:0] reg_val0, reg_val1;
	output[4:0] curr_state;
	
	output[31:0] bus;
	
	/*
	wire  [3:0] num_main_reg;
	assign num_main_reg = 4'b1000;
	*/
	
	wire[3:0] muxval, aluval, xorval; //swtch to more bits later
	wire addsub;
	
	
	/*
	wire r0in, r0out, r1in, r1out;
	wire [2:0] r0val, r1val, aval, aluval, gval;
	*/
	
	output [9:0] reg_enable_in; //8 normal regs + g and A
	output [9:0] reg_enable_out; //8 normal regs + g extern
	wire addorxor; 	
	wire [3:0] reg_val [0:9];
	wire temp;
	
	assign reg_val0 = reg_val[0];
	assign reg_val1 = reg_val[1];
	
	//assign reg_val0 = reg_val;
	//assign reg_val1 = reg_val[9];
	
	/*
	my_reg r0(.x(bus), .enable(reg_enable_in[0]), .y(reg_val), .clk(clk), .rst(rst));
	
	
	*/
	
	
	genvar j;
	
	generate
		for (j = 0;j < 9; j = j + 1) begin : gen_tribufs //i = 8 is G reg, i = 9 is extern
			tri_buf tri_inst(.a(reg_val[j]), .b(bus), .enable(reg_enable_out[j]), .clk(clk));
		end
	endgenerate
	
	genvar i;
	
	generate
		for (i = 0;i < 8; i = i + 1) begin : gen_regs//i = 8 is G reg, i = 9 is A  and does not run in loop
			my_reg reg_inst(.x(bus), .enable(reg_enable_in[i]), .y(reg_val[i]), .clk(clk), .rst(rst));
		end
	endgenerate
	
	tri_buf external(.a(data), .b(bus), .enable(reg_enable_out[9]), .clk(clk)); //have to seperate since does not take from register
	
	my_reg areg(.x(bus), .enable(reg_enable_in[9]), .y(reg_val[9]), .clk(clk), .rst(rst));
	
	my_reg greg(.x(aluval), .enable(reg_enable_in[8]), .y(reg_val[8]), .clk(clk), .rst(rst));	//have to seperate since does not take from bus
	
	my_alu alu(.clk(clk), .a(reg_val[9]), .b(bus), .addsub(addsub), .y(aluval)); //if 0, add. if 1,  xor
	
	my_fsm state_mach(.w(w), .clk(clk), .func(func), .rx(rx), .ry(ry), .addorxor(addorxor), .addsub(addsub), .reg_enable_out(reg_enable_out), .reg_enable_in(reg_enable_in), .curr_state(curr_state));
	/*
	r0 my_reg(.clk(clk), .x(bus), .enable(r0in), .y(r0val));
	r0tri tri_buf(.clk(clk), .x(r0val), .enable(r0out), .y(bus));
	r1 my_reg(.clk(clk), .x(bus), .enable(r1in), .y(r1val));
	r1tri tri_buf(.clk(clk), .x(r1val), .enable(r1out), .y(bus));
	*/
	//r2 my_reg(clk, rst, bus, r2in, r2out);
	
	
	//my_reg a(.clk(clk), .x(bus), .enable(ain), .y(aval));
	//my_reg g(.clk(clk), .x(muxval), .enable(gin), .y(gval));	
	//tri_buf gtri(.clk(clk), .x(gval), .enable(gout), .y(bus));
	//tri_buf gtri(.clk(clk), .x(gval), .enable(gout), .y(bus));
	
endmodule