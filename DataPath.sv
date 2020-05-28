// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/27/2020
// ProjectB
// Datapath module that combines all the submodules within the datapath portion of the Processor. Takes all the inputs from the State Machine and
// and uses them, along with pre-stored values in Data memory to work, Run on a positive edge triggered clock signal.

`timescale 1 ps / 1 ps

module DataPath(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out, r_data, wData);
    input logic clk, RegF_W_en, MuxS, D_WriteEn;                          // clock signal, enable and select bits
    input logic [2:0] ALU_S;                                              // ALU select bit
    input logic [3:0] RegF_W_addr, RegF_Ra_addr, RegF_Rb_addr;    // all the address locations being sent into the datapath
    output logic [15:0] ALU_A, ALU_B, ALU_Out;
    input logic [7:0] D_Addr;

    output logic [15:0] r_data, wData;  // logic within the DataPath

    //DataMemory (	address, clock, data, wren, q);
    DataMem U1(D_Addr, clk, ALU_A, D_WriteEn, r_data);          // instantiating the DataMemory
 
    //module Mux_16_2(rData, aluData, wData, S);
    Mux_16_2 U2(r_data, ALU_Out, wData, MuxS);                      // instantiating the Mux

    //RegisterFile(clk, writeEn, wrAddr, wrData, rdAddrA, rdAddrB, rdDataB, rdDataA)
    RegisterFile U3(clk, RegF_W_en, RegF_W_addr, wData, RegF_Ra_addr, RegF_Rb_addr, ALU_B, ALU_A);  // instantiating the RegisterFile

    //module ALU( A, B, Sel, Q );
    ALU U4( ALU_A, ALU_B, ALU_S, ALU_Out );                     // instantiating the ALU
endmodule


// testbench
// Comes with some prestored values in Data Memory (1 in idex 1, 2 in index 2, etc. up to 4)
// and executes all the possible instructions with this data. Accounts for registered Data Memory by loading in data for two clock cycles


module DataPath_tb();
    logic clk, RegF_W_en, MuxS, D_WriteEn;                          // clock signal, enable and select bits
    logic [2:0] ALU_S;                                              // ALU select bit
    logic [3:0] RegF_W_addr, RegF_Ra_addr, RegF_Rb_addr;    // all the address locations being sent into the datapath
    logic [15:0] ALU_A, ALU_B, ALU_Out;
    logic [7:0] D_Addr;

    logic [15:0] r_data, wData;  // logic within the DataPath

    DataPath DUT(clk, D_Addr, D_WriteEn, MuxS, RegF_W_addr, RegF_W_en, RegF_Ra_addr, RegF_Rb_addr, ALU_S, ALU_A, ALU_B, ALU_Out, r_data, wData);

    always begin        //clock signal
        clk = 0; #10;
        clk = 1; #10; 
    end

    initial begin
        @(posedge clk); D_WriteEn = 0;
        D_Addr = 0; MuxS = 1; RegF_W_addr = 0; RegF_W_en = 1;                     // load data memory [1] into RF[1]
        @(posedge clk); D_Addr = 1;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(posedge clk); D_WriteEn = 0;
        D_Addr = 1; MuxS = 1; RegF_W_addr = 1; RegF_W_en = 1;                     // load data memory [1] into RF[1]
        @(posedge clk); D_Addr = 2;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(posedge clk);
        D_Addr = 2; MuxS = 1; RegF_W_addr = 2; RegF_W_en = 1;                     // load data memory [2] into RF[2]
        @(posedge clk); D_Addr = 3;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(posedge clk);
        D_Addr = 3; MuxS = 1; RegF_W_addr = 3; RegF_W_en = 1;                     // load data memory [3] into RF[3]
        @(posedge clk); D_Addr = 4;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(posedge clk);
        D_Addr = 4; MuxS = 1; RegF_W_addr = 4; RegF_W_en = 1;                     // load data memory [4] into RF[4]
        @(posedge clk); 
        @(posedge clk)
        RegF_W_addr = 5; RegF_Ra_addr = 1; RegF_Rb_addr = 2; ALU_S = 1; MuxS = 0; // add the data in RF[1] and RF[2] and store into RF[5]
        @(posedge clk);
        RegF_W_addr = 6; RegF_Ra_addr = 4; RegF_Rb_addr = 2; ALU_S = 2; MuxS = 0; // subrtact the data in RF[2] from RF[4] and store into RF[6]
        @(posedge clk); RegF_W_en = 0;
        D_Addr = 5; RegF_Ra_addr = 5; D_WriteEn = 1;                              // store RF[5] into dataMem[5]
        @(posedge clk);
        D_Addr = 6; RegF_Ra_addr  = 6; D_WriteEn = 1;                             // store RF[5] into dataMem[5]. Output of Reg_File (ALU_A) holds this value
        @(posedge clk);                                                           // show that r_data hold value stored earlier  
        @(posedge clk);                                                           // show that r_data hold value stored earlier  
        $stop;
    end

    initial begin
        $monitor("Time =%4d R_data =%16b W_data =%16b ALU_A=%16b ALU_B =%16b ALU_Out = %16b ALU_S =%3b D_WriteEn =%1b RegF_W_addr =%4b, MuxS =%1b D_Addr =%7b", $time, r_data, wData, ALU_A, ALU_B, ALU_Out, ALU_S, D_WriteEn, RegF_W_addr, MuxS, D_Addr);
    end
endmodule