module ahb_assertion(input [31:0]haddr,hwdata,hrdata,input [1:0]htrans,input [2:0]hburst,hsize,input hwrite,input hclk,hreset,hready,hresp);


begin
property p_htrans;
	@(posedge hclk) disable iff(!hreset)	
	(hwrite) |=> (htrans==2'b00) || (htrans==2'b01) || (htrans==2'b10) || (htrans==2'b11);
endproperty
	assert property(p_htrans);
end

begin
property p_hburst;
	@(posedge hclk) disable iff(!hreset)	
	(hwrite) |=> (hburst==3'b000) || (hburst==3'b001) || (hburst==2'b010) || (hburst==3'b011) || (hburst==3'b100) || (hburst==3'b101) || (hburst==3'b110) || (hburst==3'b111);
endproperty
	assert property(p_hburst);
end
/*begin

property p_hwdata;
	@(posedge hclk) (hwrite && htrans inside{2'b10,2'b11} && hready) |=> !$isunknown(hwdata);
endproperty
	assert property(p_hwdata);
end

begin
property p_hready;
	@(posedge hclk) disable iff(!hreset)
		(hreset) |=> (hready); 
endproperty
assert property(p_hready);
end*/

endmodule
