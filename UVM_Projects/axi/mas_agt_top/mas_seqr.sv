class mas_seqr extends uvm_sequencer#(axi_xtn);
  `uvm_component_utils(mas_seqr)

  extern function new(string name="mas_seqr",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function mas_seqr::new(string name="mas_seqr",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void mas_seqr::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
endfunction
//----------------------------------------------------------------------------
