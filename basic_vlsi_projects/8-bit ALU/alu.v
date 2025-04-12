// 8-bit ALU Module with 16-bit output
module alu (
    input [7:0] a,           // Operand A
    input [7:0] b,           // Operand B
    input [3:0] cmd,         // Operation selector
    input en,                // Enable signal
    output reg [15:0] res    // Result output
);

    // ALU operation codes
    parameter ADD   = 4'b0000;  // Addition
    parameter SUB   = 4'b0001;  // Subtraction
    parameter AND   = 4'b0010;  // Bitwise AND
    parameter OR    = 4'b0011;  // Bitwise OR
    parameter XOR   = 4'b0100;  // Bitwise XOR
    parameter NOR   = 4'b0101;  // Bitwise NOR
    parameter NAND  = 4'b0110;  // Bitwise NAND
    parameter XNOR  = 4'b0111;  // Bitwise XNOR
    parameter SLL   = 4'b1000;  // Logical Shift Left (a << b)
    parameter SRL   = 4'b1001;  // Logical Shift Right (a >> b)
    parameter DIV   = 4'b1010;  // Division (a / b)
    parameter INC   = 4'b1011;  // Increment A
    parameter DEC   = 4'b1100;  // Decrement A
    parameter MUL   = 4'b1101;  // Multiplication (a * b)
    parameter BUFF  = 4'b1110;  // Buffer (passes A)
    parameter INVR  = 4'b1111;  // Inverter (~A)

    // ALU operation logic
    always @(*) begin
        if (en) begin
            case (cmd)
                ADD   : res = a + b;
                SUB   : res = a - b;
                AND   : res = a & b;
                OR    : res = a | b;
                XOR   : res = a ^ b;
                NOR   : res = ~(a | b);
                NAND  : res = ~(a & b);
                XNOR  : res = ~(a ^ b);
                SLL   : res = a << b;
                SRL   : res = a >> b;
                DIV   : res = (b != 0) ? a / b : 16'hFFFF;  // Prevent divide by zero
                INC   : res = a + 1;
                DEC   : res = a - 1;
                MUL   : res = a * b;
                BUFF  : res = a;
                INVR  : res = ~a;
                default: res = 16'd0;  // Safety default
            endcase
        end else begin
            res = 16'bz;  // High impedance when not enabled
        end
    end

endmodule
