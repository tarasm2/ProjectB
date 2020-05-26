// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/26/2020
// ProjectB
// The KeyFilter module follows a button synchronizer to deal with button debouncing

	module KeyFilter( Clock, In, Out, Strobe);
	
		input Clock, In;
		output reg Out, Strobe;
		
			localparam DUR = 5_000_000 - 1;
			reg [32:0] Countdown = 0;
			
		always @ (posedge Clock) begin
		
			Out <= 0;
			Strobe <= 0;
			
			if ( Countdown == 0) begin
				Strobe <= 1;
				if (In) begin 
					Out <= 1;
					Countdown <= DUR;
				end
			end
			
			else begin
				Countdown <= Countdown - 1;
			end
		end
	endmodule
				