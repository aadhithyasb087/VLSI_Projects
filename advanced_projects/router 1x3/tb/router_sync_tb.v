`timescale 1ns / 1ps

module router_sync_tb;

  // Inputs
  reg clk;
  reg resetn;
  reg detect_add;
  reg [1:0] address;

  // Outputs
  wire write_enb_0, write_enb_1, write_enb_2;

  // Instantiate the Unit Under Test (UUT)
  router_sync uut (
    .clk(clk),
    .resetn(resetn),
    .detect_add(detect_add),
    .address(address),
    .write_enb_0(write_enb_0),
    .write_enb_1(write_enb_1),
    .write_enb_2(write_enb_2)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Test procedure
  initial begin
    $display("===== router_sync Testbench =====");
    resetn = 0;
    detect_add = 0;
    address = 2'b00;

    #10 resetn = 1;
    $display("[INFO] Reset de-asserted");

    // Test each address with detect_add high
    repeat (3) begin
      @(negedge clk);
      detect_add = 1;
      address = $random % 3; // Generates 0, 1, or 2
      $display("[TEST] Sending address: %b", address);
      @(posedge clk);
      detect_add = 0;
      address = 2'b00;
      @(posedge clk);
    end

    // Check default case (no detect_add)
    $display("[TEST] Checking default output (detect_add = 0)");
    @(negedge clk);
    detect_add = 0;
    address = 2'b10;
    @(posedge clk);

    #20;
    $finish;
  end

endmodule