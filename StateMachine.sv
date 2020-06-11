// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen 
// 5/20/2020
// ProjectB
// State Machine that cycles through a set of staesdepending on the input. The initial state resets the counter, and then goes to the fetch state which grabs the instruction
// and then depending on what that instruction is, the next state is decided, with the ability to execute multiple commands, labeled by the state names. It runs on the clock that the whole
// processor uses and outputs all the data necessary for the computaions or exectution of the instruction.
// All the output enable bits are turned off initially in the Fetch block and are enabled when needed in other blocks, and are then turned back of in the Fetch block again

	typedef enum logic 	[3:0]	{ A, B, C, D, E, F, G, H, I ,J } statetype; 

			
	module StateMachine (clk, data, reset, IR_ld, PC_clr, PC_up, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, CurrentStateOut, NextStateOut);
					 
			input logic clk, reset;                                     // clock and reset signals 
			input logic [15:0] data;                                    // input to state machine
			output logic D_wr, PC_clr, PC_up, IR_ld, RF_s, RF_W_en;     // counter clear, count up, reg load, mux select, reg write, and data write signals
			output logic [2:0] ALU_s0;
			output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;       // write, readA, and readB addresses for Regiester File    
			output logic [7:0] D_addr;                                  // address to be written to/read from in Data Memory
			
			output logic [3:0] CurrentStateOut, NextStateOut;	
		
			statetype CurrentState = A, NextState;
			
			assign CurrentStateOut = CurrentState;
			assign NextStateOut = NextState;

    // state register
        always_ff @(posedge clk) begin
        if (!reset) CurrentState <= A;
        else        CurrentState <= NextState;  
        end
    // next state logic
    always_comb begin

                D_wr = 0;                   // this and all lower signals in fetch are created to avoid inferred latches by setting these values to
                RF_W_en = 0;                // a constant value.
                D_addr = 0;                 
                RF_s = 0;                   
                RF_Ra_addr = 0;
                RF_Rb_addr = 0;
                ALU_s0 = 0;
                RF_W_addr = 0;
                IR_ld = 0;
                PC_clr = 0;
                PC_up = 0;

        case(CurrentState)
            A:begin
                    PC_clr = 1;                 // clear/reset the PC counter
                    NextState = B;          // Next state is Fetch
            end   
            B:begin
                    PC_up = 1;                  // increment PC counter
                    IR_ld = 1;                  // load in data from memory
                    NextState = C;         // decode state next
            end
            C:begin                        // depending on first four numbers of input, choose which operation is going to be done
                if(data[15:12] == 0)      NextState = D;     // NOOP     
                else if(data[15:12] == 1) NextState = G;     // Store
                else if(data[15:12] == 2) NextState = E;     // Load_A
                else if(data[15:12] == 3) NextState = H;     // Add
                else if(data[15:12] == 4) NextState = I;     // Sub
                else if(data[15:12] == 5) NextState = J;     // Halt
                else                      NextState = D;     // NOOP
            end
            D:   NextState = B;                 // no operations in this state, go back to fetch
            E:begin
                D_addr = data[11:4];            // address being sent to datapath memory to be read/written
                RF_s = 1;                       // select bit for the mux chooses to load in something from the data Memory
                RF_W_addr = data[3:0];          // address in the Register file where the data will be written to
                NextState = F;                  // Nextstate will go to the Next load cycle                                 
            end
            F: begin
                D_addr = data[11:4];            // address being sent to datapath memory to be read/written
                RF_s = 1;                       // select bit for the mux chooses to load in something from the data Memory
                RF_W_addr = data[3:0];          // address in the Register file where the data will be written to
                RF_W_en = 1;                    // enable the write command in the register file to allow writing to it
                NextState = B;                  // the Load operation takes two clock cycles to toggle, this is a stopgap to take a clockcycle
            end
			G:begin
                D_addr = data[7:0];             // address being sent to datapath memory where the information will be stored within it
                D_wr = 1;                       // write enable bit for data memory
                RF_Ra_addr = data[11:8];        // data being saved from register to data memeory
                NextState = B;                  // Nextstate will go back to fetch next command
            end
            H:begin
                RF_W_addr = data[3:0];          // address that the sum will be written to within the register file
                RF_W_en = 1;                    // enable to write to the register file
                RF_Ra_addr = data[11:8];        // first number being added
                RF_Rb_addr = data[7:4];         // second number being added
                ALU_s0 = 1;                     // tell the ALU to add the two numbers
                RF_s = 0;                       // input being selected by the Mux is output from ALU
                NextState = B;                  // Nextstate will go back to fetch next command
            end

            I:begin
                RF_W_addr = data[3:0];          // address that the sum will be written to within the register file
                RF_W_en = 1;                    // enable to write to the register file
                RF_Ra_addr= data[11:8];         // number that will be subrtacted from
                RF_Rb_addr = data[7:4];         // number that will be subtracted from above number
                ALU_s0 = 2;                     // ALU signal to do the subtracting
                RF_s = 0;                       // input being selected by the Mux is output from ALU
                NextState = B;                  // Nextstate will go back to fetch next command
            end

            J:   NextState = J;              // Halt the entire system by constantly staying in the Halt State

            default: NextState = A;          // initial case is our default case
        endcase
    end
    
endmodule

module StateMachine_tb();
    logic [15:0] data;                                             // input to state machine
    logic PC_clr, PC_up, IR_ld, RF_s, RF_W_en, reset, D_wr, clk;   // counter clear, count up, reg load, mux select, write, reset enable, data write and clock signals
    logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;                 // write, readA, and readB addresses for Regiester File
    logic [2:0] ALU_s0;                                            // ALU select bits
    logic [7:0] D_addr;                                            // address to be written to/read from in Data Memory
    logic [3:0] CurrentStateOut, NextStateOut;

	StateMachine DUT(clk, data, reset, IR_ld, PC_clr, PC_up, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, CurrentStateOut, NextStateOut);

    always begin        // clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin                                   
        reset = 0;
        data = 0;                                   // data for NOOP instruction
        @(negedge clk) reset = 1; #22;              // turn reset bit off to start the cycle with a NOOP input
        wait(NextStateOut == 1); #22;                  // wait until its about to fetch the next instruction within the NOOP cycle
        $display("Time =%4d PC_up =%2b IR_ld =%2b", $time, PC_up, IR_ld);            // display nessesary info
        data = 16'b0001_1111_0010_1001;             // move the data in register 15 in reg file into data register 41 (checking the STORE instruction)
        wait(NextStateOut == 6); #22;               // wait until its about to fetch the next instruction
        $display("Time =%4d RF_Ra_addr=%7d D_Wr=%1b D_addr=%4d",$time, RF_Ra_addr, D_wr, D_addr);
        data = 16'b0010_0000_1010_0111;             // move the data in data memory register 10 to register 7 in reg file (checking the LOAD instruction)
        wait(NextStateOut == 5); #22;               // wait until its about to fetch the next instruction
        $display("Time =%4d D_Addr=%7d RF_s=%2b RF_W_addr =%4d RF_W_en =%2d",$time, D_addr, RF_s, RF_W_addr, RF_W_en);
        data = 16'b0011_0001_0010_0011;             // add the data in the reg file (register 1 + register 2) and store in the 3rd register in reg file (testing ADD instruction)
        wait(NextStateOut == 7); #22;               // wait until its about to fetch the next instruction
        $display("Time =%4d RF_Ra_addr=%7d RF_Rb_addr=%7d RF_s=%2b ALU_s0 =%1b RF_W_addr =%4d RF_W_en =%2b",$time, RF_Ra_addr, RF_Rb_addr, RF_s, ALU_s0, RF_W_addr, RF_W_en);
        data = 16'b0100_0001_0010_0011;             // subtract data in reg file (data in register 1 - register 2) and store in the 3rd register
        wait(NextStateOut == 8); #22;               // wait until its about to fetch the next instruction
        $display("Time =%4d RF_Ra_addr=%7d RF_Rb_addr=%7d RF_s=%2b ALU_s0 =%1b RF_W_addr =%4d RF_W_en =%2b",$time, RF_Ra_addr, RF_Rb_addr, RF_s, ALU_s0, RF_W_addr, RF_W_en);
        data = 16'b0101_0000_0000_0000; #90;        // test the HALT instruction to see if it just stays there
        $display("Time =%4d RF_Ra_addr=%7d RF_Rb_addr=%7d RF_s=%2b ALU_s0 =%1b RF_W_addr =%4d RF_W_en =%2b",$time, RF_Ra_addr, RF_Rb_addr, RF_s, ALU_s0, RF_W_addr, RF_W_en);
        reset = 0; #22;                             // see if reset signal reset it to the initial state and resets PC counter
        $stop;
    end
endmodule