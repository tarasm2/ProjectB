// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen 
// 5/20/2020
// ProjectB
// State Machine that cycles through a set of staesdepending on the input. The initial state resets the counter, and then goes to the fetch state which grabs the instruction
// and then depending on what that instruction is, the next state is decided, with the ability to execute multiple commands, labeled by the state names. It runs on the clock that the whole
// processor uses and outputs all the data necessary for the computaions or exectution of the instruction.

module StateMachine(clk, reset, data, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, CurrentState, NextState);
    input logic [15:0] data;                                              // input to state machine
    input logic clk, reset;                                               // clock and reset signals 
    output logic PC_clr, PC_up, IR_ld, RF_s, RF_W_en, D_wr;               // counter clear, count up, reg load, mux select, reg write, and data write signals
    output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;                 // write, readA, and readB addresses for Regiester File
    output logic [2:0] ALU_s0;                                            // ALU select bits
    output logic [7:0] D_addr;                                            // address to be written to/read from in Data Memory

    output logic [3:0] CurrentState, NextState;                     // declaring the two states in the state machine


        localparam                          // declaring all the states within the state machine
            Init   = 0,
            Fetch  = 1,
            Decode = 2,
            NOOP   = 3,
            Load_A = 4,
            Load_B = 5,
            Store  = 6,
            Add    = 7,
            Sub    = 8,
            Halt   = 9;

    // state register
    always_ff@(posedge clk)
        if (reset) CurrentState <= Init;
        else       CurrentState <= NextState;                                              
    
    // next state logic
    always_comb
        case(CurrentState)
            Init:begin
                    PC_clr = 1;                 // clear/reset the PC counter
                    NextState = Fetch;          // Next state is Fetch
            end   
            Fetch:begin
                    PC_clr = 0;                 // stop the clear signal from going to the PC counter
                    PC_up = 1;                  // increment PC counter
                    IR_ld = 1;                  // load in data from memory
                    D_wr = 0;                   // disable being able to write to data if it was enabled elsewhere
                    RF_W_en = 0;                // disable being able to write to reg file if it was enabled elsewhere
                    NextState = Decode;         // decode state next
            end
            Decode:begin                        // depending on first four numbers of input, choose which operation is going to be done
                IR_ld = 0;                      // wait until the next fetch to load next signal
                PC_up = 0;                      // dont count up any more until next fetch
                if(data[15:12] == 0)      NextState = NOOP;          
                else if(data[15:12] == 1) NextState = Store;
                else if(data[15:12] == 2) NextState = Load_A;
                else if(data[15:12] == 3) NextState = Add;
                else if(data[15:12] == 4) NextState = Sub;
                else                      NextState = Halt;
            end
            NOOP:   NextState = Fetch;          // no operations in this state, go back to fetch
            Load_A:begin
                D_addr = data[11:4];            // address being sent to datapath memory to be read/written
                RF_s = 1;                       // select bit for the mux chooses to load in something from the data Memory
                RF_W_addr = data[3:0];          // address in the Register file where the data will be written to
                RF_W_en = 1;                    // enable the write command in the register file to allow writing to it
                NextState = Load_B;             // Nextstate will go to the Next load cycle
            end
            Load_B: NextState = Fetch;          // the Load operation takes two clock cycles to toggle, this is a stopgap to take a clockcycle
            Store:begin
                D_addr = data[7:0];             // address being sent to datapath memory where the information will be stored within it
                D_wr = 1;                       // write enable bit for data memory
                RF_Ra_addr = data[11:8];        // data being saved from register to data memeory
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Add:begin
                RF_W_addr = data[3:0];          // address that the sum will be written to within the register file
                RF_W_en = 1;                    // enable to write to the register file
                RF_Ra_addr = data[11:8];        // first number being added
                RF_Rb_addr = data[7:4];         // second number being added
                ALU_s0 = 1;                     // tell the ALU to add the two numbers
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Sub:begin
                RF_W_addr = data[3:0];          // address that the sum will be written to within the register file
                RF_W_en = 1;                    // enable to write to the register file
                RF_Ra_addr= data[11:8];         // number that will be subrtacted from
                RF_Rb_addr = data[7:4];         // number that will be subtracted from above number
                ALU_s0 = 2;                     // ALU signal to do the subtracting
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Halt:   NextState = Halt;           // Halt the entire system by constantly staying in the Halt State
            default: NextState = Init;          // initial case is our default case
        endcase
endmodule

module StateMachine_tb();
    logic [15:0] data;                                             // input to state machine
    logic PC_clr, PC_up, IR_ld, RF_s, RF_W_en, reset, D_wr, clk;   // counter clear, count up, reg load, mux select, write, reset enable, data write and clock signals
    logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;                 // write, readA, and readB addresses for Regiester File
    logic [2:0] ALU_s0;                                            // ALU select bits
    logic [7:0] D_addr;                                            // address to be written to/read from in Data Memory
    logic [3:0] CurrentState, NextState;

    StateMachine U1(clk, reset, data, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, CurrentState, NextState);

    always begin        // clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin                                   // #22 is chosen to go a little over 1 clock cycle to make wait statements work
        @(negedge clk) reset = 1; data = 0;         // reset the state machine to set it to the initial state 
        @(negedge clk) reset = 0; #22;              // turn reset bit off to start the cycle with a NOOP input
        wait(NextState == 1); #22;                  // wait until its about to fetch the next instruction within the NOOP cycle
        data = 16'b0001_1111_0010_1001;             // move the data in register 15 in reg file into data register 41 (checking the STORE instruction)
        wait(CurrentState == 6); #22;                // wait until its about to fetch the next instruction
        data = 16'b0010_0000_1010_0111;             // move the data in data memory register 10 to register 7 in reg file (checking the LOAD instruction)
        wait(CurrentState == 5); #22;               // wait until its about to fetch the next instruction
        data = 16'b0011_0001_0010_0011;             // add the data in the reg file (register 1 + register 2) and store in the 3rd register in reg file (testing ADD instruction)
        wait(CurrentState == 7); #22;               // wait until its about to fetch the next instruction
        data = 16'b0100_0001_0010_0011;             // subtract data in reg file (data in register 1 - register 2) and store in the 3rd register
        wait(CurrentState == 8); #22;               // wait until its about to fetch the next instruction
        data = 16'b0101_0000_0000_0000; #90;        // test the HALT instruction to see if it just stays there
        reset = 1; #22;                             // see if reset signal reset it to the initial state and resets PC counter
        $stop;
    end
endmodule