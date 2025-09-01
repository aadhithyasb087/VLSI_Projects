`include "apb_intf.sv"

module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import apb_pkg::*;

    
    // APB interface virtual handle
    apb_intf vif();

    // Clock generation: 10ns period (100MHz)
    initial begin
    vif.pclk = 0;
    forever #5 vif.pclk = ~vif.pclk;
    end

   initial begin
	    vif.presetn = 0;
    #20;
    vif.presetn=1;   
    end
    

    // Initial block for test
    initial begin
        uvm_config_db #(virtual apb_intf)::set(null,"*","vif",vif);
        // Run UVM test
        run_test();

        // Finish simulation after 100ns
        #100 $finish;
    end

    // ===============================
    // APB Protocol Assertions
    // ===============================

    // 1. PREADY should be low during setup phase
   property pready_low;
        // Trigger on positive edge of clock
        @(posedge vif.pclk) disable iff(!vif.presetn)
        (vif.psel && !vif.penable) |-> !vif.pready;
    endproperty

    // Assertion instance
    a1: assert property(pready_low)
        else $error("APB Protocol Violation: PREADY should be low during setup phase");

    // 2. PREADY should be high during access phase
    property pready_completion;
        @(posedge vif.pclk) disable iff(!vif.presetn)
        (vif.psel && vif.penable) |-> ##[0:10] (vif.pready && vif.psel && vif.penable);
    endproperty

    // Assertion instance (corrected name)
    a2: assert property(pready_completion)
        else $error("APB Protocol Violation: PREADY should be high during access phase");

endmodule

