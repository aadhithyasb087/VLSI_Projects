class host_monitor extends uvm_monitor;
  `uvm_component_utils(host_monitor)

  virtual nvme_if vif;
nvme_txn t;
  // Separate analysis port for commands
  uvm_analysis_port#(nvme_txn) cmd_ap;

  function new(string name="host_monitor", uvm_component parent=null);
    super.new(name,parent);
    cmd_ap = new("cmd_ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual nvme_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "host_monitor: virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
  t = nvme_txn::type_id::create("t",this);
    forever begin
      @(posedge vif.clk);
      // Capture commands issued from host driver
      wait(vif.cmd_valid && vif.cmd_ready);
        t.cmd = vif.cmd_data; 
        `uvm_info("HOST_MON", $sformatf("Observed CMD: CID=%0d OPC=0x%0h PRP1=0x%0h",
                        t.cmd.cid, t.cmd.opcode, t.cmd.prp1), UVM_MEDIUM)
        cmd_ap.write(t);
      
    end
  endtask

endclass

