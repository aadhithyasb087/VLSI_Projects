module dual_port_ram_16x8 #(
    parameter width = 8,              // Data width (default 8 bits)
    parameter depth = 16,             // Memory depth (default 16 entries)
    parameter addr_bus = 4            // Address bus width (log2(depth) = 4 for 16 locations)
)(
    input [addr_bus-1:0] wr_addr,     // Write address
    input [addr_bus-1:0] rd_addr,     // Read address
    input [width-1:0] d_in,           // Data input for write
    input clk,                        // Clock
    input re,                         // Read enable
    input we,                         // Write enable
    input rst,                        // Synchronous reset
    output reg [width-1:0] d_out      // Data output for read
);

    // Declare memory array
    reg [width-1:0] memory [depth-1:0];
    integer i;

    // Synchronous logic
    always @(posedge clk) begin
        if (rst) begin
            // On reset, clear output and all memory locations
            d_out <= 0;
            for (i = 0; i < depth; i = i + 1)
                memory[i] <= 0;
        end
        else if (we) begin
            // Write operation (write takes priority over read)
            memory[wr_addr] <= d_in;
        end
        else if (re) begin
            // Read operation
            d_out <= memory[rd_addr];
        end
    end

endmodule