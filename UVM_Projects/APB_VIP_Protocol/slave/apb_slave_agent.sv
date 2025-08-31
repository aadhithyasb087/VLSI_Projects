class apb_slave_agent extends uvm_agent;
	`uvm_component_utils(apb_slave_agent)

	apb_slave_driver s_drv;
	apb_slave_monitor s_mon;
	apb_slave_sequencer s_seqr;

	function new(string name="apb_slave_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info("apb_slave_agent","in apb_slave_agent build phase",UVM_NONE)
		s_drv=apb_slave_driver::type_id::create("s_drv",this);
		s_mon=apb_slave_monitor::type_id::create("s_mon",this);
		s_seqr=apb_slave_sequencer::type_id::create("s_seqr",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		`uvm_info("apb_slave_agent","in apb_slave_agent connect phase",UVM_NONE)
		s_drv.seq_item_port.connect(s_seqr.seq_item_export);
	endfunction

endclass	
