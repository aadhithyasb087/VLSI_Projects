// Testbench for 4:1 Multiplexer (mux_4_1_dec_buf)
module mux_4_1_dec_buf_tb;

	// Inputs (registers to store test values)
	reg [3:0] in;   // 4-bit input data
	reg [1:0] sel;  // 2-bit selection signal

	// Output (wire to capture the output of the UUT)
	wire y; 

	// Instantiate the Unit Under Test (UUT)
	mux_4_1_dec_buf uut (
		.in(in),  // Connect testbench 'in' to UUT 'in'
		.sel(sel), // Connect testbench 'sel' to UUT 'sel'
		.y(y)     // Connect UUT output 'y' to testbench 'y'
	);

	// Initial block to initialize inputs
	initial 
	begin
		// Set initial values (though overwritten in the next block)
		in = 4'b0000;
		sel = 2'b00;
	end		

	// Test cases to verify multiplexer functionality
	initial 
	begin
        // Apply different input and selection values and wait 10 time units each
        in = 4'b1000; sel = 2'b00; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y); // Display result

        in = 4'b1000; sel = 2'b01; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        in = 4'b1000; sel = 2'b10; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        in = 4'b1000; sel = 2'b11; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        $finish; // End simulation
    end
      
endmodule

