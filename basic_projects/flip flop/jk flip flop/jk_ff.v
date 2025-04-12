// JK Flip-Flop with Asynchronous Reset and Complement Output
module jk_flip_flop(
    input j,         // J input
    input k,         // K input
    input clk,       // Clock signal (positive edge triggered)
    input reset,     // Asynchronous reset (active high)
    output reg q,    // Output Q
    output q_bar     // Complement of Q
);

    // State encoding using parameters
    parameter HOLD   = 2'b00;  // No change
    parameter RESET  = 2'b01;  // Reset (Q = 0)
    parameter SET    = 2'b10;  // Set (Q = 1)
    parameter TOGGLE = 2'b11;  // Toggle Q

    // On positive clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Asynchronous reset
            q <= 1'b0;
        end else begin
            // Determine next state based on J and K
            case ({j, k})
                HOLD:   q <= q;      // Hold current state
                RESET:  q <= 1'b0;   // Reset
                SET:    q <= 1'b1;   // Set
                TOGGLE: q <= ~q;     // Toggle
                default: q <= 1'b0;  // (Optional) Safe default
            endcase
        end
    end

    // Complement of Q
    assign q_bar = ~q;

endmodule
