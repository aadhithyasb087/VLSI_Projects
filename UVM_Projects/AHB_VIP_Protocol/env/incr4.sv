class incr4 extends uvm_test;

`uvm_component_utils(incr4)
ahb_seq seq;
env envh;

function new(string name="incr4",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
seq=ahb_seq::type_id::create("seq");
envh=env::type_id::create("envh",this);

uvm_config_db#(int)::set(null,"incr4","pkt_size",20);
set_config_string("envh.m_agt.m_seqr","str_cfg","incr4");

endfunction

task run_phase(uvm_phase phase);

	phase.raise_objection(this);
	seq.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);
endtask
endclass

