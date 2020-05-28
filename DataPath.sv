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
        #52;
        @(negedge clk); D_WriteEn = 0;
        D_Addr = 11; MuxS = 1; RegF_W_addr = 1; RegF_W_en = 1;                    // load data memory [11] into RF[1]
        @(negedge clk); D_Addr = 27;                                              // start loading in the next register (accounts for registered Data Mem)  
        @(negedge clk); D_WriteEn = 0;
        D_Addr = 27; MuxS = 1; RegF_W_addr = 2; RegF_W_en = 1;                    // load data memory [27] into RF[2]
        @(negedge clk); D_Addr = 6;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(negedge clk);
        D_Addr = 6; MuxS = 1; RegF_W_addr = 3; RegF_W_en = 1;                     // load data memory [6] into RF[3]
        @(negedge clk); D_Addr = 138;                                             // start loading in the next register (accounts for registered Data Mem)  
        @(negedge clk);
        D_Addr = 138; MuxS = 1; RegF_W_addr = 4; RegF_W_en = 1;                   // load data memory [138] into RF[4]
        @(negedge clk); D_Addr = 138;                                               // start loading in the next register (accounts for registered Data Mem)  
        @(negedge clk);
        @(negedge clk)                                                            // wait another clock cycle to make sure the last register is loaded into  
        RegF_W_addr = 5; RegF_Ra_addr = 1; RegF_Rb_addr = 4; ALU_S = 2; MuxS = 0; // subrtact the data in RF[2] from RF[1] and store into RF[5]
        @(negedge clk);
        RegF_W_addr = 6; RegF_Ra_addr = 3; RegF_Rb_addr = 2; ALU_S = 2; MuxS = 0; // subrtact the data in RF[4] from RF[3] and store into RF[6]
        @(negedge clk);
        RegF_W_addr = 0; RegF_Ra_addr = 5; RegF_Rb_addr = 6; ALU_S = 1; MuxS = 0; // add the data in RF[5] and RF[6] and store into RF[0]
        @(negedge clk); RegF_W_en = 0;                                            // no longer want to write to register, want to read from it, so we turn off RegF_W_en
        D_Addr = 205; RegF_Ra_addr = 0; D_WriteEn = 1;                            // store RF[5] into dataMem[5]
        #42;                                                                      // show that dataMem 6 is written to
        $stop;
    end

    initial begin
        $monitor("Time =%4d R_data =%16d W_data =%16d ALU_A=%16d ALU_B =%16d ALU_Out = %16d ALU_S =%3b D_WriteEn =%1b RegF_W_addr =%4d, MuxS =%1b D_Addr=%7d", $time, r_data, wData, ALU_A, ALU_B, ALU_Out, ALU_S, D_WriteEn, RegF_W_addr, MuxS, D_Addr);
    end
endmodule