// Priority Circuit: Identifies the highest priority bit
module priority_circuit (
    input [7:0] in,     // 8-bit input
    output [7:0] prio   // One-hot encoded output
);
    // Assign the highest priority bit to '1', all lower bits remain '0'
    assign prio[7] = in[7];
    assign prio[6] = in[6] & ~in[7];
    assign prio[5] = in[5] & ~in[6] & ~in[7];
    assign prio[4] = in[4] & ~in[5] & ~in[6] & ~in[7];
    assign prio[3] = in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign prio[2] = in[2] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign prio[1] = in[1] & ~in[2] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign prio[0] = in[0] & ~in[1] & ~in[2] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];

endmodule

// Encoder: Converts one-hot priority output to 3-bit binary
module encoder (
    input [7:0] prio,  // One-hot encoded input from priority circuit
    output [2:0] Y     // 3-bit binary output
);
    // OR gates to generate the binary equivalent of the highest priority bit
    assign Y[2] = prio[4] | prio[5] | prio[6] | prio[7];   // Y2 = OR of prio[4] to prio[7]
    assign Y[1] = prio[2] | prio[3] | prio[6] | prio[7];   // Y1 = OR of prio[2], prio[3], prio[6], prio[7]
    assign Y[0] = prio[1] | prio[3] | prio[5] | prio[7];   // Y0 = OR of prio[1], prio[3], prio[5], prio[7]

endmodule

// Top-Level Module: Combines Priority Circuit and Encoder
module pri_encoder_8_3(
    input [7:0] in,     // 8-bit input
    output [2:0] out    // 3-bit priority encoded output
);
    wire [7:0] prio;  // Internal wire for priority encoding

    // Instantiate the priority circuit
    priority_circuit pc (
        .in(in),
        .prio(prio)
    );

    // Instantiate the encoder
    encoder enc (
        .prio(prio),
        .Y(out)
    );

endmodule
