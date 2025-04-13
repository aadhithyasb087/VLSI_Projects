set_app_var enable_lint true  
set_app_var enable_lint_save "true" 
set met_path $::env(VC_STATIC_HOME)/auxx/monet/tcl/GuideWare/block/initial_rtl/lint 
set goal_name  lint_rtl
configure_lint_methodology -path $met_path -goal $goal_name 
configure_lint_setup -goal $goal_name  
set top "half_adder" 
analyze -format verilog -vcs "/home1/BPRN16/ADithYa/VLSI_RN_ONLINE/Verilog_labs/lab1/rtl/half_adder.v" 
elaborate $top -verbose  
check_lint 
report_violations 
checkpoint_session -session "my_session" -full 