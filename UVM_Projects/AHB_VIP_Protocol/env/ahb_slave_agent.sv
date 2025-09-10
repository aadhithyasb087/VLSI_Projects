class ahb_slave_agent extends uvm_agent;

`uvm_component_utils(ahb_slave_agent)


ahb_slave_monitor s_mon;
ahb_slave_bfm s_bfm;


//-----------new method-------------//

function new(string name="ahb_slave_monitor" ,uvm_component parent);
	super.new(name,parent);
endfunction

//-------------build_phase------------//

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	s_mon=ahb_slave_monitor::type_id::create("s_mon",this);
	s_bfm=ahb_slave_bfm::type_id::create("s_bfm",this);	
endfunction

endclass

