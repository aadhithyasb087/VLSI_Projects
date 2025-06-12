class router_op_agt_cfg extends uvm_object;
  `uvm_object_utils(router_op_agt_cfg)
  virtual router_intf vif;
  uvm_active_passive_enum is_active=UVM_ACTIVE;

  extern function new(string name="router_op_agt_cfg");

endclass
//----------------------------------------------------------------------------------------------------------
function router_op_agt_cfg::new(string name="router_op_agt_cfg");
  super.new(name);
endfunction
