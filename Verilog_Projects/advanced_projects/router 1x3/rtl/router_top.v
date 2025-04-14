// Top module for the router, integrating FSM, synchronizer, register and FIFO buffers

module router_top(
    input wire clk,
    input wire rstn,
    input wire pkt_valid,
    input wire read_enb_0,
    input wire read_enb_1,
    input wire read_enb_2,
    input wire [7:0] data_in,
    output wire [7:0] data_out_0,
    output wire [7:0] data_out_1,
    output wire [7:0] data_out_2,
    output wire valid_out_0,
    output wire valid_out_1,
    output wire valid_out_2,
    output wire err,
    output wire busy
);

    // Internal wires
    wire [2:0] write_enb;
    wire [7:0] d_out;

    wire soft_reset_0, soft_reset_1, soft_reset_2;
    wire empty_0, empty_1, empty_2;
    wire full_0, full_1, full_2;
    wire fifo_full;
    wire low_pkt_valid, parity_done, lfd_state, write_enb_reg;
    wire ld_state, laf_state, rst_int_reg, detect_add;
    wire full_state;

    // FSM: Controls the overall state of packet handling
    router_fsm fsm(
        .rstn(rstn), .clk(clk), .data_in(data_in[1:0]),
        .soft_reset_0(soft_reset_0), .soft_reset_1(soft_reset_1), .soft_reset_2(soft_reset_2),
        .fifo_full(fifo_full), .fifo_empty_0(empty_0), .fifo_empty_1(empty_1), .fifo_empty_2(empty_2),
        .pkt_valid(pkt_valid), .low_pkt_valid(low_pkt_valid), .parity_done(parity_done),
        .lfd_state(lfd_state), .write_enb_reg(write_enb_reg), .ld_state(ld_state), .laf_state(laf_state),
        .rst_int_reg(rst_int_reg), .detect_add(detect_add), .busy(busy), .full_state(full_state)
    );

    // Synchronizer: Synchronizes control logic for reading/writing and generates soft resets
    router_sync synchronizer(
        .clk(clk), .rstn(rstn), .full_0(full_0), .full_1(full_1), .full_2(full_2),
        .empty_0(empty_0), .empty_1(empty_1), .empty_2(empty_2),
        .detect_add(detect_add), .data_in(data_in[1:0]), .write_enb_reg(write_enb_reg),
        .read_enb_0(read_enb_0), .read_enb_1(read_enb_1), .read_enb_2(read_enb_2),
        .fifo_full(fifo_full), .write_enb(write_enb),
        .soft_reset_0(soft_reset_0), .soft_reset_1(soft_reset_1), .soft_reset_2(soft_reset_2),
        .vld_out_0(valid_out_0), .vld_out_1(valid_out_1), .vld_out_2(valid_out_2)
    );

    // Register: Stores incoming data, computes parity, checks errors
    router_reg register(
        .clk(clk), .rstn(rstn), .data_in(data_in), .fifo_full(fifo_full),
        .ld_state(ld_state), .laf_state(laf_state), .lfd_state(lfd_state),
        .detect_add(detect_add), .full_state(full_state), .rst_int_reg(rst_int_reg),
        .pkt_valid(pkt_valid), .err(err), .data_out(d_out),
        .parity_done(parity_done), .low_pkt_valid(low_pkt_valid)
    );

    // FIFO 0: Queue for destination 0
    router_fifo fifo_0(
        .clk(clk), .rstn(rstn), .write_enb(write_enb[0]), .read_enb(read_enb_0),
        .soft_reset(soft_reset_0), .data_in(d_out), .lfd_state(lfd_state),
        .full(full_0), .empty(empty_0), .data_out(data_out_0)
    );

    // FIFO 1: Queue for destination 1
    router_fifo fifo_1(
        .clk(clk), .rstn(rstn), .write_enb(write_enb[1]), .read_enb(read_enb_1),
        .soft_reset(soft_reset_1), .data_in(d_out), .lfd_state(lfd_state),
        .full(full_1), .empty(empty_1), .data_out(data_out_1)
    );

    // FIFO 2: Queue for destination 2
    router_fifo fifo_2(
        .clk(clk), .rstn(rstn), .write_enb(write_enb[2]), .read_enb(read_enb_2),
        .soft_reset(soft_reset_2), .data_in(d_out), .lfd_state(lfd_state),
        .full(full_2), .empty(empty_2), .data_out(data_out_2)
    );

endmodule