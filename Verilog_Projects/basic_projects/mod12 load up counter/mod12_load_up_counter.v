//===============================================================
// Module: mod12_load_up_counter
// Description:
//   A 4-bit mod-12 (0 to 11) up counter with synchronous load and reset.
//
// Features:
//   - Synchronous counting on rising edge of clock
//   - Synchronous active-high reset: sets counter to 0
//   - Synchronous load: loads input value if it's less than 12 (i.e., d_in < 12)
//   - Automatically rolls over to 0 after reaching 11 (decimal)
//===============================================================

module mod12_load_up_counter(
    input [3:0] d_in,         // 4-bit data input to load into counter
    input clk,                // Clock input
    input rst,                // Active-high synchronous reset
    input load,               // Load enable (active-high)
    output reg [3:0] count    // 4-bit counter output
);

    always @(posedge clk) begin
        if (rst) begin
            // Reset the counter to 0
            count <= 4'b0000;
        end
        else if (count == 4'b1011) begin
            // If count reaches 11 (decimal), roll over to 0
            count <= 4'b0000;
        end
        else if (load) begin
            // If load is high, check if d_in is a valid value (less than 12)
            if (d_in >= 4'b1100) begin
                // If d_in is 12 or more, ignore the load
                count <= count;
            end else begin
                // Load the value of d_in
                count <= d_in;
            end
        end
        else begin
            // Normal counting operation
            count <= count + 1;
        end
    end

endmodule