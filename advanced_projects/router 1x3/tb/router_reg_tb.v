`timescale 1ns / 1ps

module router_reg_tb;

  // Inputs
  reg clk;
  reg resetn;
  reg detect_add;
  reg ld_state, laf_state, full_state, empty_state, write_enb_reg;
  reg pkt_valid;
  reg rst_int_reg;

  // Outputs
  wire busy;

  // Instantiate the router_reg module
  router_reg uut (
    .clk(clk),
    .resetn(resetn),
    .detect_add(detect_add),
    .ld_state(ld_state),
    .laf_state(laf_state),
    .full_state(full_state),
    .empty_state(empty_state),
    .write_enb_reg(write_enb_reg),
    .pkt_valid(pkt_valid),
    .rst_int_reg(rst_int_reg),
    .busy(busy)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("===== router_reg Testbench =====");
    // Initial values
    resetn = 0;
    detect_add = 0;
    ld_state = 0;
    laf_state = 0;
    full_state = 0;
    empty_state = 0;
    write_enb_reg = 0;
    pkt_valid = 0;
    rst_int_reg = 0;

    // Reset logic
    #10 resetn = 1;
    $display("[INFO] Reset de-asserted");

    // Case 1: detect_add = 1 => busy should be 1
    @(negedge clk);
    detect_add = 1;
    #10 $display("[TEST] detect_add=1 => busy=%b", busy);

    // Case 2: ld_state = 1 => busy = 1
    @(negedge clk);
    detect_add = 0; ld_state = 1;
    #10 $display("[TEST] ld_state=1 => busy=%b", busy);

    // Case 3: laf_state = 1, full=1, pkt_valid=1 => busy = 1
    @(negedge clk);
    ld_state = 0; laf_state = 1; full_state = 1; pkt_valid = 1;
    #10 $display("[TEST] laf_state & full & pkt_valid => busy=%b", busy);

    // Case 4: laf=1, full=1, pkt_valid=0 => busy = 0
    @(negedge clk);
    pkt_valid = 0;
    #10 $display("[TEST] pkt_valid=0 => busy=%b", busy);

    // Case 5: laf=1, full=0 => busy = 1
    @(negedge clk);
    full_state = 0;
    #10 $display("[TEST] full=0 => busy=%b", busy);

    // Case 6: empty=1, write_enb=1 => busy = 1
    @(negedge clk);
    laf_state = 0; empty_state = 1; write_enb_reg = 1;
    #10 $display("[TEST] empty & write_enb => busy=%b", busy);

    // Case 7: rst_int_reg = 1 => busy = 1
    @(negedge clk);
    rst_int_reg = 1;
    #10 $display("[TEST] rst_int_reg => busy=%b", busy);

    #20 $finish;
  end

endmodule