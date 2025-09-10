class ahb_env extends uvm_env;

`uvm_component_utils(ahb_env)
ahb_sb sb_h;

ahb_master_agent m_agt;
ahb_slave_agent s_agt;
function new(string name="ahb_env", uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
 	super.build_phase(phase);

	m_agt=ahb_master_agent::type_id::create("m_agt",this);
	s_agt=ahb_slave_agent::type_id::create("s_agt",this);
	sb_h=ahb_sb::type_id::create("sb_h",this);
endfunction

function void connect_phase(uvm_phase phase);
	m_agt.m_mon.m_ap.connect(sb_h.m_fifo.analysis_export);
	s_agt.s_mon.s_ap.connect(sb_h.s_fifo.analysis_export);
endfunction
task run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask

endclass

