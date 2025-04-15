module multiplier(
  input  [3:0] a,  // 4-bit input 'a'
  input  [3:0] b,  // 4-bit input 'b'
  output [7:0] y   // 8-bit output 'y' (product of a and b)
);

  assign y = a * b; // simple combinational multiplier

endmodule
