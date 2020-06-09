// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// Program counter that increments as the next instruction is fetched. When an high input signal is given (by the state machine) to count up the 
// counter should count up by one and sent that number (8 bit binary) as the output. This output is used to acces the next address location in the 
// instruction memory 

module PC_Counter(clk, up, clear, address);
    input logic up, clear, clk;       // increase counter, clock and clear signals
    output logic [6:0] address;       // output address

    always@(posedge clk) begin
        if(clear) address <= 0;                     // if clear is on, reset couner
        else if (up) address <= (address + 1'b1);      // if up is on, increament counter
        else address <= address;                       // else stay at same count
    end

endmodule

//testbench
module PC_Counter_tb();
    logic up, clear, clk;       // increase counter, clock and clear signals
    logic [6:0] address;        // output address

    PC_Counter U1(clk, up, clear, address);

    always begin        // clock signal
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        clear = 1; up = 0; #22;         // reset the counter
        clear = 0; up = 1; #22;         // start counting up
        wait(address == 0); #82;        // wait one full cycle and a bit longer to see it loop around
        clear = 1;         #22;         // make sure counter resets
        $stop;
    end

    initial
        $monitor($time,,,clear,,,up,,,address);
        
endmodule