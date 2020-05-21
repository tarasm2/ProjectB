// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a Verilog description for an 256 x 16 register file

module ControlUnit(reset, clk, PC_Out, IR_Out, OutState, NextState, D_Addr, D_Wr,RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0)
    input logic clk, reset, D_Wr, RF_s, RF_W_en, ALU_s0;    // clock, reset, Data write enable, MUX select, Register write enable, ALU select bit  
    output logic [6:0] PC_Out;                              // PC address being sent to Instruction memory
    output logic [15:0] IR_Out, data;                       // Data sent to state machine from Instruction Reg, and data sent into IR from Instruction memory
    output logic [3:0] RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr    // Addresses for A, B, and write destination within the Register file
    output logic [7:0] D_Addr;                              // address within the Data Memory
    output logic [3:0] OutState, NextState;                 // State of State Machine to be shown on board

    logic PC_up, PC_clr, IR_ld;

    //InstMemory (address, clock,	q);
    InstMemory U1(PC_Out, clk, data);

    //StateMachine(reset, data, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, CurrentState, NextState);
    StateMachine U2(reset, IR_Out, PC_clr, PC_up, IR_ld, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, OutState, NextState);

    //PC_Counter(clk, up, clear, address);
    PC_Counter U3(clk, PC_up, PC_clr, PC_Out);

    //Instruc_Reg (clk, data, load, out);
    Instruc_Reg U4(clk, data, IR_ld, IR_Out);
endmodule