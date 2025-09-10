module ahb_coverage(input logic [2:0]hburst,input logic [1:0]htrans,input logic [2:0]hsize,input logic [31:0]haddr,input logic [31:0]hwdata,input logic [31:0]hrdata,input logic hwrite);

covergroup c_group;
    option.per_instance = 1;
	c1:coverpoint haddr
	                    {bins b1={[32'd0:32'd4294967295]};}
	c2:coverpoint hwdata
	                    {bins b2={[32'd0:32'd4294967295]};}
	c3:coverpoint hwrite
	                    {bins b3={0,1};}
	c4:coverpoint hburst
	                    {bins b4={[0:7]};}
	c5:coverpoint hsize
	                    {bins b5={[0:2]};}
	c6:coverpoint htrans
	                    {bins b6={[0:3]};}
	c7:coverpoint hrdata
	                    {bins b7={[32'd0:32'd4294967295]};}
endgroup

real cov;
c_group cg;
initial
begin
	cg=new();
	forever
	begin
	#10;
		cg.sample();
		cov=cg.get_coverage();
	//$display("AHB Functional Coverage = %0.2f%%", cov);
	end 
end
endmodule
