class slv_seqr extends uvm_sequencer;
  `uvm_component_utils(slv_seqr)

  extern function new(string name="slv_seqr",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function slv_seqr::new(string name="slv_seqr",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void slv_seqr::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
endfunction
//----------------------------------------------------------------------------
