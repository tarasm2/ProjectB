// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/26/2020
// ProjectB
// Button Synchronizer module that works with two flip flops and a state machine. It is used to minimize the chance of a metastable voltage.
// The first flip flop takes the input. If it is metastable, the next flip flop and FSM should be able to stabilize it to a usable range (0 or 1).
	
	module ButtonSync( Clock, In, Bo);
		
		input Clock, In;		   //system clock and input Bi to State machine and module
		output logic Bo; 			//system output
		logic Q, Bi;
		
		localparam  A = 2'd0,
					B = 2'd1,
					C = 2'd2;
					  
		logic [1:0] State, NextState;
		
		//combination logic for state machine
		always_comb begin
		
			Bo = 1'b0;					//system output (default)
			NextState = State;
			
			case (State)
			
				A: 
					if (Bi) NextState = B;
					else NextState = A;
				
				B: begin
					Bo = 1'b1;
					if (Bi) 	NextState = C;
					else NextState = A;
				end
				
				C: 
					if (Bi) NextState = C;
					else NextState = A;
				
				default:NextState = A;
				
			endcase
		end
		//state register and flip flops
		always_ff @( posedge Clock ) begin
			State <= NextState;
			Q     <= In;
			Bi    <= Q;
		end
		
	endmodule
		