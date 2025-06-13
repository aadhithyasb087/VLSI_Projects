class axi_env_cfg extends uvm_object;
  `uvm_object_utils(axi_env_cfg)

  extern function new(string name="axi_env_cfg");

  bit has_mas_agt_top=1;
  bit has_slv_agt_top=1;
  bit has_scbd=1;
  int no_of_mas_agt=1;
  int no_of_slv_agt=1;
  mas_agt_cfg h_mas_agt_cfg[];
  slv_agt_cfg h_slv_agt_cfg[];
  static int no_of_trans_data=11;
  static int no_of_act_wdata,no_of_act_rdata;
endclass
//--------------------------------------------------------
function axi_env_cfg::new(string name="axi_env_cfg");
  super.new(name);
endfunction
