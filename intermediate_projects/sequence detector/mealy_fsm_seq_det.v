module mealy_fsm_seq_det(
    input clk,
    input rst,
    input seq_in,
    output reg out
);

    // State encoding
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010;

    reg [2:0] state, next_state;

    // State transition block (Synchronous)
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;  // Reset to initial state
        else
            state <= next_state;  // Update state
    end

    // Next state and output logic (Combinational)
    always @(*) begin
        case(state)
            S0: begin
                if (seq_in)
                    next_state = S1;  // Transition to S1 if seq_in = 1
                else
                    next_state = S0;  // Stay in S0 if seq_in = 0
                out = 1'b0;  // Output is 0 in S0
            end

            S1: begin
                if (seq_in)
                    next_state = S1;  // Stay in S1 if seq_in = 1
                else
                    next_state = S2;  // Transition to S2 if seq_in = 0
                out = 1'b0;  // Output is 0 in S1
            end

            S2: begin
                if (seq_in) begin
                    next_state = S1;  // Transition back to S1 if seq_in = 1
                    out = 1'b1;  // Output is 1 when we detect the sequence
                end else begin
                    next_state = S0;  // Return to S0 if seq_in = 0
                    out = 1'b0;  // Output is 0 in S2 when seq_in = 0
                end
            end

            default: begin
                next_state = S0;  // Default state is S0
                out = 1'b0;  // Default output is 0
            end
        endcase
    end

endmodule