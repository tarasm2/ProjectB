// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// MUX...

module Mux_16_2(rData, aluData, wData, S);
    input S;
    input [15:0] rData, aluData;
    output [15:0] wData;

    assign wData = S ? rData : aluData;

endmodule