class host_seqr extends uvm_sequencer #(nvme_txn);
`uvm_component_utils(host_seqr)

function new(string name="host_seqr",uvm_component parent=null);
	super.new(name,parent);
endfunction

endclass
