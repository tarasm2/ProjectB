// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/26/2020
// ProjectB
// Button Synchronizer...
	
	module ButtonSync( Clock, Bi, Bo);
		
		input Clock, Bi;		//system clock and input
		output logic Bo; 		//system output
		
		
		localparam A = 2'd0,
					  B = 2'd1,
					  C = 2'd2;
					  
		logic [1:0] State = A, NextState;
		
		//combination logic
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
				
				default: begin
					NextState = A;
				end
				
			endcase
		end
		//state register
		always_ff @( posedge Clock ) begin
			State <= NextState;
		end
		
	endmodule
		