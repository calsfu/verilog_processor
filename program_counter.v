module program_counter(clk, rst,enable, addr,jmpen, jmpaddr); //similar to my_reg, but increments output if enable 
	input clk, rst, enable, jmpen;
	input [15:0] jmpaddr;
	output reg [8:0] addr;
	reg q;
	reg d;
	initial begin
		addr = 9'b000000000;
	end
	always@(clk) begin 
		q <= clk;
	end
	always@(q) begin
		d <= q;
	end
	always@(posedge d or posedge rst) begin
		if(rst) addr = 9'b00000;
		else if(enable) addr = addr + 9'b00001;
		else if(jmpen) addr = jmpaddr[8:0];
		else addr = addr;
	end
	
endmodule

