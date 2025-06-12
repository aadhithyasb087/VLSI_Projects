class router_op_mon extends uvm_monitor;
  `uvm_component_utils(router_op_mon)
  router_op_agt_cfg m_cfg;
  virtual router_intf.OP_MR_MP vif;
  op_xtn h_trans;
  uvm_analysis_port#(op_xtn) op_mon_port;

  extern function new(string name="router_op_mon",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task monitor_data();
endclass
//----------------------------------------------------------------------------------------------------------
function router_op_mon::new(string name="router_op_mon",uvm_component parent);
  super.new(name,parent);
  op_mon_port=new("op_mon_port",this);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_mon::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
 if(!uvm_config_db#(router_op_agt_cfg)::get(this,"","router_op_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_mon::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction

task router_op_mon::monitor_data();
  h_trans=op_xtn::type_id::create("h_trans");
  while(vif.OP_MRCB.valid_out!==1)
    @(vif.OP_MRCB);
  @(vif.OP_MRCB);
  while(vif.OP_MRCB.read_enb!==1'b1)
    @(vif.OP_MRCB);
  @(vif.OP_MRCB);
  h_trans.header=vif.OP_MRCB.data_out;
  @(vif.OP_MRCB);
  h_trans.payload=new[h_trans.header[7:2]];
  foreach(h_trans.payload[i])begin
    h_trans.payload[i]=vif.OP_MRCB.data_out;
    @(vif.OP_MRCB);
  end
  h_trans.parity=vif.OP_MRCB.data_out;
  @(vif.OP_MRCB);
  `uvm_info(get_type_name(),"from dst monitor",UVM_LOW)
  h_trans.print();
  op_mon_port.write(h_trans);
  @(vif.OP_MRCB);
  @(vif.OP_MRCB);

endtask
  
  

   

task router_op_mon::run_phase(uvm_phase phase);
  forever begin
    monitor_data();
  end
endtask
