module tb_mealy_fsm_seq_det;

    reg clk;
    reg rst;
    reg seq_in;
    wire out;

    // Instantiate the Mealy FSM Sequence Detector
    mealy_fsm_seq_det uut (
        .clk(clk),
        .rst(rst),
        .seq_in(seq_in),
        .out(out)
    );

    // Clock generation: toggles every 5 time units (10ns period)
    always #5 clk = ~clk;

    // Display header and monitor every change
    initial begin
        $display("--------------------------------------------------");
        $display("Time\tReset\tSeq_in\tOutput");
        $display("--------------------------------------------------");
        $monitor("%0t\t%b\t%b\t%b", $time, rst, seq_in, out);
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        seq_in = 0;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        $display("\n--- Test 1: Non-overlapping sequence 101 ---");
        #10 seq_in = 1;
        #10 seq_in = 0;
        #10 seq_in = 1;  // Expected Output: 1

        // Reset before next sequence
        #10 rst = 1;
        #10 rst = 0;

        $display("\n--- Test 2: Overlapping sequences 101101 ---");
        #10 seq_in = 1;
        #10 seq_in = 0;
        #10 seq_in = 1;  // Expected Output: 1
        #10 seq_in = 1;
        #10 seq_in = 0;
        #10 seq_in = 1;  // Expected Output: 1 again
        #10 seq_in = 0;
        #10 seq_in = 1;  // Expected Output: 1 again (optional depending on FSM logic)

        $display("\n--- Test complete ---");

        // End simulation
        #10 $finish;
    end

endmodule
