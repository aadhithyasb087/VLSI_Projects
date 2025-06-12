class op_xtn extends uvm_sequence_item;
  `uvm_object_utils_begin(op_xtn)
   `uvm_field_int(header,UVM_ALL_ON)
   `uvm_field_array_int(payload,UVM_ALL_ON)
   `uvm_field_int(parity,UVM_ALL_ON)
   `uvm_field_int(no_of_cycles,UVM_ALL_ON)
   `uvm_object_utils_end

  bit[7:0] header;
  bit[7:0] payload[];
  bit[7:0] parity;
  rand static int no_of_cycles;
  extern function new(string name="op_xtn");

endclass

function op_xtn::new(string name="op_xtn");
  super.new(name);
endfunction
