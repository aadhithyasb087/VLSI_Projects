class router_vsequencer extends uvm_sequencer;
  `uvm_component_utils(router_vsequencer)
  router_env_cfg m_cfg;
  router_ip_seqr h_ip_seqr[];
  router_op_seqr h_op_seqr[];
  extern function new(string name="router_vsequencer",uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass
//--------------------------------------------------------------------------------------------
function router_vsequencer::new(string name="router_vsequencer",uvm_component parent);
  super.new(name,parent);
endfunction
//--------------------------------------------------------------------------------------------
function void router_vsequencer::build_phase(uvm_phase phase);
  if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"env config not get properly")

  h_ip_seqr=new[m_cfg.no_of_ip_agents];
  h_op_seqr=new[m_cfg.no_of_op_agents];
endfunction

