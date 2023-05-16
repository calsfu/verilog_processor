module my_reg(x, enable, y, clk);
	input clk, enable;
	input [2:0] x;
	output reg [2:0] y;
	
	always @ (posedge clk | enable) begin
		if (enable == 1'b1)
			y = x;
	end



endmodule