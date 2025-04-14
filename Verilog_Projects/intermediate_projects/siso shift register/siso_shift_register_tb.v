module siso_shift_register_tb;

    // Declare inputs and outputs for the testbench
    reg clk;              // Clock input (to drive the shift register)
    reg rst;              // Reset input (to reset the shift register)
    reg serial_in;        // Serial input (data to be shifted in)
    wire serial_out;      // Serial output (output of the shift register)

    // Instantiate the SISO shift register module under test (uut)
    siso_shift_register uut (
        .clk(clk),          // Connect clock
        .rst(rst),          // Connect reset
        .serial_in(serial_in), // Connect serial input
        .serial_out(serial_out) // Connect serial output
    );

    // Clock generation: Toggle the clock every 5 time units (10-unit period)
    always #5 clk = ~clk;

    // Task to initialize signals to default values
    task initialize_signals;
    begin
        clk = 0;          // Set clock to 0 initially
        rst = 0;          // Set reset to 0 initially (no reset)
        serial_in = 0;    // Set serial input to 0 initially
    end
    endtask

    // Task to apply reset (rst)
    task apply_rst;
    begin
        rst = 1;          // Activate reset
        #10;              // Wait for one clock cycle (ensure reset takes effect)
        rst = 0;          // Deactivate reset after the wait
    end
    endtask

    // Task to apply serial input to the shift register
    task apply_serial_input(input value);
    begin
        serial_in = value;  // Apply the given serial input value
        #10;                // Wait for one clock cycle (observe effect)
    end
    endtask

    // Monitor and display the simulation output
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | serial_in: %b | serial_out: %b | shift_reg: %b", 
                 $time, clk, rst, serial_in, serial_out, uut.shift_reg); // Monitor values of clk, rst, serial_in, serial_out, and shift_reg
    end

    // Dump waveform data for viewing in a waveform viewer (e.g., GTKWave)
    initial begin
        $dumpfile("siso_shift_register_tb.vcd");  // Create a VCD (Value Change Dump) file for waveform output
        $dumpvars(0, siso_shift_register_tb);     // Dump all variables in the testbench to the VCD file
    end

    // Testbench sequence: Steps to verify the SISO shift register behavior
    initial begin
        initialize_signals; // Initialize the signals before starting the test sequence

        // Test Case 1: Apply reset
        apply_rst; // Apply the reset signal and check the state of the shift register

        // Test Case 2: Shift in data serially
        apply_serial_input(1);  // Shift in '1'
        apply_serial_input(0);  // Shift in '0'
        apply_serial_input(1);  // Shift in '1'
        apply_serial_input(1);  // Shift in '1'

        // Allow a few more shifts to observe output
        apply_serial_input(0);  // Shift in '0'
        apply_serial_input(0);  // Shift in '0'
        apply_serial_input(1);  // Shift in '1'

        #20; // Allow a few more clock cycles for the output to stabilize

        $finish; // End the simulation
    end

endmodule