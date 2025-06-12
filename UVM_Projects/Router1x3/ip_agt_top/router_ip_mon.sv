class router_ip_mon extends uvm_monitor;
  `uvm_component_utils(router_ip_mon)
  router_ip_agt_cfg m_cfg;
  ip_xtn h_trans;
  uvm_analysis_port#(ip_xtn) ip_mon_port;
  virtual router_intf.IP_MR_MP vif;
  extern function new(string name="router_ip_mon",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task monitor_data();
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function router_ip_mon::new(string name="router_ip_mon",uvm_component parent);
  super.new(name,parent);
  ip_mon_port=new("ip_mon_port",this);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_ip_mon::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
  if(!uvm_config_db#(router_ip_agt_cfg)::get(this,"","router_ip_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

endfunction
//----------------------------------------------------------------------------------------------------------
function void router_ip_mon::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------------------------------------
task router_ip_mon::monitor_data();
  h_trans=ip_xtn::type_id::create("h_trans");

  while(vif.IP_MRCB.pkt_valid!==1)
    @(vif.IP_MRCB);
  while(vif.IP_MRCB.busy!==0)
    @(vif.IP_MRCB);
    
  h_trans.header=vif.IP_MRCB.data_in;
  @(vif.IP_MRCB);

  h_trans.data_in=new[h_trans.header[7:2]];
 
  foreach(h_trans.data_in[i])begin
    while(vif.IP_MRCB.busy!==0)
      @(vif.IP_MRCB);
    h_trans.data_in[i]=vif.IP_MRCB.data_in;
    @(vif.IP_MRCB);
    
  end
  while(vif.IP_MRCB.busy!==0)
    @(vif.IP_MRCB);
  h_trans.parity=vif.IP_MRCB.data_in;
  @(vif.IP_MRCB);
  repeat(2)
    @(vif.IP_MRCB);
  h_trans.error=vif.IP_MRCB.error;
  `uvm_info(get_type_name(),"in src monitor",UVM_LOW)
  h_trans.print();
  ip_mon_port.write(h_trans);
endtask
  


  
task router_ip_mon::run_phase(uvm_phase phase);
  forever begin
    monitor_data();
    end
  

endtask
    
