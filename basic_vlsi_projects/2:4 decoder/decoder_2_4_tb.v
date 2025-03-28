module decoder_2_4_tb();

	// Inputs
	reg a;
	reg b;
	reg en;

	// Outputs
	wire y0;
	wire y1;
	wire y2;
	wire y3;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	decoder_2_4 uut (
		.a(a), 
		.b(b), 
		.en(en), 
		.y0(y0), 
		.y1(y1), 
		.y2(y2), 
		.y3(y3)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		en = 0;

	end
	
	// Add stimulus here
   initial
      begin 
	   for (i=0;i<8;i=i+1)
	    begin
	       {a,b,en}=i[2:0];
	       #10;
	    end
      end
    
 //Process to monitor the changes in the variables
   initial 
      $monitor("Input a=%b, b=%b, en=%b, Output y =%b%b%b%b",a,b,en,y3,y2,y1,y0);
									
   //Process to terminate simulation after 100ns
   initial #100 $finish;

  //Waveform dump
   initial
    begin
    // $fsdbDumpvars(0,full_adder_tb);
	 $dumpfile("decoder_2_4_tb.vcd");  // Name of the VCD file
    $dumpvars(0, decoder_2_4_tb);     // Dump signals in 'full_adder_tb'
    end
      
endmodule

