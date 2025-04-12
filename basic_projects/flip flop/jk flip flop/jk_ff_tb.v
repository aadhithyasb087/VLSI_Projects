module jk_flip_flop_tb;

    reg clk;        // Clock input
    reg reset;      // Reset input
    reg j;          // J input
    reg k;          // K input
    wire q;         // Output Q
    wire q_bar;     // Complement of Q

    // Instantiate the JK flip-flop
    jk_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .j(j),
        .k(k),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation
    always #5 clk = ~clk;  // Toggle clock every 5 units (10 unit period)

    // Task to initialize signals
    task initialize_signals;
    begin
        clk = 1'b0;
        reset = 1'b0;
        j = 1'b0;
        k = 1'b0;
    end
    endtask

    // Task to apply reset
    task apply_reset;
    begin
        reset = 1'b1; 
        #10;          // Wait for one clock cycle
        reset = 1'b0;
    end
    endtask

    // Task to apply J and K inputs
    task apply_jk(input reg j_value, input reg k_value);
    begin
        j = j_value; 
        k = k_value;
        #10;          // Wait for one clock cycle
    end
    endtask

    // Monitor the signals and display output
    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | j: %b | k: %b | q: %b | q_bar: %b", 
                 $time, clk, reset, j, k, q, q_bar);
    end

    // Dump waveform data for visualization
    initial begin
        $dumpfile("jk_flip_flop_tb.vcd");  // Specify VCD file
        $dumpvars(0, jk_flip_flop_tb);     // Dump all variables
    end

    // Testbench process to apply test cases
    initial begin
        initialize_signals;  // Initialize signals

        // Test Case 1: Apply reset
        apply_reset;

        // Test Case 2: Apply different J and K inputs and observe the behavior
        apply_jk(1'b0, 1'b0);  // J = 0, K = 0 (No change)
        apply_jk(1'b0, 1'b1);  // J = 0, K = 1 (Reset Q to 0)
        apply_jk(1'b1, 1'b0);  // J = 1, K = 0 (Set Q to 1)
        apply_jk(1'b1, 1'b1);  // J = 1, K = 1 (Toggle Q)

        // Test Case 3: Apply reset again
        apply_reset;

        #20;            // Wait for a few clock cycles
        $finish;        // End simulation
    end

endmodule