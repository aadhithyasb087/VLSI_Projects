// Synchronizer: Handles control signal coordination and soft reset generation

module router_sync(
    input wire clk,
    input wire rstn,
    input wire full_0, full_1, full_2,
    input wire empty_0, empty_1, empty_2,
    input wire detect_add,
    input wire [1:0] data_in,
    input wire write_enb_reg,
    input wire read_enb_0, read_enb_1, read_enb_2,
    output reg [2:0] write_enb,
    output reg fifo_full,
    output reg vld_out_0, vld_out_1, vld_out_2,
    output reg soft_reset_0, soft_reset_1, soft_reset_2
);

    always @(*) begin
        // Default assignments
        write_enb = 3'b000;
        fifo_full = 0;
        vld_out_0 = 0;
        vld_out_1 = 0;
        vld_out_2 = 0;
        soft_reset_0 = 0;
        soft_reset_1 = 0;
        soft_reset_2 = 0;

        if (detect_add) begin
            case(data_in)
                2'b00: begin
                    fifo_full = full_0;
                    write_enb[0] = write_enb_reg;
                end
                2'b01: begin
                    fifo_full = full_1;
                    write_enb[1] = write_enb_reg;
                end
                2'b10: begin
                    fifo_full = full_2;
                    write_enb[2] = write_enb_reg;
                end
                default: fifo_full = 0;
            endcase
        end

        // Valid output flags based on empty signals
        if (!empty_0) vld_out_0 = 1;
        if (!empty_1) vld_out_1 = 1;
        if (!empty_2) vld_out_2 = 1;

        // Soft resets based on simultaneous read+empty
        if (read_enb_0 && empty_0) soft_reset_0 = 1;
        if (read_enb_1 && empty_1) soft_reset_1 = 1;
        if (read_enb_2 && empty_2) soft_reset_2 = 1;
    end

endmodule