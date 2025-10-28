class host_driver extends uvm_driver#(nvme_txn);
`uvm_component_utils(host_driver)

  host_bfm bfm;

  function new(string name="host_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);                                                            
      bfm = host_bfm::type_id::create("bfm", this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      nvme_txn tr;
      seq_item_port.get_next_item(tr);
	  bfm.host_drive(tr);
      seq_item_port.item_done();
    end
  endtask
endclass
