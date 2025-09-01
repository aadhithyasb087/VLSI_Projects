// Base sequence class for all APB transactions
class apb_seq_base extends uvm_sequence #(apb_xtns);
  `uvm_object_utils(apb_seq_base)
  apb_xtns xtn;
  function new(string name = "apb_seq_base");
    super.new(name);
  endfunction
endclass


// Single write transaction
class single_write extends apb_seq_base;
  `uvm_object_utils(single_write)

  function new(string name = "single_write");
    super.new(name);
  endfunction

  virtual task body();
    xtn = apb_xtns::type_id::create("xtn");
    start_item(xtn);
    assert(xtn.randomize());
    xtn.pwrite = 1; // Write transaction
    finish_item(xtn);
  endtask
endclass


// Single read transaction
class single_read extends apb_seq_base;
  `uvm_object_utils(single_read)

  function new(string name = "single_read");
    super.new(name);
  endfunction

  virtual task body();
    xtn = apb_xtns::type_id::create("xtn");
    start_item(xtn);
    assert(xtn.randomize());
    xtn.pwrite = 0; // Read transaction
    finish_item(xtn);
  endtask
endclass


// Multiple write transactions (random addresses)
class multiple_write extends apb_seq_base;
  `uvm_object_utils(multiple_write)

  function new(string name = "multiple_write");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass

// Multiple write transactions with same address
class resetn extends apb_seq_base;
  `uvm_object_utils(resetn)

  function new(string name = "resetn");
    super.new(name);
  endfunction

  virtual task body();
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.presetn = 0;
      xtn.rst = 0;
      finish_item(xtn);
  endtask
endclass


// Multiple write transactions with same address
class mult_wr_same_aadr extends apb_seq_base;
  `uvm_object_utils(mult_wr_same_aadr)

  function new(string name = "mult_wr_same_aadr");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr == 32'b1; });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple read transactions (random addresses)
class multiple_read extends apb_seq_base;
  `uvm_object_utils(multiple_read)

  function new(string name = "multiple_read");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 0;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple read transactions with same address
class mult_rd_same_aadr extends apb_seq_base;
  `uvm_object_utils(mult_rd_same_aadr)

  function new(string name = "mult_rd_same_aadr");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr == 32'b1; });
      xtn.pwrite = 0;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple write transactions with even addresses
class mult_wr_even_aadr extends apb_seq_base;
  `uvm_object_utils(mult_wr_even_aadr)

  function new(string name = "mult_wr_even_aadr");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr %2 == 0; });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple write transactions with odd addresses
class mult_wr_odd_aadr extends apb_seq_base;
  `uvm_object_utils(mult_wr_odd_aadr)

  function new(string name = "mult_wr_odd_aadr");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr %2 == 1; });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple write transactions with odd address and odd data
class mult_wr_odd_aadr_odd_data extends apb_seq_base;
  `uvm_object_utils(mult_wr_odd_aadr_odd_data)

  function new(string name = "mult_wr_odd_aadr_odd_data");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr %2 == 1 && xtn.pwdata %2 == 1; });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple write transactions with even address and even data
class mult_wr_even_aadr_even_data extends apb_seq_base;
  `uvm_object_utils(mult_wr_even_aadr_even_data)

  function new(string name = "mult_wr_even_aadr_even_data");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { xtn.paddr %2 == 0 && xtn.pwdata %2 == 0; });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Multiple write transactions with different address and data constraints
class mult_wr_diff_addr_data extends apb_seq_base;
  `uvm_object_utils(mult_wr_diff_addr_data)

  function new(string name = "mult_wr_diff_addr_data");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize() with { 
        xtn.paddr > 10; 
        xtn.pwdata %2 == 1; 
        xtn.pwdata > 10; 
        xtn.pwdata < 20; 
      });
      xtn.pwrite = 1;
      finish_item(xtn);
    end
  endtask
endclass


// Single write followed by single read
class single_write_read extends apb_seq_base;
  `uvm_object_utils(single_write_read)

  function new(string name = "single_write_read");
    super.new(name);
  endfunction

  virtual task body();
    // Write transaction
    xtn = apb_xtns::type_id::create("xtn");
    start_item(xtn);
    assert(xtn.randomize());
    xtn.pwrite = 1;
    xtn.paddr =10;
    finish_item(xtn);

    // Read transaction
    start_item(xtn);
    assert(xtn.randomize());
    xtn.pwrite = 0;
    xtn.paddr =10;
    finish_item(xtn);
  endtask
endclass


// Multiple write followed by read transactions
class multiple_write_read extends apb_seq_base;
  `uvm_object_utils(multiple_write_read)

  function new(string name = "multiple_write_read");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      // Write
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 1;
      finish_item(xtn);

      // Read
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 0;
      finish_item(xtn);
    end
  endtask
endclass


// Bulk write then bulk read
class write_read_bulk extends apb_seq_base;
  `uvm_object_utils(write_read_bulk)

  function new(string name = "write_read_bulk");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 1;
      finish_item(xtn);
    end
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 0;
      finish_item(xtn);
    end
  endtask
endclass


// Write to error address
class write_err extends apb_seq_base;
  `uvm_object_utils(write_err)

  function new(string name = "write_err");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 1;
      xtn.paddr = 40; // Error address
      finish_item(xtn);
    end
  endtask
endclass


// Read from error address
class read_err extends apb_seq_base;
  `uvm_object_utils(read_err)

  function new(string name = "read_err");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      xtn = apb_xtns::type_id::create("xtn");
      start_item(xtn);
      assert(xtn.randomize());
      xtn.pwrite = 0;
      xtn.paddr = 40; // Error address
      finish_item(xtn);
    end
  endtask
endclass

