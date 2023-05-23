module my_reg(x, enable, y, clk, rst); //tri, reg, reg, tri
	input clk, enable, rst;					//tri up, reg up, reg down, tri down
	input [15:0] x;
	output reg [15:0] y;
	reg q;
	reg d;
	
	initial begin 
		y = 4'b0000;
	end
	
	
	always@(clk) begin 
		q <= clk;
	end
	always@(q) begin
		d <= q;
	end
	
	
	always@(posedge clk or posedge rst ) begin
		if(rst == 1'b1) y <= 4'b0000;
		else if(enable == 1'b1) y <= x;
		else y <= y;
	end

endmodule