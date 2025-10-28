interface nvme_if(input bit clk, input bit rst_n);

  // Command path: host -> controller
  logic        cmd_valid;
  logic        cmd_ready;
  logic [511:0] cmd_data; // 512-bit SQE

  // Completion path: controller -> host
  logic        cpl_valid;
  logic        cpl_ready;
  logic [127:0] cpl_data; // 128-bit CQE

  // Doorbell port (memory mapped writes from host)
  logic [31:0] db_addr;
  logic [31:0] db_data;
  logic        db_write;

  // Memory/DMA interface (controller BFM <-> mem model)
  logic        mem_rd_req;
  logic [63:0] mem_rd_addr;
  logic [31:0] mem_rd_len; // bytes
  logic        mem_rd_ack;
  logic [511:0] mem_rd_data; // single beat read

  logic        mem_wr_req;
  logic [63:0] mem_wr_addr;
  logic [31:0] mem_wr_len;  // bytes
  logic        mem_wr_ack;
  logic [511:0] mem_wr_data;

  // host modport: used by driver/monitor
  modport host (
    input clk, rst_n,
    output cmd_valid, cmd_data, db_addr, db_data, db_write,	cpl_ready,
    input cmd_ready, cpl_valid, cpl_data
  );

  // ctrl modport: used by controller BFM/monitor
  modport ctrl (
    input clk, rst_n,
    input cmd_valid, cmd_data,
    output cmd_ready, cpl_valid, cpl_data,
    input cpl_ready,
    input db_write, db_addr, db_data,
    // mem ports
    output mem_rd_req, mem_rd_addr, mem_rd_len,
    input mem_rd_ack, mem_rd_data,
    output mem_wr_req, mem_wr_addr, mem_wr_len, mem_wr_data,
    input mem_wr_ack
  );
  
  modport mem_model (
  input clk,
  input rst_n,
  // memory IF
  input mem_rd_req,
  input mem_rd_addr, 
  input mem_rd_len,
  output mem_rd_ack,
  output mem_rd_data,

  input mem_wr_req,
  input mem_wr_addr,
  input mem_wr_len,
  input mem_wr_data,
  output mem_wr_ack
  );

endinterface

