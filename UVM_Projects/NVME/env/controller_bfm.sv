class controller_bfm extends uvm_component;
`uvm_component_utils(controller_bfm)

// internal state
  typedef struct {
    int unsigned last_sq_tail[16];
    int unsigned last_cq_head[16];
  } ctrl_state_t;
  ctrl_state_t st;

virtual nvme_if.ctrl ctrl_if;
host_mem h_mem;

  function new(string name="controller_bfm", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual nvme_if.ctrl)::get(this, "", "vif", ctrl_if))
      `uvm_fatal("NOVIF", "controller_bfm: virtual interface not set")
    if (!uvm_config_db#(host_mem)::get(this, "", "mem_h", h_mem))
      `uvm_fatal("CTRL_BFM", "mem_h not found in config_db")
  endfunction
  
  task run_phase(uvm_phase phase);
  	forever begin
  		slave_drive();
  	end
  endtask
  
  // helper functions
  function automatic nvme_cmd_s unpack_cmd(input logic [511:0] bits);
    nvme_cmd_s c;
    {c.opcode, c.flags, c.cid, c.nsid, c.rsvd1, c.mptr, c.prp1, c.prp2, c.slba, c.nlb, c.reserved} = bits;
    return c;
  endfunction

  function automatic logic [127:0] pack_cpl(nvme_cpl_s c);
    logic [127:0] bits;
    bits = {c.result,c.sq_head,c.sq_id,c.cid,c.status,c.reserved};
    return bits;
  endfunction

   
  task slave_drive();
  int i;
  int sqid;
  int new_tail;
  int cqid;
  logic [511:0] temp_cmd;
  nvme_cpl_s cpl;
  nvme_cmd_s cmd;
  
    if (!ctrl_if.rst_n) begin
      for (i = 0; i < 16; i++) begin
        st.last_sq_tail[i] <= 0;
        st.last_cq_head[i] <= 0;
      end
      ctrl_if.cpl_valid <= 0;
      ctrl_if.cmd_ready <= 0;
      ctrl_if.mem_rd_req <= 0;
      ctrl_if.mem_wr_req <= 0;
    end 
wait(ctrl_if.rst_n);
@(posedge ctrl_if.clk);
      // Command handling
      wait (ctrl_if.cmd_valid);
      ctrl_if.cmd_ready <= 1;
        h_mem.rd_cmd(64'b0,temp_cmd); 
        
        cmd = unpack_cmd(temp_cmd);
        cpl = '0;
        cpl.cid = cmd.cid;
        cpl.sq_id = 0;
        cpl.sq_head = st.last_sq_tail[0];
        
                case (cmd.opcode)
          // ---------------- I/O Command Set ----------------
          nvme_pkg::OPC_FLUSH: begin
            // flush — no data xfer
            cpl.status = 16'h0000;
            cpl.result = 32'hF1A5_F1A5;
          end

          nvme_pkg::OPC_WRITE: begin
            // simulate DMA read from PRP1 (host -> controller)
            ctrl_if.mem_rd_req  <= 1;
            ctrl_if.mem_rd_addr <= cmd.prp1;
            ctrl_if.mem_rd_len  <= 64;
            cpl.status  = 16'h0000;
            cpl.result  = 32'h1111_0001; // Write completed
          end

          nvme_pkg::OPC_READ: begin
            // simulate DMA write to PRP1 (controller -> host)
            ctrl_if.mem_wr_req   <= 1;
            ctrl_if.mem_wr_addr  <= cmd.prp1;
            ctrl_if.mem_wr_len   <= 64;
            ctrl_if.mem_wr_data  <= {8{64'h0123_4567_89AB_CDEF}};
            cpl.status   = 16'h0000;
            cpl.result   = 32'h2222_0003; // Read completed
          end

         

          // ---------------- Admin Command Set ----------------
          nvme_pkg::OPC_ADMIN_IDENTIFY: begin
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_0005;
          end

          nvme_pkg::OPC_ADMIN_CREATE_IO_CQ: begin
            // create I/O CQ success
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_0006;
          end

          nvme_pkg::OPC_ADMIN_CREATE_IO_SQ: begin
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_0007;
          end

          nvme_pkg::OPC_ADMIN_DELETE_IO_CQ: begin
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_0008;
          end

          nvme_pkg::OPC_ADMIN_DELETE_IO_SQ: begin
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_000A;
          end

          nvme_pkg::OPC_ADMIN_ABORT: begin
            // abort command accepted
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_000B;
          end

          nvme_pkg::OPC_ADMIN_SHUTDOWN: begin
            cpl.status = 16'h0000;
            cpl.result = 32'hA5A5_000C;
          end

          nvme_pkg::OPC_ADMIN_GET_LOG_PAGE: begin
            // return sample log page
            ctrl_if.mem_wr_req   <= 1;
            ctrl_if.mem_wr_addr  <= cmd.prp1;
            ctrl_if.mem_wr_len   <= 64;
            ctrl_if.mem_wr_data  <= {8{64'hFEED_FACE_DEAD_BEEF}};
            cpl.status   = 16'h0000;
            cpl.result   = 32'hA5A5_000D;
          end

          default: begin
            // unsupported opcode
            cpl.status = 16'h00FF;
            cpl.result = 32'hBAD0_BAD0;
          end
        endcase

        
		
        if (ctrl_if.mem_rd_req) ctrl_if.mem_rd_req <= 0;
        if (ctrl_if.mem_wr_req) ctrl_if.mem_wr_req <= 0;
       
        @(posedge ctrl_if.clk);
        ctrl_if.cmd_ready <= 0;
        // Doorbell decode
      wait(ctrl_if.db_write); 
        if ((ctrl_if.db_addr & 32'hFFFFFF00) == 32'h00000100) begin
          sqid = ctrl_if.db_addr[7:0];
          new_tail = ctrl_if.db_data;
          if (new_tail > st.last_sq_tail[sqid]) begin
            st.last_sq_tail[sqid] = new_tail;
          end
        end else if ((ctrl_if.db_addr & 32'hFFFFFF00) == 32'h00000200) begin
          cqid = ctrl_if.db_addr[7:0];
          st.last_cq_head[cqid] = ctrl_if.db_data;
        end
        ctrl_if.cpl_valid <= 1;
        wait(ctrl_if.cpl_ready);
          ctrl_if.cpl_data  <= pack_cpl(cpl);
        @(posedge ctrl_if.clk);
          ctrl_if.cpl_valid <= 0;
   
  endtask

endclass

