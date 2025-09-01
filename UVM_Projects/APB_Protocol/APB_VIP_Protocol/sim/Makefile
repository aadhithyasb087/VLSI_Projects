# Simulator selection
# SIMULATOR = Questa  # Mentor QuestaSim
SIMULATOR = VCS      # Synopsys VCS

FSDB_PATH = /home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

work = work # library name
SVTB1 = ../tb/apb_top.sv
INC = +incdir+../tb +incdir+../test +incdir+../master +incdir+../slave
SVTB2 = ../test/apb_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"



help:
	@echo =============================================================================================================
	@echo "! USAGE    --  make target                                                                               !"
	@echo "! clean      => clean logs and intermediate files                                                        !"
	@echo "! sv_cmp     => Create library and compile the code                                                      !"
	@echo "! run_test1  => Run test1 (single_write)                                                                !"
	@echo "! run_test2  => Run test2 (single_read)                                                                 !"
	@echo "! run_test3  => Run test3 (multiple_write)                                                              !"
	@echo "! run_test4  => Run test4 (mult_wr_same_aadr)                                                           !"
	@echo "! run_test5  => Run test5 (multiple_read)                                                               !"
	@echo "! run_test6  => Run test6 (mult_rd_same_aadr)                                                           !"
	@echo "! run_test7  => Run test7 (mult_wr_even_aadr)                                                           !"
	@echo "! run_test8  => Run test8 (mult_wr_odd_aadr)                                                            !"
	@echo "! run_test9  => Run test9 (mult_wr_odd_aadr_odd_data)                                                  !"
	@echo "! run_test10 => Run test10 (mult_wr_even_aadr_even_data)                                               !"
	@echo "! run_test11 => Run test11 (mult_wr_diff_addr_data)                                                    !"
	@echo "! run_test12 => Run test12 (single_write_read)                                                         !"
	@echo "! run_test13 => Run test13 (multiple_write_read)                                                       !"
	@echo "! run_test14 => Run test14 (write_read_bulk)                                                           !"
	@echo "! run_test15 => Run test15 (write_err)                                                                 !"
	@echo "! run_test16 => Run test16 (read_err)                                                                  !"
	@echo "! regression => Run all tests (test1 to test16)                                                       !"
	@echo =============================================================================================================

# Default targets mapping
clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
run_test10 : run_test10_$(SIMULATOR)
run_test11 : run_test11_$(SIMULATOR)
run_test12 : run_test12_$(SIMULATOR)
run_test13 : run_test13_$(SIMULATOR)
run_test14 : run_test14_$(SIMULATOR)
run_test15 : run_test15_$(SIMULATOR)
run_test16 : run_test16_$(SIMULATOR)
regression : run_all_tests_$(SIMULATOR)

# ----------------------------- VCS Targets -----------------------------
sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb -lca \
	-P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(INC) $(SVTB2) $(SVTB1)

# Individual test runs
run_test1_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb -cm_dir ./mem_cov1 +ntb_random_seed_automatic +UVM_TESTNAME=test1
	urg -dir mem_cov1.vdb -format both -report urgReport1
 
run_test2_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb -cm_dir ./mem_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=test2
	urg -dir mem_cov2.vdb -format both -report urgReport2
 
run_test3_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb -cm_dir ./mem_cov3 +ntb_random_seed_automatic +UVM_TESTNAME=test3
	urg -dir mem_cov3.vdb -format both -report urgReport3

run_test12_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb -cm_dir ./mem_cov12 +ntb_random_seed_automatic +UVM_TESTNAME=test12
	urg -dir mem_cov12.vdb -format both -report urgReport12


run_test5_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test5.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test5

run_test6_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test6.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test6

run_test7_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test7.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test7

run_test8_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test8.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test8

run_test9_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test9.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test9

run_test10_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test10.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test10

run_test11_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test11.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test11



run_test13_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test13.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test13

run_test14_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test14.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test14

run_test15_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test15.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test15

run_test16_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_test16.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test16

# Regression: Run all tests
run_all_tests_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_all.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test1,test2,test3,test4,test5,test6,test7,test8,test9,test10,test11,test12,test13,test14,test15,test16

run_tests_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_all.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test1,test2,test3
 
report_VCS:
	urg -dir mem_cov12.vdb -dbname merged_dir/merged_test -format both -report urgReport
 
cov_VCS:
	verdi -cov -covdir merged_dir.vdb

# Clean files
clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h *.fsdb verdi*
	clear

# ----------------------------- End of Definitions for Synopsys's VCS Specific Targets -------------------------------
