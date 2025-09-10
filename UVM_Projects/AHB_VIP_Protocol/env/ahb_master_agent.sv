class ahb_master_agent extends uvm_agent;

`uvm_component_utils(ahb_master_agent)

ahb_master_driver m_drv;
ahb_master_monitor m_mon;
ahb_master_sequencer m_seqr;

function new(string name="ahb_master_agent" ,uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	m_drv=ahb_master_driver::type_id::create("m_drv",this);
	m_mon=ahb_master_monitor::type_id::create("m_mon",this);
	m_seqr=ahb_master_sequencer::type_id::create("m_seqr",this);
		
endfunction

function void connect_phase(uvm_phase phase);
	m_drv.seq_item_port.connect(m_seqr.seq_item_export);
endfunction

endclass

