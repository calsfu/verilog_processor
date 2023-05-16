module mux(a, b, sel, y);
	input a, b;
	input sel;
	output reg y;
	always@(a, b, sel) begin
		if(sel == 1'b0) y = a;
		else y = b;
	end
endmodule