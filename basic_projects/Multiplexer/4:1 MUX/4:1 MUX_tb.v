module mux_4_1_tb;

	// Inputs
	reg [3:0] in;
	reg [1:0] sel;
	

	// Outputs
	wire y;

	// Instantiate the Unit Under Test (UUT)
	mux_4_1 uut (
		.in(in), 
		.sel(sel), 
		.y(y)
	);

	initial begin
        // Test all combinations of inputs and select signals
        in = 4'b1000; sel = 2'b00; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        in = 4'b1000; sel = 2'b01; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        in = 4'b1000; sel = 2'b10; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        in = 4'b1000; sel = 2'b11; #10;
        $display("in = %b, sel = %b, y = %b", in, sel, y);

        $finish;
    end
      
endmodule

