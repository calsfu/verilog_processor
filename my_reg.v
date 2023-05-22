module my_reg(x, enable, y, clk, rst);
	input clk, enable, rst;
	input [3:0] x;
	output reg [3:0] y;
	
	initial begin 
		y = 4'b0000;
	end
	
	always@(x) begin
		if(rst == 1'b1) y <= 4'b0000;
		else if(enable == 1'b1 & x !== 4'bzzzz) y <= x;
	end

endmodule