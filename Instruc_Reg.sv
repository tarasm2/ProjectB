// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// Instruction register that latches onto data when a load signal is provided and outputs whatever is stored in
// that register

module Instruc_Reg (clk, data, load, out);
    
    input logic [15:0] data;    // input data
    input logic load, clk;      // load and clock signals
    output logic [15:0] out;    // instruction that is sent out to state machine

    logic [15:0] register;      // register that contains that current instruction

    assign out = register;          // connects the instruction to the output of the register

    always@(posedge clk) begin
        if(load) register <= data;      // if load is on, load thte data into the register
        else     register <= register;  // else keep the value in the register the same
    end
endmodule

module Instruc_Reg_tb();

    logic [15:0] data;    // input data
    logic load, clk;      // load and clock signals
    logic [15:0] out;     // instruction that is sent out to state machine  

    Instruc_Reg DUT(clk, data, load, out);  // instantiate Instuction Register

    always begin        // clock signal
        clk = 0; #10;
        clk = 1; #10;
    end    

    initial begin
        data = 15; load = 1; #22;       // set the data input to a value and let it be loaded into the register
        data = 0;  load = 0; #20;       // set load to 0 and data to a different value to make sure the output and register both hold the old value
                   load = 1; #20;       // set load to 1 and make sure that the new value takes over the old value in the register
        $stop;
    end
endmodule
        