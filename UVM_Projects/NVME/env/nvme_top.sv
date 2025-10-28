
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "nvme_if.sv"
import nvme_pkg::*;
`include "nvme_coverage.sv"
`include "nvme_assertions.sv"


module nvme_top;
  // clock/reset
  bit clk;
  bit rst_n;

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz
  end
  initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
  end

  // instantiate interface
  nvme_if nvme_if_inst(.clk(clk), .rst_n(rst_n));
  // Coverage module
  nvme_coverage cov_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_valid(nvme_if_inst.cmd_valid),
    .cmd_ready(nvme_if_inst.cmd_ready),
    .cmd_data(nvme_if_inst.cmd_data),
    .cpl_valid(nvme_if_inst.cpl_valid),
    .cpl_data(nvme_if_inst.cpl_data),
    .db_write(nvme_if_inst.db_write),
    .db_addr(nvme_if_inst.db_addr),
    .db_data(nvme_if_inst.db_data),
    .mem_rd_addr(nvme_if_inst.mem_rd_addr),
    .mem_wr_addr(nvme_if_inst.mem_wr_addr)
  );

  // Assertions module
  nvme_assertions asrt_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_valid(nvme_if_inst.cmd_valid),
    .cmd_ready(nvme_if_inst.cmd_ready),
    .cpl_valid(nvme_if_inst.cpl_valid),
    .cpl_ready(nvme_if_inst.cpl_ready),
    .db_write(nvme_if_inst.db_write),
    .db_addr(nvme_if_inst.db_addr),
    .db_data(nvme_if_inst.db_data)
  );


  initial begin
    uvm_config_db#(virtual nvme_if)::set(null, "*", "vif", nvme_if_inst);
    uvm_config_db#(virtual nvme_if.host)::set(null, "*", "vif", nvme_if_inst.host);
    uvm_config_db#(virtual nvme_if.mem_model)::set(null, "*", "vif", nvme_if_inst.mem_model);
    uvm_config_db#(virtual nvme_if.ctrl)::set(null, "*", "vif", nvme_if_inst.ctrl);
    run_test("test_io_rw"); 
    $finish;
  end

endmodule

