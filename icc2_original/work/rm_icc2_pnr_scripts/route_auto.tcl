##########################################################################################
# Tool: IC Compiler II
# Script: route_auto.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################

source -echo ./rm_setup/icc2_pnr_setup.tcl 
set REPORT_PREFIX $ROUTE_AUTO_BLOCK_NAME
if {$REPORT_PARALLEL_SUBMIT_COMMAND != ""} {set REPORTS_DIR $REPORTS_DIR/$REPORT_PREFIX; file mkdir $REPORTS_DIR}

open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${CLOCK_OPT_OPTO_BLOCK_NAME} -to ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}
current_block ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}
link_block

## The following only applies to hierarchical designs
## Swap abstracts if abstracts specified for clock_opt_opto and route_auto are different
if {$DESIGN_STYLE == "hier"} {
	if {$USE_ABSTRACTS_FOR_BLOCKS != "" && ($BLOCK_ABSTRACT_FOR_ROUTE_AUTO != $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO)} {
		puts "RM-info: Swapping from $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO to $BLOCK_ABSTRACT_FOR_ROUTE_AUTO abstracts for all blocks."
		change_abstract -references $USE_ABSTRACTS_FOR_BLOCKS -label $BLOCK_ABSTRACT_FOR_ROUTE_AUTO
		report_abstracts
	}
}

if {$ROUTE_AUTO_ACTIVE_SCENARIO_LIST != ""} {
	set_scenario_status -active false [get_scenarios -filter active]
	set_scenario_status -active true $ROUTE_AUTO_ACTIVE_SCENARIO_LIST
}


## Non-persistent settings to be applied in each step (optional)
if {[file exists [which $TCL_USER_NON_PERSISTENT_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_NON_PERSISTENT_SCRIPT]"
	source -echo $TCL_USER_NON_PERSISTENT_SCRIPT
} elseif {$TCL_USER_NON_PERSISTENT_SCRIPT != ""} {
	puts "RM-error: TCL_USER_NON_PERSISTENT_SCRIPT($TCL_USER_NON_PERSISTENT_SCRIPT) is invalid. Please correct it."
}

##########################################################################################
## Settings
##########################################################################################
## set_stage : a command to apply stage-based application options; intended to be used after set_qor_strategy within RM scripts.
set_stage -step route

## Prefix
set_app_options -name opt.common.user_instance_name_prefix -value route_auto_
## Antenna fixing is on by default since route.detail.antenna is default true
if {[file exists [which $TCL_ANTENNA_RULE_FILE]]} {
	puts "RM-info: Sourcing [which $TCL_ANTENNA_RULE_FILE]"
	source $TCL_ANTENNA_RULE_FILE
} elseif {$TCL_ANTENNA_RULE_FILE != ""} {
	puts "RM-error : TCL_ANTENNA_RULE_FILE($TCL_ANTENNA_RULE_FILE) is invalid. Please correct it."
}

##########################################################################################
## Pre-route_auto customizations
##########################################################################################
if {[file exists [which $TCL_USER_ROUTE_AUTO_PRE_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_ROUTE_AUTO_PRE_SCRIPT]"
	source -echo $TCL_USER_ROUTE_AUTO_PRE_SCRIPT
} elseif {$TCL_USER_ROUTE_AUTO_PRE_SCRIPT != ""} {
	puts "RM-error: TCL_USER_ROUTE_AUTO_PRE_SCRIPT($TCL_USER_ROUTE_AUTO_PRE_SCRIPT) is invalid. Please correct it."
}

redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.start {report_app_options -non_default *}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_lib_cell_purpose {report_lib_cell -objects [get_lib_cells] -column {full_name:20 valid_purposes}}

set check_stage_settings_cmd "check_stage_settings -stage pnr -metric \"${SET_QOR_STRATEGY_METRIC}\" -step route"
if {$ENABLE_REDUCED_EFFORT} {lappend check_stage_settings_cmd -reduced_effort}
if {$RESET_CHECK_STAGE_SETTINGS} {lappend check_stage_settings_cmd -reset_app_options}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_stage_settings {eval ${check_stage_settings_cmd}}


## The following only applies to designs with physical hierarchy
## Ignore the sub-blocks (bound to abstracts) internal timing paths
if {$DESIGN_STYLE == "hier" && $PHYSICAL_HIERARCHY_LEVEL != "bottom"} {
	set_timing_paths_disabled_blocks  -all_sub_blocks
}

##########################################################################################
## Routing flow
##########################################################################################
if {[file exists [which $TCL_USER_ROUTE_AUTO_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_ROUTE_AUTO_SCRIPT]"
	source -echo $TCL_USER_ROUTE_AUTO_SCRIPT
} elseif {$TCL_USER_ROUTE_AUTO_SCRIPT != ""} {
	puts "RM-error: TCL_USER_ROUTE_AUTO_SCRIPT($TCL_USER_ROUTE_AUTO_SCRIPT) is invalid. Please correct it."
} else {

	##########################################################################
	## Routing with single command : route_auto (default)
	##########################################################################
	## Note: GR phase will be skipped if global route optimization was done
	puts "RM-info: Running route_auto"
	route_auto

}


## Fix remaining routing DRCs
#route_detail -incremental true -initial_drc_from_input true

## Create shields
if {$ENABLE_CREATE_SHIELDS} {
	create_shields -shielding_mode reshield
	set_extraction_options -virtual_shield_extraction false
}

##########################################################################################
## Post-route_auto customizations
##########################################################################################
if {[file exists [which $TCL_USER_ROUTE_AUTO_POST_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_ROUTE_AUTO_POST_SCRIPT]"
	source -echo $TCL_USER_ROUTE_AUTO_POST_SCRIPT
} elseif {$TCL_USER_ROUTE_AUTO_POST_SCRIPT != ""} {
	puts "RM-error: TCL_USER_ROUTE_AUTO_POST_SCRIPT($TCL_USER_ROUTE_AUTO_POST_SCRIPT) is invalid. Please correct it."
}

##########################################################################################
## connect_pg_net
##########################################################################################
if {$TCL_USER_CONNECT_PG_NET_SCRIPT != ""} {
	if {[file exists [which $TCL_USER_CONNECT_PG_NET_SCRIPT]]} {
		puts "RM-info: Sourcing [which $TCL_USER_CONNECT_PG_NET_SCRIPT]"
  		source $TCL_USER_CONNECT_PG_NET_SCRIPT
	} else {
		puts "RM-error: TCL_USER_CONNECT_PG_NET_SCRIPT($TCL_USER_CONNECT_PG_NET_SCRIPT) is invalid. Please correct it."
	}
} else {
	connect_pg_net
}

## Run check_routes to save updated routing DRC to the block
redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_routes {check_routes}

save_block

##########################################################################################
## Create abstract and frame
##########################################################################################
## Enabled for hierarchical designs; for bottom and intermediate levels of physical hierarchy
if {$DESIGN_STYLE == "hier"} {
	if {$USE_ABSTRACTS_FOR_POWER_ANALYSIS == "true"} {
		set_app_options -name abstract.annotate_power -value true
   	}
	if { $PHYSICAL_HIERARCHY_LEVEL == "bottom" } {
		create_abstract -read_only
	        create_frame -block_all true
       	 	derive_hier_antenna_property -design ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}
                save_block ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}.frame
	} elseif { $PHYSICAL_HIERARCHY_LEVEL == "intermediate"} {
            if { $ABSTRACT_TYPE_FOR_MPH_BLOCKS == "nested"} {
                ## Create nested abstract for the intermediate level of physical hierarchy
                create_abstract -read_only
            } elseif { $ABSTRACT_TYPE_FOR_MPH_BLOCKS == "flattened"} {
                ## Create flattened abstract for the intermediate level of physical hierarchy
                create_abstract -read_only -preserve_block_instances false
            }
            create_frame -block_all true
            derive_hier_antenna_property -design ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}
            save_block ${DESIGN_NAME}/${ROUTE_AUTO_BLOCK_NAME}.frame
	}
}

## StarRC in-design extraction (optional) : a config file is required to set up a proper StarRC run
if {[file exists [which $ROUTE_OPT_STARRC_CONFIG_FILE]]} {
	set_starrc_in_design -config $ROUTE_OPT_STARRC_CONFIG_FILE
} elseif {$ROUTE_OPT_STARRC_CONFIG_FILE != ""} {
	puts "RM-error: ROUTE_OPT_STARRC_CONFIG_FILE($ROUTE_OPT_STARRC_CONFIG_FILE) is invalid. Please correct it."
}

## StarRC in-design extraction validation flow
## Discover potential setup issues of StarRC in-design extraction
## Low effort performs setup checks for config file path, StarRC path, layer mapping file path, and corner mapping;
## medium effort creates StarRC command file in your local dir; high effort invokes StarRC. 
#	check_starrc_in_design -effort <low|medium|high>

##########################################################################################
## Report and output
##########################################################################################
## Recommended timing settings for reporting on routed designs (AWP, CCS receiver, and SI timing window)
puts "RM-info: Setting time.delay_calc_waveform_analysis_mode to full_design and time.enable_ccs_rcv_cap to true for reporting"
set_app_options -name time.delay_calc_waveform_analysis_mode -value full_design ;# tool default disabled; enables AWP
set_app_options -name time.enable_ccs_rcv_cap -value true ;# tool default false; enables CCS receiver model; required

if {$REPORT_QOR} {
	if {$REPORT_PARALLEL_SUBMIT_COMMAND != ""} {
		## Generate a file to pass necessary RM variables for running report_qor.tcl to the report_parallel command
		rm_generate_variables_for_report_parallel -work_directory ${REPORTS_DIR} -file_name rm_tcl_var.tcl

		## Parallel reporting using the report_parallel command (requires a valid REPORT_PARALLEL_SUBMIT_COMMAND)
		report_parallel -work_directory ${REPORTS_DIR} -submit_command ${REPORT_PARALLEL_SUBMIT_COMMAND} -max_cores ${REPORT_PARALLEL_MAX_CORES} -user_scripts [list "${REPORTS_DIR}/rm_tcl_var.tcl" "[which report_qor.tcl]"]
	} else {
		## Classic reporting
		source report_qor.tcl
	}
}

print_message_info -ids * -summary
echo [date] > route_auto
exit

