module clock_buffer(
    input clk_in,       // Input clock signal
    output clk_out      // Buffered output clock signal
);

// Buffer primitive: Passes clk_in to clk_out with minimal skew or delay
buf(clk_out, clk_in);

endmodule