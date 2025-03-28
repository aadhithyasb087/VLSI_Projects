// 2-to-4 Decoder Module
module decoder_2_4(
    input a,   // First select bit
    input b,   // Second select bit
    input en,  // Enable signal
    output y0, // Output corresponding to 00
    output y1, // Output corresponding to 01
    output y2, // Output corresponding to 10
    output y3  // Output corresponding to 11
    );

    // Decoder logic: Outputs one-hot encoded signals based on (a, b) inputs
    assign y0 = (~a & ~b & en); // Select 00
    assign y1 = (~a & b & en);  // Select 01
    assign y2 = (a & ~b & en);  // Select 10
    assign y3 = (a & b & en);   // Select 11

endmodule
