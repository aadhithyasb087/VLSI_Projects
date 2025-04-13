// FSM: Controls data flow between input, register, and output FIFOs

module router_fsm(
    input wire clk,
    input wire rstn,
    input wire pkt_valid,
    input wire parity_done,
    input wire low_pkt_valid,
    input wire fifo_full,
    input wire fifo_empty_0, fifo_empty_1, fifo_empty_2,
    input wire [1:0] data_in,
    input wire soft_reset_0, soft_reset_1, soft_reset_2,
    output reg lfd_state, ld_state, laf_state, full_state,
    output reg detect_add, busy, write_enb_reg,
    output reg rst_int_reg
);

    reg [2:0] state, next_state;

    parameter [2:0]
        DECODE_ADDRESS = 3'b000,
        LOAD_FIRST_DATA = 3'b001,
        LOAD_DATA = 3'b010,
        LOAD_PARITY = 3'b011,
        FIFO_FULL_STATE = 3'b100,
        LOAD_AFTER_FULL = 3'b101,
        CHECK_PARITY_ERROR = 3'b110,
        WAIT_TILL_EMPTY = 3'b111;

    // State register
    always @(posedge clk or negedge rstn) begin
        if (!rstn) state <= DECODE_ADDRESS;
        else if ((soft_reset_0 && data_in == 2'b00) ||
                 (soft_reset_1 && data_in == 2'b01) ||
                 (soft_reset_2 && data_in == 2'b10)) state <= DECODE_ADDRESS;
        else state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default
        case (state)
            DECODE_ADDRESS: if (pkt_valid) next_state = LOAD_FIRST_DATA;
            LOAD_FIRST_DATA: next_state = LOAD_DATA;
            LOAD_DATA: begin
                if (fifo_full) next_state = FIFO_FULL_STATE;
                else if (!pkt_valid) next_state = LOAD_PARITY;
            end
            FIFO_FULL_STATE: if (!fifo_full) next_state = LOAD_AFTER_FULL;
            LOAD_AFTER_FULL: next_state = LOAD_PARITY;
            LOAD_PARITY: next_state = CHECK_PARITY_ERROR;
            CHECK_PARITY_ERROR: next_state = DECODE_ADDRESS;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values
        lfd_state = 0; ld_state = 0; laf_state = 0; full_state = 0;
        detect_add = 0; busy = 1; write_enb_reg = 0; rst_int_reg = 0;

        case (state)
            DECODE_ADDRESS: begin
                detect_add = 1;
                busy = 0;
            end
            LOAD_FIRST_DATA: begin
                lfd_state = 1;
                write_enb_reg = 1;
            end
            LOAD_DATA: begin
                ld_state = 1;
                write_enb_reg = 1;
            end
            FIFO_FULL_STATE: full_state = 1;
            LOAD_AFTER_FULL: begin
                laf_state = 1;
                write_enb_reg = 1;
            end
            LOAD_PARITY: write_enb_reg = 1;
            CHECK_PARITY_ERROR: begin
                busy = 0;
                rst_int_reg = 1;
            end
        endcase
    end

endmodule