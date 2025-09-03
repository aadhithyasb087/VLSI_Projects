#XCELIUM = xrun
#XCL_OPTIONS = -sv -access +rw

# Source files
#RTL_SOURCE = up_count.v    # Replace with your RTL file name
#TB_SOURCE = tb_up_count.sv       # Replace with your testbench file name

# Output executable name
#OUTPUT = sim_executable

# Default target
#all: compile run

# Compile RTL and Testbench
#compile:
#	$(XCELIUM) $(XCL_OPTIONS) $(RTL_SOURCE) $(TB_SOURCE) -top tb_up_count -work work

# Run simulation
#run:
#	$(XCELIUM) $(XCL_OPTIONS) -top tb_up_count -work work

# Clean up generated files
#clean:
#	rm -rf work $(OUTPUT) *.log

#.PHONY: all compile run clean
################################################################################################

SIMULATOR = xrun							# simulator 
#RTL_SRC = ../rtl/*		      					# Your RTL source files
#TB_SRC = ../apb/*.sv		     				# Your Testbench files
TOP_TEST = ../env/top.sv						# top file name
TOP_MODULE = top	   						# Top-level module name for simulation
#FILELIST = pkg.f							# file list file name for sv
PACKAGE = ../env/apb_pkg.sv						# pacakge file name for UVM
INCDIR = +incdir+../env/				# include all the files from different directories
#INCDIR = +incdir+../../work
WAVEFORM = waves.shm      						# Output waveform directory for .shm format
WAVE_FORMAT = shm         						# Options: shm, vcd, fsdb (fsdb requires Verdi)
SIM_OPTIONS = -access +rwc -gui	-coverage all	
ASSERT = +assert				# set options for simulation
LOG = xrun.log

# Compile and simulate
all: compile simulate

# Compile RTL and Testbench
compile:
	#$(SIMULATOR) -sv -timescale 1ns/1ps $(SIM_OPTIONS) -f $(FILELIST) -top $(TOP_MODULE) -log $(LOG)                	#for sv
	$(SIMULATOR) -uvm $(SIM_OPTIONS) $(INCDIR) $(TOP_TEST) $(PACKAGE) -top $(TOP_MODULE) -log $(LOG)				#for UVM
# Simulate with waveform generation
simulate:
ifeq ($(WAVE_FORMAT),vcd)
	$(SIMULATOR) -run -top $(TOP_MODULE) -access +r -vcd
else ifeq ($(WAVE_FORMAT),fsdb)
	$(SIMULATOR) -run -top $(TOP_MODULE) -access +r +define+FSDB
else
	$(SIMULATOR) -run -top $(TOP_MODULE) -access +r +define+SHM +shm+$(WAVEFORM_DIR)
endif

# Clean up generated files
clean:
	rm -rf *.log *.d *.simv $(WAVEFORM_DIR) *.vcd *.fsdb
# Help
help:
	@echo "Makefile commands:"
	@echo "  make         - Compile and simulate RTL and Testbench with waveform"
	@echo "  make clean   - Remove generated files"
	@echo "  make help    - Display this help message"
	@echo "  To set waveform format, use 'make WAVE_FORMAT=<format>' where <format> is shm, vcd, or fsdb."

.PHONY: all compile simulate clean help

