`timescale 1ns / 1ps

module tb_load;

    reg [3:0] count, data;
    reg [3:0] rx, ry;
    reg [2:0] func;
    reg clk, w, rst;
    wire [3:0] reg_val0, reg_val1, reg_val;
	 wire [3:0] bus;
	 wire [9:0] reg_enable_in; //8 normal regs + g and A
	wire [9:0] reg_enable_out;
	wire[4:0] curr_state;

    control dsa(.clk(clk), .w(w), .rx(rx), .ry(ry), .rst(rst), .func(func), .data(data), .reg_val0(reg_val0), .reg_val1(reg_val1), .bus(bus), .reg_enable_in(reg_enable_in), .reg_enable_out(reg_enable_out), .curr_state(curr_state));

    initial begin
        count = 4'b0000;
    end

    always begin
        #50
        count = count + 4'b0001;
    end

    always@(count) begin
        case(count) 
            4'b0000 : begin clk = 0; func = 3'b000; w=	1'b0; rx=4'b0000; ry=4'b0001; data=4'b0000; rst = 0; end //Load
            4'b0001 : begin clk = 1; func = 3'b000; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b0001; rst = 0; end //Load
				4'b0010 : begin clk = 0; func = 3'b000; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1000; rst = 0; end //Load
            4'b0011 : begin clk = 1; func = 3'b000; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1000; end //Move
				4'b0100 : begin clk = 0; func = 3'b000; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1001; end //Move
				4'b0101 : begin clk = 1; func = 3'b000; w=1'b1; rx=4'b0001; ry=4'b0000; data=4'b1010; end //Move
				4'b0110 : begin clk = 0; func = 3'b000; w=1'b1; rx=4'b0001; ry=4'b0000; data=4'b1010; end  //Move
				4'b0111 : begin clk = 1; func = 3'b000; w=1'b1; rx=4'b0001; ry=4'b0001; data=4'b1010; end  //Add
				4'b1000 : begin clk = 0; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; end  //Add
				4'b1001 : begin clk = 1; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; end  //Add
				4'b1010 : begin clk = 0; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; end  //Add
				4'b1011 : begin clk = 1; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; end  //Add
				4'b1100 : begin clk = 0; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; end  //Add
				default : begin clk = 1; func = 3'b010; w=1'b1; rx=4'b0000; ry=4'b0001; data=4'b1010; rst = 0; end
        endcase
    end




endmodule