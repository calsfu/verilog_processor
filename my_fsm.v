module my_fsm(clk, command, addsub, reg_enable_out, reg_enable_in, done, jmpen);
	input clk;
	input [24:0] command; // {1'b w 4'b func, 4'b reg, 16'b input} if not load, uses bits [15:12} of input
	wire [4:0] curr_func; //25 bits
	reg[4:0] saved_func;
	wire[3:0] rx, ry; 
	wire[15:0] data;
	reg[5:0] state, next;
	assign curr_func = command[24:20];
	assign rx = command[19:16];
	assign ry = command[15:12];
	assign data = command[15:0];
	reg q;
	
	output reg done, jmpen;
	output reg [2:0] addsub;
	output reg [9:0] reg_enable_out ;
	output reg [10:0] reg_enable_in ;
	//output reg[4:0] curr_state;
	
	//reg[4:0] ini_state, next;
	
	always@(state) begin
		case(state)  //
			6'b000000 : begin next = 6'b111111; end //display reg
			6'b100000 : begin next = 6'b111111; end //load
			6'b100001 : begin next = 6'b111111; end //move
			6'b100010 : begin next = 6'b100011; end//add, xor, or, mult, sub, 
			6'b100011 : begin next = 6'b100100; end
			6'b100100 : begin next = 6'b111111; end
			6'b100101 : begin next = 6'b100110; end //swap
			6'b100110 : begin next = 6'b100111; end
			6'b100111 : begin next = 6'b111111; end
			6'b101000 : begin next = 6'b101001; end //inc , dec
			6'b101001 : begin next = 6'b111111; end
			6'b101010 : begin next = 6'b111111; end
			6'b101011 : begin next = 6'b111111; end
			6'b111111 : begin next = 6'b111111; end
		endcase
	end
	
	
	initial begin
		reg_enable_in = 11'b0000000000;
		reg_enable_out = 10'b000000000;
		saved_func = 4'b0000;
		state = 6'b111111;
		q = clk;
	end
	
	always@(clk) begin
		q <= clk;
	end
	/*
	STATE LIST
	100000 : LOAD
	100001 : MOVE
	100010 : ADD,XOR,MULT,OR,SUB 1
	100011 : ADD,XOR,MULT,OR,SUB 2
	100100 : ADD,XOR,MULT,OR,SUB 3
	100101 : SWAP 1
	100110 : SWAP 2
	100111 : SWAP 3
	101000 : INC/DEC 1
	101001 : INC/DEC 2
	*/
	always@(posedge q) begin
		if(curr_func !== saved_func) begin //checks if func has changed
			done = 1'b0;
			jmpen = 1'b0;
			reg_enable_in = 11'b0000000000;
			reg_enable_out = 10'b000000000;
			saved_func = curr_func;
			case(curr_func) 
				5'b00000 : begin state = 6'b000000; end //display hex
				5'b10000 : begin state = 6'b100000; end //load
				5'b10001 : begin state = 6'b100001; end //move
				5'b10010 : begin addsub = 3'b000; state = 6'b100010; end //add ends at 100100
				5'b10011 : begin addsub = 3'b001; state = 6'b100010; end //xor
				5'b10100 : begin addsub = 3'b111; state = 6'b100010; end //mult
				5'b10101 : begin addsub = 3'b101; state = 6'b100010; end //or
				5'b10110 : begin addsub = 3'b110; state = 6'b100101; end //swap ends at 6'b100111
				5'b10111 : begin addsub = 3'b010; state = 6'b100010; end //sub
				5'b11000 : begin addsub = 3'b011; state = 6'b101000; end //inc ends at 101001
				5'b11001 : begin addsub = 3'b100; state = 6'b101000; end //dec
				5'b11010 : begin state = 6'b101010; end //jmpload not finished
				5'b11011 : begin state = 6'b101011; end //jmpaddr
				default : begin state = 6'bzzzzzz; addsub = 3'bzzz; end //curr_func is undefined
			endcase
		end
		else state = next;
		case(state)  
			6'b000000 : begin  //display reg
				reg_enable_out[rx] = 1'b1;
				done = 1'b1; 
				end
			6'b100000 : begin //load
				reg_enable_out = 10'b1000000000;
				reg_enable_in[rx] = 1'b1;
				done = 1'b1;
			end 
			6'b100001 : begin //move
				reg_enable_in[rx] = 1'b1;
				reg_enable_out[ry] = 1'b1;
					done = 1'b1;
			end 
			6'b100010 : begin //add, xor, mult, or, sub 1
				reg_enable_out[rx] = 1'b1;
				reg_enable_in[9] = 1'b1;
			end
			6'b100011 : begin //add, xor, mult, or, sub 2
				reg_enable_in[9] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
				reg_enable_out[rx] = 1'b0;
				reg_enable_out[ry] = 1'b1;
				
				reg_enable_in[8] = 1'b1;	
			end
			6'b100100 : begin //add, xor, mult, or, sub 3
				reg_enable_in[8] = 1'b0;
				reg_enable_out[ry] = 1'b0;
				reg_enable_out[8] = 1'b1; //opens gout and rxin, then closes both
				reg_enable_in[rx] = 1'b1;
				done = 1'b1;
			end
			6'b100101 : begin //swap 1
				reg_enable_out[rx]=1'b1;
				reg_enable_in[8]=1'b1;
			end
			6'b100110 : begin //swap 2
				reg_enable_out[rx]=1'b0;
				reg_enable_in[8]=1'b0;
				reg_enable_out[ry]=1'b1;
				reg_enable_in[rx]=1'b1;
			end
			6'b100111 : begin //swap 3
				reg_enable_out[ry]=1'b0;
				reg_enable_in[rx]=1'b0;
				reg_enable_out[8]=1'b1;
				reg_enable_in[ry]=1'b1;
				done = 1'b1;
			end
			6'b101000 : begin //inc 1
				reg_enable_out[rx] = 1'b1;
				reg_enable_in[8] = 1'b1;
			end
			6'b101001 : begin //inc 2
				reg_enable_in[8] = 1'b0; //closes Ain closes rxout and opens ryout. opens Gin, then closes Gin and closes RY
				reg_enable_out[rx] = 1'b0;
				reg_enable_in[rx] = 1'b1;

				reg_enable_out[8] = 1'b1;
				done = 1'b1;
			end
			6'b101010 : begin //jmpload
				reg_enable_in[10] = 1'b1;
				reg_enable_out = 10'b1000000000;
				done = 1'b1;
			end
			6'b101011 : begin //jmpaddr
				jmpen = 1'b1;
				done = 1'b1;
			end
			6'b111111 : begin
				
				reg_enable_in = 11'b0000000000;
				reg_enable_out = 10'b000000000;
				done = 1'b0;
			end
			
		endcase
		
	end
	
endmodule	