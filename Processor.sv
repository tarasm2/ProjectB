// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a Verilog description for an 256 x 16 register file

module Processor( clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
    input clk;                  // processor clock
    input Reset;                // system reset
    output [15:0] IR_Out;       // Instruction register
    output [7:0] PC_Out;        // Program counter
    output [3:0] State;         // FSM current state
    output [3:0] NextState;     // FSM next state (or 0 if you don’t use one)
    output [15:0] ALU_A;        // ALU A-Side Input
    output [15:0] ALU_B;        // ALU B-Side Input
    output [15:0] ALU_Out;      // ALU current output

    logic D_Wr, RF_s, RF_W_en, ALU_s0;
    logic [7:0] D_Addr;
    logic [3:0] RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;

    //module ControlUnit(reset, clk, PC_Out, IR_Out, OutState, NextState, D_Addr, D_Wr,RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0)
    ControlUnit U1(reset, clk, PC_Out, IR_Out, State, NextState, D_Addr, D_Wr, RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0);

    //DataPathDataPath(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out)
    DataPath U2(clk, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_A, ALU_B, ALU_Out);