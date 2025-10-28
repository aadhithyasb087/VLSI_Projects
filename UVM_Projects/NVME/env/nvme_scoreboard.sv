class nvme_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(nvme_scoreboard)

  // FIFOs for cmds & completions
  uvm_tlm_analysis_fifo #(nvme_txn) cmd_fifo;
  uvm_tlm_analysis_fifo #(nvme_txn) cpl_fifo;


  function new(string name="nvme_scoreboard", uvm_component parent=null);
    super.new(name,parent);
    cmd_fifo = new("cmd_fifo", this);
    cpl_fifo = new("cpl_fifo", this);
  endfunction

//--------------------build_phase-------------------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

  task run_phase(uvm_phase phase);
    
    forever begin
      nvme_txn cmd_tr;
      nvme_txn cpl_tr;
      nvme_cpl_s cpl;

      // get next cmd + next completion (blocking until both are available)
      fork
      cmd_fifo.get(cmd_tr);
      cpl_fifo.get(cpl_tr);
      join
      `uvm_info("SCB", $sformatf("Observed CMD: CID=%0d OPC=0x%0h PRP1=0x%0h",
                        cmd_tr.cmd.cid, cmd_tr.cmd.opcode, cmd_tr.cmd.prp1), UVM_MEDIUM)
      // extract completion
      cpl = cpl_tr.expected_cqe_bits;

      // match by CID
      if (cpl.cid != cmd_tr.cmd.cid) begin
        `uvm_error("SBD", $sformatf("CID mismatch: CMD cid=%0d CPL cid=%0d",
                                    cmd_tr.cmd.cid, cpl.cid))
      end else begin
        // opcode-based verification
        case (cmd_tr.cmd.opcode)

  // ---------------- I/O Command Set ----------------
  OPC_FLUSH: begin
    if (cpl.status != 0)
      `uvm_error("SBD", "FLUSH failed when success expected")
    else
      `uvm_info("SBD", $sformatf("FLUSH verified for cid=%0d", cpl.cid), UVM_LOW)
  end

  OPC_WRITE: begin
    if (cpl.status != 0)
      `uvm_error("SBD", "WRITE failed when success expected")
    else
      `uvm_info("SBD", $sformatf("WRITE verified for cid=%0d", cpl.cid), UVM_LOW)
  end

  OPC_READ: begin
    if (cpl.status != 0)
      `uvm_error("SBD", "READ failed when success expected")
    else
      `uvm_info("SBD", $sformatf("READ verified for cid=%0d", cpl.cid), UVM_LOW)
  end

  // ---------------- Admin Command Set ----------------
  OPC_ADMIN_IDENTIFY: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Controller IDENTIFY response verified", UVM_LOW)
    else
      `uvm_error("SBD", "IDENTIFY failed with non-zero status")
  end

  OPC_ADMIN_CREATE_IO_CQ: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Create IO CQ verified", UVM_LOW)
    else
      `uvm_error("SBD", "Create IO CQ failed")
  end

  OPC_ADMIN_CREATE_IO_SQ: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Create IO SQ verified", UVM_LOW)
    else
      `uvm_error("SBD", "Create IO SQ failed")
  end

  OPC_ADMIN_DELETE_IO_CQ: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Delete IO CQ verified", UVM_LOW)
    else
      `uvm_error("SBD", "Delete IO CQ failed")
  end

  OPC_ADMIN_DELETE_IO_SQ: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Delete IO SQ verified", UVM_LOW)
    else
      `uvm_error("SBD", "Delete IO SQ failed")
  end

  OPC_ADMIN_ABORT: begin
    if (cpl.status == 16'h0)
      `uvm_info("SBD", "Abort accepted", UVM_LOW)
    else
      `uvm_error("SBD", $sformatf("Abort command failed, status=%0h", cpl.status))
  end

  OPC_ADMIN_SHUTDOWN: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "Controller SHUTDOWN completion verified", UVM_LOW)
    else
      `uvm_error("SBD", "Controller SHUTDOWN failed with non-zero status")
  end

  OPC_ADMIN_GET_LOG_PAGE: begin
    if (cpl.status == 0)
      `uvm_info("SBD", "GET LOG PAGE verified", UVM_LOW)
    else
      `uvm_error("SBD", "GET LOG PAGE failed")
  end

  default: begin
    `uvm_warning("SBD",
      $sformatf("Opcode 0x%0h not specifically checked, status=%0h",
                cmd_tr.cmd.opcode, cpl.status))
  end

endcase
      end
    end
  endtask
endclass

