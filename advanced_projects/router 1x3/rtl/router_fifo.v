// FIFO: Handles buffering of packets per output port

module router_fifo(
    input wire clk,
    input wire rstn,
    input wire write_enb,
    input wire read_enb,
    input wire soft_reset,
    input wire [7:0] data_in,
    input wire lfd_state,
    output wire full,
    output wire empty,
    output reg [7:0] data_out
);

    reg [4:0] wr_ptr, rd_ptr, count;
    reg [8:0] mem [0:15];  // 9 bits for 8-bit data + 1 flag bit (lfd)

    assign full = (count == 16);
    assign empty = (count == 0);

    always @(posedge clk) begin
        if (!rstn || soft_reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end
        else begin
            // Write logic
            if (write_enb && !full) begin
                mem[wr_ptr] <= {lfd_state, data_in};
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            // Read logic
            if (read_enb && !empty) begin
                {lfd_state, data_out} <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end

endmodule