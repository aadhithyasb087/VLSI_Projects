// Register: Buffers data, handles parity checking, error detection

module router_reg(
    input wire clk,
    input wire rstn,
    input wire [7:0] data_in,
    input wire fifo_full,
    input wire ld_state, laf_state, lfd_state,
    input wire detect_add, full_state, rst_int_reg, pkt_valid,
    output reg err,
    output reg [7:0] data_out,
    output reg parity_done, low_pkt_valid
);

    reg [7:0] header, payload_data, parity_byte, internal_parity;
    reg flag;

    always @(posedge clk) begin
        if (!rstn || detect_add || rst_int_reg) begin
            // Reset state
            header <= 0;
            payload_data <= 0;
            parity_byte <= 0;
            internal_parity <= 0;
            flag <= 0;
            err <= 0;
            data_out <= 0;
            parity_done <= 0;
            low_pkt_valid <= 0;
        end
        else begin
            // LFD state: store header
            if (lfd_state) begin
                header <= data_in;
                internal_parity <= data_in;
                data_out <= data_in;
            end
            // LD state: store payload, update parity
            else if (ld_state && !fifo_full) begin
                payload_data <= data_in;
                internal_parity <= internal_parity ^ data_in;
                data_out <= data_in;
            end
            // LAF state: handle full FIFO
            else if (laf_state && !fifo_full) begin
                data_out <= payload_data;
                flag <= 1;
            end
            // Handle parity
            if (!pkt_valid && flag) begin
                parity_byte <= data_in;
                parity_done <= 1;
                err <= (parity_byte != internal_parity);
            end
            // Handle last byte validity
            if (!pkt_valid && !fifo_full) begin
                low_pkt_valid <= 1;
                parity_done <= 1;
                parity_byte <= data_in;
                err <= (parity_byte != internal_parity);
            end
        end
    end

endmodule
