class apb_master_driver extends uvm_driver #(apb_xtns);
  `uvm_component_utils(apb_master_driver)

  virtual apb_intf vif;        // Virtual interface handle
  apb_master_bfm mbfm;           // Master BFM handle
  apb_xtns xtn;              // Transaction handle

  // Constructor
  function new(string name="apb_master_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    `uvm_info("apb_master_driver","Build phase",UVM_LOW)
   
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal("M_DRV","Cannot access interface");
    mbfm = apb_master_bfm::type_id::create("mbfm",this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    `uvm_info("apb_master_driver","Run phase",UVM_LOW)
    forever begin
       xtn = apb_xtns::type_id::create("xtn");
      seq_item_port.get_next_item(xtn);
      mbfm.master_drive(xtn);
      seq_item_port.item_done();
    end
  endtask

endclass

