class apb_slave_agent extends uvm_agent;
	`uvm_component_utils(apb_slave_agent)

	apb_slave_monitor s_mon;
	

	function new(string name="apb_slave_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info("apb_slave_agent","in apb_slave_agent build phase",UVM_NONE)
		s_mon=apb_slave_monitor::type_id::create("s_mon",this);
                
	endfunction

endclass	
