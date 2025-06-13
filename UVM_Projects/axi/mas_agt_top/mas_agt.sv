class mas_agt extends uvm_agent;
  `uvm_component_utils(mas_agt)
  mas_drv h_drv;
  mas_mon h_mon;
  mas_seqr h_seqr;
  mas_agt_cfg m_cfg;
  extern function new(string name="mas_agt",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function mas_agt::new(string name="mas_agt",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void mas_agt::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(mas_agt_cfg)::get(this,"","mas_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")
  h_mon=mas_mon::type_id::create("h_mon",this);
  if(m_cfg.is_active)begin
    h_drv=mas_drv::type_id::create("h_drv",this);
    h_seqr=mas_seqr::type_id::create("h_seqr",this);
  end
endfunction
//----------------------------------------------------------------------------
function void mas_agt::connect_phase(uvm_phase phase);
  if(m_cfg.is_active)
    h_drv.seq_item_port.connect(h_seqr.seq_item_export);
endfunction
