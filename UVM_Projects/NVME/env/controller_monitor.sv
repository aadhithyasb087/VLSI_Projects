class controller_monitor extends uvm_monitor;
  `uvm_component_utils(controller_monitor)

  virtual nvme_if vif;
  nvme_txn t;
  // Analysis port for completions
  uvm_analysis_port#(nvme_txn) cpl_ap;

  function new(string name="controller_monitor", uvm_component parent=null);
    super.new(name,parent);
    cpl_ap = new("cpl_ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual nvme_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "controller_monitor: virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
  t = nvme_txn::type_id::create("t");
    forever begin
      @(posedge vif.clk);
      // Completion data from controller to host
      wait(vif.cpl_valid && vif.cpl_ready);
        t.expected_cqe_bits = vif.cpl_data;
        `uvm_info("CTRL_MON", $sformatf("Observed CPL: bits=%0h", vif.cpl_data), UVM_MEDIUM)
        cpl_ap.write(t);  
    end
  endtask

endclass

