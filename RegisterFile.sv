// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a Verilog description for an 256 x 16 register file

module RegisterFile
    (input logic clk,                     // system clock
    input logic writeEn,                  // write enable
    input logic [3:0]  wrAddr,            // write address
    input logic [15:0] wrData,            // write data
    input logic [3:0] rdAddrA,            // A-side read address
    input logic [3:0] rdAddrB,            // B-side read address
    output logic [15:0] rdDataB,          // B-sdie read data
    output logic [15:0] rdDataA);         // A-side read data

    logic [15:0] regfile [0:15];    // the registers (16 X 16)

    // read the registers
    assign rdDataA = regfile[rdAddrA];      // read dataA (copied to rdDataA)
    assign rdDataB = regfile[rdAddrB];      // read dataA (copied to rdDataA)

    always @(posedge clk) begin
    if (writeEn) regfile[wrAddr] <= wrData; // if write is enabled, write wrData to wrAddr
    end
endmodule

module RegisterFile_tb();
    logic [3:0] wrAddr, rdAddrA, rdAddrB;
    logic [15:0] wrData, rdDataB, rdDataA;
    logic clk, writeEn;

RegisterFile DUT(clk, writeEn, wrAddr, wrData, rdAddrA, rdAddrB, rdDataB, rdDataA);     // instantiate the RegisterFile module

    //clock signal
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        @(negedge clk) writeEn = 1; wrAddr = 0; wrData = 1;                             // on first negative edge, setup system to write 1 to first address in reg file
        @(negedge clk)              wrAddr = 1; wrData = 7;                             // on second negative edge, write a 7 to the second address in the register
        @(negedge clk) writeEn = 0;                         rdAddrA = 0; rdAddrB = 1;   // read the first and second registers to outbut A and B, respectivly
        @(negedge clk) writeEn = 1; wrAddr = 0; wrData = 5;                             // overwrite the data in the first register
        @(negedge clk) writeEn = 0;                         rdAddrA = 0; rdAddrB = 1;   // read the first and second registers to outbut A and B, respectivly to check if it was overwritten
        #22                                                                             // let last instruction execute 
        $stop;
    end

    initial begin
        $monitor("Time =%4d A =%16b B =%16b", $time, rdDataA, rdDataB);
    end
endmodule

