class apb_master_agent extends uvm_agent;
	`uvm_component_utils(apb_master_agent)

	apb_master_driver m_drv;
	apb_master_monitor m_mon;
	apb_master_sequencer m_seqr;

	function new(string name="apb_master_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info("apb_master_agent","in apb_master_agent build phase",UVM_LOW)
		m_drv=apb_master_driver::type_id::create("m_drv",this);
		m_mon=apb_master_monitor::type_id::create("m_mon",this);
		m_seqr=apb_master_sequencer::type_id::create("m_seqr",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		`uvm_info("apb_master_agent","in apb_master_agent connect phase",UVM_LOW)
		m_drv.seq_item_port.connect(m_seqr.seq_item_export);
	endfunction

endclass
