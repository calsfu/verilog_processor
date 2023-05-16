module my_alu(clk, a, b, addsub, y);
	
	input[2:0] a, b;
	input addsub, clk; //0 or 1
	output reg[2:0] y;
	
	always@(addsub or a or b) begin
		if(addsub == 1'b0) 
			y = a + b;
		else 
			y = a - b;
	end
endmodule