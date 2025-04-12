// Module: rp_carry_adr
// Description: 4-bit Ripple Carry Adder using full_adder_dataflow modules
// Adds two 4-bit numbers (a and b) with a carry-in (c_in)
// Produces a 4-bit sum and a carry-out (c_out)

module rp_carry_adr(
    input [3:0] a,         // 4-bit input operand a
    input [3:0] b,         // 4-bit input operand b
    input c_in,            // Initial carry-in
    output [3:0] sum,      // 4-bit sum output
    output c_out           // Final carry-out
    );

    // Internal wires for carry between full adders
    wire c0;
    wire c1;
    wire c2;

    // First full adder: LSB addition
    full_adder_dataflow fa1 (
        .a(a[0]), 
        .b(b[0]), 
        .c_in(c_in),          // Initial carry-in
        .sum_out(sum[0]),     // Sum bit 0
        .carry_out(c0)        // Carry to next stage
    );

    // Second full adder
    full_adder_dataflow fa2 (
        .a(a[1]), 
        .b(b[1]), 
        .c_in(c0),            // Carry from previous stage
        .sum_out(sum[1]),     // Sum bit 1
        .carry_out(c1)        // Carry to next stage
    );

    // Third full adder
    full_adder_dataflow fa3 (
        .a(a[2]), 
        .b(b[2]), 
        .c_in(c1),            // Carry from previous stage
        .sum_out(sum[2]),     // Sum bit 2
        .carry_out(c2)        // Carry to next stage
    );

    // Fourth full adder: MSB addition
    full_adder_dataflow fa4 (
        .a(a[3]), 
        .b(b[3]), 
        .c_in(c2),            // Carry from previous stage
        .sum_out(sum[3]),     // Sum bit 3
        .carry_out(c_out)     // Final carry-out
    );

endmodule

