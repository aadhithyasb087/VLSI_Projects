class router_op_seqr extends uvm_sequencer#(op_xtn);
  `uvm_component_utils(router_op_seqr)

  extern function new(string name="router_op_seqr",uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass
//----------------------------------------------------------------------------------------------------------
function router_op_seqr::new(string name="router_op_seqr",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_op_seqr::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
endfunction
