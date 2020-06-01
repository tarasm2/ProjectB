// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This module creates a 8 to 1 mux  that is 3 bits wide
// by using multiple 8 to 1 muxes
module Mux_3w_8_to_1(R, S, T, U, V, W, X, Y, M, S0, S1, S2);
	input S0, S1, S2;							// select bits
	input [15:0] R, S, T, U, V, W, X, Y;		// 16 bit inputs
	output [15:0] M;								// 16 bit output
	
	//instantiating three 8 to 1 muxes to create a 3 bit wide 8 to 1 mux
	Mux_8_to_1 U1(R[0], S[0], T[0],U[0], V[0], W[0], X[0], Y[0], M[0], S0, S1, S2);
	Mux_8_to_1 U2(R[1], S[1], T[1],U[1], V[1], W[1], X[1], Y[1], M[1], S0, S1, S2);
	Mux_8_to_1 U3(R[2], S[2], T[2],U[2], V[2], W[2], X[2], Y[2], M[2], S0, S1, S2);
	
endmodule

    
module Mux_3w_8_to_1_tb; //testbench to check te 8 to 1 3 wide mux
		 logic [2:0] R, S, T, U, V, W, X, Y, M;
		 logic S0, S1, S2;
		 
		 Mux_3w_8_to_1 U4(R, S, T, U, V, W, X, Y, M, S0, S1, S2); //instantiating the mux
		 

		 initial begin
			R = 3'b010; S = 3'b100; T = 3'b101; U = 3'b011; V = 3'b111; W = 3'b000; X = 3'b001; Y = 3'b110; S2 = 0; S1 = 0; S0 = 0; #10; //test to see if correct output is
																																			S2 = 0; S1 = 0; S0 = 1; #10; //selected when select bits are switched
																																			S2 = 0; S1 = 1; S0 = 0; #10;
																																			S2 = 0; S1 = 1; S0 = 1; #10;
																																			S2 = 1; S1 = 0; S0 = 0; #10;
																																			S2 = 1; S1 = 0; S0 = 1; #10;
																																			S2 = 1; S1 = 1; S0 = 0; #10;
																																			S2 = 1; S1 = 1; S0 = 1; #10;
																							
			R = 3'b000; S = 3'b000; T = 3'b000; U = 3'b000; V = 3'b000; W = 3'b000; X = 3'b000; Y = 3'b000; S2 = 0; S1 = 0; S0 = 0; #10; //edge case with all inputs being 0
																																			S2 = 0; S1 = 0; S0 = 1; #10;
																																			S2 = 0; S1 = 1; S0 = 0; #10;
																																			S2 = 0; S1 = 1; S0 = 1; #10;
																																			S2 = 1; S1 = 0; S0 = 0; #10;
																																			S2 = 1; S1 = 0; S0 = 1; #10;
																																			S2 = 1; S1 = 1; S0 = 0; #10;
																																			S2 = 1; S1 = 1; S0 = 1; #10;
																																			
			R = 3'b111; S = 3'b111; T = 3'b111; U = 3'b111; V = 3'b111; W = 3'b111; X = 3'b111; Y = 3'b111; S2 = 0; S1 = 0; S0 = 0; #10; //edge case with all inputs being 1
																																			S2 = 0; S1 = 0; S0 = 1; #10;
																																			S2 = 0; S1 = 1; S0 = 0; #10;
																																			S2 = 0; S1 = 1; S0 = 1; #10;
																																			S2 = 1; S1 = 0; S0 = 0; #10;
																																			S2 = 1; S1 = 0; S0 = 1; #10;
																																			S2 = 1; S1 = 1; S0 = 0; #10;
																																			S2 = 1; S1 = 1; S0 = 1; #10;

			
		end
			
endmodule
