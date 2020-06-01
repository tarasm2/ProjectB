// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This module creates a 8 to 1 mux by connecting a series of 
// 2 to 1 muxes

module Mux_8_to_1 (R, S, T, U, V, W, X, Y, M, S0, S1, S2);
	input R, S, T, U, V, W, X, Y, S0, S1, S2; 				//8 inputs and 3 select bits
	output M;												//output
	
	logic A, B, C, D, E, F;
	
	//instantiating a series of 2 to 1 muxes
	
	Mux_2_to_1 U1(R, S, S0, A);
	Mux_2_to_1 U2(T, U, S0, B);
	Mux_2_to_1 U3(V, W, S0, C);
	Mux_2_to_1 U4(X, Y, S0, D);
	Mux_2_to_1 u5(A, B, S1, E);
	Mux_2_to_1 U6(C, D, S1, F);
	Mux_2_to_1 U7(E, F, S2, M);
	
endmodule

//testmodult to test the 8 to 1 mux
module Mux_8_to_1_tb;
	
	logic R, S, T, U, V, W, X, Y, S0, S1, S2;
	logic M;
	
	
	Mux_8_to_1 U1(R, S, T, U, V, W, X, Y, M, S0, S1, S2);
	
	integer k;
	
	initial begin
				for (k=0; k<2048; k++) begin
					{R, S, T, U, V, W, X, Y, S0, S1, S2} = k; #10;
				end
				
	end
	
	initial
			$monitor($time,,,U,,,V,,,W,,,X,,,Y);
			
endmodule
