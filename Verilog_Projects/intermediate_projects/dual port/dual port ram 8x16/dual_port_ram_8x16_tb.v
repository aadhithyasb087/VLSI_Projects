module dual_port_ram_8x16_tb;

    // Testbench signals
    reg clk;                      // Clock signal
    reg [15:0] d_in;              // Data input (16-bit)
    reg [2:0] rd_addr;            // Read address (3-bit)
    reg [2:0] wr_addr;            // Write address (3-bit)
    reg re;                       // Read enable
    reg we;                       // Write enable
    reg rst;                      // Synchronous reset
    wire [15:0] d_out;            // Data output (16-bit)

    // Instantiate the dual-port RAM module
    dual_port_ram_8x16 uut (
        .clk(clk),
        .d_in(d_in),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .re(re),
        .we(we),
        .rst(rst),
        .d_out(d_out)
    );

    // Generate clock with 10 time unit period
    always #5 clk = ~clk;

    // Task: Reset the RAM
    task reset_memory;
        begin
            rst = 1;
            #10 rst = 0;  // Hold reset high for 1 clock cycle
        end
    endtask

    // Task: Write 16-bit data to a given address
    task write_data;
        input [2:0] address;
        input [15:0] data;
        begin
            wr_addr = address;
            d_in = data;
            we = 1;
            re = 0;
            #10;
            we = 0;
        end
    endtask

    // Task: Read 16-bit data from a given address
    task read_data;
        input [2:0] address;
        begin
            rd_addr = address;
            re = 1;
            we = 0;
            #10;
            $display("Read data at address %0d: %h", address, d_out);
            re = 0;
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        we = 0;
        re = 0;

        // Step 1: Reset memory
        reset_memory;

        // Step 2: Write test values into memory
        write_data(3'b001, 16'hAAAA);
        write_data(3'b010, 16'hBBBB);
        write_data(3'b011, 16'h59CC);

        // Step 3: Read back and verify the values
        read_data(3'b001);  // Expect 0xAAAA
        read_data(3'b010);  // Expect 0xBBBB
        read_data(3'b011);  // Expect 0x59CC

        // Step 4: End simulation
        $finish;
    end

endmodule