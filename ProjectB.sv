// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/31/2020
// ProjectB
// This is the top level module in projectB that connects all the submodules to put the information
// onto the DEII board to display the required things on specified displays. All information is decoded into HEX numbers

module ProjectB(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, KEY, LEDG, CLOCK_50);
    input CLOCK_50;                 // clock input in the board
    input [17:0] SW;                // switch input for clear bit
    input [3:0] KEY;                // KEY button inputs 
    output [17:0] LEDR;             // Red LED outputs
    output [3:0] LEDG;              // Green LED output
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;    //Hexidecimal display outputs
    logic Bo;                                                       // wire between buttonsync and keyfilter
    logic F_out;                                                    // wire from keyfilter to clock input of processor
    logic Strobe;                                                   // Strobe not connected to anything
    logic [15:0] ALU_A, ALU_B, ALU_Out, IR_Out, MUX_Out;            // 16-bit outputs of processor and output of MUX
    logic [6:0] PC_Out;                                             // 8-bit outputs of processor
    logic [3:0]NextState, CurrentState;                             // States of the processor

    assign LEDR = SW;                                                      // connecting switch inputs to red LEDs
    assign LEDG[0] = !KEY[0];                                              // connecting button inputs to green LEDs
    assign LEDG[1] = !KEY[1];                                              // connecting button inputs to green LEDs
    assign LEDG[2] = !KEY[2];                                              // connecting button inputs to green LEDs
    assign LEDG[3] = !KEY[3];                                              // connecting button inputs to green LEDs

    //ButtonSync( Clock, Bi, Bo);
    ButtonSync U1(CLOCK_50, KEY[2], Bo);                                    // instantiating buttonsync module

    //KeyFilter( Clock, In, Out, Strobe);
    KeyFilter U2(CLOCK_50, Bo, F_out, Strobe);                              // instantiating Keyfilter Module

    //Processor( clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
    Processor U3(F_out, !KEY[0], IR_Out, PC_Out, CurrentState, NextState, ALU_A, ALU_B, ALU_Out);

    //module Mux_3w_8_to_1(R, S, T, U, V, W, X, Y, M, S);
    Mux_16w_8_to_1 U4({1'b0, PC_Out, 4'b0, CurrentState}, ALU_A, ALU_B, ALU_Out, {4'b0, NextState, 8'b0}, 16'h0, 16'h0, 16'h0, MUX_Out, SW[17:15]);

    // /Decoder (data, seg);
    Decoder U5(MUX_Out[15:12], HEX7);   // Decoding all the infor being sent to the board into HEX numbers
    Decoder U6(MUX_Out[11:8],  HEX6);
    Decoder U7(MUX_Out[7:4],   HEX5);
    Decoder U8(MUX_Out[3:0],   HEX4);
    Decoder U9(IR_Out[15:12],  HEX3);
    Decoder U10(IR_Out[11:8],  HEX2);
    Decoder U11(IR_Out[7:4],   HEX1);
    Decoder U12(IR_Out[3:0],   HEX0);
endmodule






