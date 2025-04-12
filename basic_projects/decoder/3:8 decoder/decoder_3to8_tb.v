module decoder_3to8_tb;

    reg [2:0] in;        // 3-bit input for the decoder
    reg enable;          // Enable input
    wire [7:0] out;      // 8-bit output from the decoder

    // Instantiate the 3-to-8 Decoder
    decoder_3to8 uut (
        .in(in),
        .enable(enable),
        .out(out)
    );

    // Task to initialize the inputs
    task initialize_inputs;
    begin
        in = 3'b000;        // Initialize input to 000
        enable = 1'b0;      // Disable the decoder initially
    end
    endtask

    // Task to apply inputs and observe output
    task apply_data;
        input [2:0] input_data;
        input enable_signal;
    begin
        in = input_data;    // Apply the 3-bit input
        enable = enable_signal;  // Apply the enable signal
        #10;                // Wait for 10 time units
    end
    endtask

    // Monitor the signals and display output
    initial begin
        $monitor("At time %0t: in = %b, enable = %b, out = %b", $time, in, enable, out);
    end

    // Dump waveform data for visualization
    initial begin
        $dumpfile("decoder3to8_tb.vcd");  // Specify VCD file for waveform
        $dumpvars(0, decoder_3to8_tb);     // Dump all variables in testbench
    end

    // Testbench process to apply different input values and enable signals
    initial begin
        initialize_inputs;  // Initialize inputs first
        
        // Apply inputs and observe output
        apply_data(3'b000, 1'b1); // Apply input 000 with enable high
        apply_data(3'b001, 1'b1); // Apply input 001 with enable high
        apply_data(3'b010, 1'b1); // Apply input 010 with enable high
        apply_data(3'b011, 1'b1); // Apply input 011 with enable high
        apply_data(3'b100, 1'b1); // Apply input 100 with enable high
        apply_data(3'b101, 1'b1); // Apply input 101 with enable high
        apply_data(3'b110, 1'b1); // Apply input 110 with enable high
        apply_data(3'b111, 1'b1); // Apply input 111 with enable high

        // Apply input with enable off (all output should be zero)
        apply_data(3'b001, 1'b0); // Apply input 001 with enable low
        apply_data(3'b010, 1'b0); // Apply input 010 with enable low

        $finish;  // End simulation after all test cases
    end

endmodule
