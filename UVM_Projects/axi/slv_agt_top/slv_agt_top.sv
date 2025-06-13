class slv_agt_top extends uvm_env;
  `uvm_component_utils(slv_agt_top)
  slv_agt h_agt[];
  axi_env_cfg m_cfg;
  extern function new(string name="slv_agt_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function slv_agt_top::new(string name="slv_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void slv_agt_top::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(axi_env_cfg)::get(this,"","axi_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get properly")
  h_agt=new[m_cfg.no_of_slv_agt];
  foreach(h_agt[i])begin
    uvm_config_db#(slv_agt_cfg)::set(this,$sformatf("h_agt[%0d]*",i),"slv_agt_cfg",m_cfg.h_slv_agt_cfg[i]);
    h_agt[i]=slv_agt::type_id::create($sformatf("h_agt[%0d]",i),this);
  end
endfunction
//----------------------------------------------------------------------------
