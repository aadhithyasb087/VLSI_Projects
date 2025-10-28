class nvme_env extends uvm_env;
  `uvm_component_utils(nvme_env)

  host_agent       hostag;
  controller_agent ctrlag;
  nvme_scoreboard  sb;
  controller_mem ctrl_mem;
  host_mem h_mem;

  function new(string name="nvme_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    hostag = host_agent::type_id::create("hostag", this);
    ctrlag = controller_agent::type_id::create("ctrlag", this);
    sb     = nvme_scoreboard::type_id::create("sb", this);
    ctrl_mem     = controller_mem::type_id::create("ctrl_mem", this);
    h_mem     = host_mem::type_id::create("h_mem", this);
    
    uvm_config_db#(host_mem)::set(this, "*", "mem_h", h_mem);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect host monitor to scoreboard
    hostag.h_mon.cmd_ap.connect(sb.cmd_fifo.analysis_export);

    // Connect controller monitor to scoreboard
    ctrlag.c_mon.cpl_ap.connect(sb.cpl_fifo.analysis_export); 
    
  endfunction

endclass

