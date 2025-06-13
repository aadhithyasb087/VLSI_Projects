class mas_drv extends uvm_driver#(axi_xtn);
  `uvm_component_utils(mas_drv)
  mas_agt_cfg m_cfg;
  virtual axi_intf vif;
  axi_xtn w_addr_q[$];
  axi_xtn w_data_q[$];
  axi_xtn w_resp_q[$];
  axi_xtn r_addr_q[$];
  axi_xtn r_data_q[$];

  bit[31:0] read_mem[bit[31:0]];

  semaphore w_addr_sem=new(1);
  semaphore w_data_sem=new(1);
  semaphore w_resp_sem=new(1);
  semaphore w_addr_data_sem=new();
  semaphore w_data_resp_sem=new();
  semaphore r_addr_sem=new(1);
  semaphore r_data_sem=new(1);
  semaphore r_addr_data_sem=new();

  extern function new(string name="mas_drv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_data(axi_xtn h_trans);
  extern task drive_waddr();
  extern task drive_wdata();
  extern task drive_resp();
  extern task reset_addr_sig();
  extern task reset_data_sig();
  extern task drive_raddr();
  extern task reset_raddr_sig();
  extern task drive_rdata();
  extern function void report_phase(uvm_phase phase);
   
endclass
//----------------------------------------------------------------------------
function mas_drv::new(string name="mas_drv",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void mas_drv::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(mas_agt_cfg)::get(this,"","mas_agt_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get")
  
endfunction
//----------------------------------------------------------------------------
function void mas_drv::connect_phase(uvm_phase phase);
  this.vif=m_cfg.vif;
endfunction
//----------------------------------------------------------------------------
task mas_drv::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),"got pkt in drv",UVM_LOW)
    drive_data(req);
    seq_item_port.item_done();
  end
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_raddr();
  axi_xtn h_trans;
  h_trans=r_addr_q.pop_front();
  r_addr_sem.get(1);
  @(vif.mas_dr_cb); 
  vif.mas_dr_cb.araddr<=h_trans.araddr;
  vif.mas_dr_cb.arid<=h_trans.arid;
  vif.mas_dr_cb.arlen<=h_trans.arlen;
  vif.mas_dr_cb.arsize<=h_trans.arsize;
  vif.mas_dr_cb.arburst<=h_trans.arburst;
  vif.mas_dr_cb.arvalid<=1;
  @(vif.mas_dr_cb);

  while(vif.mas_dr_cb.arready!==1)
    @(vif.mas_dr_cb);
  //@(vif.mas_dr_cb); 
  vif.mas_dr_cb.arvalid<=0;
  reset_raddr_sig();
  repeat($urandom_range(1,5))
    @(vif.mas_dr_cb);
  r_addr_sem.put(1);
  r_addr_data_sem.put(1);
endtask
//----------------------------------------------------------------------------
task mas_drv::reset_raddr_sig();
  vif.mas_dr_cb.araddr<='hx;
  vif.mas_dr_cb.arid<='hx;
  vif.mas_dr_cb.arlen<='hx;
  vif.mas_dr_cb.arsize<='hx;
  vif.mas_dr_cb.arburst<='hx;
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_rdata();
  axi_xtn h_trans;
  r_addr_data_sem.get(1);
  r_data_sem.get(1);
  h_trans=r_data_q.pop_front();
  h_trans.r_cal_data();
  h_trans.r_addr_calc();
 // h_trans.r_strobe_calc();
  repeat($urandom_range(1,5))
    @(vif.mas_dr_cb);
  while(vif.mas_dr_cb.rvalid!==1)
    @(vif.mas_dr_cb);
  vif.mas_dr_cb.rready<=1;

  foreach(h_trans.r_addr[i])begin
    @(vif.mas_dr_cb);

    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata;
/*    case(h_trans.rstrb[i])
      4'b1111:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata;
      4'b0001:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[7:0];
      4'b0011:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[15:0];
      4'b0111:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[23:0];
      4'b0010:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[15:8];
      4'b0110:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[23:8];
      4'b1110:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[31:8];
      4'b0100:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[23:16];
      4'b1100:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[31:16];
      4'b1000:    read_mem[h_trans.r_addr[i]]=vif.mas_dr_cb.rdata[31:24];
    endcase */

  end  
  vif.mas_dr_cb.rready<=0;
  r_data_sem.put(1);
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_data(axi_xtn h_trans);
  w_addr_q.push_back(h_trans);
  w_data_q.push_back(h_trans);
  w_resp_q.push_back(h_trans);
  r_addr_q.push_back(h_trans);
  r_data_q.push_back(h_trans);

  fork    
    drive_waddr();
    drive_wdata();
    drive_resp();
    drive_raddr();
    drive_rdata();

  join_any
endtask
//----------------------------------------------------------------------------
task mas_drv::reset_addr_sig();
  vif.mas_dr_cb.awaddr<='hx;
  vif.mas_dr_cb.awid<='hx;
  vif.mas_dr_cb.awlen<='hx;
  vif.mas_dr_cb.awsize<='hx;
  vif.mas_dr_cb.awburst<='hx;
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_waddr();
  axi_xtn h_trans;
  h_trans=w_addr_q.pop_front();
  w_addr_sem.get(1);
    @(vif.mas_dr_cb); 
  vif.mas_dr_cb.awaddr<=h_trans.awaddr;
  vif.mas_dr_cb.awid<=h_trans.awid;
  vif.mas_dr_cb.awlen<=h_trans.awlen;
  vif.mas_dr_cb.awsize<=h_trans.awsize;
  vif.mas_dr_cb.awburst<=h_trans.awburst;
  vif.mas_dr_cb.awvalid<=1;
  @(vif.mas_dr_cb);

  while(vif.mas_dr_cb.awready!==1)
    @(vif.mas_dr_cb);
  //@(vif.mas_dr_cb); 
  vif.mas_dr_cb.awvalid<=0;
  reset_addr_sig();
  repeat($urandom_range(1,5))
    @(vif.mas_dr_cb);
  w_addr_sem.put(1);
  w_addr_data_sem.put(1);
endtask
//----------------------------------------------------------------------------
task mas_drv::reset_data_sig();
  vif.mas_dr_cb.wid<='hx;
  vif.mas_dr_cb.wdata<='hx;
  vif.mas_dr_cb.wstrb<='hx;
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_wdata();
  axi_xtn h_trans;
  h_trans=w_data_q.pop_front();
  w_addr_data_sem.get(1);
  w_data_sem.get(1);

  @(vif.mas_dr_cb); 
  vif.mas_dr_cb.wid<=h_trans.wid;
  vif.mas_dr_cb.wvalid<=1;
  foreach(h_trans.wdata[i])begin
    vif.mas_dr_cb.wdata<=h_trans.wdata[i];
    vif.mas_dr_cb.wstrb<=h_trans.wstrb[i];
    if(i==h_trans.awlen)
      vif.mas_dr_cb.wlast<=1;
    @(vif.mas_dr_cb);

    while(vif.mas_dr_cb.wready!==1)
      @(vif.mas_dr_cb);

   
  end
  vif.mas_dr_cb.wvalid<=0;
  vif.mas_dr_cb.wlast<=0;
  reset_data_sig();
  repeat($urandom_range(1,5))
    @(vif.mas_dr_cb);
  w_data_sem.put(1);
  w_data_resp_sem.put(1);
endtask
//----------------------------------------------------------------------------
task mas_drv::drive_resp();
  axi_xtn h_trans; 
  h_trans=w_resp_q.pop_front();
  w_data_resp_sem.get(1);
  w_resp_sem.get(1);

  repeat($urandom_range(1,5))
    @(vif.mas_dr_cb);
  while(vif.mas_dr_cb.bvalid!==1)
    @(vif.mas_dr_cb);
  vif.mas_dr_cb.bready<=1;
  @(vif.mas_dr_cb);
  vif.mas_dr_cb.bready<=0;
  w_resp_sem.put(1);
 // w_data_resp_sem.put(1);
endtask
 

function void mas_drv::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("read_mem = %0p",read_mem),UVM_LOW)
endfunction
  
  

  
    
