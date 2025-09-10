module apb_assertion(input pclk, presetn, psel, penable, pready);

// ===============================
    // APB Protocol Assertions
    // ===============================

    // 1. PREADY should be low during setup phase
   property pready_low;
        // Trigger on positive edge of clock
        @(posedge pclk) disable iff(presetn)
        (psel && !penable) |-> !pready;
    endproperty

    // Assertion instance
    a1: assert property(pready_low)
        else $error("APB Protocol Violation: PREADY should be low during setup phase");

    // 2. PREADY should be high during access phase
    property pready_completion;
        @(posedge pclk) disable iff(!presetn)
        (psel && penable) |-> ##[0:10] (pready && psel && penable);
    endproperty

    // Assertion instance (corrected name)
    a2: assert property(pready_completion)
        else $error("APB Protocol Violation: PREADY should be high during access phase");

endmodule
