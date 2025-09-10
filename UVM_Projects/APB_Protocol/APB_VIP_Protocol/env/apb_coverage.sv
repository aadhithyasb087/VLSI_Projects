module apb_coverage(input logic presetn, psel, penable, pready, pwrite, input logic [31:0] paddr, input logic [31:0] pwdata, input logic [31:0] prdata);

// Coverage model
  covergroup c_group;
    option.per_instance = 1;
    ADDR   : coverpoint paddr   { bins addr_range = {[0:31]}; }
    PWDATA : coverpoint pwdata  { bins pw_range   = {[0:32'hFFFF_FFFF]}; }
    PRDATA : coverpoint prdata  { bins pr_range   = {[0:32'hFFFF_FFFF]}; }
    READY  : coverpoint pready;
    SEL  : coverpoint psel;
    WRITE  : coverpoint pwrite;
    ENABLE  : coverpoint penable;
    RESET  : coverpoint presetn;
  endgroup

    c_group cg;
    real cov;

    initial begin
        cg = new();
        forever begin
            #10;
            cg.sample();
            cov = cg.get_coverage();
            $display("APB FUNCTIONAL COVERAGE = %0.2f%%", cov);
        end
    end

endmodule
