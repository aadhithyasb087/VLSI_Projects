//=============================================================
// Testbench: sync_load_updown_counter_tb
// Description:
//   Testbench for the synchronous loadable up/down counter.
//   Tests reset, load, up-counting, down-counting, and value loading.
//=============================================================

module sync_load_updown_counter_tb;

    // Testbench Signals
    reg clk;                     // Clock input
    reg rst;                     // Reset signal
    reg load;                    // Load control
    reg updown;                  // Up/down control signal
    reg [3:0] d_in;              // Data input for loading
    wire [3:0] count;            // Counter output

    // DUT Instantiation (Device Under Test)
    sync_load_updown_counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .updown(updown),
        .d_in(d_in),
        .count(count)
    );

    // Clock Generation: Toggle every 5 time units
    always #5 clk = ~clk;

    // Task: Initialize all input signals
    task initialize_signals;
    begin
        clk = 0;
        rst = 0;
        load = 0;
        updown = 1;     // Default to counting up
        d_in = 4'b0000; // Default load value
    end
    endtask

    // Task: Apply synchronous reset
    task apply_rst;
    begin
        rst = 1;
        #10;         // Wait one clock cycle
        rst = 0;
    end
    endtask

    // Task: Load a specific value into the counter
    task apply_load(input [3:0] value);
    begin
        d_in = value;
        load = 1;
        #10;         // Wait one clock cycle
        load = 0;
    end
    endtask

    // Task: Change counter direction
    task change_direction(input dir);
    begin
        updown = dir; // 1 for up, 0 for down
    end
    endtask

    // Output Monitor
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | load: %b | updown: %b | d_in: %b | count: %b", 
                 $time, clk, rst, load, updown, d_in, count);
    end

    // Dump waveforms for GTKWave
    initial begin
        $dumpfile("sync_updown_counter_tb.vcd");
        $dumpvars(0, sync_load_updown_counter_tb);
    end

    // Main Test Sequence
    initial begin
        initialize_signals;

        // Test Case 1: Reset the counter
        apply_rst;

        // Test Case 2: Allow counter to count up for a few cycles
        #60;

        // Test Case 3: Load specific value (10)
        apply_load(4'b1010);
        #20;

        // Test Case 4: Switch to down counting
        change_direction(0);
        #60;

        // Test Case 5: Load a new value (3)
        apply_load(4'b0011);
        #20;

        // Test Case 6: Switch back to up counting
        change_direction(1);
        #60;

        $finish; // End simulation
    end

endmodule