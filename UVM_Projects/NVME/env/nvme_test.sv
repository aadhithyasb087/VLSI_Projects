// Base test class
class nvme_test_base extends uvm_test;
  `uvm_component_utils(nvme_test_base)

  nvme_env env;

  function new(string name = "nvme_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // create environment in build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Building nvme test environment", UVM_LOW)
    env = nvme_env::type_id::create("env", this);
  endfunction

  // print topology; tests may override run_phase to perform sequences
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "nvme_test_base run_phase - printing topology", UVM_LOW)
    uvm_top.print_topology();
  endtask

endclass : nvme_test_base


// -------------------------
// Test 1: I/O Write & Read
// -------------------------
class test_io_rw extends nvme_test_base;
  `uvm_component_utils(test_io_rw)
  io_rw_seq seq;

  function new(string name="test_io_rw", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = io_rw_seq::type_id::create("io_rw_seq");
    `uvm_info(get_type_name(), "Starting io_rw_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #200;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 2: Admin Commands (Create/Delete)
// -------------------------
class test_admin_cmds extends nvme_test_base;
  `uvm_component_utils(test_admin_cmds)
  admin_cmds_seq seq;
  
  function new(string name="test_admin_cmds", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = admin_cmds_seq::type_id::create("admin_cmds_seq");
    `uvm_info(get_type_name(), "Starting admin_cmds_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #200;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 3: Controller init (Identify)
// -------------------------
class test_init extends nvme_test_base;
  `uvm_component_utils(test_init)

init_seq seq;

  function new(string name="test_init", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = init_seq::type_id::create("init_seq");
    `uvm_info(get_type_name(), "Starting init_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #100;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 4: Shutdown (normal & abrupt skeleton)
// -------------------------
class test_shutdown extends nvme_test_base;
  `uvm_component_utils(test_shutdown)
  shutdown_seq seq;
  function new(string name="test_shutdown", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = shutdown_seq::type_id::create("shutdown_seq");
    `uvm_info(get_type_name(), "Starting shutdown_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    // If you want an abrupt reset, do it from tb_top or add a call to a top-level task here.
    #200;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 5: Register file read/write
// -------------------------
class test_regfile_rw extends nvme_test_base;
  `uvm_component_utils(test_regfile_rw)
  regfile_rw_seq seq;
  function new(string name="test_regfile_rw", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = regfile_rw_seq::type_id::create("regfile_rw_seq");
    `uvm_info(get_type_name(), "Starting regfile_rw_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #100;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 6: Arbitration (multiple outstanding commands)
// -------------------------
class test_arbitration extends nvme_test_base;
  `uvm_component_utils(test_arbitration)
  arbitration_seq seq;
  function new(string name="test_arbitration", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = arbitration_seq::type_id::create("arbitration_seq");
    `uvm_info(get_type_name(), "Starting arbitration_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #500;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 7: Abort limit exceeded
// -------------------------
class test_abort_limit extends nvme_test_base;
  `uvm_component_utils(test_abort_limit)
  abort_limit_seq seq;
  
  function new(string name="test_abort_limit", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = abort_limit_seq::type_id::create("abort_limit_seq");
    `uvm_info(get_type_name(), "Starting abort_limit_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #500;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 8: Create IO SQ with invalid QID
// -------------------------
class test_create_io_sq_invalid_qid extends nvme_test_base;
  `uvm_component_utils(test_create_io_sq_invalid_qid)
  create_io_sq_invalid_qid_seq seq;
  
  function new(string name="test_create_io_sq_invalid_qid", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = create_io_sq_invalid_qid_seq::type_id::create("create_io_sq_invalid_qid_seq");
    `uvm_info(get_type_name(), "Starting create_io_sq_invalid_qid_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #200;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 9: Delete non-existent CQ
// -------------------------
class test_delete_nonexist_cq extends nvme_test_base;
  `uvm_component_utils(test_delete_nonexist_cq)
  delete_nonexist_cq_seq seq;
  
  function new(string name="test_delete_nonexist_cq", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = delete_nonexist_cq_seq::type_id::create("delete_nonexist_cq_seq");
    `uvm_info(get_type_name(), "Starting delete_nonexist_cq_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #200;
    phase.drop_objection(this);
  endtask
endclass


// -------------------------
// Test 10: Delete non-existent SQ
// -------------------------
class test_delete_nonexist_sq extends nvme_test_base;
  `uvm_component_utils(test_delete_nonexist_sq)
  delete_nonexist_sq_seq seq;
  
  function new(string name="test_delete_nonexist_sq", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = delete_nonexist_sq_seq::type_id::create("delete_nonexist_sq_seq");
    `uvm_info(get_type_name(), "Starting delete_nonexist_sq_seq", UVM_LOW)
    seq.start(env.hostag.m_seqr);

    #200;
    phase.drop_objection(this);
  endtask
endclass

