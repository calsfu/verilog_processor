module tri_buf (a,b,enable, clk);
	input enable, clk;
	input[15:0] a;
	output reg [15:0] b;
	
	always@(enable) begin
		if(enable == 1'b1) b <= a;
		else b <= 16'bz;
	end

endmodule