// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// Processor module that combines all the submodules within the processor to run through a series of instructions
// that are stored in instruction Memory and uses data that is stored in Data memory. It can operate 6 different instructions

`timescale 1 ps / 1 ps

module Processor( clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
    input clk;                  // processor clock
    input Reset;                // system reset
    output [15:0] IR_Out;       // Instruction register
    output [6:0] PC_Out;        // Program counter
    output [3:0] State;         // FSM current state
    output [3:0] NextState;     // FSM next state (or 0 if you don’t use one)
    output [15:0] ALU_A;        // ALU A-Side Input
    output [15:0] ALU_B;        // ALU B-Side Input
    output [15:0] ALU_Out;      // ALU current output

    logic D_Wr, RF_s, RF_W_en, PC_clr, PC_up, IR_ld;
    logic [2:0] ALU_s0;
    logic [7:0] D_Addr;
    logic [3:0] RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
    logic [15:0] data;

    //module ControlUnit(reset, clk, OutState, NextState, D_addr, D_wr,RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0, PC_Out, PC_clr, PC_up, IR_ld, IR_Out, data);
    ControlUnit U1(Reset, clk, State, NextState, D_Addr, D_Wr, RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0, PC_Out, IR_Out);

    //DataPath(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out);
    DataPath U2(clk, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_A, ALU_B, ALU_Out);

endmodule

//testbench

module Processor_tb();

    logic clk;                  // processor clock
    logic Reset;                // system reset
    logic [15:0] IR_Out;       // Instruction register
    logic [6:0] PC_Out;        // Program counter
    logic [3:0] State;         // FSM current state
    logic [3:0] NextState;     // FSM next state (or 0 if you don’t use one)
    logic [15:0] ALU_A;        // ALU A-Side Input
    logic [15:0] ALU_B;        // ALU B-Side Input
    logic [15:0] ALU_Out;      // ALU current output

    Processor DUT( clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);

    always begin        //clock signal
        clk = 0; #10;
        clk = 1; #10; 
    end

    initial begin
        Reset = 1; #52;
        Reset = 0; #22;
        wait (State == 9);       // Wait until the last instruction (HALT) is completed
        #62;                      // Show that Halt Worked
        $stop;
    end
    initial begin
        $monitor("Time =%0t IR_Out =%5h PC_Out =%4d State =%3d NextState =%3d ALU_A =%7d ALU_B =%7d ALU_Out =%7d", $time, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
    end
endmodule