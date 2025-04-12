module ring_counter_4bit_tb;

    reg clk, presetn, clearn;
    wire [3:0] count;

    // Instantiate the ring counter
    ring_counter_4bit uut (
        .clk(clk),
        .presetn(presetn),
        .clearn(clearn),
        .count(count)
    );

    // Clock generation (negedge triggered)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0; presetn = 1; clearn = 1;
		  
		   // Set up waveform dump
        $dumpfile("ring_counter_waveform.vcd");  // File name for waveform dump
        $dumpvars(0, uut);  // Dump all variables from the testbench module

        $monitor("Time: %0t | clk: %b | presetn: %b | clearn: %b | count: %b", $time, clk, presetn, clearn, count);

        // Apply reset and clear signals
        clearn = 0; #10;
        clearn = 1; #10;
        
        // Apply preset to set the counter to 1
        presetn = 0; #10;
        presetn = 1; #10;

        // Test counter counting behavior
        #100; // Wait for some clock cycles	

        // End simulation
        $finish;
    end

endmodule
