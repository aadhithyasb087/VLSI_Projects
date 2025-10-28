module nvme_coverage (
  input  logic         clk,
  input  logic         rst_n,

  input  logic         cmd_valid,
  input  logic         cmd_ready,
  input  logic [511:0] cmd_data,

  input  logic         cpl_valid,
  input  logic [127:0] cpl_data,

  input  logic         db_write,
  input  logic [31:0]  db_addr,
  input  logic [31:0]  db_data,

  input  logic [63:0]  mem_rd_addr,
  input  logic [63:0]  mem_wr_addr
);

  // -------------------------------------------------------------------
  // Decode packed structs from interface
  // -------------------------------------------------------------------
  nvme_cmd_s cmd_in;
  nvme_cpl_s cpl_in;

  always_comb begin
    // unpack the 512-bit and 128-bit buses into struct types
    cmd_in = cmd_data;
    cpl_in = cpl_data;
  end

  // -------------------------------------------------------------------
  // Functional Coverage Group
  // -------------------------------------------------------------------
  covergroup nvme_cov @(posedge clk);
    option.per_instance = 1;

    // I/O and Admin command opcode coverage
    opcode_cp: coverpoint cmd_in.opcode {
      bins io_ops = {OPC_FLUSH, OPC_WRITE, OPC_READ,OPC_ADMIN_IDENTIFY, OPC_ADMIN_CREATE_IO_CQ,
                          OPC_ADMIN_CREATE_IO_SQ, OPC_ADMIN_DELETE_IO_CQ,
                          OPC_ADMIN_DELETE_IO_SQ, OPC_ADMIN_ABORT,
                          OPC_ADMIN_SHUTDOWN, OPC_ADMIN_GET_LOG_PAGE};
    }

    // Completion status coverage
    status_cp: coverpoint cpl_in.status{
      bins success = {16'h0000};
    }

    // Result coverage
    /*result_cp: coverpoint cpl_in.result iff (cpl_valid) {
      bins low  = {[0:32'h00FF_FFFF]};
      bins mid  = {[32'h0100_0000:32'h7FFF_FFFF]};
      bins high = {[32'h8000_0000:32'hFFFF_FFFF]};
    }*/

  endgroup : nvme_cov

  nvme_cov cg = new();

  real cov;

  
  initial begin
    
  forever begin
  #10;
      //if (rst_n)
        cg.sample();
      cov = cg.get_coverage();
      
        $display("[%0t] NVMe Functional Coverage = %0.2f%%", $time, cov);
   end
  end

endmodule

