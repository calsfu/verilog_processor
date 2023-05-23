module program_counter(clk, rst,enable, addr); //similar to my_reg, but increments output if enable 
	input clk, rst, enable;
	output reg [8:0] addr;
	
	initial begin
		addr = 9'b000000000;
	end
	
	always@(posedge enable) begin
		if(rst) addr = 9'b00000;
		else if(enable) addr = addr + 9'b00001;
		else addr = addr;
	end
	
endmodule

