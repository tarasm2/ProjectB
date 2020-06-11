// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// This is a Verilog description for an 256 x 16 register file

module Instruc_Mem(Clk, Reset, Out);
  input Clk, Reset;
  output [15:0] Out; // 7-bit data to be read
  
  logic [6:0]addr = 7'd0;
  
  // using IP Catalog On Chip Memory module
  // 1-port ROM, output registered one clock
  // instance name u1
  InstructionMem u1(
	.address(addr),
	.clock(Clk),
	.q(Out));
	
  always_ff @(posedge Clk) begin
	 if (Reset)  // active high reset
			addr <= 7'd0;
	 else if (addr != 7'd127) 
	       addr <= addr + 1;
         else
			 addr <= 7'd0;
  end
  
  

endmodule

// This testbench will check and display readings
// of data at all locations from 0 to 127
// the ROM has been initialized using myData.mif
// the ROM has the output Dout registered for 1 clock cycle 
// (when do the IP catalog wizerd, you have the option 
// to register or not register the output)
`timescale 1ns/1ns
module Instruc_Mem_tb();
 
  logic Clk, Reset;
  logic [15:0] Dout;
  
  
  Instruc_Mem DUT(Clk, Reset, Dout);
  
  always begin
    Clk = 0; #10;
	 Clk = 1; #10;
  end

  initial begin
      Reset = 1; // assert reset
      #53;
      Reset = 0; // disassert reset
		for (int k=0; k<127; k++) begin
		@(posedge Clk); 
		#5 $display(k, $time, Dout);
		end
      $stop;
  end  

endmodule
