module tri_buf (a,b,enable);
	input[3:0] a;
	output reg [3:0]  b;
	input enable;
	
	always @ (enable or a) begin
		if (enable)	b = a;
		else b = 3'bzzz;
	end

endmodule