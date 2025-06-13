class slv_agt extends uvm_agent;
  `uvm_component_utils(slv_agt)
  slv_drv h_drv;
  slv_mon h_mon;
  slv_seqr h_seqr;
  slv_agt_cfg m_cfg;
  extern function new(string name="slv_agt",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function slv_agt::new(string name="slv_agt",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void slv_agt::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(slv_agt_cfg)::get(this,"","slv_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")
  h_mon=slv_mon::type_id::create("h_mon",this);
  if(m_cfg.is_active)begin
    h_drv=slv_drv::type_id::create("h_drv",this);
    h_seqr=slv_seqr::type_id::create("h_seqr",this);
  end
endfunction
//----------------------------------------------------------------------------
