class apb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(apb_slave_monitor)

  virtual apb_intf vif;   
  apb_xtns xtn,xtn1;
  uvm_analysis_port #(apb_xtns) s_mon_port;
  apb_slave_bfm sbfm;

  function new(string name="apb_slave_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"in apb_slave_monitor build phase",UVM_LOW)
    if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal("s_mon","cannot access interface");
    s_mon_port = new("s_mon_port", this); 
    sbfm = apb_slave_bfm::type_id::create("sbfm",this);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"in apb_slave_monitor run phase",UVM_NONE)
    forever begin
      xtn = apb_xtns::type_id::create("xtn");
      fork
      sbfm.slave();
      slave_mon(xtn); 
      join
      
      s_mon_port.write(xtn);
      
    end
  endtask



  task slave_mon(apb_xtns xtn);
   	    
  @(posedge vif.pclk)
      wait(vif.S_MON.psel && vif.S_MON.penable && vif.S_MON.pready);
        xtn.paddr  = vif.S_MON.paddr;
        xtn.pwrite = vif.S_MON.pwrite;
	xtn.penable = vif.S_MON.penable;
        xtn.pready  = vif.S_MON.pready;
        if(vif.S_MON.pwrite)
        xtn.pwdata = vif.S_MON.pwdata; 
        else
        xtn.prdata = vif.S_MON.prdata; 
  endtask

endclass
