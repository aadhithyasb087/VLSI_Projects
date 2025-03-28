module bidir_buffer_tb;

    // Testbench signals
    wire a;        // Wire type for 'a'
    wire b;        // Wire type for 'b'
    reg temp_a;    // Input signal for a
    reg temp_b;    // Input signal for b
    reg cntrl;     // Control signal for the buffer

    // Instantiate the bidirectional buffer module
    bidir_buffer uut (
        .a(a),      // Connect 'a' to 'a' of the module
        .b(b),      // Connect 'b' to 'b' of the module
        .cntrl(cntrl)  // Control signal to manage direction
    );

    // Continuous assignments to drive 'a' and 'b'
    assign a = (cntrl == 1'b1) ? temp_a : 1'bz; // If cntrl=1, drive a with temp_a, else high-impedance
    assign b = (cntrl == 1'b0) ? temp_b : 1'bz; // If cntrl=0, drive b with temp_b, else high-impedance

    // Testbench stimulus
    initial begin
        // Test case 1: cntrl = 1, should pass 'a' to 'b' (b = a)
        cntrl = 1'b1;        // Set cntrl to 1 (passing a -> b)
        temp_a = 1'b1;       // Set a to 1
        temp_b = 1'b0;       // Set b to 0
        #10;                 // Wait for 10 time units
        $display("Time:%0t a:%b b:%b cntrl:%b", $time, a, b, cntrl);  // Display results

        // Test case 2: cntrl = 0, should pass 'b' to 'a' (a = b)
        cntrl = 1'b0;        // Set cntrl to 0 (passing b -> a)
        temp_a = 1'b0;       // Set a to 0
        temp_b = 1'b1;       // Set b to 1
        #10;                 // Wait for 10 time units
        $display("Time:%0t a:%b b:%b cntrl:%b", $time, a, b, cntrl);  // Display results

        // Test case 3: cntrl = 1, a = 0, should pass 'a' to 'b' (b = a)
        cntrl = 1'b1;        // Set cntrl to 1 (passing a -> b)
        temp_a = 1'b0;       // Set a to 0
        temp_b = 1'b1;       // Set b to 1
        #10;                 // Wait for 10 time units
        $display("Time:%0t a:%b b:%b cntrl:%b", $time, a, b, cntrl);  // Display results

        // Finish the simulation
        $finish;
    end
endmodule

