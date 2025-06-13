// uart_monitor.sv
// UART Monitor for observing DUT signals and publishing transactions

class uart_monitor extends uvm_monitor;

  `uvm_component_utils(uart_monitor)

  //==================================================
  // Members
  //==================================================
  uvm_analysis_port#(uart_xtn) send;   // Analysis port to send observed transactions
  uart_xtn xtn;                        // Handle for the transaction
  virtual uart_if vif;                // Virtual interface

  //==================================================
  // Constructor
  //==================================================
  function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  //==================================================
  // Build Phase
  //==================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    xtn = uart_xtn::type_id::create("xtn"); // Corrected handle name
    send = new("send", this);

    // Get the virtual interface from config DB
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Unable to access Interface");
  endfunction

  //==================================================
  // Run Phase
  //==================================================
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      if (vif.rst) begin
        xtn.rst = 1'b1;
        `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
        send.write(xtn);
      end
      else begin
        @(posedge vif.tx_done); // Wait until transmission is done

        // Capture DUT signals into transaction
        xtn.rst         = 1'b0;
        xtn.tx_start    = vif.tx_start;
        xtn.rx_start    = vif.rx_start;
        xtn.tx_data     = vif.tx_data;
        xtn.baud        = vif.baud;
        xtn.length      = vif.length;
        xtn.parity_type = vif.parity_type;
        xtn.parity_en   = vif.parity_en;
        xtn.stop2       = vif.stop2;

        @(negedge vif.rx_done); // Wait until receiver finishes (de-assertion)

        xtn.rx_out = vif.rx_out;

        // Log the captured values
        `uvm_info("MON", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d",
          xtn.baud, xtn.length, xtn.parity_type, xtn.parity_en, xtn.stop2, xtn.tx_data, vif.rx_out), UVM_NONE);

        send.write(xtn);
      end
    end
  endtask

endclass

