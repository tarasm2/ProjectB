`timescale 1 ps / 1 ps
module ControlUnit_1(clk, data, IR_ld, addr, PC_up, PC_clr, IR_Out);
    input logic    clk, PC_clr, PC_up, IR_ld;   // Inputs from state machine
    output logic [15:0] IR_Out;                 // Output to state machine
    output logic [15:0] data;                   // data from Memory to IR
    output logic  [6:0]  addr;                   // address from PC to memory

    //InstMemory (address, clock,	q);
    Instruction_Mem U1(addr, clk, data);

    //Instruc_Reg (clk, data, load, out);
    Instruc_Reg U4(clk, data, IR_ld, IR_Out);

    //PC_Counter(clk, up, clear, address);
    PC_Counter U3(clk, PC_up, PC_clr, addr);

endmodule

//testbench
module ControlUnit_1_tb();
    
    logic          clk, PC_clr, PC_up, IR_ld;   // Inputs from state machine
    logic        [15:0] IR_Out;                 // Output to state machine
    logic        [15:0] data;                   // data from Memory to IR
    logic        [6:0]  addr;                   // address from PC to memory

    ControlUnit_1 DUT(clk, data, IR_ld, addr, PC_up, PC_clr, IR_Out);

    always begin        //clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        PC_clr = 1; IR_ld = 1; PC_up = 0; #52;             // clear out the counter and turn on the IR_load
        PC_clr = 0;            PC_up = 1;                  // turn of the counter reset
        for (int k=0; k<7; k++) begin                      // for loop to go through the 6 instructions in memory
		@(posedge clk);                     
		#2 $display(k, $time,,, data,,,, IR_Out);    // display k=(which index of memory), time, data (coming out of memory), IR_Out (data coming from Instruction Reg)
		end
        $display("///////////////////////////////////////////////////////////////");
        $display("               With IR_load turned off:");
        IR_ld = 0; #22; 
        for (int k=0; k<6; k++) begin
		@(posedge clk); 
		#2 $display(k, $time,,,, data,,,, IR_Out);
		end
      $stop;
  end   
endmodule

