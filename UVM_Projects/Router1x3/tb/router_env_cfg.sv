class router_env_cfg extends uvm_object;
  `uvm_object_utils(router_env_cfg)
  router_ip_agt_cfg h_ip_agt_cfg[];
  router_op_agt_cfg h_op_agt_cfg[];
  extern function new(string name="router_env_cfg");
  int no_of_ip_agents;
  int no_of_op_agents;
  bit has_ip_agt=1;
  bit has_op_agt=1;
  bit has_scoreboard=1;
  bit[1:0] addr;
endclass
//----------------------------------------------------------------------------------------------------------
function router_env_cfg::new(string name="router_env_cfg");
  super.new(name);
  
endfunction
