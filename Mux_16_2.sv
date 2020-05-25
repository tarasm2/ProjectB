// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// MUX File that selects one of two 16 bit inputs as its output

module Mux_16_2(rData, aluData, wData, S);
    input  logic S;                         // Select Bit
    input  logic [15:0] rData, aluData;     // two options being selected between
    output logic [15:0] wData;              // output

    assign wData = S ? rData : aluData;

endmodule

module Mux_16_2_tb();

    logic S;                         // Select Bit
    logic [15:0] rData, aluData;     // two options being selected between
    logic [15:0] wData;              // output

    Mux_16_2 DUT(rData, aluData, wData, S); // instantiating the MUX

    initial begin
        rData = 7; aluData = 15;        // set inputs to be whatever values we want
        S = 1; #22;                     // set select to 1 to make sure it chooses the correct input
        S = 0; #20;                     // set select to 0 to make sure it chooses the other input
        rData = 1; aluData = 0;         // test again with other values
        S = 1; #22;
        S = 0; #20;
    end
endmodule