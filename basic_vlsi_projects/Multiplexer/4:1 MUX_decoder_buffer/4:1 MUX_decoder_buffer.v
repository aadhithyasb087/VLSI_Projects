// Tri-State Buffer Module
module tribuf(input in, input cntrl, output y);
    // Tri-state buffer: passes `in` to `y` when `cntrl` is high (1), otherwise outputs high impedance (Z)
    bufif1 BUF(y, in, cntrl);
endmodule

// 4:1 Multiplexer using a 2:4 Decoder and Tri-State Buffers
module mux_4_1_dec_buf(
    input [3:0] in,   // 4-bit input data
    input [1:0] sel,  // 2-bit select signal
    output wor y      // `wor` (wired OR) to handle multiple tri-state outputs
    );

    wire [3:0] w; // One-hot outputs from the decoder

    // Instantiate 2:4 Decoder
    decoder_2_4 dec(
        .a(sel[1]),    // Higher bit of select signal
        .b(sel[0]),    // Lower bit of select signal
        .en(1'b1),     // Enable always ON
        .y3(w[3]), 
        .y2(w[2]), 
        .y1(w[1]), 
        .y0(w[0])
    );

    // Instantiate tri-state buffers
    tribuf b0(.in(in[3]), .cntrl(w[3]), .y(y));
    tribuf b1(.in(in[2]), .cntrl(w[2]), .y(y));
    tribuf b2(.in(in[1]), .cntrl(w[1]), .y(y));
    tribuf b3(.in(in[0]), .cntrl(w[0]), .y(y));

endmodule

/* Description:
4:1 Multiplexer using a 2:4 Decoder and Tri-State Buffers
This project implements a 4:1 multiplexer (MUX) using a 2:4 decoder and tri-state buffers. The multiplexer selects one of four input signals (in[3:0]) based on a 2-bit select signal (sel[1:0]).

Working Principle:
2:4 Decoder (decoder_2_4):

Takes the 2-bit select signal (sel[1:0]) and generates a one-hot output (w[3:0]).

The one-hot encoding means that only one of w[3], w[2], w[1], or w[0] is active (1), while the others remain 0.

Tri-State Buffers (tribuf):

Each buffer receives one input bit (in[3:0]) and is enabled by the corresponding decoder output (w[3:0]).

Since only one w[i] is active at a time, only one buffer drives the output y, while the rest remain in a high-impedance (Z) state. */
