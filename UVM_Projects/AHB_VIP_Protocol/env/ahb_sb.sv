class ahb_sb extends uvm_scoreboard;

`uvm_component_utils(ahb_sb)

//------------------tlm_analysis_port------------//
uvm_tlm_analysis_fifo #(ahb_xtn) m_fifo;
uvm_tlm_analysis_fifo #(ahb_xtn) s_fifo;

ahb_xtn m_xtn;
ahb_xtn s_xtn;

  bit [31:0] exp_mem [int];  // Reference memory model
  bit [31:0] data, addr;


//-------------------------new_method----------------//
function new(string name="ahb_sb",uvm_component parent);
	super.new(name,parent);
	m_fifo=new("m_fifo",this);	
	s_fifo=new("s_fifo",this);
endfunction

//--------------------build_phase-------------------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//--------------------run_phase------------------//
task run_phase(uvm_phase phase);
bit [31:0] addr;
    bit [31:0] data;
	forever
	begin
		compare_data();
	end

endtask
//----------------compare_logic-----------------//
task compare_data();
    
    fork
    m_fifo.get(m_xtn);  
    s_fifo.get(s_xtn);
    join
    
    $display("Master: Addr=%0d, Data=%0d",m_xtn.HADDR[0],m_xtn.HWDATA[0]);
    $display("Slave: Addr=%0d, Data=%0d",s_xtn.HADDR[0],s_xtn.HWDATA[0]);
    /*if(!m_xtn.HRESETn)
    	`uvm_info("SCOREBOARD","Resetn", UVM_LOW)
    else */
    begin
    addr = s_xtn.HADDR[0];
    if (s_xtn.HWRITE) begin
      exp_mem[addr] = s_xtn.HWDATA[0];
    end 
     
    // Compare expected vs actual
    addr = m_xtn.HADDR[0];
    if (exp_mem.exists(addr)) begin
      data = exp_mem[addr];
      if (m_xtn.HWRITE) begin
        if (data == m_xtn.HWDATA[0])
          `uvm_info("SCOREBOARD",
                    $sformatf("WRITE MATCH: Addr=%0d, Data=%0d",
                              addr, s_xtn.HWDATA[0]), UVM_LOW)
        else
          `uvm_warning("SCOREBOARD",
                       $sformatf("WRITE MISMATCH: Addr=%0d, Expected=%0d, Actual=%0d",
                                 addr, data, s_xtn.HWDATA[0]))
      end else begin
        if (data == s_xtn.HRDATA)
          `uvm_info("SCOREBOARD",
                    $sformatf("READ MATCH: Addr=%0d, Data=%0d",
                              addr, s_xtn.HRDATA), UVM_LOW)
        else
          `uvm_warning("SCOREBOARD",
                       $sformatf("READ MISMATCH: Addr=%0d, Expected=%0d, Actual=%0d",
                                 addr, data, s_xtn.HRDATA))
      end
    end else begin
      `uvm_warning("SCOREBOARD",
                   $sformatf("Unexpected Addr=%0d not found in exp_mem", addr))
    end
    end
    
endtask

endclass
