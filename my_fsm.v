module my_fsm(w, clk, func, rx, ry, addorxor, addsub, reg_enable_out, reg_enable_in, curr_state);
	input clk, w;
	input [2:0] func;
	input [3:0] rx, ry; 
	
	output reg addorxor, addsub;
	output reg [9:0] reg_enable_out ;
	output reg [9:0] reg_enable_in ;
	output reg[4:0] curr_state;
	reg[4:0] ini_state, next_state;
	
	wire [3:0] curr_func;
	assign curr_func = {w, func};
	reg[3:0] saved_func;
	reg done;
	
	initial begin
		reg_enable_in = 10'b000000000;
		reg_enable_out = 10'b000000000;
	end
	
	always@(posedge clk) begin
		if(done) begin 
			reg_enable_in = 10'b000000000;
			reg_enable_out = 10'b000000000;
			done = 1'b0;
		end
		else begin
			case(curr_func) 
				4'b1000 : begin 
				reg_enable_out = 10'b1000000000;
				reg_enable_in[rx] = 1'b1;
				done = 1'b1;
				/*
				case (rx) 
					3'b000 : begin r0in = 1'b1; end
					3'b001 : begin r1in = 1'b1; end
					endcase
				*/
				//reg_enable_in[rx] = 1'b0;
				//reg_enable_out[9] = 1'b0;
			end
			
			4'b1001 : begin
				reg_enable_in[rx] = 1'b1;
				reg_enable_out[ry] = 1'b1;
				done = 1'b1;
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
			end
			
			
			4'b1010 : begin
				//reg_enable_in[9] = ain
				//reg_enable_in[8] = gin
				//reg_enable_out[8] = gout
				addsub = 1'b0;
				if (reg_enable_in[9] == 1'b0 && reg_enable_in[8] == 1'b0) begin //if ain and gin are 0
					 //opens Ain and opens rxout
					reg_enable_out[rx] = 1'b1;
					reg_enable_in[9] = 1'b1;
				end
				else if (reg_enable_in[9] == 1'b1) begin //if ain is 1
					reg_enable_in[9] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
					reg_enable_out[rx] = 1'b0;
					reg_enable_out[ry] = 1'b1;
					
					reg_enable_in[8] = 1'b1;

				end
				else begin
					reg_enable_in[8] = 1'b0;
					reg_enable_out[ry] = 1'b0;
					reg_enable_out[8] = 1'b1; //opens gout and rxin, then closes both
					reg_enable_in[rx] = 1'b1;
					done = 1'b1;
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
				//reg_enable_in[9] = ain
				//reg_enable_in[8] = gin
				//reg_enable_out[8] = gout
				addsub = 1'b1;
				if (reg_enable_in[9] == 1'b0 && reg_enable_in[8] == 1'b0) begin //if ain and gin are 0
					 //opens Ain and opens rxout
					reg_enable_out[rx] = 1'b1;
					reg_enable_in[9] = 1'b1;
				end
				else if (reg_enable_in[9] == 1'b1) begin //if ain is 1
					reg_enable_in[9] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
					reg_enable_out[rx] = 1'b0;
					reg_enable_out[ry] = 1'b1;
					
					reg_enable_in[8] = 1'b1;

				end
				else begin
					reg_enable_in[8] = 1'b0;
					reg_enable_out[ry] = 1'b0;
					reg_enable_out[8] = 1'b1; //opens gout and rxin, then closes both
					reg_enable_in[rx] = 1'b1;
					done = 1'b1;
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
	end
endmodule	