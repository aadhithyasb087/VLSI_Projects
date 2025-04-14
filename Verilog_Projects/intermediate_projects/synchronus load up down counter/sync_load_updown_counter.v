//======================================================================
// Module: sync_load_updown_counter
// Description:
//   A 4-bit synchronous up/down counter with synchronous reset and load.
//
// Features:
//   - Counts up or down based on `updown` input.
//   - Wraps from 15 → 0 (up) and 0 → 15 (down).
//   - Can synchronously load a custom value (d_in).
//   - Synchronous reset sets counter to 0.
//======================================================================

module sync_load_updown_counter(
    input [3:0] d_in,      // Data input to load into the counter
    input clk,             // Clock signal (active on rising edge)
    input rst,             // Synchronous reset (active high)
    input load,            // Load signal (active high)
    input updown,          // Up/Down control (1 = up, 0 = down)
    output reg [3:0] count // 4-bit counter output
);

    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset: set counter to 0
            count <= 4'b0000;
        end
        else if (load) begin
            // Load a new value into the counter
            count <= d_in;
        end
        else begin
            case (updown)
                1'b0: begin // Count down
                    if (count == 4'b0000)
                        count <= 4'b1111; // Wrap from 0 to 15
                    else
                        count <= count - 1;
                end
                1'b1: begin // Count up
                    if (count == 4'b1111)
                        count <= 4'b0000; // Wrap from 15 to 0
                    else
                        count <= count + 1;
                end
            endcase
        end
    end

endmodule