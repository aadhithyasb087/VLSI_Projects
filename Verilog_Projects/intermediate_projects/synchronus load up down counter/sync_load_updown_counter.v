module sync_load_updown_counter (
  input clk,
  input reset,                // Synchronous reset
  input up_down,              // 1: up, 0: down
  input load,                 // Load enable
  input [3:0] load_data,      // Data to load
  output reg [3:0] count      // 4-bit counter output
);

  always @(posedge clk) begin
    if (reset) begin
      if (up_down)
        count <= 4'd0;         // Up counter starts at 0
      else
        count <= 4'd15;        // Down counter starts at 15
    end
    else if (load)
      count <= load_data;      // Load input value
    else if (up_down) begin
      if (count == 4'd15)
        count <= 4'd0;         // Wrap from 15 to 0
      else
        count <= count + 1;
    end
    else begin
      if (count == 4'd0)
        count <= 4'd15;        // Wrap from 0 to 15
      else
        count <= count - 1;
    end
  end

endmodule
