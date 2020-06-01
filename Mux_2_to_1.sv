// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This module created the 2 to 1 mux (tested elsewhere)

module Mux_2_to_1(X, Y, S, M);
	input X, Y, S; //two inputs and select bit
	output M;		//output of mux
	
	assign M = (~S & X) | (S & Y);
endmodule
