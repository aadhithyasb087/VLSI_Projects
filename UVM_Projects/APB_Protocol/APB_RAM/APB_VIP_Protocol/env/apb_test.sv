// Top-level APB test class
class apb_test extends uvm_test;
    `uvm_component_utils(apb_test)

    apb_env env; 

    // Constructor
    function new(string name="apb_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: create environment
    function void build_phase(uvm_phase phase);
        `uvm_info("apb_test","In apb_test build phase",UVM_NONE)
        env = apb_env::type_id::create("env",this);
    endfunction

    // Run phase: print UVM topology for debugging
    task run_phase(uvm_phase phase);
        `uvm_info("apb_test","In apb_test run phase",UVM_NONE)
        uvm_top.print_topology();
    endtask
endclass

//---------------------------------------------
// Single write test
class test1 extends apb_test;
    `uvm_component_utils(test1)

    single_write t1; 

    function new(string name="test1", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        // Create sequence
        t1 = single_write::type_id::create("t1");
        // Raise objection to prevent end-of-run
        phase.raise_objection(this);
        t1.start(env.m_agt.m_seqr); // Start sequence on agent sequencer
	#100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Single read test
class test2 extends apb_test;
    `uvm_component_utils(test2)

    single_read t2; 

    function new(string name="test2", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t2 = single_read::type_id::create("t2");
        phase.raise_objection(this);
        t2.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple write test
class test3 extends apb_test;
    `uvm_component_utils(test3)

    multiple_write t3; 

    function new(string name="test3", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t3 = multiple_write::type_id::create("t3");
        phase.raise_objection(this);
        t3.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass


//---------------------------------------------
// Multiple read test
class test4 extends apb_test;
    `uvm_component_utils(test4)

    multiple_read t4; 

    function new(string name="test4", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t4 = multiple_read::type_id::create("t4");
        phase.raise_objection(this);
        t4.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple read same address test
class test5 extends apb_test;
    `uvm_component_utils(test5)

    mult_rd_same_aadr t5; 

    function new(string name="test5", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t5 = mult_rd_same_aadr::type_id::create("t5");
        phase.raise_objection(this);
        t5.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple write odd address with odd data test
class test6 extends apb_test;
    `uvm_component_utils(test6)

    mult_wr_odd_aadr_odd_data t6; 

    function new(string name="test6", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t6 = mult_wr_odd_aadr_odd_data::type_id::create("t6");
        phase.raise_objection(this);
        t6.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple write even address with even data test
class test7 extends apb_test;
    `uvm_component_utils(test7)

    mult_wr_even_aadr_even_data t7; 

    function new(string name="test7", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t7 = mult_wr_even_aadr_even_data::type_id::create("t7");
        phase.raise_objection(this);
        t7.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Single write-read test
class test8 extends apb_test;
    `uvm_component_utils(test8)

    single_write_read t8; 

    function new(string name="test8", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t8 = single_write_read::type_id::create("t8");
        phase.raise_objection(this);
        t8.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple write-read test
class test9 extends apb_test;
    `uvm_component_utils(test9)

    multiple_write_read t9; 

    function new(string name="test9", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t9 = multiple_write_read::type_id::create("t9");
        phase.raise_objection(this);
        t9.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Bulk write-read test
class test10 extends apb_test;
    `uvm_component_utils(test10)

    write_read_bulk t10; 

    function new(string name="test10", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t10 = write_read_bulk::type_id::create("t10");
        phase.raise_objection(this);
        t10.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Write error test
class test11 extends apb_test;
    `uvm_component_utils(test11)

    write_err t11; 

    function new(string name="test11", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t11 = write_err::type_id::create("t11");
        phase.raise_objection(this);
        t11.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Read error test
class test12 extends apb_test;
    `uvm_component_utils(test12)

    read_err t12; 

    function new(string name="test12", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t12 = read_err::type_id::create("t12");
        phase.raise_objection(this);
        t12.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

//---------------------------------------------
// Multiple write same address test
class test13 extends apb_test;
    `uvm_component_utils(test13)

    mult_wr_same_aadr t13; 

    function new(string name="test17", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        t13 = mult_wr_same_aadr::type_id::create("t13");
        phase.raise_objection(this);
        t13.start(env.m_agt.m_seqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

