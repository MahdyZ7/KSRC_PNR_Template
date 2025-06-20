##########################################################################################
# Tool: IC Compiler II
# Script: write_data.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################

echo hi
source -echo ./rm_setup/icc2_pnr_setup.tcl
echo bye
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${WRITE_DATA_FROM_BLOCK_NAME} -to ${DESIGN_NAME}/${WRITE_DATA_BLOCK_NAME}
current_block ${DESIGN_NAME}/${WRITE_DATA_BLOCK_NAME}
link_block

## Non-persistent settings to be applied in each step (optional)
if {[file exists [which $TCL_USER_NON_PERSISTENT_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_NON_PERSISTENT_SCRIPT]"
	source -echo $TCL_USER_NON_PERSISTENT_SCRIPT
} elseif {$TCL_USER_NON_PERSISTENT_SCRIPT != ""} {
	puts "RM-error: TCL_USER_NON_PERSISTENT_SCRIPT($TCL_USER_NON_PERSISTENT_SCRIPT) is invalid. Please correct it."
}

########################################################################
## change_names
########################################################################
## Purpose : change the names of ports, cells, and nets in a design, in order to make the output netlist, 
#  DEF, SPEF, ... etc conform to specified name rules
#  Note : 
#  - If the current block is a sub cell of another block, make sure no port names are changed during change_names;
#    if there is, you either modify your naming rule to avoid the name change, re-setup the connection between
#    the renamed port and the net at the parent level, or if the blocks are from commit_block then you can run 
#    the same change_names command before commit_block at the parent level.
#  - To preview whether there is any potential port name changes, check the report_names log first
redirect -tee -file ${REPORTS_DIR}/${WRITE_DATA_BLOCK_NAME}.report_names.log {report_names -rules verilog}

change_names -rules verilog -hierarchy

save_block

####################################################################################################
## For current block, write out ASCII Data (verilog, UPF, DEF, scripts/SDC, parasitics, and GDS)  
####################################################################################################
## write_verilog (no pg, and no physical only cells)
set write_verilog_logic_only_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations pg_objects end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.v"
puts "RM-info: running $write_verilog_logic_only_cmd"

## write_verilog for comparison with a DC netlist (no pg, no physical only cells, and no diodes)
set write_verilog_dc_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations pg_objects end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells diode_cells} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.dc.v"
puts "RM-info: running $write_verilog_dc_cmd"

## write_verilog for PrimeTime (no pg, no physical only cells but with diodes and DCAP for leakage power analysis)
set write_verilog_pt_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations pg_objects end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells flip_chip_pad_cells} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.pt.v"
if {$CHIP_FINISH_METAL_FILLER_LIB_CELL_LIST != ""} {
	lappend write_verilog_pt_cmd -force_reference $CHIP_FINISH_METAL_FILLER_LIB_CELL_LIST
}
puts "RM-info: running $write_verilog_pt_cmd"

## write_verilog for LVS (with pg, and with physical only cells)
set write_verilog_lvs_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations empty_modules} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.lvs.v"
puts "RM-info: running $write_verilog_lvs_cmd"


## write_verilog for Formality (with pg, no physical only cells, and no supply statements)
set write_verilog_fm_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells supply_statements} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.fm.v"
puts "RM-info: running $write_verilog_fm_cmd"

## write_verilog for VC LP (with pg, no physical_only cells, no diodes, and no supply statements)
set write_verilog_vclp_cmd "write_verilog -compress gzip -exclude {scalar_wire_declarations leaf_module_declarations end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells diode_cells supply_statements} -hierarchy all ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.vc_lp.v"
puts "RM-info: running $write_verilog_vclp_cmd"

parallel_execute -commands_only {
	{eval $write_verilog_logic_only_cmd}
	{eval $write_verilog_dc_cmd}
	{eval $write_verilog_pt_cmd}
	{eval $write_verilog_lvs_cmd}
	{eval $write_verilog_fm_cmd}
	{eval $write_verilog_vclp_cmd}
}

## Write out UPF
if {$UPF_SUPPLEMENTAL_FILE != ""} {

	## For golden UPF flow
	## write supplemental UPF with supply exceptions
	save_upf ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.supplemental.pg.upf
	## write supplemental UPF without supply exceptions
	set_app_options -name mv.upf.save_upf_include_supply_exceptions -value false
	save_upf ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.supplemental.upf

} else {

	## For UPF prime flow
	save_upf ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.upf

}

## write_script
#  writes multiple files to the specified directory. 
#  It writes mode_{mode_name}.tcl for mode specific info, corner_{corner_name}.tcl for corner specific info, 
#  design.tcl for non-mode or corner specific info, cts.tcl for cts options and top.tcl that sources all scripts. 
write_script -force -compress gzip -output ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}_wscript
#  -format pt generates PT compatible outputs 
write_script -force -compress gzip -format pt -output ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}_wscript_for_pt

## Writes routing constraints of the design in a Tcl script, such as :
## create_routing_rule, set_routing_rule, create_wire_matching, create_length_limit, create_differential_group, 
## create_net_shielding, create_net_priority, create_bus_routing_style and set_ignored_layers.
write_routing_constraints ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}_write_routing_constraints

## write_parasitics
update_timing
write_parasitics -compress -output ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}

## write_def : Enable the following for LEF/DEF based ICC-II to StarRC flow if LEF is from ICC II,
#  since write_lef in ICC-II doesn't currently support WRONGDIRECTION syntax.
#  This is not needed if you are using LEF files which contain the WRONGDIRECTION syntax already.
#	set_app_options -name file.def.wrong_way_wiring_to_special_net -value true
set write_def_cmd "write_def -compress gzip -version 5.8 -include_tech_via_definitions ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.def"
puts "RM-info: running $write_def_cmd"

## write_gds
set write_gds_cmd "write_gds -compress -hierarchy all -long_names -keep_data_type ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.gds"


if {[file exists $WRITE_GDS_LAYER_MAP_FILE]} {lappend write_gds_cmd -layer_map $WRITE_GDS_LAYER_MAP_FILE}

## If there's any design mismatches found, write_gds will not write out GDS, since GDS will be used for tape-out.
#  If you still want to write out GDS despite of mismatches, append the -allow_design_mismatch option to the 
#  write_gds command.

puts "RM-info: running $write_gds_cmd"

## write_oasis
set write_oasis_cmd "write_oasis -compress 6 -hierarchy all -keep_data_type ${OUTPUTS_DIR}/${WRITE_DATA_BLOCK_NAME}.oasis"


if {[file exists $WRITE_OASIS_LAYER_MAP_FILE]} {lappend write_oasis_cmd -layer_map $WRITE_OASIS_LAYER_MAP_FILE}

## If there's any design mismatches found, write_oasis will not write out OASIS, since OASIS will be used for tape-out.
#  If you still want to write out OASIS despite of mismatches, append the -allow_design_mismatch option to the 
#  write_oasis command.

puts "RM-info: running $write_oasis_cmd"

parallel_execute -commands_only {
	{eval $write_def_cmd}
	{eval $write_gds_cmd}
	{eval $write_oasis_cmd}
}

echo [date] > write_data

exit

