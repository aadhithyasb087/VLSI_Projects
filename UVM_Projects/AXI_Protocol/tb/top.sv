module top();
  import uvm_pkg::*;
  import axi_pkg::*;
  `include "uvm_macros.svh"
  bit clk;

  always #5 clk=~clk;
  
  axi_intf intf(clk);

  initial begin
    `ifdef VCS 
      $fsdbDumpvars(0,top);
    `endif

    `uvm_info("TOP","in top module",UVM_LOW)
    uvm_config_db#(virtual axi_intf)::set(null,"*","intf",intf);
    run_test("axi_test1");
  end

endmodule
