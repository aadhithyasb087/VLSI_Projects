// Base test class already provided
class uart_test extends uvm_test;
  `uvm_component_utils(uart_test)

  function new(input string inst = "test", uvm_component c);
    super.new(inst, c);
  endfunction

  uart_env e;
  rand_baud rb;
  rand_baud_with_stop rbs;
  rand_baud_len5p rb5l;
  rand_baud_len6p rb6l;
  rand_baud_len7p rb7l;
  rand_baud_len8p rb8l;

  rand_baud_len5 rb5lwop;
  rand_baud_len6 rb6lwop;
  rand_baud_len7 rb7lwop;
  rand_baud_len8 rb8lwop;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e       = uart_env::type_id::create("env", this);
    rb      = rand_baud::type_id::create("rb");
    rbs     = rand_baud_with_stop::type_id::create("rbs");

    rb5l    = rand_baud_len5p::type_id::create("rb5l");
    rb6l    = rand_baud_len6p::type_id::create("rb6l");
    rb7l    = rand_baud_len7p::type_id::create("rb7l");
    rb8l    = rand_baud_len8p::type_id::create("rb8l");

    rb5lwop = rand_baud_len5::type_id::create("rb5lwop");
    rb6lwop = rand_baud_len6::type_id::create("rb6lwop");
    rb7lwop = rand_baud_len7::type_id::create("rb7lwop");
    rb8lwop = rand_baud_len8::type_id::create("rb8lwop");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb8lwop.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

// Individual test classes
class test_rb extends uart_test;
  `uvm_component_utils(test_rb)
  function new(string name = "test_rb", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rbs extends uart_test;
  `uvm_component_utils(test_rbs)
  function new(string name = "test_rbs", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rbs.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb5l extends uart_test;
  `uvm_component_utils(test_rb5l)
  function new(string name = "test_rb5l", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb5l.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb6l extends uart_test;
  `uvm_component_utils(test_rb6l)
  function new(string name = "test_rb6l", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb6l.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb7l extends uart_test;
  `uvm_component_utils(test_rb7l)
  function new(string name = "test_rb7l", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb7l.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb8l extends uart_test;
  `uvm_component_utils(test_rb8l)
  function new(string name = "test_rb8l", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb8l.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb5lwop extends uart_test;
  `uvm_component_utils(test_rb5lwop)
  function new(string name = "test_rb5lwop", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb5lwop.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb6lwop extends uart_test;
  `uvm_component_utils(test_rb6lwop)
  function new(string name = "test_rb6lwop", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb6lwop.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb7lwop extends uart_test;
  `uvm_component_utils(test_rb7lwop)
  function new(string name = "test_rb7lwop", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb7lwop.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass

class test_rb8lwop extends uart_test;
  `uvm_component_utils(test_rb8lwop)
  function new(string name = "test_rb8lwop", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rb8lwop.start(e.agent.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
