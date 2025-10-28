// -----------------------------------------------------------------
// Base sequence that sends a single nvme_txn via start_item/finish_item
// -----------------------------------------------------------------
class nvme_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(nvme_seq)

  // optional: allow setting a template cmd before body() runs
  nvme_cmd_s cmd;

  function new(string name="nvme_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn;
    txn = nvme_txn::type_id::create("txn");
    txn.cmd = cmd;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 1: I/O Write & Read
// -------------------------
class io_rw_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(io_rw_seq)

  function new(string name="io_rw_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn;

    // WRITE
    txn = nvme_txn::type_id::create("write_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_WRITE;
    txn.cmd.cid    = 16'h1;
    txn.cmd.prp1   = 64'h0000_1000;
    txn.cmd.nlb    = 1;
    start_item(txn);
    finish_item(txn);

    // READ
    txn = nvme_txn::type_id::create("read_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_READ;
    txn.cmd.cid    = 16'h1;
    txn.cmd.prp1   = 64'h0000_1000;
    txn.cmd.nlb    = 1;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 2: Admin Commands (Create/Delete)
// -------------------------
class admin_cmds_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(admin_cmds_seq)

  function new(string name="admin_cmds_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn;

    // Create I/O CQ
    txn = nvme_txn::type_id::create("create_cq");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_CREATE_IO_CQ;
    txn.cmd.cid    = 8'h10;
    txn.cmd.prp1   = 64'h0000_2000;
    start_item(txn);
    finish_item(txn);

    // Create I/O SQ
    txn = nvme_txn::type_id::create("create_sq");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_CREATE_IO_SQ;
    txn.cmd.cid    = 8'h11;
    txn.cmd.prp1   = 64'h0000_3000;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 3: Controller init (Identify)
// -------------------------
class init_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(init_seq)

  function new(string name="init_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("identify_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_IDENTIFY;
    txn.cmd.cid    = 16'h0;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 4: Shutdown (normal / abrupt skeleton)
// -------------------------
class shutdown_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(shutdown_seq)

  function new(string name="shutdown_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("shutdown_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_SHUTDOWN;
    txn.cmd.cid    = 16'h5;
    start_item(txn);
    finish_item(txn);

    // If you want the test to perform an "abrupt" reset, have the test that started this sequence
    // assert reset or call a top-level task after seq completes.
  endtask
endclass


// -------------------------
// seq 5: Register file read/write
// -------------------------
class regfile_rw_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(regfile_rw_seq)

  function new(string name="regfile_rw_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("regfile_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_GET_LOG_PAGE; // used here to model reg read/write
    txn.cmd.cid    = 16'h7;
    txn.cmd.prp1   = 64'h0000_4000;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 6: Arbitration (multiple outstanding commands)
// -------------------------
class arbitration_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(arbitration_seq)

  function new(string name="arbitration_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn;
    for (int i=0; i<8; i++) begin
      txn = nvme_txn::type_id::create($sformatf("arb_txn_%0d", i));
      txn.cmd = '0;
      txn.cmd.opcode = (i % 2) ? nvme_pkg::OPC_READ : nvme_pkg::OPC_WRITE;
      txn.cmd.cid    = i;
      txn.cmd.prp1   = 64'h0000_1000 + i*64;
      txn.cmd.flags  = i; // pseudo-priority field for arbitration modelling
      start_item(txn);
      finish_item(txn);
    end
  endtask
endclass


// -------------------------
// seq 7: Abort limit exceeded
// -------------------------
class abort_limit_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(abort_limit_seq)

  function new(string name="abort_limit_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn;
    for (int i=0; i<20; i++) begin
      txn = nvme_txn::type_id::create($sformatf("abort_txn_%0d", i));
      txn.cmd = '0;
      txn.cmd.opcode = nvme_pkg::OPC_ADMIN_ABORT;
      txn.cmd.cid    = i[15:0];
      start_item(txn);
      finish_item(txn);
    end
  endtask
endclass


// -------------------------
// seq 8: Create IO SQ with invalid QID
// -------------------------
class create_io_sq_invalid_qid_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(create_io_sq_invalid_qid_seq)

  function new(string name="create_io_sq_invalid_qid_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("create_sq_invalid_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_CREATE_IO_SQ;
    txn.cmd.cid    = 16'h22;
    txn.cmd.prp1   = 64'h0;
    txn.cmd.flags  = 8'hFF; // intentionally invalid
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 9: Delete non-existent CQ
// -------------------------
class delete_nonexist_cq_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(delete_nonexist_cq_seq)

  function new(string name="delete_nonexist_cq_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("del_cq_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_DELETE_IO_CQ;
    txn.cmd.cid    = 16'h77;
    start_item(txn);
    finish_item(txn);
  endtask
endclass


// -------------------------
// seq 10: Delete non-existent SQ
// -------------------------
class delete_nonexist_sq_seq extends uvm_sequence#(nvme_txn);
  `uvm_object_utils(delete_nonexist_sq_seq)

  function new(string name="delete_nonexist_sq_seq");
    super.new(name);
  endfunction

  task body();
    nvme_txn txn = nvme_txn::type_id::create("del_sq_txn");
    txn.cmd = '0;
    txn.cmd.opcode = nvme_pkg::OPC_ADMIN_DELETE_IO_SQ;
    txn.cmd.cid    = 16'h78;
    start_item(txn);
    finish_item(txn);
  endtask
endclass

