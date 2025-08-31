module apb_cov(
    input logic [31:0] PADDR,
    input logic PWRITE,
    input logic PSEL,
    input logic PENABLE,
    input logic [31:0] PWDATA,
    input logic [31:0] PRDATA,
    input logic PREADY
);
  
  covergroup c_group{
        c1_PADDR: coverpoint PADDR {
            bins b1 = {[0:31]};   // 32 bins, one for each address
        }

        c2_PWRITE: coverpoint PWRITE {
            bins b2[] = {0, 1};
        }

        c3_PSEL: coverpoint PSEL {
            bins b3[] = {0, 1};
        }

        c4_PENABLE: coverpoint PENABLE {
            bins b4[] = {0, 1};
        }

        c5_PWDATA: coverpoint PWDATA {
            bins b5 = {[0:31]};  
        }

        c6_PRDATA: coverpoint PRDATA {
            bins b6 = {[0:31]};
        }

        c7_PREADY: coverpoint PREADY {
            bins b7[] = {0, 1};
        }
}
    endgroup

c_group cg;
real cov;

initial begin
cg=new();
cov = cg.get_coverage():
$display("APB FUNCTIONAL COVERAGE = %0.2f%%", cov);
end

endmodule

  
