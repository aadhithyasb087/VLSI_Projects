//------------------interface----------------//
`include "ahb_if.sv"

`include "ahb_coverage.sv"
`include "ahb_assertion.sv"

module ahb_top;

	 import uvm_pkg::*;
	 import ahb_pkg::*;
	 
 	`include "uvm_macros.svh"
 	
	//--------------clock_definion-------------//
	bit clk=1;
	bit hreset;
	//--------------clock_generation------------//
	always #5 clk=~clk;
	
	ahb_if vif(clk,hreset);
	ahb_coverage covg(.hwrite(vif.HWRITE), .hburst(vif.HBURST), .hsize(vif.HSIZE), .haddr(vif.HADDR), .hwdata(vif.HWDATA), .hrdata(vif.HRDATA), .htrans(vif.HTRANS));
    //ahb_assertion ahba(.hclk(vif.HCLK), .hreset(hreset), .hwrite(vif.HWRITE), .hburst(vif.HBURST), .hsize(vif.HSIZE), .htrans(vif.HTRANS), .haddr(vif.HADDR), .hwdata(vif.HWDATA), .hrdata(vif.HRDATA),.hready(vif.HREADY), .hresp(vif.HRESP));

initial
begin
	hreset=0;
	#10;
	hreset=1;
end

	initial 
		begin
		//--------------------setting_uvm_config_interface----------------//
			uvm_config_db #(virtual ahb_if)::set(null,"*","vif",vif);
		    run_test("test2");
			//#100;
			$finish;

		end

/*initial
begin
`ifdef TEST
run_test("test");
`endif

`ifdef TEST1
run_test("incr4");
`endif

`ifdef TEST2
run_test("incr4_halfword");
`endif

`ifdef TEST3
run_test("single");
`endif

`ifdef TEST4
run_test("incr4_word");
`endif

`ifdef TEST5
run_test("incr8");
`endif

`ifdef TEST6
run_test("incr8_halfword");
`endif

`ifdef TEST7
run_test("incr8_word");
`endif

`ifdef TEST8
run_test("incr16");
`endif

`ifdef TEST9
run_test("incr16_halfword");
`endif

`ifdef TEST10
run_test("incr16_word");
`endif


`ifdef TEST11
run_test("wrap4");
`endif

`ifdef TEST12
run_test("wrap4_halfword");
`endif

`ifdef TEST13
run_test("wrap4_word");
`endif

`ifdef TEST14
run_test("wrap8");
`endif

`ifdef TEST15
run_test("wrap8_halfword");
`endif

`ifdef TEST16
run_test("wrap8_word");
`endif

`ifdef TEST17
run_test("wrap16");
`endif

`ifdef TEST18
run_test("wrap16_halfword");
`endif

`ifdef TEST19
run_test("wrap16_word");
`endif

`ifdef TEST20
run_test("undefined_length");
`endif
end
*/
endmodule
