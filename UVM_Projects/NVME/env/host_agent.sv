class host_agent extends uvm_agent;
  `uvm_component_utils(host_agent)
  host_driver h_drv;
  host_monitor h_mon;
  host_seqr m_seqr;

  function new(string name="host_agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    h_drv = host_driver::type_id::create("h_drv", this);
    h_mon = host_monitor::type_id::create("h_mon", this);
    m_seqr = host_seqr::type_id::create("m_seqr", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
  	h_drv.seq_item_port.connect(m_seqr.seq_item_export);
  endfunction

endclass
