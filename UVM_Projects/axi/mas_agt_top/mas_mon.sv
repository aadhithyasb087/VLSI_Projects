class mas_mon extends uvm_monitor;
  `uvm_component_utils(mas_mon)
  mas_agt_cfg m_cfg;
  virtual axi_intf vif;
  uvm_analysis_port#(axi_xtn) mas_mon_wport;
  uvm_analysis_port#(axi_xtn) mas_mon_rport;

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

  extern function new(string name="mas_mon",uvm_component parent);
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
function mas_mon::new(string name="mas_mon",uvm_component parent);
  super.new(name,parent);
  mas_mon_wport=new("mas_mon_wport",this);
  mas_mon_rport=new("mas_mon_rport",this);

endfunction
//----------------------------------------------------------------------------
function void mas_mon::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(mas_agt_cfg)::get(this,"","mas_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

endfunction
//----------------------------------------------------------------------------
function void mas_mon::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------
task mas_mon::mon_waddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  w_addr_sem.get(1);
  while((vif.mas_mr_cb.awvalid!==1) ||(vif.mas_mr_cb.awready!==1))
    @(vif.mas_mr_cb);

  h_trans.awid=vif.mas_mr_cb.awid;
  h_trans.awaddr=vif.mas_mr_cb.awaddr;
  h_trans.awlen=vif.mas_mr_cb.awlen;
  h_trans.awsize=vif.mas_mr_cb.awsize;
  h_trans.awburst=vif.mas_mr_cb.awburst;
  wdata_q.push_back(h_trans);
  @(vif.mas_mr_cb);
  w_addr_sem.put(1);
  w_addr_data_sem.put(1);

endtask
//----------------------------------------------------------------------------
task mas_mon::mon_wdata();
  axi_xtn h_trans;
  w_addr_data_sem.get(1);
  w_data_sem.get(1);
  h_trans=wdata_q.pop_front();
  h_trans.wdata=new[h_trans.awlen+1];
  h_trans.wstrb=new[h_trans.awlen+1];
  while((vif.mas_mr_cb.wvalid!==1) ||(vif.mas_mr_cb.wready!==1))
    @(vif.mas_mr_cb);
  h_trans.wid=vif.mas_mr_cb.wid;
  for(int i=0;i<=h_trans.awlen;i++)begin
    h_trans.wdata[i]=vif.mas_mr_cb.wdata;
    h_trans.wstrb[i]=vif.mas_mr_cb.wstrb;
    @(vif.mas_mr_cb);
    //while((vif.mas_mr_cb.wvalid!==1) ||(vif.mas_mr_cb.wready!==1))
    //  @(vif.mas_mr_cb);
  end
  wresp_q.push_back(h_trans);
  w_data_sem.put(1);
  w_data_resp_sem.put(1);
endtask
//----------------------------------------------------------------------------
task mas_mon::mon_wresp();
  axi_xtn h_trans;
  w_data_resp_sem.get(1);
  w_resp_sem.get(1);
  h_trans=wresp_q.pop_front();
  while((vif.mas_mr_cb.bvalid!==1) ||(vif.mas_mr_cb.bready!==1))
    @(vif.mas_mr_cb);
  h_trans.bid=vif.mas_mr_cb.bid;
  h_trans.bresp=vif.mas_mr_cb.bresp;
  `uvm_info("MASTER MONITOR WRITE INFO" ,$sformatf("%0s",h_trans.sprint()),UVM_LOW) 
  mas_mon_wport.write(h_trans);  
  @(vif.mas_mr_cb);
  w_resp_sem.put(1);

endtask
//----------------------------------------------------------------------------
task mas_mon::mon_raddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  r_addr_sem.get(1);
  while((vif.mas_mr_cb.arvalid!==1) ||(vif.mas_mr_cb.arready!==1))
    @(vif.mas_mr_cb);

  h_trans.arid=vif.mas_mr_cb.arid;
  h_trans.araddr=vif.mas_mr_cb.araddr;
  h_trans.arlen=vif.mas_mr_cb.arlen;
  h_trans.arsize=vif.mas_mr_cb.arsize;
  h_trans.arburst=vif.mas_mr_cb.arburst;
  rdata_q.push_back(h_trans);
  @(vif.mas_mr_cb);
  r_addr_sem.put(1);
  r_addr_data_sem.put(1);



endtask
//----------------------------------------------------------------------------
task mas_mon::mon_rdata();
  axi_xtn h_trans;
  r_addr_data_sem.get(1);
  r_data_sem.get(1);

  h_trans=rdata_q.pop_front();
  
  h_trans.rdata=new[h_trans.arlen+1];
  while((vif.mas_mr_cb.rvalid!==1) ||(vif.mas_mr_cb.rready!==1))
    @(vif.mas_mr_cb);
  h_trans.rid=vif.mas_mr_cb.rid;
  h_trans.rresp=vif.mas_mr_cb.rresp;
  for(int i=0;i<=h_trans.arlen;i++)begin
    h_trans.rdata[i]=vif.mas_mr_cb.rdata;
    @(vif.mas_mr_cb);
   // while((vif.mas_mr_cb.rvalid!==1) ||(vif.mas_mr_cb.rready!==1))
    //  @(vif.mas_mr_cb);
  end

  `uvm_info("MASTER MONITOR READ INFO" ,$sformatf("%0s",h_trans.sprint()),UVM_LOW) 
  mas_mon_rport.write(h_trans);
  r_data_sem.put(1);
  

endtask


task mas_mon::monitor_data();
  fork
    mon_waddr();
    mon_wdata();
    mon_wresp();
    mon_raddr();
    mon_rdata();
   
  join_any
endtask
//----------------------------------------------------------------------------
task mas_mon::run_phase(uvm_phase phase);
  forever begin
    monitor_data();
  end
endtask
//----------------------------------------------------------------------------
