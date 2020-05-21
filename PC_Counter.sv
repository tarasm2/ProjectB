// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// decription...

module PC_Counter(clk,up, clear, address);
    input logic up, clear, clk;       // increase counter, clock and clear signals
    output logic [6:0] address;       // output address

    always@(posedge clk) begin
        if(clear) address <= 0;                     // if clear is on, reset couner
        else if (up) address <= (address + 1);      // if up is on, increament counter
        else address <= address;                    // else stay at same count
    end

endmodule
