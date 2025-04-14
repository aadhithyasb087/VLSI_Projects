#Liberty files are needed for logical and physical netlist designs
set search_path "./"
set link_library " "

set_app_var enable_lint true

#configure_lint_tag -enable -tag "W241" -goal lint_rtl
#configure_lint_tag -enable -tag "W240" -goal lint_rtl

configure_lint_setup -goal lint_rtl

analyze -verbose -format verilog "./rtl/router_top.v"
analyze -verbose -format verilog "./rtl/router_fifo.v"
analyze -verbose -format verilog "./rtl/router_fsm.v"
analyze -verbose -format verilog "./rtl/router_reg.v"
analyze -verbose -format verilog "./rtl/router_sync.v"


elaborate router_top

check_lint

report_lint -verbose -file ./report_lint/report_lint_router1X3.txt
