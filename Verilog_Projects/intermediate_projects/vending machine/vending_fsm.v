module vending_fsm (
    input clk,
    input rst,
    input i, j,        // Coin inputs: i = ₹1, j = ₹2
    output reg x, y    // Output: x = product dispense, y = change
);

    // State encoding
    parameter nocoin = 2'b00,
              onerup = 2'b01,
              tworup = 2'b10;

    reg [1:0] state, next_state;

    // Sequential block: state update
    always @(posedge clk) begin
        if (rst)
            state <= nocoin;
        else
            state <= next_state;
    end

    // Combinational block: next state logic and output logic
    always @(*) begin
        // Default outputs
        x = 0;
        y = 0;
        case (state)
            nocoin: begin
                case ({i, j})
                    2'b00, 2'b01: next_state = nocoin;
                    2'b10:        next_state = onerup;
                    2'b11:        next_state = tworup;
                    default:      next_state = nocoin;
                endcase
            end

            onerup: begin
                case ({i, j})
                    2'b00, 2'b01: begin
                        next_state = nocoin;
                    end
                    2'b10: begin
                        next_state = tworup;
                    end
                    2'b11: begin
                        next_state = nocoin;
                        x = 1;      // Product dispensed
                        y = 0;      // No change
                    end
                endcase
            end

            tworup: begin
                case ({i, j})
                    2'b00, 2'b01: next_state = nocoin;
                    2'b10: begin
                        next_state = nocoin;
                        x = 1;
                        y = 0;  // ₹3 exactly
                    end
                    2'b11: begin
                        next_state = nocoin;
                        x = 1;
                        y = 1;  // ₹4 inserted, dispense + change
                    end
                endcase
            end

            default: begin
                next_state = nocoin;
            end
        endcase
    end

endmodule
