module full_adder_tb();
		
   //Testbench global variables
   reg   a,b,cin;
   wire  sum,carry;

   //Variable for loop iteration 
   integer i;

   //Step1 : Instantiate the full adder with order based port mapping
	full_adder f1(.a_in(a),.b_in(b),.c_in(cin),.sum_out(sum),.carry_out(carry));

   //Process to initialize the variables at 0ns
   initial 
      begin
         a   = 0;
	      b   = 0;
	      cin = 0;
      end
				
   //Process to generate stimulus using for loop
   initial
      begin 
	   for (i=0;i<8;i=i+1)
	    begin
	       {a,b,cin}=i[2:0];
	       #10;
	    end
      end
				
   //Process to monitor the changes in the variables
   initial 
      $monitor("Input a=%b, b=%b, c=%b, Output sum =%b, carry=%b",a,b,cin,sum,carry);
									
   //Process to terminate simulation after 100ns
   initial #100 $finish;

  //Waveform dump
   initial
    begin
    // $fsdbDumpvars(0,full_adder_tb);
	 $dumpfile("full_adder_tb.vcd");  // Name of the VCD file
    $dumpvars(0, full_adder_tb);     // Dump signals in 'full_adder_tb'
    end

			
   
endmodule
