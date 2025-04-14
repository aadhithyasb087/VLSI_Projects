module router_fifo_tb();

  // Inputs and Outputs
  reg clk, rstn, write_enb, read_enb, lfd_state;
  reg [7:0] data_in;
  wire full, empty;
  wire [7:0] data_out;

  // Instantiate the FIFO DUT
  router_fifo FIFO (
    .clk(clk),
    .rstn(rstn),
    .write_enb(write_enb),
    .read_enb(read_enb),
    .lfd_state(lfd_state),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  // Reset task
  task reset;
  begin
    $display("[%0t] Applying Reset...", $time);
    rstn = 0;
    write_enb = 0;
    read_enb = 0;
    lfd_state = 0;
    data_in = 0;
    #10;
    rstn = 1;
    $display("[%0t] Reset Released", $time);
  end
  endtask

  // Write Task
  task write;
    input [7:0] data;
  begin
    wait (!full)
    @(negedge clk);
    write_enb = 1;
    data_in = data;
    $display("[%0t] Writing Data: %h", $time, data);
    @(negedge clk);
    write_enb = 0;
  end
  endtask

  // Read Task
  task read;
  begin
    wait (!empty)
    @(negedge clk);
    read_enb = 1;
    $display("[%0t] Reading Data: %h", $time, data_out);
    @(negedge clk);
    read_enb = 0;
  end
  endtask

  // Main test sequence
  initial begin
    reset;

    #10;
    $display("[%0t] Starting FIFO Test", $time);
    write(8'hAA);
    write(8'hBB);
    write(8'hCC);

    #20;

    read();
    read();

    #10;

    write(8'hDD);
    read();
    read();

    #50;
    $display("[%0t] FIFO Test Complete", $time);
    $finish;
  end

endmodule