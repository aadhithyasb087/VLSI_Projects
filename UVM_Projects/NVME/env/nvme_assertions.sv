module nvme_assertions (
  input logic clk,
  input logic rst_n,
  input logic cmd_valid,
  input logic cmd_ready,
  input logic cpl_valid,
  input logic cpl_ready,
  input logic db_write,
  input logic [31:0] db_addr,
  input logic [31:0] db_data
);

  // ----------------------------------------
  // 1. Handshake rules
  // ----------------------------------------
  property p_cmd_handshake;
    @(posedge clk) disable iff (!rst_n)
      cmd_valid |-> ##1 cmd_ready;
  endproperty
  assert property (p_cmd_handshake)
    else `uvm_error("ASSERT", "Command valid not acknowledged by ready next cycle")

  property p_cpl_handshake;
    @(posedge clk) disable iff (!rst_n)
      cpl_valid |-> ##[0:2] cpl_ready;
  endproperty
  assert property (p_cpl_handshake)
    else `uvm_error("ASSERT", "Completion valid not acknowledged within 2 cycles")

  // ----------------------------------------
  // 2. Doorbell pulse must be one clock cycle
  // ----------------------------------------
  property p_db_one_pulse;
    @(posedge clk) disable iff (!rst_n)
      db_write |-> ##1 !db_write;
  endproperty
  assert property (p_db_one_pulse)
    else `uvm_error("ASSERT", "Doorbell write held for more than one cycle")

  // ----------------------------------------
  // 3. Command completion timing
  // Every accepted cmd must see completion within 200 cycles
  // ----------------------------------------
  property p_cmd_to_cpl;
    @(posedge clk) disable iff (!rst_n)
      (cmd_valid && cmd_ready) |-> ##[1:200] cpl_valid;
  endproperty
  assert property (p_cmd_to_cpl)
    else `uvm_error("ASSERT", "Command did not complete within 200 cycles")

  // ----------------------------------------
  // 4. Doorbell write sanity (address ranges)
  // ----------------------------------------
  property p_db_addr_range;
    @(posedge clk) disable iff (!rst_n)
      db_write |-> (db_addr inside {[32'h00000100:32'h000002FF]});
  endproperty
  assert property (p_db_addr_range)
    else `uvm_error("ASSERT", $sformatf("Invalid doorbell addr 0x%0h", db_addr))


endmodule

