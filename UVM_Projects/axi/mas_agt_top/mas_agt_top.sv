class mas_agt_top extends uvm_env;
  `uvm_component_utils(mas_agt_top)
  mas_agt h_agt[];
  axi_env_cfg m_cfg;
  extern function new(string name="mas_agt_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function mas_agt_top::new(string name="mas_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void mas_agt_top::build_phase(uvm_phase phase);
  if(!uvm_config_db#(axi_env_cfg)::get(this,"","axi_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get properly")
  h_agt=new[m_cfg.no_of_mas_agt];
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  foreach(h_agt[i])begin
    uvm_config_db#(mas_agt_cfg)::set(this,$sformatf("h_agt[%0d]*",i),"mas_agt_cfg",m_cfg.h_mas_agt_cfg[i]);
    h_agt[i]=mas_agt::type_id::create($sformatf("h_agt[%0d]",i),this);
  end
endfunction
//----------------------------------------------------------------------------
