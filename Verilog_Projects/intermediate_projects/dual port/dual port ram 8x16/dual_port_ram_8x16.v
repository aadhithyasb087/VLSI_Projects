module dual_port_ram_8x16 (
    input wire clk,                   // Clock input
    input wire [2:0] wr_addr,        // 3-bit write address (0–7)
    input wire [2:0] rd_addr,        // 3-bit read address (0–7)
    input wire [15:0] d_in,          // 16-bit data input
    input wire we,                   // Write enable
    input wire re,                   // Read enable
    input wire rst,                  // Synchronous reset
    output wire [15:0] d_out         // 16-bit data output
);

    // Instantiate 16-bit wide, 8-depth, 3-bit address dual-port RAM
    dual_port_ram_16x8 #(
        .width(16),                  // 16-bit word
        .depth(8),                   // 8 entries
        .addr_bus(3)                 // 3-bit address
    ) ram_inst (
        .d_in(d_in),                 // Connect 16-bit data input
        .wr_addr(wr_addr),          // Write address
        .rd_addr(rd_addr),          // Read address
        .clk(clk),                  // Clock
        .re(re),                    // Read enable
        .we(we),                    // Write enable
        .rst(rst),                  // Reset
        .d_out(d_out)               // 16-bit data output
    );

endmodule