class axi_base_test extends uvm_test;
  `uvm_component_utils(axi_base_test)
  axi_env h_env;
  axi_env_cfg h_env_cfg;
  mas_agt_cfg h_mas_agt_cfg[];
  slv_agt_cfg h_slv_agt_cfg[];
  int no_of_mas_agt=1;
  int no_of_slv_agt=1;
  extern function new(string name="axi_base_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void set_config();
endclass
//----------------------------------------------------------------------------
function axi_base_test::new(string name="axi_base_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void axi_base_test::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  set_config();
  uvm_config_db#(axi_env_cfg)::set(this,"*","axi_env_cfg",h_env_cfg);
  h_env=axi_env::type_id::create("h_env",this);
endfunction
//----------------------------------------------------------------------------
function void axi_base_test::set_config();
  h_env_cfg=axi_env_cfg::type_id::create("h_env_cfg");
  h_mas_agt_cfg=new[no_of_mas_agt];
  h_slv_agt_cfg=new[no_of_slv_agt];

  foreach(h_mas_agt_cfg[i])begin
    h_mas_agt_cfg[i]=mas_agt_cfg::type_id::create($sformatf("h_mas_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual axi_intf)::get(this,"","intf",h_mas_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"vif not get correctly")
  end

  foreach(h_slv_agt_cfg[i])begin
    h_slv_agt_cfg[i]=slv_agt_cfg::type_id::create($sformatf("h_slv_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual axi_intf)::get(this,"","intf",h_slv_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"vif not get correctly")

  end
  h_env_cfg.h_mas_agt_cfg=h_mas_agt_cfg;
  h_env_cfg.h_slv_agt_cfg=h_slv_agt_cfg;
endfunction
//----------------------------------------------------------------------------

class axi_test1 extends axi_base_test;
  `uvm_component_utils(axi_test1)
  axi_master_seq h_seq;
  extern function new(string name="axi_test1",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function axi_test1::new(string name="axi_test1",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void axi_test1::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction

task axi_test1::run_phase(uvm_phase phase);
  h_seq=axi_master_seq::type_id::create("axi_master_seq");
  phase.raise_objection(this);
  h_seq.start(h_env.h_m_agt_top.h_agt[0].h_seqr);
  #1500;
 // while(h_env_cfg.no_of_trans_data!=h_env_cfg.no_of_act_wdata)
 //  #10;
  phase.drop_objection(this);
endtask


