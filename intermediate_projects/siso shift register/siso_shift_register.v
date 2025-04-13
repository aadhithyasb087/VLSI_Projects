module siso_shift_register (
    input wire clk,         // Clock input: Controls the timing of the register operations
    input wire rst,         // Synchronous reset: Resets the shift register to 0
    input wire serial_in,   // Serial input: The new data bit to be shifted into the register
    output wire serial_out  // Serial output: The bit that is shifted out (least significant bit)
);

    // Internal 4-bit shift register
    // A register of 4 bits to hold the shifted data
    reg [3:0] shift_reg;

    // Always block triggered on the rising edge of the clock (posedge clk)
    always @(posedge clk) begin
        // Check if the reset signal is high
        if (rst)
            shift_reg <= 4'b0000; // Reset the register to 0 (4-bit 0000)
        else begin
            // Shift the contents of the register right by 1 bit and load the new serial_in bit
            // The new serial_in value is placed in the leftmost bit (most significant bit),
            // while the other bits move one position to the right.
            shift_reg <= {serial_in, shift_reg[3:1]}; 
        end
    end

    // Assign the least significant bit of the shift register to the serial output
    // This will output the current state of the least significant bit (LSB).
    assign serial_out = shift_reg[0]; // Serial output is the LSB of the shift register

endmodule