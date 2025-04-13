module dual_port_ram_16x8_tb;

    // Testbench signals
    reg clk;                         // Clock signal
    reg [7:0] d_in;                  // Data input to RAM
    reg [3:0] rd_addr;               // Read address
    reg [3:0] wr_addr;               // Write address
    reg re;                          // Read enable
    reg we;                          // Write enable
    reg rst;                         // Reset signal
    wire [7:0] d_out;                // Data output from RAM

    // Instantiate the dual-port RAM
    dual_port_ram_16x8 uut (
        .clk(clk),
        .d_in(d_in),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .re(re),
        .we(we),
        .rst(rst),
        .d_out(d_out)
    );

    // Clock generation: Toggle every 5 time units (10-unit period)
    always #5 clk = ~clk;

    // Task: Reset memory
    task reset_memory;
        begin
            rst = 1;
            #10;           // Hold reset for 1 clock cycle
            rst = 0;
        end
    endtask

    // Task: Write data to specific address
    task write_data;
        input [3:0] address;
        input [7:0] data;
        begin
            wr_addr = address;
            d_in = data;
            we = 1;
            re = 0;
            #10;           // Wait for 1 clock cycle
            we = 0;
        end
    endtask

    // Task: Read data from specific address
    task read_data;
        input [3:0] address;
        begin
            rd_addr = address;
            re = 1;
            we = 0;
            #10;           // Wait for 1 clock cycle
            $display("Read data at address %0d: %h", address, d_out);
            re = 0;
        end
    endtask

    // Test sequence
    initial begin
        // Initialize all control signals
        clk = 0;
        rst = 0;
        we = 0;
        re = 0;

        // Step 1: Reset the memory
        reset_memory;

        // Step 2: Write data into memory
        write_data(4'b0001, 8'hA5);  // Write 0xA5 to address 1
        write_data(4'b0010, 8'h3C);  // Write 0x3C to address 2
        write_data(4'b0011, 8'h7F);  // Write 0x7F to address 3

        // Step 3: Read and verify the written data
        read_data(4'b0001);          // Expect 0xA5
        read_data(4'b0010);          // Expect 0x3C
        read_data(4'b0011);          // Expect 0x7F

        // Step 4: End simulation
        $finish;
    end

endmodule