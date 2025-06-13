

module uart_tb_top;

  // import uart_test_pkg
  import uart_test_pkg::*;
     
  // import uvm_pkg.sv
  import uvm_pkg::*;


  // Instantiate the interface
  uart_if vif();

  // DUT instantiation (connect interface signals)
  uart_top dut (
    .clk(vif.clk),
    .rst(vif.rst),
    .tx_start(vif.tx_start),
    .rx_start(vif.rx_start),
    .tx_data(vif.tx_data),
    .baud(vif.baud),
    .length(vif.length),
    .parity_type(vif.parity_type),
    .parity_en(vif.parity_en),
    .stop2(vif.stop2),
    .tx_done(vif.tx_done),
    .rx_done(vif.rx_done),
    .tx_err(vif.tx_err),
    .rx_err(vif.rx_err),
    .rx_out(vif.rx_out)
  );

  // Clock generation
  initial vif.clk = 0;
  always #10 vif.clk = ~vif.clk;  // 50MHz clock

  // Connect virtual interface and start UVM test
  initial begin
    uvm_config_db #(virtual uart_if)::set(null, "*", "vif", vif);
    run_test(); // Make sure you have a test class named 'test'
  end

  // Dump waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule


