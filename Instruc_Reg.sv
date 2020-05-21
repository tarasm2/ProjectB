// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// decription...

module Instruc_Reg (clk, data, load, out);
    
     logic [15:0] data;         // input data
    input logic load, clk;      // load and clock signals
    output logic [15:0] out;    // instruction that is sent out to state machine

    logic [15:0] register;      // register that contains that current instruction

    assign out = data;          // connects the instruction to the output of the register

    always@(posedge clk) begin
        if(load) register <= data;      // if load is on, load thte data into the register
        else     register <= register;  // else keep the value in the register the same
    end
endmodule
                 
        