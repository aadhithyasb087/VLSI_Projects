`timescale 1ns/1ps

module uart_top_tb;

  // Clock and Reset
  logic clk;
  logic rst;

  // Inputs
  logic tx_start, rx_start;
  logic [7:0] tx_data;
  logic [16:0] baud;
  logic [3:0] length;
  logic parity_type, parity_en;
  logic stop2;

  // Outputs
  logic tx_done, rx_done;
  logic tx_err, rx_err;
  logic [7:0] rx_out;

  // Clock Generation
  always #5 clk = ~clk;

  // DUT instantiation
  uart_top dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .rx_start(rx_start),
    .tx_data(tx_data),
    .baud(baud),
    .length(length),
    .parity_type(parity_type),
    .parity_en(parity_en),
    .stop2(stop2),
    .tx_done(tx_done),
    .rx_done(rx_done),
    .tx_err(tx_err),
    .rx_err(rx_err),
    .rx_out(rx_out)
  );

  // Stimulus
  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    tx_start = 0;
    rx_start = 0;
    tx_data = 8'h00;
    baud = 17'd0;        // For example
    length = 4'd0;
    parity_type = 0;
    parity_en = 0;
    stop2 = 0;

    #20 rst = 0;          // Release reset

    // Transmit a byte
    @(negedge clk);
    tx_data = 8'hA5;
    tx_start = 1;
    baud = 17'd9600;
    length = 4'd8;
    #10 tx_start = 0;

    // Wait for TX done
    wait (tx_done);
    $display("TX Done");

    // Start RX manually (only for simulation control)
    @(negedge clk);
    rx_start = 1;
    #10 rx_start = 0;

    // Wait for RX done
    wait (rx_done);
    $display("RX Done: Data = %h", rx_out);

    // Finish simulation
    #50;
    $finish;
  end

endmodule

