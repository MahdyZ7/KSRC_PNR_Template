# design files
dsgn_files        ?= ./src
# questa library
library        ?= systolic
$(library):
	vlib${questa_version} $(library)
	vmap systolic systolic
sim_original:
	vsim -c -do 'source $(compile_script); quit'
sim_sorted:
	vsim -c -do 'source $(compile_script); quit'
synth_original:
	@dc_shell -x "source ./Synthesis_original/syn_original.tcl; $(EXIT_SWITCH)"
synth_sorted:
	@dc_shell -x "source ./Synthesis_sorted/syn_sorted.tcl; $(EXIT_SWITCH)"
clr:
	rm -rf csrc simv* out.saif
