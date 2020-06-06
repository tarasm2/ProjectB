// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This module creates a 8 to 1 mux  that is 3 bits wide
// by using multiple 8 to 1 muxes
module Mux_16w_8_to_1(R, S, T, U, V, W, X, Y, M, Sel);
	input [2:0] Sel;							// select bits
	input [15:0] R, S, T, U, V, W, X, Y;		// 16 bit inputs
	output [15:0] M;							// 16 bit output
	
	//instantiating three 8 to 1 muxes to create a 3 bit wide 8 to 1 mux
	Mux_8_to_1 U1(R[0], S[0], T[0],U[0], V[0], W[0], X[0], Y[0], M[0], Sel[0], Sel[1], Sel[2]);
	Mux_8_to_1 U2(R[1], S[1], T[1],U[1], V[1], W[1], X[1], Y[1], M[1], Sel[0], Sel[1], Sel[2]);
	Mux_8_to_1 U3(R[2], S[2], T[2],U[2], V[2], W[2], X[2], Y[2], M[2], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U4(R[3], S[3], T[3],U[3], V[3], W[3], X[3], Y[3], M[3], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U5(R[4], S[4], T[4],U[4], V[4], W[4], X[4], Y[4], M[4], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U6(R[5], S[5], T[5],U[5], V[5], W[5], X[5], Y[5], M[5], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U7(R[6], S[6], T[6],U[6], V[6], W[6], X[6], Y[6], M[6], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U8(R[7], S[7], T[7],U[7], V[7], W[7], X[7], Y[7], M[7], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U9(R[8], S[8], T[8],U[8], V[8], W[8], X[8], Y[8], M[8], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U10(R[9], S[9], T[9],U[9], V[9], W[9], X[9], Y[9], M[9], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U11(R[10], S[10], T[10],U[10], V[10], W[10], X[10], Y[10], M[10], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U12(R[11], S[11], T[11],U[11], V[11], W[11], X[11], Y[11], M[11], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U13(R[12], S[12], T[12],U[12], V[12], W[12], X[12], Y[12], M[12], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U14(R[13], S[13], T[13],U[13], V[13], W[13], X[13], Y[13], M[13], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U15(R[14], S[14], T[14],U[14], V[14], W[14], X[14], Y[14], M[14], Sel[0], Sel[1], Sel[2]);
    Mux_8_to_1 U16(R[15], S[15], T[15],U[15], V[15], W[15], X[15], Y[15], M[15], Sel[0], Sel[1], Sel[2]);

	
endmodule

    
module Mux_16w_8_to_1_tb; //testbench to check te 8 to 1 3 wide mux
		 logic [15:0] R, S, T, U, V, W, X, Y, M;
		 logic [2:0] Sel;
		 
		 Mux_16w_8_to_1 U4(R, S, T, U, V, W, X, Y, M, Sel); //instantiating the mux
		 

		 initial begin
			R = 16'b010; S = 16'b100; T = 16'b101; U = 16'b011; V = 16'b111; W = 16'b000; X = 16'b001; Y = 16'b110; S[2] = 0; S[1] = 0; S[0] = 0; #10; //test to see if correct output is
																																			S[2] = 0; S[1] = 0; S[0] = 1; #10; //selected when select bits are switched
																																			S[2] = 0; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 0; S[1] = 1; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 1; #10;
																							
			R = 16'd0; S = 16'd0; T = 16'd0; U = 16'd0; V = 16'd0; W = 16'd0; X = 16'd0; Y = 16'd0; S[2] = 0; S[1] = 0; S[0] = 0; #10; //edge case with all inputs being 0
																																			S[2] = 0; S[1] = 0; S[0] = 1; #10;
																																			S[2] = 0; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 0; S[1] = 1; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 1; #10;
																																			
			R = 16'd7; S = 16'd7; T = 16'd7; U = 16'd7; V = 16'd7; W = 16'd7; X = 16'd7; Y = 16'd7; S[2] = 0; S[1] = 0; S[0] = 0; #10; //edge case with all inputs being 1
																																			S[2] = 0; S[1] = 0; S[0] = 1; #10;
																																			S[2] = 0; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 0; S[1] = 1; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 0; S[0] = 1; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 0; #10;
																																			S[2] = 1; S[1] = 1; S[0] = 1; #10;

			
		end
			
endmodule
