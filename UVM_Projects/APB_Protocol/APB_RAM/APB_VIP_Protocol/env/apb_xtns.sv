class apb_xtns extends uvm_sequence_item;

 // Fields
  bit        pclk;    
  bit        presetn;
  rand bit [31:0] paddr;    // Randomizable address
  bit        pwrite;
  rand bit [31:0] pwdata;   // Randomizable write data
  bit        psel;
  bit        penable;
  bit [31:0] prdata;
  bit        pready;
  bit        pslverr;


  // Register class with factory and field automation
  `uvm_object_utils_begin(apb_xtns)
    `uvm_field_int(pclk,    UVM_DEFAULT)    
    `uvm_field_int(presetn, UVM_DEFAULT)    
    `uvm_field_int(paddr,   UVM_DEFAULT)    // Rand field
    `uvm_field_int(pwrite,  UVM_DEFAULT)    // Control signal
    `uvm_field_int(pwdata,  UVM_DEFAULT)    // Rand field
    `uvm_field_int(psel,    UVM_DEFAULT)
    `uvm_field_int(penable, UVM_DEFAULT)
    `uvm_field_int(prdata,  UVM_DEFAULT)
    `uvm_field_int(pready,  UVM_DEFAULT)
    `uvm_field_int(pslverr, UVM_DEFAULT)
  `uvm_object_utils_end

 
  // Constructor
  function new(string name = "apb_xtn");
    super.new(name);
  endfunction

  // Address constraint (example: keep in 32-bit range)
  constraint addr_c { paddr inside {[0:32]}; }

endclass

