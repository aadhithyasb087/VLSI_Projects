class mas_agt_cfg extends uvm_object;
  `uvm_object_utils(mas_agt_cfg)
  virtual axi_intf vif;
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  extern function new(string name="mas_agt_cfg");
  
 endclass
//--------------------------------------------------------
function mas_agt_cfg::new(string name="mas_agt_cfg");
  super.new(name);
endfunction
