// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a sytemverilog file made to read off all the data in the A.mif file

module Instruction_Mem(addr, Clk, Out);
  input Clk;
  output logic [15:0] Out; // 16-bit data to be read
  input [6:0] addr;


// calling on the ROM created in Quartus
  InstructionMem u1(
	.address(addr),
	.clock(Clk),
	.q(Out));
  
  
endmodule

// This testbench will check and display readings
// of data at all locations from 0 to 127
// the ROM has been initialized using A.mif
`timescale 1ns/1ns
module Instruction_Mem_tb();
 
  logic Clk;
  logic [6:0] addr;
  logic [15:0] Out;
  
  
  Instruction_Mem DUT(addr, Clk, Out);
  
  always begin
    Clk = 0; #10;
	  Clk = 1; #10;
  end

  initial begin
    addr = 0;                       // Start at address 0
		for (int k=0; k<6; k++) begin   // loop through 6 addresses
		@(posedge Clk);           
		#5 $display(k, $time, Out);     // display index, time, Output of Instuction Data
    addr = k + 1;                   // next address location
		end
      $stop;
  end  

endmodule
