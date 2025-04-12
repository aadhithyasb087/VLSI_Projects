

`timescale 1ns / 1ps

module alu_tb;
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] cmd;
    reg en;
    wire [15:0] res;

    alu uut (
        .a(a),
        .b(b),
        .cmd(cmd),
        .en(en),
        .res(res)
    );

    initial begin
        // Initialize dump file for waveform viewing
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, alu_tb);

        // Monitor signal changes
        $monitor("At time %t, a = %b, b = %b, cmd = %b, en = %b, res = %b", $time, a, b, cmd, en, res);

        // Enable ALU
        en = 1;

        // Test ADD operation
        a = 8'b00001010; b = 8'b00000101; cmd = 4'b0000;
        $display("Performing ADD operation (a + b)...");
        #10;

        // Test SUB operation
        a = 8'b00001010; b = 8'b00000101; cmd = 4'b0001;
        $display("Performing SUB operation (a - b)...");
        #10;

        // Test AND operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0010;
        $display("Performing AND operation (a & b)...");
        #10;

        // Test OR operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0011;
        $display("Performing OR operation (a | b)...");
        #10;

        // Test XOR operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0100;
        $display("Performing XOR operation (a ^ b)...");
        #10;

        // Test NOR operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0101;
        $display("Performing NOR operation (~(a | b))...");
        #10;

        // Test NAND operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0110;
        $display("Performing NAND operation (~(a & b))...");
        #10;

        // Test XNOR operation
        a = 8'b11110000; b = 8'b10101010; cmd = 4'b0111;
        $display("Performing XNOR operation (a ~^ b)...");
        #10;

        // Test SLL operation (shift left)
        a = 8'b00010000; b = 8'b00000001; cmd = 4'b1000;
        $display("Performing SLL operation (a << b)...");
        #10;

        // Test SRL operation (shift right)
        a = 8'b00010000; b = 8'b00000001; cmd = 4'b1001;
        $display("Performing SRL operation (a >> b)...");
        #10;

        // Test DIV operation
        a = 8'b00001000; b = 8'b00000010; cmd = 4'b1010;
        $display("Performing DIV operation (a / b)...");
        #10;

        // Test INC operation
        a = 8'b00001000; cmd = 4'b1011;
        $display("Performing INC operation (a + 1)...");
        #10;

        // Test DEC operation
        a = 8'b00001000; cmd = 4'b1100;
        $display("Performing DEC operation (a - 1)...");
        #10;

        // Test MUL operation
        a = 8'b00000100; b = 8'b00000010; cmd = 4'b1101;
        $display("Performing MUL operation (a * b)...");
        #10;

        // Test BUFF operation
        a = 8'b10101010; cmd = 4'b1110;
        $display("Performing BUFF operation (Pass a as result)...");
        #10;

        // Test INVR operation
        a = 8'b10101010; cmd = 4'b1111;
        $display("Performing INVR operation (~a)...");
        #10;

        // Test with Enable = 0 (should output high impedance 'z')
        en = 0; cmd = 4'b0000;
        $display("Disabling ALU (Enable = 0)...");
        #10;

        // End simulation
        $finish;
    end
endmodule
