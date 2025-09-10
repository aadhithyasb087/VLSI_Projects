class slv_drv extends uvm_driver;
  `uvm_component_utils(slv_drv)
  slv_agt_cfg m_cfg;
  bit[31:0] write_mem[bit[31:0]];
  //axi_xtn h_trans;
  axi_xtn w_data_q[$];
  axi_xtn w_resp_q[$];
  axi_xtn r_data_q[$];

  virtual axi_intf vif;
  semaphore w_addr_sem=new(1);
  semaphore w_data_sem=new(1);
  semaphore w_resp_sem=new(1);
  semaphore w_addr_data_sem=new();
  semaphore w_data_resp_sem=new();
  semaphore r_addr_sem=new(1);
  semaphore r_data_sem=new(1);
  semaphore r_addr_data_sem=new();

  extern function new(string name="slv_drv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_waddr();
  extern task drive_wdata();
  extern task drive_wresp();
  extern task drive_data();
  extern task reset_resp_sig();
  extern task drive_raddr();
  extern task drive_rdata();

  extern function void report_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function slv_drv::new(string name="slv_drv",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void slv_drv::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(slv_agt_cfg)::get(this,"","slv_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")

endfunction
//----------------------------------------------------------------------------
function void slv_drv::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------
task slv_drv::run_phase(uvm_phase phase);
  forever begin
    `uvm_info(get_type_name(),"in slv drv",UVM_LOW)
    drive_data();
  end
endtask
//----------------------------------------------------------------------------  
task slv_drv::drive_data();
  fork
    drive_waddr();
    drive_wdata();
    drive_wresp(); 
    drive_raddr();
    drive_rdata();

  join_any
endtask
//----------------------------------------------------------------------------
task slv_drv::drive_waddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  w_addr_sem.get(1);
  repeat($urandom_range(1,5))
    @(vif.slv_dr_cb);
  while(vif.slv_dr_cb.awvalid!==1)
    @(vif.slv_dr_cb);
 
  vif.slv_dr_cb.awready<=1;

  h_trans.awid=vif.slv_dr_cb.awid;
  h_trans.awaddr=vif.slv_dr_cb.awaddr;
  h_trans.awlen=vif.slv_dr_cb.awlen;
  h_trans.awsize=vif.slv_dr_cb.awsize;
  h_trans.awburst=vif.slv_dr_cb.awburst;
  @(vif.slv_dr_cb);
  vif.slv_dr_cb.awready<=0;
  w_data_q.push_back(h_trans);
  w_resp_q.push_back(h_trans);
  w_addr_sem.put(1);
  w_addr_data_sem.put(1);
endtask
//----------------------------------------------------------------------------  
task slv_drv::drive_raddr();
  axi_xtn h_trans;
  h_trans=axi_xtn::type_id::create("h_trans");
  r_addr_sem.get(1);
  repeat($urandom_range(1,5))
    @(vif.slv_dr_cb);
  while(vif.slv_dr_cb.arvalid!==1)
    @(vif.slv_dr_cb);
 
  vif.slv_dr_cb.arready<=1;

  h_trans.arid=vif.slv_dr_cb.arid;
  h_trans.araddr=vif.slv_dr_cb.araddr;
  h_trans.arlen=vif.slv_dr_cb.arlen;
  h_trans.arsize=vif.slv_dr_cb.arsize;
  h_trans.arburst=vif.slv_dr_cb.arburst;
  @(vif.slv_dr_cb);
  vif.slv_dr_cb.arready<=0;
  r_data_q.push_back(h_trans);
  r_addr_sem.put(1);
  r_addr_data_sem.put(1);
endtask
//----------------------------------------------------------------------------
task slv_drv::drive_rdata();
  axi_xtn h_trans;
  r_addr_data_sem.get(1);
  r_data_sem.get(1);

  h_trans=r_data_q.pop_front();
  @(vif.slv_dr_cb); 
  vif.slv_dr_cb.rid<=h_trans.arid;
  vif.slv_dr_cb.rvalid<=1;
  vif.slv_dr_cb.rresp<=0;
  for(int i=0;i<=h_trans.arlen;i++)begin
    vif.slv_dr_cb.rdata<=$urandom_range(0,4096);
    if(i==h_trans.arlen)
      vif.slv_dr_cb.rlast<=1;
    @(vif.slv_dr_cb);
    while(vif.slv_dr_cb.rready!==1)
      @(vif.slv_dr_cb);
  end
  vif.slv_dr_cb.rvalid<=0;
  vif.slv_dr_cb.rlast<=0;
  vif.slv_dr_cb.rresp<='hx;
  vif.slv_dr_cb.rdata<='hx;
  repeat($urandom_range(1,5))
    @(vif.slv_dr_cb);
  r_data_sem.put(1);
endtask






task slv_drv::drive_wdata();
  axi_xtn h_trans;
  w_addr_data_sem.get(1);
  w_data_sem.get(1);

  h_trans=w_data_q.pop_front();
  h_trans.w_cal_data();
  h_trans.w_addr_calc();
  repeat($urandom_range(1,5))
    @(vif.slv_dr_cb);
  while(vif.slv_dr_cb.wvalid!==1)
    @(vif.slv_dr_cb);
  vif.slv_dr_cb.wready<=1;

  foreach(h_trans.w_addr[i])begin
    @(vif.slv_dr_cb);

    case(vif.slv_dr_cb.wstrb)
      4'b1111:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata;
      4'b0001:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[7:0];
      4'b0011:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[15:0];
      4'b0111:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[23:0];
      4'b0010:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[15:8];
      4'b0110:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[23:8];
      4'b1110:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[31:8];
      4'b0100:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[23:16];
      4'b1100:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[31:16];
      4'b1000:    write_mem[h_trans.w_addr[i]]=vif.slv_dr_cb.wdata[31:24];
    endcase

   // if(vif.slv_dr_cb.wlast==1)

  end  
      vif.slv_dr_cb.wready<=0;

  w_data_sem.put(1);
  w_data_resp_sem.put(1);
endtask
//----------------------------------------------------------------------------
task slv_drv::reset_resp_sig();
  vif.slv_dr_cb.bid<='hx;
  vif.slv_dr_cb.bresp<='hx;
endtask
//----------------------------------------------------------------------------
task slv_drv::drive_wresp();
  axi_xtn h_trans;
  w_data_resp_sem.get(1);
  w_resp_sem.get(1);

  h_trans=w_resp_q.pop_front();
  vif.slv_dr_cb.bvalid<=1;
  vif.slv_dr_cb.bid<=h_trans.awid;
  vif.slv_dr_cb.bresp<=0;
  @(vif.slv_dr_cb);

  while(vif.slv_dr_cb.bready!==1)
    @(vif.slv_dr_cb);
    //@(vif.slv_dr_cb);
  reset_resp_sig();
  vif.slv_dr_cb.bvalid<=0;
  w_resp_sem.put(1);
endtask
//----------------------------------------------------------------------------
function void slv_drv::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("write_mem=%0p",write_mem),UVM_LOW)
endfunction
