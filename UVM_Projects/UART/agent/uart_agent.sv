// uart_agent.sv
// Agent class to encapsulate the driver, sequencer, and monitor

class uart_agent extends uvm_agent;

  //==================================================
  // Components
  //==================================================
  uart_driver    drv;
  uart_monitor   mon;
  uart_sequencer seqr;

  uart_config    cfg; // Configuration object

  `uvm_component_utils(uart_agent)

  //==================================================
  // Constructor
  //==================================================
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  //==================================================
  // Build Phase
  //==================================================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create config object
    cfg = uart_config::type_id::create("cfg");

    // Create monitor (always needed)
    mon = uart_monitor::type_id::create("mon", this);

    // Create driver and sequencer only for ACTIVE agent
    if (cfg.is_active == UVM_ACTIVE) begin
      drv  = uart_driver::type_id::create("drv", this);
      seqr = uart_sequencer::type_id::create("seqr", this);
    end
  endfunction

  //==================================================
  // Connect Phase
  //==================================================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (cfg.is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass
