module my_fsm(clk, command, addsub, reg_enable_out, reg_enable_in, done);
	input clk;
	input [22:0] command; // {1'b w 3'b func, 4'b reg, 16'b input} if not load, uses bits [15:12} of input
	wire [3:0] curr_func;
	reg[3:0] saved_func;
	wire [2:0] rx, ry; 
	wire[15:0] data;
	reg[4:0] state, next;
	assign curr_func = command[22:19];
	assign rx = command[18:16];
	assign ry = command[15:13];
	assign data = command[15:0];
	
	output reg addsub, done;
	output reg [9:0] reg_enable_out ;
	output reg [9:0] reg_enable_in ;
	//output reg[4:0] curr_state;
	
	//reg[4:0] ini_state, next;
	
	always@(state) begin
		case(state)  //
			5'b00000 : begin next = 5'b11111; end //display reg
			5'b10000 : begin next = 5'b11111; end //load
			5'b10001 : begin next = 5'b11111; end //move
			5'b10010 : begin next = 5'b10011; end//add
			5'b10011 : begin next = 5'b10100; end
			5'b10100 : begin next = 5'b11111; end
			5'b10101 : begin next = 5'b10110; end //xor
			5'b10110 : begin next = 5'b10111; end
			5'b10111 : begin next = 5'b11111; end
			5'b11111 : begin next = 5'b11111; end
		endcase
	end
	
	
	initial begin
		reg_enable_in = 10'b000000000;
		reg_enable_out = 10'b000000000;
		saved_func = 4'b0000;
		state = 5'b11111;
	end
	
	
	always@(posedge clk) begin
		if(curr_func !== saved_func) begin //checks if func has changed
			done = 1'b0;
			state = {curr_func[3], 1'b0, curr_func[2:0]};
			saved_func = curr_func;
		end
		else state = next;
		case(state)  
			5'b00000 : begin  end //display reg
			5'b10000 : begin
				reg_enable_out = 10'b1000000000;
				reg_enable_in[rx] = 1'b1;
				//done = 1'b1;
			end //load
			5'b10001 : begin 
				reg_enable_in[rx] = 1'b1;
				reg_enable_out[ry] = 1'b1;
				// 	done = 1'b1;
			end //move
			5'b10010 : begin 
				addsub = 1'b0;
				reg_enable_out[rx] = 1'b1;
				reg_enable_in[9] = 1'b1;
			end//add
			5'b10011 : begin
				reg_enable_in[9] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
				reg_enable_out[rx] = 1'b0;
				reg_enable_out[ry] = 1'b1;
				
				reg_enable_in[8] = 1'b1;
			end
			5'b10100 : begin 
				reg_enable_in[8] = 1'b0;
				reg_enable_out[ry] = 1'b0;
				reg_enable_out[8] = 1'b1; //opens gout and rxin, then closes both
				reg_enable_in[rx] = 1'b1;
				//done = 1'b1;
			end
			5'b10101 : begin 
				addsub = 1'b1;
				reg_enable_out[rx] = 1'b1;
				reg_enable_in[9] = 1'b1;
					
			end //xor
			5'b10110 : begin 
				reg_enable_in[9] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
				reg_enable_out[rx] = 1'b0;
				reg_enable_out[ry] = 1'b1;
			
				reg_enable_in[8] = 1'b1;
			end
			5'b10111 : begin
				reg_enable_in[8] = 1'b0;
				reg_enable_out[ry] = 1'b0;
				reg_enable_out[8] = 1'b1; //opens gout and rxin, then closes both
				reg_enable_in[rx] = 1'b1;
				//done = 1'b1;
			end
			5'b11111 : begin
				reg_enable_in = 10'b000000000;
				reg_enable_out = 10'b000000000;
				done = 1'b1;
			end
		endcase
		
	end
	
endmodule	