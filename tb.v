`timescale 1ns / 1ps

module tb;
	
	reg [3:0] count;
	reg [2:0] func;
	reg clk;
	
	control main(clk, reset, func, data, hex_reg0, hex_reg1);


	
	initial begin
		count = 4'b0000;
	end
	
	always begin
		#50
		count = count + 4'b0001;
	end
	
	always@(count) begin
		case(count) 
			4'b0000 : begin clk = 0; func = 2'b10; end
			4'b0001 : begin clk = 1; func = 2'b10; end
			4'b0010 : begin clk = 0; func = 2'b10; end
			4'b0011 : begin clk = 1; func = 2'b10; end
			4'b0100 : begin clk = 0; func = 10; end
			4'b0101 : begin clk = 1; func = 10; end
			4'b0110 : begin clk = 0; func = 11; end
			4'b0111 : begin clk = 1; func = 11; end
			4'b1000 : begin clk = 0; func = 11; end
			4'b1001 : begin clk = 1; func = 11; end
			4'b1010 : begin clk = 0; func = 11; end
			4'b1011 : begin clk = 1; func = 11; end
			
		endcase
	end
	
	
	

endmodule