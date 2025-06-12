class router_ip_agt_top extends uvm_env;
  `uvm_component_utils(router_ip_agt_top)
  router_ip_agt h_agt[];
  router_env_cfg m_cfg; 
  extern function new(string name="router_ip_agt_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass
//----------------------------------------------------------------------------------------------------------
function router_ip_agt_top::new(string name="router_ip_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_ip_agt_top::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
   if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"env config not get")
  h_agt=new[m_cfg.no_of_ip_agents];
  foreach(h_agt[i])begin
    uvm_config_db#(router_ip_agt_cfg)::set(this,"*","router_ip_agt_cfg",m_cfg.h_ip_agt_cfg[i]);
    h_agt[i]=router_ip_agt::type_id::create($sformatf("h_agt[%0d]",i),this);
  end
endfunction
