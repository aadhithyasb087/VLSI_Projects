module router_top_tb();

  // Declare inputs as reg and outputs as wire
  reg clk, rstn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
  reg [7:0] data_in;
  wire [7:0] data_out_0, data_out_1, data_out_2;
  wire vld_out_0, vld_out_1, vld_out_2, err, busy;
  integer i;

  // Instantiate the router_top DUT (Design Under Test)
  router_top DUT (
    .clk(clk),
    .rstn(rstn),
    .read_enb_0(read_enb_0),
    .read_enb_1(read_enb_1),
    .read_enb_2(read_enb_2),
    .pkt_valid(pkt_valid),
    .data_in(data_in),
    .data_out_0(data_out_0),
    .data_out_1(data_out_1),
    .data_out_2(data_out_2),
    .valid_out_0(vld_out_0),
    .valid_out_1(vld_out_1),
    .valid_out_2(vld_out_2),
    .err(err),
    .busy(busy)
  );

  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  // Reset task: initializes and asserts reset
  task reset;
  begin
    $display("[%0t] Applying Reset...", $time);
    rstn = 1'b0;
    {read_enb_0, read_enb_1, read_enb_2, pkt_valid, data_in} = 0;
    #10;
    rstn = 1'b1;
    $display("[%0t] Reset Released", $time);
  end
  endtask

  // Packet Generation Task: Payload Length = 8
  task pktm_gen_8;
    reg [7:0] header, payload_data, parity;
    reg [8:0] payloadlen;
  begin
    parity = 0;
    wait (!busy)
    begin
      @(negedge clk);
      payloadlen = 8;
      pkt_valid = 1'b1;
      header = {payloadlen, 2'b10};  // Destination = 2
      data_in = header;
      parity = parity ^ data_in;
      $display("[%0t] Sent Header: %h", $time, data_in);
    end

    @(negedge clk);

    for (i = 0; i < payloadlen; i = i + 1) begin
      wait (!busy)
      @(negedge clk);
      payload_data = {$random} % 256;
      data_in = payload_data;
      parity = parity ^ data_in;
      $display("[%0t] Sent Payload[%0d]: %h", $time, i, payload_data);
    end

    wait (!busy)
    @(negedge clk);
    pkt_valid = 0;
    data_in = parity;
    $display("[%0t] Sent Parity: %h", $time, parity);

    @(negedge clk);
    read_enb_2 = 1'b1;
    $display("[%0t] Read Enable for Port 2 Activated", $time);
  end
  endtask

  // Packet Generation Task: Payload Length = 5
  task pktm_gen_5;
    reg [7:0] header, payload_data, parity;
    reg [4:0] payloadlen;
  begin
    parity = 0;
    wait (!busy)
    begin
      @(negedge clk);
      payloadlen = 5;
      pkt_valid = 1'b1;
      header = {payloadlen, 2'b10}; // Destination = 2
      data_in = header;
      parity = parity ^ data_in;
      $display("[%0t] Sent Header: %h", $time, data_in);
    end

    @(negedge clk);

    for (i = 0; i < payloadlen; i = i + 1) begin
      wait (!busy)
      @(negedge clk);
      payload_data = {$random} % 256;
      data_in = payload_data;
      parity = parity ^ data_in;
      $display("[%0t] Sent Payload[%0d]: %h", $time, i, payload_data);
    end

    wait (!busy)
    @(negedge clk);
    pkt_valid = 0;
    data_in = parity;
    $display("[%0t] Sent Parity: %h", $time, parity);

    repeat(30) @(negedge clk);
    read_enb_2 = 1'b1;
    $display("[%0t] Read Enable for Port 2 Activated", $time);
  end
  endtask

  // Main test sequence
  initial begin
    reset;         // Apply reset
    #10;
    pktm_gen_8;    // Generate a packet with payload length 8
    // pktm_gen_5;  // Uncomment to test another packet type
    #100;
    $display("[%0t] Simulation Finished", $time);
    $finish;
  end

endmodule