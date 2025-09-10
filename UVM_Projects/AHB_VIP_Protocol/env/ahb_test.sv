class ahb_test extends uvm_test;

`uvm_component_utils(ahb_test)
ahb_env env_h;
//-----------new method-------------//
function new(string name="ahb_test" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction

//-------------build_phase------------//
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

	env_h=ahb_env::type_id::create("env_h",this);	
	
endfunction

endclass

//--------------test_case_simple--------//
class test0 extends ahb_test;
`uvm_component_utils(test0)
seq0 seqh0;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction
//------------run_phase------------//
task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh0=seq0::type_id::create("seqh1");       //creating object for sequence
	seqh0.start(env_h.m_agt.m_seqr);			//starting the sequence
	#160;
    #160;
    phase.drop_objection(this);

endtask
endclass

//--------------test_case_incr4--------//
class test1 extends ahb_test;
`uvm_component_utils(test1)
seq1 seqh1;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction
//------------run_phase------------//
task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh1=seq1::type_id::create("seqh1");       //creating object for sequence
	seqh1.start(env_h.m_agt.m_seqr);			//starting the sequence
    #160;
    phase.drop_objection(this);

endtask
endclass

//--------------test_case_wrap4--------//

class test2 extends ahb_test;
`uvm_component_utils(test2)
seq2 seqh2;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh2=seq2::type_id::create("seqh2");		//creating the sequence for increment
	seqh2.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//--------------test_case_incr8--------//

class test3 extends ahb_test;
`uvm_component_utils(test3)
seq3 seqh3;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh3=seq3::type_id::create("seqh3");   		//creating sequence for wrap
	seqh3.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//--------------test_case_wrap8--------//

class test4 extends ahb_test;
`uvm_component_utils(test4)
seq4 seqh4;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh4=seq4::type_id::create("seqh4");
	seqh4.start(env_h.m_agt.m_seqr);
#160;
    phase.drop_objection(this);

endtask
endclass

//----------------test_case_incr16---------------//
class test5 extends ahb_test;
`uvm_component_utils(test5)
seq5 seqh5;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh5=seq5::type_id::create("seqh5");
	seqh5.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//-------------------test_case_wrap16--------------//
class test6 extends ahb_test;
`uvm_component_utils(test6)
seq6 seqh6;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh6=seq6::type_id::create("seqh6");
	seqh6.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//----------------------test_case_incr4 hw----------------//
class test7 extends ahb_test;
`uvm_component_utils(test7)
seq7 seqh7;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh7=seq7::type_id::create("seqh7");
	seqh7.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//-------------------test_case w4 hw---------------//
class test8 extends ahb_test;
`uvm_component_utils(test8)
seq8 seqh8;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh8=seq8::type_id::create("seqh8");
	seqh8.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//----------------test_case_i8 hw------------//
class test9 extends ahb_test;
`uvm_component_utils(test9)
seq9 seqh9;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh9=seq9::type_id::create("seqh9");
	seqh9.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_w8 hw------------//
class test10 extends ahb_test;
`uvm_component_utils(test10)
seq10 seqh10;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh10=seq10::type_id::create("seqh10");
	seqh10.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_i16 hw------------//
class test11 extends ahb_test;
`uvm_component_utils(test11)
seq11 seqh11;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh11=seq11::type_id::create("seqh11");
	seqh11.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_w16 hw------------//
class test12 extends ahb_test;
`uvm_component_utils(test12)
seq12 seqh12;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh12=seq12::type_id::create("seqh12");
	seqh12.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_i4 w------------//
class test13 extends ahb_test;
`uvm_component_utils(test13)
seq13 seqh13;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh13=seq13::type_id::create("seqh13");
	seqh13.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_w4 w------------//
class test14 extends ahb_test;
`uvm_component_utils(test14)
seq14 seqh14;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh14=seq14::type_id::create("seqh14");
	seqh14.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_i8 w------------//
class test15 extends ahb_test;
`uvm_component_utils(test15)
seq15 seqh15;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh15=seq15::type_id::create("seqh15");
	seqh15.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_w8 w------------//
class test16 extends ahb_test;
`uvm_component_utils(test16)
seq16 seqh16;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh16=seq16::type_id::create("seqh16");
	seqh16.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass


//----------------test_case_i16 w------------//
class test17 extends ahb_test;
`uvm_component_utils(test17)
seq17 seqh17;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh17=seq17::type_id::create("seqh17");
	seqh17.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass

//----------------test_case_w16 w------------//
class test18 extends ahb_test;
`uvm_component_utils(test18)
seq18 seqh18;

function new(string name="" ,uvm_component parent=null);
	super.new(name,parent);	
endfunction
function void  build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqh18=seq18::type_id::create("seqh18");
	seqh18.start(env_h.m_agt.m_seqr);
    #160;
    phase.drop_objection(this);

endtask
endclass
