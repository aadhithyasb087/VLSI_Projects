# File: Makefile

TOP_MODULE = tb
RTL       = ../rtl/multiplier.v
TB        = ../tb/verification_env.sv
DUMP      = dump.vcd
OUT       = simv

all: compile run

compile:
	vcs -full64 -sverilog +vpi -ntb_opts uvm $(RTL) $(TB) -o $(OUT)

run:
	./$(OUT)

clean:
	rm -rf $(OUT) csrc simv.daidir ucli.key $(DUMP) *.vpd *.log *.vcd DVEfiles

