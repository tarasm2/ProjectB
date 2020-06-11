// TCES 330
// Testbench  for the programmable processor

`timescale 1 ns / 1 ps
module testProcessor;
 
  logic Clk;             // system clock
  logic Reset;           // system reset
  logic [15:0] IR_Out;   // instruction register
  logic [6:0] PC_Out;    // program counter
  logic [3:0] State, NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
 
  Processor DUT( Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);


  // generate 50 MHz clock
  always begin
    Clk = 0;
    #10;
    Clk = 1'b1;
    #10;
  end

initial	// Test stimulus
  begin
    $display( "\nBegin Simulation." );
    Reset = 0;         // reset for one clock
    @ ( posedge Clk ) 
    #10; Reset = 1;
    wait( IR_Out == 16'h5000 );  // halt instruction
    $display( "\nEnd of Simulation.\n" );
    $stop;
  end
  
initial begin
    $monitor( "Time is %0t : Reset = %b PC_Out = %d IR_Out =%h State = %h  ALU A = %h  ALU B = %h ALU Out = %h", $stime, Reset, PC_Out, IR_Out, State, ALU_A, ALU_B, ALU_Out );
   
end
/*initial begin
     $monitor( "Time is %0t : D_Addr = %h  D_Wr = %d  RF_s = %d  RF_W_addr = %h RF_W_en = %d RF_Ra_addr = %h RF_Rb_addr = %h ALU_s = %b", 
                $stime, DUT.I1.D_Addr, DUT.I1.D_Wr, DUT.I1.RF_s, DUT.I1.RF_W_Addr, DUT.I1.RF_W_en, DUT.I1.RF_Ra_Addr, DUT.I1.RF_Rb_Addr, DUT.I1.ALU_s );
end*/

endmodule    



                           