// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/26/2020
// ProjectB
// The KeyFilter module follows a button synchronizer to deal with button debouncing
// Starts by checking if Countdown has reached zero -- if it has, keep checking if input signal is on. If signal
// is on, set output to on for that clock cycle and set clock to count down from 5Mhz. Once it has counted down,
// the cycle restarts. Strobe just turns on whenever the input signal is bein read.

	module KeyFilter( Clock, In, Out, Strobe);
	
		input Clock, In;					// clock and input signal
		output logic Out, Strobe;			// Output and Strobe signals
		
			localparam DUR = 5_000_000 - 1;		// 50MHz / 5MHz allows for 10 output signals per second
			logic [32:0] Countdown = 0;			
			
		always @ (posedge Clock) begin
		
			Out <= 0;						// Set Output to 0 at start
			Strobe <= 0;					// Set Strobe to 0 at start

			if ( Countdown == 0) begin		// If countdown reaches 0
				Strobe <= 1;				// Set Strobe to 1 (input is being read)
				if (In) begin 				// If The button is pressed (In = 1)
					Out <= 1;				// Output a positive signal
					Countdown <= DUR;		// Set Countdown to 5MHz
				end
			end
			
			else begin
				Countdown <= Countdown - 1;// Count down from 5Mhz on every clock cycle
			end
		end
	endmodule
				