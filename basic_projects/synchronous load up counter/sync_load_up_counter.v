// 4-bit Synchronous Loadable Up Counter
module sync_load_up_counter(
    input [3:0] d_in,   // Parallel data input for loading
    input clk,          // Clock signal (positive edge triggered)
    input rst,          // Synchronous reset (active high)
    input load,         // Synchronous load control (active high)
    output reg [3:0] count // 4-bit counter output
);

    // Always block triggered on rising edge of clock
    always @(posedge clk) begin
        if (rst)
            // Reset the counter to 0 when reset is active
            count <= 4'b0000;
        else if (load)
            // Load the input value when load is active
            count <= d_in;
        else
            // Otherwise, increment the counter
            count <= count + 1;
    end

endmodule