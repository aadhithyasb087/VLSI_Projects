module tribuf(input in,input cntrl,output y);

    bufif1 BUF(y,in,cntrl);

endmodule

module mux_4_1_dec_buf(
    input [3:0] in,
    input [1:0] sel,
    output wor y
    );
    wire [3:0] w;        // Decoder outputs (one-hot encoded)
   // wire [3:0] buf_out;  // Outputs from tri-state buffers

    // Instantiate 2:4 Decoder
    decoder_2_4 dec(
        .a(sel[1]),
        .b(sel[0]),
        .en(1'b1),       // Enable always ON
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

    // Combine the outputs of the buffers (only one will drive `y`)
 //  assign y = (w[0] ? buf_out[0] : (w[1] ? buf_out[1] : (w[2] ? buf_out[2] : buf_out[3])));

endmodule
