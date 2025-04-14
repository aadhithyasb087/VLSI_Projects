// D Flip-Flop with Asynchronous Reset and Complement Output
module d_ff(
    input clk,        // Clock signal (positive edge triggered)
    input reset,      // Asynchronous reset signal (active high)
    input d,          // Data input
    output reg q,     // Flip-flop output
    output q_bar      // Complement of the output
);

    // Always block triggered on rising edge of clock
    always @(posedge clk) begin
        if (reset) begin
            // If reset is active, set output to 0
            q <= 1'b0;
        end else begin
            // Otherwise, capture the value of 'd' at clock edge
            q <= d;
        end
    end

    // Continuous assignment: q_bar is the complement of q
    assign q_bar = ~q;

endmodule
