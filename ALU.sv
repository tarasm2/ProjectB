// TCES 330, Spring 2020
// Taras Martynyuk, Ben Mulyarchuk, Kevin Nguyen
// 5/20/2020
// ProjectB
// ALU mdule...


module ALU( A, B, Sel, Q );
    input [2:0] Sel;        // function select
    input [15:0] A, B;      // input data
    output [15:0] Q;        // ALU output (result)

    always_comb
        case(Sel)
            0: Q = 0;           // if s == 0 the output is 0
            1: Q = (A + B);     // if s == 1 the output is A + B
            2: Q = (A - B);     // if s == 2 the output is A – B
            3: Q =  A;          // if s == 3 the output is A (pass-through)
            4: Q = (A ^ B);     // if s == 4 the output is A ^ B
            5: Q = (A | B);     // if s == 5 the output is A | B
            6: Q = (A & B);     // if s == 6 the output is A & B
            7: Q = (A + 1);     // if s == 7 the output is A + 1
            default: Q = 0;     // default to Q = 0;
        endcase
endmodule
