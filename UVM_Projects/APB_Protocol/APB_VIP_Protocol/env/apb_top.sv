`include "apb_intf.sv"
`include "apb_assertion.sv"
`include "apb_coverage.sv"


module apb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import apb_pkg::*;

    
    // APB interface virtual handle
    apb_intf vif();
    apb_assertion asr(.pclk(vif.pclk),.presetn(vif.presetn), .psel(vif.psel), .penable(vif.penable), .pready(vif.pready));
    apb_coverage cov(.presetn(vif.presetn), .psel(vif.psel), .pwrite(vif.pwrite),.penable(vif.penable), .pready(vif.pready), .paddr(vif.paddr), .pwdata(vif.pwdata), .prdata(vif.prdata));

    // Clock generation: 10ns period (100MHz)
    initial begin
    vif.pclk = 0;
    forever #5 vif.pclk = ~vif.pclk;
    end

   initial begin
	    vif.presetn = 0;
    #10;
    vif.presetn=1;   
    end
    

    // Initial block for test
    initial begin
        uvm_config_db #(virtual apb_intf)::set(null,"*","vif",vif);
        // Run UVM test
        run_test("test13");

        // Finish simulation after 100ns
        #100;
       $finish;
    end

    

endmodule

