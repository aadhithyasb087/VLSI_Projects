class controller_mem extends uvm_component;
`uvm_component_utils(controller_mem)

  virtual nvme_if.mem_model vif;
  
  localparam int MEM_SIZE_BYTES = 8192; // 8KB
  localparam int WORDS = MEM_SIZE_BYTES/8;
  // memory as 64-bit words for simplicity
  logic [63:0] mem [0:WORDS-1];
  
  function new(string name="nvme_mem_model", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual nvme_if.mem_model)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "host_monitor: virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
  int i;
  int base;
  forever begin
  @(posedge vif.clk);
    if(!vif.rst_n) begin
      vif.mem_rd_ack <= 0;
      vif.mem_wr_ack <= 0;
      vif.mem_rd_data <= '0;
    end else begin
      vif.mem_rd_ack <= 0;
      vif.mem_wr_ack <= 0;
      if (vif.mem_rd_req) begin
        // gather 8 words starting at rd_addr (64-bit aligned)
        
        vif.mem_rd_data = '0;
        base = vif.mem_rd_addr[31:3]; // divide by 8
        for (i=0;i<8;i++) begin
          if ((base + i) < WORDS)
            vif.mem_rd_data[ (i*64) +: 64 ] = mem[base + i];
          else
            vif.mem_rd_data[(i*64) +:64] = 64'hDEAD_BEEF_DEAD_BEEF;
        end
        vif.mem_rd_ack <= 1;
      end
      if (vif.mem_wr_req) begin
        int i;
        int base = vif.mem_wr_addr[31:3];
        for (i=0;i<8;i++) begin
          if ((base + i) < WORDS)
            mem[base + i] = vif.mem_wr_data[(i*64) +: 64];
        end
        vif.mem_wr_ack <= 1;
      end
    end
  end
  endtask

endclass

