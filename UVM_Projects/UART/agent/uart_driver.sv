// uart_driver.sv
// UART Driver for UVM Testbench

class uart_driver extends uvm_driver #(uart_xtn);

  `uvm_component_utils(uart_driver)

  uart_xtn xtn;                         // Transaction handle
  virtual uart_if vif;                 // Virtual interface

  //==================================================
  // Constructor
  //==================================================
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  //==================================================
  // Build Phase
  //==================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create transaction object
    xtn = uart_xtn::type_id::create("xtn");

    // Get virtual interface from configuration DB
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Unable to access Interface");
  endfunction

  //==================================================
  // Run Phase
  //==================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    reset_dut(); // Apply reset at start

    forever begin
      seq_item_port.get_next_item(xtn);
      drive(xtn);
      seq_item_port.item_done();
    end
  endtask

  //==================================================
  // Drive Task - Drives DUT with transaction data
  //==================================================
  task drive(uart_xtn xtn);
    vif.rst         <= 1'b0;
    vif.tx_start    <= xtn.tx_start;
    vif.rx_start    <= xtn.rx_start;
    vif.tx_data     <= xtn.tx_data;
    vif.baud        <= xtn.baud;
    vif.length      <= xtn.length;
    vif.parity_type <= xtn.parity_type;
    vif.parity_en   <= xtn.parity_en;
    vif.stop2       <= xtn.stop2;

    `uvm_info("DRV", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d",
      xtn.baud, xtn.length, xtn.parity_type, xtn.parity_en, xtn.stop2, xtn.tx_data), UVM_NONE);

    @(posedge vif.clk);
    @(posedge vif.tx_done);     // Wait for transmission to complete
    @(negedge vif.rx_done);     // Wait for receiver to go low (could indicate done de-assertion)
  endtask

  //==================================================
  // Reset DUT Task
  //==================================================
  task reset_dut();
    repeat (5) begin
      vif.rst         <= 1'b1;     // Active-high reset
      vif.tx_start    <= 1'b0;
      vif.rx_start    <= 1'b0;
      vif.tx_data     <= 8'h00;
      vif.baud        <= 16'h0000;
      vif.length      <= 4'h0;
      vif.parity_type <= 1'b0;
      vif.parity_en   <= 1'b0;
      vif.stop2       <= 1'b0;

      `uvm_info("DRV", "System Reset: Start of Simulation", UVM_MEDIUM);
      @(posedge vif.clk);
    end
  endtask

endclass

