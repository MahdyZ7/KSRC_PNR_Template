# Makefile for Questa Sim simulation

# Colors
BLUE = "\\033[36m"
NC = "\\033[0m"
RED = "\\033[91m"


# Questa Sim commands
VLIB = vlib
VMAP = vmap
VLOG = vlog
VSIM = vsim

# Icarus sim commands
ICARUS := iverilog
GTKWAVE := gtkwave


# Source files (add your .sv files here)
SV_FILES := $(shell find . -name "*sv")

# Testbench top module
TB_TOP = tb_traffic_light_controller

# Library name
LIB_NAME := $(shell echo $(TB_TOP) | tr '[:lower:]' '[:upper:]')

# Simulation options
SIM_OPTIONS = -voptargs=+acc -quiet 
VERBOSE_OPTIONS := -hazards -lint -lrmclassinit -pedanticerrors -warning error -fsmverbose

all: compile simulate

icarus: icarus_run

# Create library
create_lib:
	@echo "$(BLUE)>> Create a logical library $(LIB_NAME) $(NC)"
	$(VLIB) -quiet $(LIB_NAME)

# Map library
map_lib: create_lib
	@echo "$(BLUE)>> Maping library to a directory $(LIB_NAME) $(NC)"
	$(VMAP) -quiet $(LIB_NAME) $(LIB_NAME)

# Compile SystemVerilog files
compile: map_lib
	@echo "$(BLUE)>> Compiling SystemVerilog files: $(SV_FILES) $(NC)"
	$(VLOG) -sv -quiet -work $(LIB_NAME) +acc $(SV_FILES)

# Run simulation
simulate: compile
	@echo "$(BLUE)>> Running simulation $(NC)"
	$(VSIM) $(SIM_OPTIONS) -L $(LIB_NAME) $(LIB_NAME).$(TB_TOP) -do "log -r /*;add wave -r /*; run -all;view wave;"

# Run cli simulation
cli: compile
	@echo "$(BLUE)>> Running simulation command line mode $(NC)"
	$(VSIM) -c $(SIM_OPTIONS) -L $(LIB_NAME) $(LIB_NAME).$(TB_TOP) -do "run -all;exit;"

do:
	@echo "$(BLUE)>> Running simulation form sim.do file $(NC)"
	$(VSIM) -do sim.do

icarus_compile:
	mkdir -p build
	@echo "$(BLUE)>> Compiling SystemVerilog files: $(SV_FILES) $(NC)"
	$(ICARUS)  -Wall -g2012  -o build/testbench $(SV_FILES)

icarus_run: icarus_compile
	cd build && ./testbench
	@if [ -f "./build/dump.vcd" ]; then \
		cd build && $(GTKWAVE) -M dump.vcd .dump.gtkw -a .dump.gtkw & \
	else \
		echo "$(RED) No dump.vcd file found, Make sure '\$$dumpvars' is included in the testbench $(NC)"; \
	fi

wave:
	@if [ -f "./build/dump.vcd" ]; then \
		echo "$(BLUE) Icarus waves $(NC)"; \
		cd build && $(GTKWAVE) -M dump.vcd .dump.gtkw -a .dump.gtkw & \
	else \
		echo "$(RED) No waveform found for Icarus $(NC)"; \
	fi
	@if [ -f "vsim.wlf" ]; then \
		echo "$(BLUE) Questasim waves $(NC)"; \
		$(VSIM) -view vsim.wlf add wave -r /*; \
	else \
		echo "$(RED) No waveform found for Questasim $(NC)"; \
	fi

help:
	@echo "$(BLUE) \t *** Makefile rules for SystemVerilog *** $(NC)\n\
	This is a makefile to compile and simulate SystemVerilog projects using modelsim and icarus. \
	Make sure you atleast one of them installed.\n\
	In the makefile, Intialize the variable 'TB_TOP' to be the testbench of your project \
	\n$(BLUE) \t *** The Makefile Targets *** $(NC)\n\
	$(BLUE)all$(NC): The default. simulate using Questasim / Modelsim and display all waves \n\
	$(BLUE)compile$(NC): compile using Questasim to check for syntax errors\n\
	$(BLUE)cli$(NC): Command line simulation using Questasim / Modelsim \n\
	$(BLUE)do$(NC): Use sim.do file to \n\
	$(BLUE)icarus$(NC): simulate using icarus and display all waves \n\
	$(BLUE)wave$(NC): display waveforms of prevoius simulation \n\
	$(BLUE)help$(NC): display help \n\
	$(BLUE)clean$(NC): remove all simulation and graph files \n\
	$(BLUE)re$(NC): clean and resimulate \n\
	";

# Clean up
clean:
	rm -rf $(LIB_NAME) transcript *.wlf build *.vcd

re: clean all

.PHONY: all create_lib map_lib compile simulate cli do icarus_compile \
	icarus_run wave help clean re
