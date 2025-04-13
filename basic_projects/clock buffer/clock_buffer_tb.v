module clock_buffer_tb;

    // Testbench signals
    reg clk_in;             // Input clock to the buffer
    wire clk_out;           // Output clock from the buffer

    // Timing variables to track clock edge timings
    reg t1, t2, t3;         // t1 and t2: input clock rising edges, t3: input clock period
    reg t4, t5, t6;         // t4 and t5: output clock rising edges, t6: output clock period

    // Instantiate the clock buffer module (Unit Under Test)
    clock_buffer uut (
        .clk_in(clk_in),
        .clk_out(clk_out)
    );

    // Generate a clock signal: 10 ns period (100 MHz)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;  // Toggle every 5 time units
    end

    // Task to measure the time period of clk_in
    task input_tp;
    begin
        @(posedge clk_in) t1 = $time;   // Capture first rising edge time of clk_in
        @(posedge clk_in) t2 = $time;   // Capture second rising edge
        t3 = t2 - t1;                   // Calculate period of clk_in
    end
    endtask

    // Task to measure the time period of clk_out
    task output_tp;
    begin
        @(posedge clk_out) t4 = $time;  // Capture first rising edge time of clk_out
        @(posedge clk_out) t5 = $time;  // Capture second rising edge
        t6 = t5 - t4;                   // Calculate period of clk_out
    end
    endtask

    // Task to compare frequency and phase differences
    task freq_phase;
        realtime freq, phase;
    begin
        freq = t6 - t3;                 // Difference in clock periods (should be zero ideally)
        phase = t4 - t1;                // Phase difference between input and output clocks
        $display("freq_diff: %0t, phase_diff: %0t", freq, phase);
    end
    endtask

    // Main test sequence
    initial begin
        fork
            input_tp;       // Start measuring input clock timing
            output_tp;      // Start measuring output clock timing
        join

        freq_phase;         // Calculate and display frequency and phase differences

        // Dump waveform data for debugging/analysis
        $dumpfile("clock_buffer.vcd");
        $dumpvars(0, clock_buffer_tb);

        #10 $finish;        // End simulation
    end

endmodule