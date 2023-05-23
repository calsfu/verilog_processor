`timescale 1ns / 1ps

module tb;
	reg [19:0] count;
	reg clk_in, reset_in, start_in;
	wire[15:0] bus;

	wire[22:0] command;
	
	processor proc(.clk(clk_in),.rst(reset_in),.start(start_in), .bus(bus), .command(command));
	
	initial begin
        count = 20'b0000;
		  clk_in = 1'b0;
		  reset_in = 1'b0;
		  start_in = 1'b0;
    end

    always begin
        #50
        count = count + 20'b0001;
    end
	 
	 always begin
		#25
		clk_in = 1'b0;
		#25
		clk_in = 1'b1;
	end
	
	always @(count) begin
		case (count)
			20'b0000 : begin reset_in = 1'b1; start_in = 1'b0; end
			20'b0001 : begin reset_in = 1'b0; start_in = 1'b1; end
			default : begin reset_in = 1'b0; start_in = 1'b0; end
		endcase
	end
	

endmodule