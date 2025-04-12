// 2:1 Multiplexer Module
module mux_2_1(input a, input b, input sel, output y);
    // If sel is 1, output b; otherwise, output a
    assign y = sel ? b : a; 
endmodule

// 4:1 Multiplexer Module
module mux_4_1(
    input [3:0] in,  // 4-bit input data
    input [1:0] sel, // 2-bit select signal
    output y         // Output
    );

    wire y1, y2; // Intermediate wires for 2:1 MUX outputs

    // First stage: Two 2:1 MUXes select between pairs of inputs based on sel[0]
    mux_2_1 m1(.a(in[0]), .b(in[1]), .sel(sel[0]), .y(y1));
    mux_2_1 m2(.a(in[2]), .b(in[3]), .sel(sel[0]), .y(y2));

    // Second stage: Another 2:1 MUX selects between y1 and y2 based on sel[1]
    mux_2_1 m3(.a(y1), .b(y2), .sel(sel[1]), .y(y));

endmodule
