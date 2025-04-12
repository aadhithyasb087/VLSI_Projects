module full_adder(input a_in,
                 input  b_in,
		  input c_in,
		  output sum_out,
		  output carry_out);
     

   //Step2 : Declare the internal wires    
	wire sum1;
	wire carry1;
	wire carry2;

   //Step3 : Instantiate the Half-Adders using name-based port mapping	

   half_adder h1(.a(a_in),.b(b_in),.sum(sum1),.carry(carry1));
   half_adder h2(.a(sum1),.b(c_in),.sum(sum_out),.carry(carry2));	

   //Step4 : Instantiate the OR gate
	assign carry_out=carry1|carry2;


endmodule
