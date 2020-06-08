// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/26/2020
// ProjectB
// Button Synchronizer module that works with two flip flops and a state machine. It is used to minimize the chance of a metastable voltage.
// The first flip flop takes the input. If it is metastable, the next flip flop and FSM should be able to stabilize it to a usable range (0 or 1).

module ButtonSync( Clk, Bi, Bo);
  input Clk;        // system clock
  input Bi;        
  output logic Bo;  // system output 
  
  // name your states with localparams
  // suppose 3 states named A, B, C, and one unused
  localparam A  = 2'd0, 
             B  = 2'd1, 
             C    = 2'd2, 
             Unused  = 2'd3;
             
  logic [1:0] State = A, NextState;  // state variables
  
  // CombLogic (use blocking assigns)
  always_comb begin
    Bo = 1'b0;	                // system output (by default)
    NextState = State;  // by default don't change state
    
    case (State)
      
      A: begin
          // specify the output
        if (Bi)  begin
          NextState = B;  // 
        end
		  else NextState = A;
      end  //
      
      B: begin
         Bo = 1'b1; // specify the output
        if (Bi) begin
          NextState = C;
        end
		  else NextState = A;
      end  // 
      
      C: begin
         //specify the output
	     if (Bi) begin
          NextState = C;
        end
		  else NextState = A;
       end
      
      default: begin
                              // specify the output
        NextState = A;          // safe state
      end
    endcase
  end // always Comb Logic
    
  // StateReg (use non-blocking assigns)
  always_ff @( posedge Clk ) begin
      State <= NextState;   // go to the state we set
  end  // always
  
endmodule



//********************************************//
//                 Testbench	                //
//********************************************//

module ButtonSync_tb(); 
   logic Clk, Bi, Bo;
  	
	always begin  // 50 MHz Clock
	  Clk = 0;
		#10;
		Clk = 1'b1;
		#10;
	end
  
  ButtonSync DUT(Clk, Bi, Bo);
  
  initial begin
    Bi = 1'b0; #35; // generate your input sequence
    Bi = 1'b1; #60;
	 Bi = 1'b0; #40;
	 $stop;
  end
  
  initial
    $monitor($time,,,Bi,,,Bo);
  
endmodule

