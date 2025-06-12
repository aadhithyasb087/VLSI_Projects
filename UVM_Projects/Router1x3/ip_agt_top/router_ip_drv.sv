class router_ip_drv extends uvm_driver#(ip_xtn);
  `uvm_component_utils(router_ip_drv)
  router_ip_agt_cfg m_cfg;
  virtual router_intf.IP_DR_MP vif;

  extern function new(string name="router_ip_drv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_data(ip_xtn h_trans);
  extern task reset_dut();
endclass
//----------------------------------------------------------------------------------------------------------
function router_ip_drv::new(string name="router_ip_drv",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_ip_drv::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
  if(!uvm_config_db#(router_ip_agt_cfg)::get(this,"","router_ip_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

endfunction
//----------------------------------------------------------------------------------------------------------
function void router_ip_drv::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------------------------------------
task router_ip_drv::drive_data(ip_xtn h_trans);
    @(vif.IP_DRCB);
   // @(vif.IP_DRCB);
   // @(vif.IP_DRCB);
   // @(vif.IP_DRCB);

  while(vif.IP_DRCB.busy!==0)
    @(vif.IP_DRCB);
  vif.IP_DRCB.pkt_valid<=1;
  vif.IP_DRCB.data_in<=h_trans.header;
  @(vif.IP_DRCB);
 // while((vif.IP_DRCB.busy==1) && (vif.IP_DRCB.error==1))
   // @(vif.IP_DRCB);
  foreach(h_trans.data_in[i])begin
    while(vif.IP_DRCB.busy!==0)
      @(vif.IP_DRCB);
    vif.IP_DRCB.data_in<=h_trans.data_in[i];
    @(vif.IP_DRCB);
   // while((vif.IP_DRCB.busy==1) && (vif.IP_DRCB.error==1))
   //   @(vif.IP_DRCB);
  end
  while(vif.IP_DRCB.busy!==0)
    @(vif.IP_DRCB);
  vif.IP_DRCB.pkt_valid<=0;
  vif.IP_DRCB.data_in<=h_trans.parity;
  @(vif.IP_DRCB);
 // while((vif.IP_DRCB.busy==1) && (vif.IP_DRCB.error==1))
 //     @(vif.IP_DRCB);
  
endtask
//----------------------------------------------------------------------------------------------------------
task router_ip_drv::reset_dut();

  vif.IP_DRCB.resetn<=1;
    @(vif.IP_DRCB);
  
  repeat(2)begin
    vif.IP_DRCB.resetn<=0;
    @(vif.IP_DRCB);
  end
  vif.IP_DRCB.resetn<=1;
endtask
//----------------------------------------------------------------------------------------------------------    
task router_ip_drv::run_phase(uvm_phase phase);
  reset_dut();
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),"in src drv",UVM_LOW)
    req.print();
    `uvm_info(get_type_name(),$sformatf("addr=%0d",req.header[1:0]),UVM_LOW)
    drive_data(req);
    seq_item_port.item_done();
  end
endtask
