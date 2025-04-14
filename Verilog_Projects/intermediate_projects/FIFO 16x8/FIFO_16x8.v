module FIFO_16x8(
    input clk,              // Clock signal
    input re,               // Read enable: Read data from FIFO when asserted
    input we,               // Write enable: Write data to FIFO when asserted
    input [7:0] data_in,    // 8-bit data input to be written into FIFO
    output reg [7:0] data_out, // 8-bit data output read from FIFO
    output full,            // FIFO full flag
    output empty,           // FIFO empty flag
    input rst               // Synchronous reset
);

    // FIFO memory: 16 locations, each 8 bits wide
    reg [7:0] memory [15:0];

    // FIFO counter (5 bits): Tracks number of elements in FIFO (0 to 16)
    reg [4:0] fifo_count = 0;

    // Read and write pointers (4 bits): Index into the memory (0 to 15)
    reg [3:0] rd_ptr = 0;
    reg [3:0] wr_ptr = 0;

    // Assign 'full' when fifo_count is greater than 15 (i.e., 16 elements)
    assign full = (fifo_count > 5'b01111) ? 1 : 0;

    // Assign 'empty' when fifo_count is 0
    assign empty = (fifo_count == 5'b00000) ? 1 : 0;

    // Sequential logic: Triggered on rising edge of clock
    always @(posedge clk) begin
        if (rst) begin
            // Reset all pointers and count when reset is asserted
            fifo_count <= 5'b00000;
            rd_ptr <= 0;
            wr_ptr <= 0;
        end
        else begin
            // Read operation
            if (!empty && re) begin
                data_out <= memory[rd_ptr];   // Output the data from current read pointer
                rd_ptr <= rd_ptr + 1;         // Increment the read pointer
                fifo_count <= fifo_count - 1; // Decrement the FIFO count
            end

            // Write operation
            if (!full && we) begin
                memory[wr_ptr] <= data_in;    // Write input data at the current write pointer
                wr_ptr <= wr_ptr + 1;         // Increment the write pointer
                fifo_count <= fifo_count + 1; // Increment the FIFO count
            end
        end
    end

endmodule