module control(clk, w, rx, ry, reset, func, data, hex_reg0, hex_reg1);
	input clk, reset, w;
	input [2:0] func; 
	wire[31:0] bus;
	/*
	wire r0in, r0out, r1in, r1out;
	wire [2:0] r0val, r1val, aval, aluval, gval;
	*/
	wire [17:0] reg_enable_in ;
	wire [16:0] reg_enable_out ;
	wire addorxor; 	
	wire [3:0] reg_val [17:0];
	output [3:0] hex_reg0, hex_reg1;
	assign hex_reg0 = reg_val[0];
	assign hex_reg0 = reg_val[1];
	
	
	genvar i;
	
	generate
		for (i = 0;i < 18; i = i + 1) begin : gen_regs//i = 16 is G reg, i = 17 is A reg
			my_reg reg_inst(.clk(clk), .x(bus), .enable(reg_enable_in[i]), .y(reg_val[i]));
		end
	endgenerate
	
	genvar j;
	
	generate
		for (j = 0;j < 17; j = j + 1) begin : gen_tribufs //i = 16 is G reg
			tri_buf tri_inst(.a(reg_val[j]), .b(bus), .enable(reg_enable_out[j]));
		end
	endgenerate
	
	my_fsm state_mach(w, clk, func, rx, ry, takedata, addorxor, addsub, reg_enable_in, reg_enable_out);
	/*
	r0 my_reg(.clk(clk), .x(bus), .enable(r0in), .y(r0val));
	r0tri tri_buf(.clk(clk), .x(r0val), .enable(r0out), .y(bus));
	r1 my_reg(.clk(clk), .x(bus), .enable(r1in), .y(r1val));
	r1tri tri_buf(.clk(clk), .x(r1val), .enable(r1out), .y(bus));
	*/
	//r2 my_reg(clk, rst, bus, r2in, r2out);
	
	
	//my_reg a(.clk(clk), .x(bus), .enable(ain), .y(aval));
	my_alu alu(.clk(clk), .a(aval), .b(bus), .addsub(addsub), .y(aluval)); //if 0, add. if 1, invert b and add
	
	my_xor xorr(.a(aval), .b(bus), .y(xorval));
	
	mux m0(.a(aluval), .b(xorval), .y(addorxor));
	
	//my_reg g(.clk(clk), .x(muxval), .enable(gin), .y(gval));	
	//tri_buf gtri(.clk(clk), .x(gval), .enable(gout), .y(bus));
	
endmodule