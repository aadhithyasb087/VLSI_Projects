// D Flip-Flop Module with synchronous reset
module dff(
  input clk,      // Clock input
  input rst,      // Synchronous reset input (active high)
  input din,      // Data input
  output reg dout // Data output (register)
);

  // Always block triggered on the rising edge of the clock
  always@(posedge clk)
  begin
    if (rst)
      // If reset is asserted, set output to 0
      dout <= 1'b0;
    else
      // Otherwise, latch the input value
      dout <= din;
  end

endmodule


//////////////////////////////////////////////////

// Interface definition for the D Flip-Flop
interface dff_if;
  logic clk;   // Clock signal
  logic rst;   // Reset signal
  logic din;   // Data input
  logic dout;  // Data output
endinterface
