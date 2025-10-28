class controller_agent extends uvm_agent;
`uvm_component_utils(controller_agent)

controller_monitor c_mon;
controller_bfm c_bfm;

function new(string name="controller_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	c_bfm= controller_bfm::type_id::create("c_bfm",this);
	c_mon= controller_monitor::type_id::create("c_mon",this);
endfunction

endclass
