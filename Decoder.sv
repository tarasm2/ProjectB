// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This module creates the output of the seven segment display
//	by turning on certain parts of it at a time. The outputs of
//	each part was found by using sum of products formula

module Decoder (data, seg); 		//creating the decoder
	input [3:0] data;				//4 bit binary input data to be decoded
	output [6:0] seg;				//output to be sent to HEX display to show the value of the input
	
	always_comb						//creating outputs using cases (create hexidecimal output)
		case(data)
			0:			seg = 7'b000_0001;
			1:			seg = 7'b100_1111;
			2:			seg = 7'b001_0010;
			3:			seg = 7'b000_0110;
			4:			seg = 7'b100_1100;
			5:			seg = 7'b010_0100;
			6:			seg = 7'b010_0000;
			7:			seg = 7'b000_1111;
			8:			seg = 7'b000_0000;
			9:			seg = 7'b000_1100;
			10:			seg = 7'b000_1000;
			11:			seg = 7'b110_0000;
			12: 		seg = 7'b011_0001;
			13:			seg = 7'b100_0010;
			14:			seg = 7'b011_0000;
			15:			seg = 7'b011_1000;
			default: 	seg = 7'b111_1111;	//default case HEX is off
		endcase
endmodule
