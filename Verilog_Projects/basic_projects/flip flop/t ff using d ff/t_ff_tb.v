module t_flip_flop_tb;

    reg clk;       // Clock signal
    reg reset;     // Reset signal
    reg t;         // Data input
    wire q;        // Flip-flop output
    wire q_bar;    // Complement of output

    // Instantiate the D Flip-Flop
    t_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .t(t),
        .q(q),
        .q_bar(q_bar)
    );

    // Task to initialize signals
    task initialize_signals;
    begin
        clk = 1'b0;
        reset = 1'b0;
        t = 1'b0;
    end
    endtask

    // Task to apply a reset
    task apply_reset;
    begin
	 @(negedge clk)
        reset = 1'b1;
	 @(negedge clk)
        reset = 1'b0;
    end
    endtask

    // Task to apply a data input
    task apply_data(input reg data_value);
    begin
	 @(negedge clk)
        t = data_value;
    end
    endtask

    // Clock generation
    always #5 clk = ~clk;  // Generate clock with period of 10 units

    // Monitor the signals and display output
    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | d: %b | q: %b | q_bar: %b", 
                 $time, clk, reset, t, q, q_bar);
    end

    // Dump waveform data for visualization
    initial begin
        $dumpfile("d_flip_flop_sync_reset_tb.vcd");  // Specify VCD file
        $dumpvars(0, t_flip_flop_tb);     // Dump all variables
    end

    // Testbench process to apply test cases
    initial begin
        initialize_signals;  // Initialize signals

        // Test Case 1: Apply reset
        apply_reset;         // Assert reset signal
        
        // Test Case 2: Apply data inputs with clock cycles
        apply_data(1'b0);    // Apply data = 0
        apply_data(1'b1);    // Apply data = 1
        apply_data(1'b0);    // Apply data = 0

        // Test Case 3: Assert reset again
        apply_reset;         // Assert reset signal again

        // Test Case 4: Apply more data inputs
        apply_data(1'b1);    // Apply data = 1
        apply_data(1'b0);    // Apply data = 0

        #20;                 // Wait for a few clock cycles
        $finish;             // End the simulation
    end

endmodule