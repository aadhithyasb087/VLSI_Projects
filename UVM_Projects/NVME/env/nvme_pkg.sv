package nvme_pkg;

import uvm_pkg::*;

  // NVMe sizes
  localparam int SQE_BYTES = 64;
  localparam int SQE_BITS  = SQE_BYTES * 8; // 512
  localparam int CQE_BYTES = 16;
  localparam int CQE_BITS  = CQE_BYTES * 8; // 128

  // Opcodes (subset)
  typedef enum logic [7:0] {
    OPC_FLUSH       = 8'h00,
    OPC_WRITE       = 8'h01,
    OPC_READ        = 8'h03,
    // Admin opcodes
    OPC_ADMIN_IDENTIFY = 8'h05,
    OPC_ADMIN_CREATE_IO_CQ = 8'h06, // example mapping
    OPC_ADMIN_CREATE_IO_SQ = 8'h07, 
    OPC_ADMIN_DELETE_IO_CQ = 8'h08,
    OPC_ADMIN_DELETE_IO_SQ = 8'h0A,
    OPC_ADMIN_ABORT = 8'h0B,
    OPC_ADMIN_SHUTDOWN = 8'h0C,
    OPC_ADMIN_GET_LOG_PAGE = 8'h0D
  } nvme_opcode_e;

  // Command (packed into 512 bits / 64 bytes)
  typedef struct packed {
    logic [7:0]   opcode;
    logic [7:0]   flags;
    logic [15:0]  cid;
    logic [31:0]  nsid;
    logic [63:0]  rsvd1;
    logic [63:0]  mptr;
    logic [63:0]  prp1;
    logic [63:0]  prp2;
    logic [31:0]  slba;    // simplified
    logic [31:0]  nlb;     // number of logical blocks (or similar)
    logic [127:0] reserved; // fill to 512 bits
  } nvme_cmd_s;

  // Completion (128 bits)
  typedef struct packed {
    logic [31:0]  result;
    logic [15:0]  sq_head;
    logic [15:0]  sq_id;
    logic [15:0]  cid;
    logic [15:0]  status;   // simplified status field
    logic [36:0]  reserved;
  } nvme_cpl_s;

  
    
`include "uvm_macros.svh"


`include "nvme_txn.sv"
`include "host_mem.sv"
`include "controller_mem.sv"

`include "host_bfm.sv"
`include "host_driver.sv"
`include "host_monitor.sv"
`include "host_seqr.sv"
`include "host_agent.sv"

`include "controller_bfm.sv"
`include "controller_monitor.sv"
`include "controller_agent.sv"

`include "nvme_scoreboard.sv"
`include "nvme_env.sv"
`include "nvme_seq.sv"
`include "nvme_test.sv"

endpackage
