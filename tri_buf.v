module tri_buf (a,b,enable, clk);
	input enable, clk;
	input[3:0] a;
	output reg [3:0] b;
	
	always@(enable) begin
		if(enable == 1'b1) b <= a;
		else b <= 4'bzzzz;
	end

endmodule