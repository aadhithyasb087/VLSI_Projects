module rp_carry_adr_tb();

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg c_in;


	// Outputs
	wire [3:0] sum;
	wire c_out;
	integer i,j;

	// Instantiate the Unit Under Test (UUT)
	rp_carry_adr uut (
		.a(a), 
		.b(b), 
		.c_in(c_in), 
		.sum(sum), 
		.c_out(c_out)
	);

	initial 
	begin
		// Initialize Inputs
		a = 4'b0000;
		b = 4'b0000;
		c_in=0;

   
		// Add stimulus here
 end
 initial
      begin 
	   for (i=0;i<16;i=i+1)
	    begin
		 for (j=0;j<16;j=j+1)
	    begin
	       a=i;
			 b=j;  
          c_in=0;
	       #10;
			 $display("A = %b, B = %b, Cin = %b => Sum = %b, Cout = %b", a,b,c_in,sum,c_out);
			 c_in =1; // Test with c_in = 1
				#10;
				$display("A = %b, B = %b, Cin = %b => Sum = %b, Cout = %b", a, b, c_in, sum, c_out);
			end
	    end
		 $finish;
      end

  //Waveform dump
   initial
    begin
    // $fsdbDumpvars(0,full_adder_tb);
	 $dumpfile("rp_carry_adr_tb.vcd");  // Name of the VCD file
    $dumpvars(0, rp_carry_adr_tb);     // Dump signals in 'full_adder_tb'
    end

      
endmodule

