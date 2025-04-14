// T (Toggle) Flip-Flop using D Flip-Flop
module t_flip_flop(
    input t,         // T input (Toggle control)
    input clk,       // Clock signal (positive edge triggered)
    input reset,     // Asynchronous reset (active high)
    output q,        // Output Q
    output q_bar     // Complement of Q
);

    wire w1;  // Intermediate wire to hold toggled input for D flip-flop

    // T Flip-Flop behavior using D Flip-Flop logic:
    // D = T XOR Q => when T=1, Q toggles; when T=0, Q holds
    assign w1 = t ^ q;

    // Instantiate D Flip-Flop module
    d_ff dff (
        .d(w1), 
        .clk(clk), 
        .reset(reset), 
        .q(q), 
        .q_bar(q_bar)
    );

endmodule