class apb_master_monitor extends uvm_monitor;
  `uvm_component_utils(apb_master_monitor)

  // Virtual interface handle
  virtual apb_intf vif;

  // Memory to store data
  bit [31:0] mem[0:31];

  // Transaction handle
  apb_xtns xtn;

  // Analysis port to send transactions
  uvm_analysis_port #(apb_xtns) m_mon_port;

  function new(string name="apb_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    m_mon_port = new("m_mon_port", this); 
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info("apb_master_monitor","in apb_master_monitor build phase",UVM_NONE)
    if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal("m_mon","cannot access interface")
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("apb_master_monitor","in apb_master_monitor run phase",UVM_NONE)
    forever begin
      xtn = apb_xtns::type_id::create("xtn");  
      master_monitor(xtn);
      m_mon_port.write(xtn);


      end
  endtask

  task master_monitor(apb_xtns xtn);
       wait(vif.presetn);
  @(posedge vif.pclk)
  wait(vif.M_MON.psel && vif.M_MON.penable && vif.M_MON.pready); 
  xtn.paddr   = vif.M_MON.paddr;
  xtn.pwrite  = vif.M_MON.pwrite;
  xtn.penable = vif.M_MON.penable;
  xtn.pready  = vif.M_MON.pready;
  
      //if(vif.M_MON.pwrite) begin
      xtn.pwdata = vif.M_MON.pwdata;
        //mem[xtn.paddr] = xtn.pwdata;

    //end
    //else
      //xtn.prdata = mem[xtn.paddr];
 
endtask
  

endclass

