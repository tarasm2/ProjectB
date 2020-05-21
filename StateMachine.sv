// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a Verilog description for an 256 x 16 register file

module StateMachine(reset, data, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, CurrentState, NextState);
    input logic [15:0] data;                                // input to state machine
    output logic PC_clr, PC_up, IR_ld, RF_s, RF_W_en, reset;// counter clear, count up, reg load, mux select, write, and reset enable signals
    output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;   // write, readA, and readB addresses for Regiester File
    output logic [2:0] Alu_s0;                              // ALU select bits
    output logic [7:0] D_addr;                              // address to be written to/read from in Data Memory

    output logic [3:0] CurrentState, NextState;    // declaring the two states in teh state machine

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
                    PC_up = 1;                  // increment PC counter
                    IR_ld = 1;                  // load in data from memory
                    NextState = Decode;         // decode state next
            end
            Decode:begin                        // depending on first four numbers of input, choose which operation is going to be done
                if(data[15:12] == 0)      NextState = NOOP;          
                else if(data[15:12] == 1) NextState = Store;
                else if(data[15:12] == 2) NextState = Load;
                else if(data[15:12] == 3) NextState = Add;
                else if(data[15:12] == 4) NextState = Sub;
                else                      NextState = Halt;
            end
            NOOP:   NextState = Fetch;          // no operations in this state, go back to fetch
            Load:begin
                D_addr = IR[11:4];              // address being sent to datapath memory to be read/written
                RF_s = 1;                       // select bit for the mux chooses to load in something from the data Memory
                RF_W_addr = IR[3:0];            // address in the Register file where the data will be written to
                RF_W_en = 1;                    // enable the write command in the register file to allow writing to it
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Store:begin
                D_addr = IR[7:0];               // address being sent to datapath memory where the information will be stored within it
                D_wr = 1;                       // write enable bit for data memory
                RF_Ra_addr=IR[11:8];            // data being saved from register to data memeory
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Add:begin
                RF_W_addr = IR[3:0];            // address that the sum will be written to within the register file
                RF_W_wr = 1;                    // enable to write to the register file
                RF_Ra_addr=IR[11:8];            // first number being added
                RF_Rb_addr = IR[7:4];           // second number being added
                ALU_s0 = 1;                     // tell the ALU to add the two numbers
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Sub:begin
                RF_W_addr = IR[3:0];            // address that the sum will be written to within the register file
                RF_W_wr = 1;                    // enable to write to the register file
                RF_Ra_addr=IR[11:8];            // number that will be subrtacted from
                RF_Rb_addr = IR[7:4];           // number that will be subtracted from above number
                ALU_s0 = 2;                     // ALU signal to do the subtracting
                NextState = Fetch;              // Nextstate will go back to fetch next command
            end
            Halt:   NextState = Halt;           // Halt the entire system by constantly staying in the Halt State
            default: NextState = Init;          // initial case is our default case
        endcase
endmodule


            