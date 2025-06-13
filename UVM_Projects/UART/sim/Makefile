# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS
SIMULATOR = VCS

FSDB_PATH = /home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

RTL = ../dut/*
work = work # library name
SVTB1 = ../tb/uart_tb_top.sv
INC = +incdir+../tb +incdir+../test +incdir+../agent
SVTB2 = ../test/uart_test_pkg.sv
VSIMOPT = -vopt -voptargs=+acc
VSIMCOV = -coverage -sva

# Batch run options
VSIMBATCH1 = -c -do "log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2 = -c -do "log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3 = -c -do "log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4 = -c -do "log -r /* ;coverage save -onexit mem_cov4;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE    --  make target                             										!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.       								!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   								!"
	@echo "! run_test	=>  clean, compile & run the simulation for test_rb in batch mode.			!"
	@echo "! run_test1	=>  clean, compile & run the simulation for test_rbs in batch mode.			!"
	@echo "! run_test2	=>  clean, compile & run the simulation for test_rb5l in batch mode.			!"
	@echo "! run_test3	=>  clean, compile & run the simulation for test_rb6l in batch mode.			!"
	@echo "! run_test4	=>  clean, compile & run the simulation for test_rb7l in batch mode.			!"
	@echo "! run_test5	=>  clean, compile & run the simulation for test_rb8l in batch mode.			!"
	@echo "! run_test6	=>  clean, compile & run the simulation for test_rb5lwop in batch mode.		!"
	@echo "! run_test7	=>  clean, compile & run the simulation for test_rb6lwop in batch mode.			!"
	@echo "! run_test8	=>  clean, compile & run the simulation for test_rb7lwop in batch mode.		!"
	@echo "! run_test9	=>  clean, compile & run the simulation for test_rb8lwop in batch mode.			!"
	@echo "! regression	=>  Run all tests for regression testing.									!"
	@echo "! view_wave1 =>  To view the waveform of test_rb                                                    !"
	@echo "! view_wave2 =>  To view the waveform of test_rbs                                                       !"
	@echo "! view_wave3 =>  To view the waveform of test_rb5l                                                       !"
	@echo "! view_wave4 =>  To view the waveform of test_rb6l                                                      !"
	@echo "! view_wave5 =>  To view the waveform of test_rb7l                                                      !"
	@echo "! view_wave6 =>  To view the waveform of test_rb8l                                                      !"
	@echo "! view_wave7 =>  To view the waveform of test_rb5lwop                                                  !"
	@echo "! view_wave8 =>  To view the waveform of test_rb6lwop                                                  !"
	@echo "! view_wave9 =>  To view the waveform of test_rb7lwop                                                  !"
	@echo "! view_wave10 =>  To view the waveform of test_rb8lwop                                                 !"
	@echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
regression : run_all_tests_$(SIMULATOR)

view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
view_wave4 : view_wave4_$(SIMULATOR)
view_wave5 : view_wave5_$(SIMULATOR)
view_wave6 : view_wave6_$(SIMULATOR)
view_wave7 : view_wave7_$(SIMULATOR)
view_wave8 : view_wave8_$(SIMULATOR)
view_wave9 : view_wave9_$(SIMULATOR)
view_wave10 : view_wave10_$(SIMULATOR)

# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1)

run_test_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave.wlf -l test1.log -sv_seed random work.top

run_test1_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) -wlf wave.wlf -l test1.log -sv_seed random work.test_rb

run_test2_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) -wlf wave.wlf -l test2.log -sv_seed random work.test_rbs

run_test3_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4) -wlf wave.wlf -l test3.log -sv_seed random work.test_rb5l

run_test4_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave.wlf -l test4.log -sv_seed random work.test_rb6l

run_test5_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) -wlf wave.wlf -l test5.log -sv_seed random work.test_rb7l

run_test6_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) -wlf wave.wlf -l test6.log -sv_seed random work.test_rb8l

run_test7_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4) -wlf wave.wlf -l test7.log -sv_seed random work.test_rb5lwop

run_test8_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave.wlf -l test8.log -sv_seed random work.test_rb6lwop

run_test9_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) -wlf wave.wlf -l test9.log -sv_seed random work.test_rb7lwop

run_test10_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) -wlf wave.wlf -l test10.log -sv_seed random work.test_rb8lwop

run_all_tests_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave.wlf -l all_tests.log -sv_seed random work.test_rb work.test_rbs work.test_rb5l work.test_rb6l work.test_rb7l work.test_rb8l work.test_rb5lwop work.test_rb6lwop work.test_rb7lwop work.test_rb8lwop

clean_Questa:
	rm -rf transcript* *log* fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear

# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------

sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB2) $(SVTB1)

run_test_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=uart_test

run_test1_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb

run_test2_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rbs

run_test3_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb5l

run_test4_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb6l

run_test5_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb7l

run_test6_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb8l

run_test7_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb5lwop

run_test8_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb6lwop

run_test9_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb7lwop

run_test10_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb8lwop

run_all_tests_VCS: clean sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=test_rb,test_rbs,test_rb5l,test_rb6l,test_rb7l,test_rb8l,test_rb5lwop,test_rb6lwop,test_rb7lwop,test_rb8lwop

clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h *.fsdb verdi*
	clear

# ----------------------------- End of Definitions for Synopsys's VCS Specific Targets -------------------------------
