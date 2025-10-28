class host_bfm extends uvm_component;
`uvm_component_utils(host_bfm)

virtual nvme_if.host vif;
host_mem h_mem;
function new(string name="host_bfm",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual nvme_if.host)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF","virtual interface not set for host_driver")
    if (!uvm_config_db#(host_mem)::get(this, "", "mem_h", h_mem))
      `uvm_fatal("HOST_BFM", "mem_h not found in config_db")
endfunction

task host_drive(nvme_txn tr);
logic [511:0] bits;
if (!vif.rst_n) begin 
vif.cmd_valid <= 0;
vif.cpl_ready <= 0;
end
wait(vif.rst_n);
      // pack cmd struct to 512-bit vector
      
      bits = tr.cmd;
      // Drive cmd in a single 64-byte beat as requested
      @(posedge vif.clk);
      //vif.cmd_data <= bits;
      h_mem.wr_cmd(64'b0,bits);
      vif.cmd_data <= bits;
      vif.cmd_valid <= 1;
      // wait for cmd_ready
      wait (vif.cmd_ready == 1);
      //@(posedge vif.clk);
      vif.cmd_valid <= 0;
      // Now ring SQ doorbell for SQ id 0 (example)
      //@(posedge vif.clk);
      vif.db_addr <= 32'h00000100 | 8'd0; // SQ tail DB base + sqid
      vif.db_data <= 32'( tr.cmd.cid + 1 ); // tail increment simple mapping
      vif.db_write <= 1;
      @(posedge vif.clk);
      vif.db_write <= 0;
      vif.cpl_ready <= 1;
      //wait(vif.cpl_valid);
      @(posedge vif.clk);
      vif.cpl_ready <= 0;
endtask

endclass
