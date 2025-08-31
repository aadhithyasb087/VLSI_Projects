class apb_slave_driver extends uvm_driver;

  `uvm_component_utils(apb_slave_driver)

  // Virtual interface handle to drive signals on APB
  virtual apb_intf vif;

  // Slave BFM handle for low-level signal driving
  apb_slave_bfm sbfm;

  // Constructor
  function new(string name = "apb_slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Get APB interface from config DB (fatal error if not set)
    if(!uvm_config_db #(virtual apb_intf)::get(this, "", "vif", vif))
      `uvm_fatal("S_DRV", "Cannot access APB interface");

    // Create slave BFM for signal-level driving
    sbfm = apb_slave_bfm::type_id::create("sbfm", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    sbfm.slave();
    end
    
  endtask


endclass

