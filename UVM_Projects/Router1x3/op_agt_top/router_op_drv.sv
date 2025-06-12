class router_op_drv extends uvm_driver#(op_xtn);
  `uvm_component_utils(router_op_drv)
  router_op_agt_cfg m_cfg;
  virtual router_intf.OP_DR_MP vif;

  extern function new(string name="router_op_drv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_data(op_xtn h_trans);
  extern task reset_ip_signals();

endclass
//----------------------------------------------------------------------------------------------------------
function router_op_drv::new(string name="router_op_drv",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_drv::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
  if(!uvm_config_db#(router_op_agt_cfg)::get(this,"","router_op_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_drv::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------------------------------------
task router_op_drv::drive_data(op_xtn h_trans);
  while(vif.OP_DRCB.valid_out!==1)begin
    @(vif.OP_DRCB);
  end

   `uvm_info(get_type_name(),$sformatf("no of cycles=%0d",h_trans.no_of_cycles),UVM_LOW)
   repeat(h_trans.no_of_cycles)
     @(vif.OP_DRCB);
   vif.OP_DRCB.read_enb<=1'b1;
   @(vif.OP_DRCB);
   while(vif.OP_DRCB.valid_out!==0)
     @(vif.OP_DRCB);
  // @(vif.OP_DRCB);
   vif.OP_DRCB.read_enb<=1'b0;
endtask
//----------------------------------------------------------------------------------------------------------      
task router_op_drv::reset_ip_signals();
   vif.OP_DRCB.read_enb<=1'b0;
endtask  
//----------------------------------------------------------------------------------------------------------
task router_op_drv::run_phase(uvm_phase phase);
  reset_ip_signals();
  forever begin
   // `uvm_info(get_type_name(),"in dst drv before getting packet",UVM_LOW)
    
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),"in dst drv",UVM_LOW)
    req.print();
    drive_data(req);
        seq_item_port.item_done();
  end
endtask

