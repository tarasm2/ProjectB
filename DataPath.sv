// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// decription...

module DataPath(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out);
    input logic clk, RegF_W_en, MuxS, D_WriteEn;                          // clock signal, enable and select bits
    input logic [2:0] ALU_S;                                              // ALU select bit
    input logic [3:0] D_Addr, RegF_W_addr, RegF_Ra_addr, RegF_Rb_addr;    // all the address locations being sent into the datapath
    output logic [15:0] ALU_A, ALU_B, ALU_Out;

    logic [15:0] w_data, r_data, wData;  // logic within the DataPath

    //DataMemory (	address, clock, data, wren, q);
    DataMemory U1(D_Addr, clk, w_data, D_WriteEn, r_data);          // instantiating the DataMemory
 

    //module Mux_16_2(rData, aluData, wData, S);
    Mux_16_2 U2(r_data, ALU_Out, wData, MuxS);                      // instantiating the Mux

    //RegisterFile(clk, writeEn, wrAddr, wrData, rdAddrA, rdAddrB, rdDataB, rdDataA)
    RegisterFile U3(clk, RegF_W_en, RegF_W_addr, wData, RegF_Ra_addr, RegF_Rb_addr, ALU_B, ALU_A);  // instantiating the RegisterFile

    //module ALU( A, B, Sel, Q );
    ALU U4( ALU_A, ALU_B, ALU_S, ALU_Out );                     // instantiating the ALU
endmodule

module DataPath_tb();
    logic clk, RegF_W_en, MuxS, D_WriteEn;                          // clock signal, enable and select bits
    logic [2:0] ALU_S;                                              // ALU select bit
    logic [3:0] D_Addr, RegF_W_addr, RegF_Ra_addr, RegF_Rb_addr;    // all the address locations being sent into the datapath
    logic [15:0] ALU_A, ALU_B, ALU_Out;

    DataPath DUT(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out);

    always begin        //clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        // load data into Reg File
    end