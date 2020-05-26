// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// ALU mdule...


module ALU( A, B, Sel, Q );
    input [2:0] Sel;        // function select
    input [15:0] A, B;      // input data
    output logic [15:0] Q;  // ALU output (result)
	 
    always @ (Sel, A, B) begin 
	 
	     case(Sel)
            0: Q = 0;           // if s == 0 the output is 0
            1: Q = (A + B);     // if s == 1 the output is A + B
            2: Q = (A - B);     // if s == 2 the output is A – B
            3: Q =  A;          // if s == 3 the output is A (pass-through)
            4: Q = (A ^ B);     // if s == 4 the output is A ^ B
            5: Q = (A | B);     // if s == 5 the output is A | B
            6: Q = (A & B);     // if s == 6 the output is A & B
            7: Q = (A + 1'b1);     // if s == 7 the output is A + 1
            default: Q = 0;     // default to Q = 0;
        endcase
		  
	  end //always 
endmodule

//testbench

module ALU_tb();

    logic [2:0] Sel;        // function select
    logic [15:0] A, B;      // input data
    logic [15:0] Q;        // ALU output (result)
	 
	 //module ALU( A, B, Sel, Q );
	 ALU DUT ( A, B, Sel, Q );
	 
	 initial begin
		A = 16'b0000000000000000; B=16'b0000000000000001; Sel = 3'b000; #10;  // Q stay at 0
																		  Sel = 3'b001; #10;  // Add A and B
		A = 16'b0000000000000001; B=16'b0000000000000001; Sel = 3'b010; #10;  // subtract A and B
																		  Sel = 3'b001; #10;	 // Add A and B	
																		  Sel = 3'b011; #10;  // Q is whatever A is
																		  Sel = 3'b100; #10;  // Aa xor B
																		  Sel = 3'b101; #10;  // A or B
		A = 16'b0000000000000000; B=16'b0000000000000001; Sel = 3'b110; #10;  // A and B
																		  Sel = 3'b111; #10;  // Add 1 to A
	 $stop;
	 end 
	 
endmodule

