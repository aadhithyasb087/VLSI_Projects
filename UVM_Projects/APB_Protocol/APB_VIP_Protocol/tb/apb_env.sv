class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  apb_master_agent m_agt;   // Master agent instance
  apb_slave_agent  s_agt;   // Slave agent instance
  apb_scoreboard   sb;      // Scoreboard for checking

  function new(string name="apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info("apb_env","in apb_env build phase",UVM_NONE)
    m_agt = apb_master_agent::type_id::create("m_agt", this);
    s_agt = apb_slave_agent::type_id::create("s_agt", this);
    sb    = apb_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    `uvm_info("apb_env","in apb_env connect phase",UVM_NONE)
    // Connect master & slave monitor ports to scoreboard analysis FIFOs
    m_agt.m_mon.m_mon_port.connect(sb.m_fifo.analysis_export);
    s_agt.s_mon.s_mon_port.connect(sb.s_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("apb_env","in apb_env run phase",UVM_NONE)
  endtask

endclass

