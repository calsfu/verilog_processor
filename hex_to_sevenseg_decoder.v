module hex_to_sevenseg_decoder(bus, command, hex);
		input [3:0] bus;
		input [4:0] command;
		output reg[6:0] hex;
    always@(bus) begin
		if(command == 5'b00000) begin
        case(bus)
             4'b0000 : begin hex = 7'b1000000; end
             4'b0001 : begin hex = 7'b1111001; end
             4'b0010 : begin hex = 7'b0100100; end
             4'b0011 : begin hex = 7'b0110000; end
             4'b0100 : begin hex = 7'b0011001; end
             4'b0101 : begin hex = 7'b0010010; end
             4'b0110 : begin hex = 7'b0000010; end
             4'b0111 : begin hex = 7'b1111000; end
             4'b1000 : begin hex = 7'b0000000; end
             4'b1001 : begin hex = 7'b0010000; end
             4'b1010 : begin hex = 7'b0001000; end
             4'b1011 : begin hex = 7'b0000011; end
             4'b1100 : begin hex = 7'b1000110; end
             4'b1101 : begin hex = 7'b0100001; end
             4'b1110 : begin hex = 7'b0000110; end
             4'b1111 : begin hex = 7'b0001110; end
             default : begin hex = 7'b1000000; end
        endcase
		  end
		  else hex = 7'b1000000;
    end

endmodule