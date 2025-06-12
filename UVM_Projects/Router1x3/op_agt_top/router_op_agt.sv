class router_op_agt extends uvm_agent;
  `uvm_component_utils(router_op_agt)
  router_op_mon h_mon;
  router_op_drv h_drv;
  router_op_seqr h_seqr;
  router_op_agt_cfg m_cfg;
  extern function new(string name="router_op_agt",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function router_op_agt::new(string name="router_op_agt",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_agt::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
 if(!uvm_config_db#(router_op_agt_cfg)::get(this,"","router_op_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

  h_mon=router_op_mon::type_id::create("h_mon",this);
  if(m_cfg.is_active)begin
    h_drv=router_op_drv::type_id::create("h_drv",this);
    h_seqr=router_op_seqr::type_id::create("h_seqr",this);
  end

endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_agt::connect_phase(uvm_phase phase);
  if(m_cfg.is_active)begin  
    h_drv.seq_item_port.connect(h_seqr.seq_item_export);
  end
endfunction
