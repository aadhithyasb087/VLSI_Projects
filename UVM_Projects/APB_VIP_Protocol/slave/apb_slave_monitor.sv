class apb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(apb_slave_monitor)

  virtual apb_intf vif;   
  apb_xtns xtn,xtn1;
  uvm_analysis_port #(apb_xtns) s_mon_port;

  function new(string name="apb_slave_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"in apb_slave_monitor build phase",UVM_LOW)
    if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal("s_mon","cannot access interface");
    s_mon_port = new("s_mon_port", this); 
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"in apb_slave_monitor run phase",UVM_NONE)
    forever begin
      xtn = apb_xtns::type_id::create("xtn");
      slave_mon(xtn); 
      s_mon_port.write(xtn);
      
    end
  endtask



  task slave_mon(apb_xtns xtn);
   	    wait(vif.presetn);
    @(posedge vif.pclk);
    wait(vif.M_MON.psel) 
 @(posedge vif.pclk);
      wait(vif.M_MON.penable && vif.M_MON.pready) 
        xtn.paddr  = vif.M_MON.paddr;
        xtn.pwrite = vif.M_MON.pwrite;
	xtn.penable = vif.M_MON.penable;
        xtn.pready  = vif.M_MON.pready;

        // data phase starts only after pready asserted
        if(vif.M_MON.pwrite)
          xtn.pwdata = vif.M_MON.pwdata; 
        else 
          xtn.prdata = vif.M_MON.prdata; 
  endtask

endclass
