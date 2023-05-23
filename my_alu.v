module my_alu(clk, a, b, addsub, y);
	
	input[15:0] a, b;
	input [2:0] addsub;
	input clk; //0 or 1
	output reg[15:0] y;

	always@(addsub or a or b) begin
		if(addsub == 3'b000) 
			y = a + b;
		else if (addsub == 3'b001)
			y = a ^ b;
	   else if (addsub == 3'b010)
			y = a - b;
      else if (addsub == 3'b011)
			y = b + 16'b1;
      else if (addsub == 3'b100)
			y = b - 16'b1;
		else if (addsub == 3'b111)
			y = a*b;
		else if (addsub == 3'b101)
			y = a|b;
		else if (addsub == 3'b110)
			y = b;
	end


endmodule