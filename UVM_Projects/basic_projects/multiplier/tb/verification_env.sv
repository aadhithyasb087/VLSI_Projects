

//---------------------------
// Interface for DUT
//---------------------------
interface mul_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [7:0] y;
endinterface



//---------------------------
// UVM Declarations
//---------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------
// Transaction
//---------------------------
class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)

  rand bit [3:0] a;
  rand bit [3:0] b;
  bit [7:0] y;

  function new(string name = "transaction");
    super.new(name);
  endfunction
endclass



//---------------------------
// Generator (Sequence)
//---------------------------
class generator extends uvm_sequence #(transaction);
  `uvm_object_utils(generator)

  function new(string name = "generator");
    super.new(name);
  endfunction

  virtual task body();
    transaction tr;
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      `uvm_info("GEN", $sformatf("Generated: a=%0d b=%0d", tr.a, tr.b), UVM_LOW);
      finish_item(tr);
    end
  endtask
endclass



//---------------------------
// Driver
//---------------------------
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

  virtual mul_if mif;

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual mul_if)::get(this, "", "mif", mif))
      `uvm_error("DRV", "Unable to get interface");
  endfunction

  virtual task run_phase(uvm_phase phase);
    transaction tr;
    forever begin
      seq_item_port.get_next_item(tr);
      mif.a <= tr.a;
      mif.b <= tr.b;
      `uvm_info("DRV", $sformatf("Driving: a=%0d b=%0d", tr.a, tr.b), UVM_LOW);
      seq_item_port.item_done();
      #20;
    end
  endtask
endclass



//---------------------------
// Monitor
//---------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual mul_if mif;
  uvm_analysis_port #(transaction) send;

  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual mul_if)::get(this, "", "mif", mif))
      `uvm_error("MON", "Unable to get interface");
  endfunction

  virtual task run_phase(uvm_phase phase);
    transaction tr;
    forever begin
      #20;
      tr = transaction::type_id::create("tr");
      tr.a = mif.a;
      tr.b = mif.b;
      tr.y = mif.y;
      `uvm_info("MON", $sformatf("Monitored: a=%0d b=%0d y=%0d", tr.a, tr.b, tr.y), UVM_LOW);
      send.write(tr);
    end
  endtask
endclass



//---------------------------
// Scoreboard
//---------------------------
class sb extends uvm_scoreboard;
  `uvm_component_utils(sb)

  uvm_analysis_imp #(transaction, sb) rcv;

  function new(string name = "sb", uvm_component parent);
    super.new(name, parent);
    rcv = new("rcv", this);
  endfunction

virtual function void write(transaction tr);
  if (tr.y == (tr.a * tr.b)) begin
    `uvm_info("SB", $sformatf("PASS: a=%0d b=%0d y=%0d", tr.a, tr.b, tr.y), UVM_LOW);
  end else begin
    `uvm_error("SB", $sformatf("FAIL: a=%0d b=%0d y=%0d", tr.a, tr.b, tr.y));
  end
endfunction
  endclass



//---------------------------
// Agent
//---------------------------
class agent extends uvm_agent;
  `uvm_component_utils(agent)

  driver drv;
  monitor mon;
  uvm_sequencer #(transaction) sqr;

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
    sqr = uvm_sequencer#(transaction)::type_id::create("sqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass



//---------------------------
// Environment
//---------------------------
class env extends uvm_env;
  `uvm_component_utils(env)

  agent ag;
  sb sbh;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag = agent::type_id::create("ag", this);
    sbh = sb::type_id::create("sbh", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ag.mon.send.connect(sbh.rcv);
  endfunction
endclass



//---------------------------
// Test
//---------------------------
class test extends uvm_test;
  `uvm_component_utils(test)

  env envh;
  generator gen;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = env::type_id::create("envh", this);
    gen = generator::type_id::create("gen", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(envh.ag.sqr);
    #100;
    phase.drop_objection(this);
  endtask
endclass



//---------------------------
// Top-level Testbench
//---------------------------
module tb;

  // Interface instantiation
  mul_if mif();

  // DUT instantiation
  multiplier dut (
    .a(mif.a),
    .b(mif.b),
    .y(mif.y)
  );

  // UVM configuration and test start
  initial begin
    uvm_config_db #(virtual mul_if)::set(null, "*", "mif", mif);
    run_test("test");
  end

  // VCD Dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule

