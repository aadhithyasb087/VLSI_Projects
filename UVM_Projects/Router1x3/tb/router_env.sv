class router_env extends uvm_env;
  `uvm_component_utils(router_env)
  router_ip_agt_top h_ip_agt_top;
  router_op_agt_top h_op_agt_top;
  router_env_cfg m_cfg;
  router_vsequencer h_vseqr;
  router_scoreboard h_scbd;
  extern function new(string name="router_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void start_of_simulation_phase(uvm_phase phase);
  extern function void extract_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function router_env::new(string name="router_env",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
  if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"env config not get")
   
  h_vseqr=router_vsequencer::type_id::create("h_vseqr",this);
  if(m_cfg.has_ip_agt)
    h_ip_agt_top=router_ip_agt_top::type_id::create("h_ip_agt_top",this);
  if(m_cfg.has_op_agt)  
    h_op_agt_top=router_op_agt_top::type_id::create("h_op_agt_top",this);
  if(m_cfg.has_scoreboard)
    h_scbd=router_scoreboard::type_id::create("h_scbd",this);
  
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_env::start_of_simulation_phase(uvm_phase phase);
  //uvm_top.print_topology();
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_env::extract_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in extract phase",UVM_LOW)
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_env::connect_phase(uvm_phase phase);
  foreach(h_vseqr.h_ip_seqr[i])
    h_vseqr.h_ip_seqr[i]=h_ip_agt_top.h_agt[i].h_seqr;

  foreach(h_vseqr.h_op_seqr[i])
    h_vseqr.h_op_seqr[i]=h_op_agt_top.h_agt[i].h_seqr;

  h_ip_agt_top.h_agt[0].h_mon.ip_mon_port.connect(h_scbd.ip_fifo.analysis_export);
  h_op_agt_top.h_agt[0].h_mon.op_mon_port.connect(h_scbd.op_fifo0.analysis_export);
  h_op_agt_top.h_agt[1].h_mon.op_mon_port.connect(h_scbd.op_fifo1.analysis_export);
  h_op_agt_top.h_agt[2].h_mon.op_mon_port.connect(h_scbd.op_fifo2.analysis_export);

  
endfunction
