class slv_agt_cfg extends uvm_object;
  `uvm_object_utils(slv_agt_cfg)
  virtual axi_intf vif;
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  extern function new(string name="slv_agt_cfg");

 endclass
//--------------------------------------------------------
function slv_agt_cfg::new(string name="slv_agt_cfg");
  super.new(name);
endfunction
