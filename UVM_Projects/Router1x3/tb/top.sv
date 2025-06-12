module top();
  import router_test_pkg::*;
  import uvm_pkg::*;
  
  `include "uvm_macros.svh"

  bit clock;

  router_intf ip_intf(clock);
  router_intf intf0(clock);
  router_intf intf1(clock);
  router_intf intf2(clock);

  property assert_valid_out;
    @(posedge clock) disable iff(!ip_intf.resetn)
    $rose(ip_intf.pkt_valid)|->##3(intf0.valid_out)||(intf1.valid_out)||(intf2.valid_out);
  endproperty

  asert1:assert property(assert_valid_out);

  router_top dut(.clock(clock),
                 .resetn(ip_intf.resetn),
                 .read_enb_0(intf0.read_enb),
                 .read_enb_1(intf1.read_enb),
                 .read_enb_2(intf2.read_enb),
                 .pkt_valid(ip_intf.pkt_valid),
                 .data_in(ip_intf.data_in),
                 .valid_out_0(intf0.valid_out),
                 .valid_out_1(intf1.valid_out),
                 .valid_out_2(intf2.valid_out),
                 .error(ip_intf.error),
                 .busy(ip_intf.busy),
                 .data_out_0(intf0.data_out),
                 .data_out_1(intf1.data_out),
                 .data_out_2(intf2.data_out)); 

  always #5 clock =~clock;

  initial begin
   `ifdef VCS 
      $fsdbDumpvars(0,top);
   `endif
   `uvm_info("top","in top",UVM_LOW)
  uvm_config_db#(virtual router_intf)::set(null,"*","ip_intf",ip_intf);
  uvm_config_db#(virtual router_intf)::set(null,"*","intf[0]",intf0);
  uvm_config_db#(virtual router_intf)::set(null,"*","intf[1]",intf1);
  uvm_config_db#(virtual router_intf)::set(null,"*","intf[2]",intf2);
  run_test();
  end

endmodule
