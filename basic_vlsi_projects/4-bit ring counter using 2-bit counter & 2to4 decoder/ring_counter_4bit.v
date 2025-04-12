module counter_2bit (
    input clk,              // Clock signal (negedge triggered)
    input presetn,          // Active-low preset (sets counter to 0)
    input clearn,           // Active-low clear (resets counter to 0)
    output reg [1:0] count  // 2-bit counter output
);

    always @(negedge clk or negedge presetn or negedge clearn) begin
        if (~clearn) begin
            count <= 2'b00; // clear to 0
        end else if (~presetn) begin
            count <= 2'b00; // Preset
        end else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule


// 2-to-4 Decoder Module
module decoder_2to4 (
    input [1:0] in,    // 2-bit input from the counter
    input clearn,      // Active-low clear signal
    output reg [3:0] out // 4-bit output to represent the ring counter state
);

    always @(*) begin
        if (~clearn) begin  // Check if clear is active-low (clearn = 0)
            out = 4'b0000;   // Output 0000 when clear is active
        end else begin
            case (in)
                2'b00: out = 4'b0001;  // First bit high
                2'b01: out = 4'b0010;  // Second bit high
                2'b10: out = 4'b0100;  // Third bit high
                2'b11: out = 4'b1000;  // Fourth bit high
                default: out = 4'b0000; // Default case (shouldn't occur)
            endcase
        end
    end

endmodule


// 4-bit Ring Counter
module ring_counter_4bit (
    input clk,            // Clock signal (negedge triggered)
    input presetn,        // Active-low preset
    input clearn,         // Active-low clear
    output [3:0] count    // 4-bit ring counter output
);

    wire [1:0] counter_out;
    wire [3:0] decoder_out;

    // Instantiate the 2-bit counter
    counter_2bit u_counter (
        .clk(clk),
        .presetn(presetn),
        .clearn(clearn),
        .count(counter_out)
    );

    // Instantiate the 2-to-4 decoder
    decoder_2to4 u_decoder (
        .in(counter_out),
        .clearn(clearn),
        .out(decoder_out)
    );

    assign count = decoder_out; // Ring counter output

endmodule
