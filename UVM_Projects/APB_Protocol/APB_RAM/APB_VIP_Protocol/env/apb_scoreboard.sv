class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_tlm_analysis_fifo #(apb_xtns) m_fifo;   // Master monitor data
  uvm_tlm_analysis_fifo #(apb_xtns) s_fifo;   // Slave monitor data

  apb_xtns m_xtn;
  apb_xtns s_xtn;

  bit [31:0] exp_mem [int];  // Reference memory model
  bit [31:0] data, addr;

  function new(string name="apb_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    m_fifo   = new("m_fifo", this);
    s_fifo   = new("s_fifo", this);
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info("apb_scoreboard","Build phase",UVM_LOW)
  endfunction

task run_phase(uvm_phase phase);
forever begin
    // Blocking get ensures correct order
    $display("before sb trans");
    
    m_fifo.get(m_xtn);  
    s_fifo.get(s_xtn);
    
    // Slave-side expected reference
    addr = s_xtn.paddr;
    if (s_xtn.pwrite) begin
      exp_mem[addr] = s_xtn.pwdata;
      `uvm_info("SCOREBOARD", $sformatf("WRITE EXPECTED: Addr=%0d, Data=%0d",
                     addr, s_xtn.pwdata), UVM_LOW)
    end else begin
      `uvm_info("SCOREBOARD", $sformatf("READ EXPECTED: Addr=%0d, Data=%0d",
                     addr, s_xtn.prdata), UVM_LOW)
    end

    // Master-side actual observed
     
    // Compare expected vs actual
    addr = m_xtn.paddr;
    if (exp_mem.exists(addr)) begin
      data = exp_mem[addr];
      if (m_xtn.pwrite) begin
        if (data == m_xtn.pwdata)
          `uvm_info("SCOREBOARD",
                    $sformatf("WRITE MATCH: Addr=%0d, Data=%0d",
                              addr, m_xtn.pwdata), UVM_LOW)
        else
          `uvm_warning("SCOREBOARD",
                       $sformatf("WRITE MISMATCH: Addr=%0d, Expected=%0d, Actual=%0d",
                                 addr, data, m_xtn.pwdata))
      end else begin
        if (data == s_xtn.prdata)
          `uvm_info("SCOREBOARD",
                    $sformatf("READ MATCH: Addr=%0d, Data=%0d",
                              addr, s_xtn.prdata), UVM_LOW)
        else
          `uvm_warning("SCOREBOARD",
                       $sformatf("READ MISMATCH: Addr=%0d, Expected=%0d, Actual=%0d",
                                 addr, data, s_xtn.prdata))
      end
    end else begin
      `uvm_warning("SCOREBOARD",
                   $sformatf("Unexpected Addr=%0h not found in exp_mem", addr))
    end
    
  end

endtask
 endclass

