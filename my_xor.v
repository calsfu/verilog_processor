module my_xor(a, b, y);
	input[2:0] a,b;
	output reg[2:0] y;
	always@(a,b) begin
		y = a ^ b;
	end
endmodule