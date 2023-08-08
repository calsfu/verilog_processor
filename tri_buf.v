module tri_buf (a,b,enable, clk); //tri, reg, reg, tri
	input enable, clk;				 //tri up, reg up, reg down, tri down
	input[15:0] a;
	output reg [15:0] b;
	
	reg q;
	reg d;
	

	always@(enable) begin 
		q <= enable;
	end
	always@(q) begin
		d <= q;
	end
	
	always@(enable) begin
		if(enable == 1'b1) b <= a;
		else b <= 16'bz;
	end

endmodule