module pri_encoder_8_3_tb;


    reg [7:0] in;           // Test input
    wire [2:0] Y;           // Test output

    // Instantiate the 8-to-3 priority encoder
    pri_encoder_8_3 uut (
        .in(in),
        .out(Y)
    );

    initial begin
        // Test case 1: Only input 0 is active
        in = 8'b00000001; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 000

        // Test case 2: Only input 3 is active
        in = 8'b00001000; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 011

        // Test case 3: Input 7 is active (highest priority)
        in = 8'b10000000; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 111

        // Test case 4: Inputs 6 and 7 are active (7 takes priority)
        in = 8'b11000000; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 111

        // Test case 5: Inputs 4 and 2 are active (4 takes priority)
        in = 8'b00010100; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 100

        // Test case 6: No inputs are active
        in = 8'b00000000; #10; 
        $display("Input: %b, Output: %b", in, Y); // Expected Output: 000 (Default)

        $finish;
    end
endmodule

