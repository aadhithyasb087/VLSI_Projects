module router_fsm_tb();

  // Inputs
  reg clk, rstn, pkt_valid, parity_done, low_pkt_valid;
  reg [1:0] data_in;

  // Outputs
  wire busy;
  wire detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg;

  // DUT Instance
  router_fsm FSM (
    .clk(clk),
    .rstn(rstn),
    .pkt_valid(pkt_valid),
    .parity_done(parity_done),
    .low_pkt_valid(low_pkt_valid),
    .data_in(data_in),
    .busy(busy),
    .detect_add(detect_add),
    .ld_state(ld_state),
    .laf_state(laf_state),
    .full_state(full_state),
    .lfd_state(lfd_state),
    .rst_int_reg(rst_int_reg)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset task
  task apply_reset;
  begin
    $display("[%0t] Applying Reset...", $time);
    rstn = 0;
    pkt_valid = 0;
    parity_done = 0;
    low_pkt_valid = 0;
    data_in = 2'b00;
    #10;
    rstn = 1;
    $display("[%0t] Reset Released", $time);
  end
  endtask

  // Send Packet Task
  task send_packet;
    input [1:0] header;
  begin
    @(negedge clk);
    data_in = header;
    pkt_valid = 1;
    $display("[%0t] Sending Packet Header: %b", $time, header);

    @(negedge clk);
    pkt_valid = 0;
    $display("[%0t] Header Sent", $time);
  end
  endtask

  // Parity Done Task
  task complete_parity;
  begin
    @(negedge clk);
    parity_done = 1;
    $display("[%0t] Parity Done Triggered", $time);
    @(negedge clk);
    parity_done = 0;
  end
  endtask

  // Low Packet Task
  task send_low_packet;
  begin
    @(negedge clk);
    low_pkt_valid = 1;
    $display("[%0t] Low Packet Valid Triggered", $time);
    @(negedge clk);
    low_pkt_valid = 0;
  end
  endtask

  // Test Sequence
  initial begin
    apply_reset;

    #10;
    send_packet(2'b01); // Send a packet header
    #20;

    complete_parity;    // Signal parity check completion
    #10;

    send_low_packet;    // Simulate low_pkt_valid scenario
    #30;

    $display("[%0t] FSM Test Complete", $time);
    $finish;
  end

endmodule