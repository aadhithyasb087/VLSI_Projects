class slv_mon extends uvm_monitor;
  `uvm_component_utils(slv_mon)
  slv_agt_cfg m_cfg;
  virtual axi_intf vif;
  uvm_analysis_port#(axi_xtn) slv_mon_wport;
  uvm_analysis_port#(axi_xtn) slv_mon_rport;

  axi_xtn wdata_q[$];
  axi_xtn wresp_q[$];
  axi_xtn rdata_q[$];

  semaphore w_addr_sem=new(1);
  semaphore w_data_sem=new(1);
  semaphore w_resp_sem=new(1);
  semaphore w_addr_data_sem=new();
  semaphore w_data_resp_sem=new();
  semaphore r_addr_sem=new(1);
  semaphore r_data_sem=new(1);
  semaphore r_addr_data_sem=new();


  extern function new(string name="slv_mon",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task monitor_data();
  extern task mon_waddr();
  extern task mon_wdata();
  extern task mon_wresp();
  extern task mon_raddr();
  extern task mon_rdata();


endclass
//----------------------------------------------------------------------------
function slv_mon::new(string name="slv_mon",uvm_component parent);
  super.new(name,parent);
  slv_mon_wport=new("slv_mon_wport",this);
  slv_mon_rport=new("slv_mon_rport",this);

endfunction
//----------------------------------------------------------------------------
function void slv_mon::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(slv_agt_cfg)::get(this,"","slv_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

endfunction
//----------------------------------------------------------------------------
function void slv_mon::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------

task slv_mon::mon_waddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  w_addr_sem.get(1);
  while((vif.slv_mr_cb.awvalid!==1) ||(vif.slv_mr_cb.awready!==1))
    @(vif.slv_mr_cb);
  h_trans.awid=vif.slv_mr_cb.awid;
  h_trans.awaddr=vif.slv_mr_cb.awaddr;
  h_trans.awlen=vif.slv_mr_cb.awlen;
  h_trans.awsize=vif.slv_mr_cb.awsize;
  h_trans.awburst=vif.slv_mr_cb.awburst;
  wdata_q.push_back(h_trans);
  @(vif.slv_mr_cb);
  w_addr_sem.put(1);
  w_addr_data_sem.put(1);

endtask
//----------------------------------------------------------------------------

task slv_mon::mon_wdata();
  axi_xtn h_trans;
  w_addr_data_sem.get(1);
  w_data_sem.get(1);

  h_trans=wdata_q.pop_front();
  h_trans.wdata=new[h_trans.awlen+1];
  h_trans.wstrb=new[h_trans.awlen+1];
  while((vif.slv_mr_cb.wvalid!==1) ||(vif.slv_mr_cb.wready!==1))
    @(vif.slv_mr_cb);
  h_trans.wid=vif.slv_mr_cb.wid;
  for(int i=0;i<=h_trans.awlen;i++)begin
    h_trans.wdata[i]=vif.slv_mr_cb.wdata;
    h_trans.wstrb[i]=vif.slv_mr_cb.wstrb;
    @(vif.slv_mr_cb);
  //  while((vif.slv_mr_cb.wvalid!==1) ||(vif.slv_mr_cb.wready!==1))
  //    @(vif.slv_mr_cb);
  end
  wresp_q.push_back(h_trans);
  w_data_sem.put(1);
  w_data_resp_sem.put(1);
endtask
//----------------------------------------------------------------------------
task slv_mon::mon_wresp();
  axi_xtn h_trans;
  w_data_resp_sem.get(1);
  w_resp_sem.get(1);

  h_trans=wresp_q.pop_front();
  while((vif.slv_mr_cb.bvalid!==1) ||(vif.slv_mr_cb.bready!==1))
    @(vif.slv_mr_cb);
  h_trans.bid=vif.slv_mr_cb.bid;
  h_trans.bresp=vif.slv_mr_cb.bresp;
  `uvm_info("SLAVE MONITOR WRITE INFO" ,$sformatf("%0s",h_trans.sprint()),UVM_LOW) 
  slv_mon_wport.write(h_trans);  
  @(vif.slv_mr_cb);
  w_resp_sem.put(1);

endtask
//----------------------------------------------------------------------------
task slv_mon::mon_raddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  r_addr_sem.get(1);
  while((vif.slv_mr_cb.arvalid!==1) ||(vif.slv_mr_cb.arready!==1))
    @(vif.slv_mr_cb);
  h_trans.arid=vif.slv_mr_cb.arid;
  h_trans.araddr=vif.slv_mr_cb.araddr;
  h_trans.arlen=vif.slv_mr_cb.arlen;
  h_trans.arsize=vif.slv_mr_cb.arsize;
  h_trans.arburst=vif.slv_mr_cb.arburst;
  rdata_q.push_back(h_trans);
  @(vif.slv_mr_cb);
  r_addr_sem.put(1);
  r_addr_data_sem.put(1);



endtask
//----------------------------------------------------------------------------
task slv_mon::mon_rdata();
  axi_xtn h_trans;
  r_addr_data_sem.get(1);
  r_data_sem.get(1);

  h_trans=rdata_q.pop_front();
  
  h_trans.rdata=new[h_trans.arlen+1];
  while((vif.slv_mr_cb.rvalid!==1) ||(vif.slv_mr_cb.rready!==1))
    @(vif.slv_mr_cb);
  h_trans.rid=vif.slv_mr_cb.rid;
  h_trans.rresp=vif.slv_mr_cb.rresp;
  for(int i=0;i<=h_trans.arlen;i++)begin
    h_trans.rdata[i]=vif.slv_mr_cb.rdata;
    @(vif.slv_mr_cb);
  //  while((vif.slv_mr_cb.rvalid!==1) ||(vif.slv_mr_cb.rready!==1))
   //   @(vif.slv_mr_cb);
  end

  `uvm_info("SLAVE MONITOR READ INFO" ,$sformatf("%0s",h_trans.sprint()),UVM_LOW) 
  slv_mon_rport.write(h_trans);
  r_data_sem.put(1);
  

endtask
//----------------------------------------------------------------------------
task slv_mon::monitor_data();
  fork
    mon_waddr();
    mon_wdata();
    mon_wresp();
    mon_raddr();
    mon_rdata();
   
  join_any
endtask
//----------------------------------------------------------------------------
task slv_mon::run_phase(uvm_phase phase);
  forever begin
    monitor_data();
  end
endtask
//----------------------------------------------------------------------------
