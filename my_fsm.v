module my_fsm(w, clk, func, rx, ry, takedata, addorxor, addsub, reg_enable_in, reg_enable_out);
	input clk, w;
	input [2:0] func;
	input [4:0] rx, ry; 
	
	output reg takedata, addorxor, addsub;
	output reg [17:0] reg_enable_in ;
	output reg [16:0] reg_enable_out ;
	
	wire [3:0] temp;
	assign temp = {w, func};
	
	always @(posedge clk) begin
		case(temp)
			4'b1000 : begin 
				takedata = 1'b1;
				reg_enable_in[rx] = 1'b1;
				/*
				case (rx) 
					3'b000 : begin r0in = 1'b1; end
					3'b001 : begin r1in = 1'b1; end
					endcase
				*/
				reg_enable_in[rx] = 1'b0;
				takedata = 1'b0;
			end
			
			
			4'b1001 : begin
				reg_enable_in[rx] = 1'b1;
				reg_enable_out[ry] = 1'b1;
				/*
				case (rx) 
					3'b000 : begin r0in = 1'b1; end
					3'b001 : begin r1in = 1'b1; end
					endcase
				case (ry) 
					3'b000 : begin r0out = 1'b1; end
					3'b001 : begin r1out = 1'b1; end
					endcase
					*/
				reg_enable_in[rx] = 1'b0;
				reg_enable_out[ry] = 1'b0;
			end
			
			
			4'b1010 : begin
				addorxor = 1'b0;
				if (reg_enable_in[17] == 1'b0 && reg_enable_in[16] == 1'b0) begin //if ain and gout are 0
					addsub = 1'b0; //opens Ain and opens rxout
					reg_enable_out[rx] = 1'b1;
					reg_enable_in[17] = 1'b1;
					
					
				end
				else if (reg_enable_in[17] == 1'b1) begin //if ain is 1
					reg_enable_in[17] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes G and closes RY
					reg_enable_out[rx] = 1'b0;
					reg_enable_out[ry] = 1'b1;
					
					reg_enable_in[16] = 1'b1;
					reg_enable_out[16] = 1'b0;
					reg_enable_out[ry] = 1'b0;
				end
				else begin
					reg_enable_out[16] = 1'b1; //opens gout and rxin, then closes both
					reg_enable_in[rx] = 1'b1;
					reg_enable_in[rx] = 1'b0;
					reg_enable_out[16] = 1'b0;
					
				end
				/*
				if (a_in == 1'b0 && g_in == 1'b0) begin
					addsub = 1'b0;
					a_in = 1'b1;
					case (rx) 
						3'b000 : begin r0out = 1'b1; end
						3'b001 : begin r1out = 1'b1; end
						endcase
					end
				else if (a_in == 1'b1) begin
					a_in = 1'b0;
					g_in = 1'b1;
					case (ry) 
						3'b000 : begin r0out = 1'b1; end
						3'b001 : begin r1out = 1'b1; end
					endcase
				end
				else 
					g_out = 1'b1;
					case (rx) 
						3'b000 : begin r0in = 1'b1; end
						3'b001 : begin r1in = 1'b1; end
					endcase
					*/
			end
				
			4'b1011 : begin
				addorxor = 1'b1;
				if (reg_enable_in[17] == 1'b0 && reg_enable_in[16] == 1'b0) begin //if ain and gout are 0
					addsub = 1'b0; //opens Ain and opens rxout
					reg_enable_out[rx] = 1'b1;
					reg_enable_in[17] = 1'b1;
					
					
				end
				else if (reg_enable_in[17] == 1'b1) begin //if ain is 1
					reg_enable_in[17] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes G and closes RY
					reg_enable_out[rx] = 1'b0;
					reg_enable_out[ry] = 1'b1;
					
					reg_enable_in[16] = 1'b1;
					reg_enable_out[16] = 1'b0;
					reg_enable_out[ry] = 1'b0;
				end
				else begin
					reg_enable_out[16] = 1'b1; //opens gout and rxin, then closes both
					reg_enable_in[rx] = 1'b1;
					reg_enable_in[rx] = 1'b0;
					reg_enable_out[16] = 1'b0;
					
				end
				/*
				if (a_in == 1'b0 && g_in == 1'b0) begin
					a_in = 1'b1;
					case (rx) 
						3'b000 : begin r0out = 1'b1; end
						3'b001 : begin r1out = 1'b1; end
						endcase
					end
				else if (a_in == 1'b1) begin
					a_in = 1'b0;
					g_in = 1'b1;
					case (ry) 
						3'b000 : begin r0out = 1'b1; end
						3'b001 : begin r1out = 1'b1; end
					endcase
				end
				else 
					g_out = 1'b1;
					case (rx) 
						3'b000 : begin r0in = 1'b1; end
						3'b001 : begin r1in = 1'b1; end
					endcase
					*/
			end
			
		endcase
	end
endmodule	