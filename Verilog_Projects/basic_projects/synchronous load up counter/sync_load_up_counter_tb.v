module sync_load_up_counter_tb;

    reg clk;                    // Clock input
    reg rst;                  // rst input
    reg load;                   // Load signal
    reg [3:0] d_in;       // Load value
    wire [3:0] count;           // Counter output

    // Instantiate the synchronous up counter
    sync_load_up_counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .d_in(d_in),
        .count(count)
    );

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 units (10-unit period)

    // Task to initialize signals
    task initialize_signals;
    begin
        clk = 0;
        rst = 0;
        load = 0;
        d_in = 4'b0000;
    end
    endtask

    // Task to apply rst
    task apply_rst;
    begin
        rst = 1;
        #10;          // Wait for one clock cycle
        rst = 0;
    end
    endtask

    // Task to load a value
    task apply_load(input [3:0] value);
    begin
        d_in = value;
        load = 1;
        #10;          // Wait for one clock cycle
        load = 0;
    end
    endtask

    // Monitor and display the output
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | load: %b | d_in: %b | count: %b", 
                 $time, clk, rst, load, d_in, count);
    end

    // Dump waveform data
    initial begin
        $dumpfile("sync_up_counter_tb.vcd"); // VCD file for waveform
        $dumpvars(0, sync_load_up_counter_tb);    // Dump all variables
    end

    // Testbench sequence
    initial begin
        initialize_signals;

        // Test Case 1: rst the counter
        apply_rst;

        // Test Case 2: Allow the counter to increment
        #40;

        // Test Case 3: Load a value into the counter
        apply_load(4'b1010); // Load the value 10
        #20;

        // Test Case 4: Allow the counter to increment after load
        #40;

        // Test Case 5: Load another value
        apply_load(4'b0011); // Load the value 3
        #20;

        #40; // Allow further increments
        $finish; // End simulation
    end

endmodule