module FIFO_16x8_tb;

    // Testbench signals
    reg clk;               // Clock
    reg rst;               // Reset
    reg we;                // Write enable
    reg re;                // Read enable
    reg [7:0] data_in;     // Input data to FIFO
    wire [7:0] data_out;   // Output data from FIFO
    wire full;             // FIFO full flag
    wire empty;            // FIFO empty flag

    // Instantiate the FIFO module under test (UUT)
    FIFO_16x8 uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .re(re),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation: Toggle every 5 time units (10-unit clock period)
    always #5 clk = ~clk;

    // Task: Initialize all signals to default values
    task initialize_signals;
    begin
        clk = 0;       // Start with clock low
        rst = 0;       // Deassert reset
        we = 0;        // Disable write
        re = 0;        // Disable read
        data_in = 0;   // Zero input data
    end
    endtask

    // Task: Apply synchronous reset to FIFO
    task apply_rst;
    begin
        rst = 1;       // Assert reset
        #10;           // Wait for 1 clock cycle
        rst = 0;       // Deassert reset
    end
    endtask

    // Task: Write a single byte of data into FIFO
    task write_data(input [7:0] data);
    begin
        we = 1;             // Enable write
        data_in = data;     // Set input data
        #10;                // Wait one clock cycle
        $display("Write -> data_in: %h | full: %b | empty: %b", data_in, full, empty);
        we = 0;             // Disable write
    end
    endtask

    // Task: Read a single byte of data from FIFO
    task read_data;
    begin
        re = 1;             // Enable read
        #10;                // Wait one clock cycle
        $display("Read  -> data_out: %h | full: %b | empty: %b", data_out, full, empty);
        re = 0;             // Disable read
    end
    endtask

    // Dump waveform data to VCD file for visualization in tools like GTKWave
    initial begin
        $dumpfile("fifo_16x8_tb.vcd");   // VCD output file
        $dumpvars(0, FIFO_16x8_tb);      // Dump all variables in this module
    end

    // Main test sequence
    initial begin
        initialize_signals;  // Set initial values
        apply_rst;           // Reset the FIFO

        // Test Case 1: Write 17 values into FIFO (1 more than its capacity)
        // This will test the 'full' condition
        repeat (17)
            write_data({$random} % 8);  // Write random values (0-7)

        // Test Case 2: Read 17 values from FIFO (1 more than written)
        // This will test the 'empty' condition
        repeat (17)
            read_data;

        #20;    // Wait some extra time
        $finish; // End simulation
    end

endmodule