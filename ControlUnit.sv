// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// Control unit the combines all the modules that fit in the control unit to work together and produce certain outputs.
// it is all run on a positive edge clock signal and sends out a bunch of outputs to the datapath.

`timescale 1 ps / 1 ps

module ControlUnit(reset, clk, OutState, NextState, D_addr, D_wr,RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0, PC_Out, PC_clr, PC_up, IR_ld, IR_Out, data);
    input logic clk, reset;                                 // clock, reset, Data write enable, MUX select, Register write enable, ALU select bit  
    output logic [3:0] RF_Ra_addr, RF_Rb_addr, RF_W_addr;   // Addresses for A, B, and write destination within the Register file
    output logic [7:0] D_addr;                              // address within the Data Memory
    output logic [3:0] OutState, NextState;                 // State of State Machine to be shown on board
    output logic [2:0] ALU_s0;                              // ALU select bit
    output logic D_wr, RF_s, RF_W_en, PC_clr, PC_up, IR_ld; // single bit outputs
    output logic [15:0] IR_Out, data;                       // Data sent to state machine from Instruction Reg, data sent into IR from Instruction memory 
    output logic [6:0] PC_Out;                              // PC address being sent to Instruction memory

    //InstMemory (address, clock,	q);
    InstructionMem U1(PC_Out, clk, data);

    //Instruc_Reg (clk, data, load, out);
    Instruc_Reg U4(clk, data, IR_ld, IR_Out);

    //StateMachine(clk, reset, data, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, CurrentState, NextState);
    StateMachine U2(clk, reset, IR_Out, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, OutState, NextState);

    //PC_Counter(clk, up, clear, address);
    PC_Counter U3(clk, PC_up, PC_clr, PC_Out);

    

endmodule

module ControlUnit_tb();
    logic clk, reset;                                 // clock, reset, Data write enable, MUX select, Register write enable, ALU select bit  
    logic [3:0] RF_Ra_addr, RF_Rb_addr, RF_W_addr;   // Addresses for A, B, and write destination within the Register file
    logic [7:0] D_addr;                              // address within the Data Memory
    logic [3:0] OutState, NextState;                 // State of State Machine to be shown on board
    logic [2:0] ALU_s0;                              // ALU select bit
    logic D_wr, RF_s, RF_W_en, PC_clr, PC_up, IR_ld; // single bit outputs
    logic [15:0] IR_Out, data;                       // Data sent to state machine from Instruction Reg, data sent into IR from Instruction memory 
    logic [6:0] PC_Out;                              // PC address being sent to Instruction memory

    ControlUnit DUT(reset, clk, OutState, NextState, D_addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0, PC_Out, PC_clr, PC_up, IR_ld, IR_Out, data);

    always begin        //clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        reset = 1; #52;
        reset = 0; #22;
        wait (NextState == 1); // LOAD DataMem[11] into RegFile[1]
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);        
        #22;
        wait (NextState == 1); // LOAD DataMem[27] into RegFile[2]
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);        
        #22;
        wait (NextState == 1); // LOAD DataMem[6] into RegFile[3]
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (NextState == 1); // LOAD DataMem[138] into RegFile[4]     
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (NextState == 1); // SUB Reg_File[1] - Reg_File[4] into Reg_File[5] 
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (NextState == 1); // SUB Reg_File[3] - Reg_File[2] into Reg_File[6] 
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (NextState == 1); // ADD Reg_File[5] + Reg_File[6] into Reg_File[0] 
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (NextState == 1); // STORE Reg_File[0] into data Memory[205]
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #22;
        wait (OutState == 9); // HALT
        $display("Time =%0t PC_Out =%7b Instruction Data =%16b Instruction Register Output =%16b RF_Ra_addr =%4b RF_Rb_addr =%4b RF_W_addr =%4b D_addr =%8b OutState =%4b ALU_s0 =%3b D_Wr =%1b RF_s =%1b RF_W_en =%1b", $time, PC_Out, data, IR_Out, RF_Ra_addr, RF_Rb_addr, RF_W_addr, D_addr, OutState, ALU_s0, D_wr, RF_s, RF_W_en);
        #62;                      // Show that Halt is working  
        $stop;
    end
endmodule