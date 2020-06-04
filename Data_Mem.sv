// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/27/2020
// ProjectB
// This is a sytemverilog file made to read off all the data in the D.mif file

module Data_Mem(addr, Clk, Out, D_wr, data);
  input Clk, D_wr;
  input logic [15:0] data;
  output logic [15:0] Out; // 16-bit data to be read
  input logic [7:0] addr;


// calling on the ROM created in Quartus
  DataMem u1(
	.address(addr),
	.clock(Clk),
	.q(Out),
  .wren(D_wr),
  .data(data));
  
  
endmodule

// This testbench will check and display readings
// of data at all locations from 0 to 127
// the RAM has been initialized using A.mif
`timescale 1ns/1ns
module Data_Mem_tb();
 
  logic Clk, D_wr;
  logic [7:0] addr;
  logic [15:0] Out, data;
  
  
  Data_Mem DUT(addr, Clk, Out, D_wr, data);
  
  always begin  // clock signal
  Clk = 0; #10;
	Clk = 1; #10;
  end

  initial begin
    addr = 0; D_wr = 0;                         // Start at address 0
		for (int k=0; k<255; k++) begin              // loop through first 10 addresses
		@(posedge Clk);           
		#5 $display(k, $time, data,,,,, Out);       // display index, time, Output of Data Memory
    addr = k + 1;                               // next address location
		end
    $stop;
  end  
endmodule
