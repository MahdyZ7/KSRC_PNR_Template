##########################################################################################
# Tool: IC Compiler II
# Script: clock_opt_opto.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################

source -echo ./rm_setup/icc2_pnr_setup.tcl 
set REPORT_PREFIX $CLOCK_OPT_OPTO_BLOCK_NAME
if {$REPORT_PARALLEL_SUBMIT_COMMAND != ""} {set REPORTS_DIR $REPORTS_DIR/$REPORT_PREFIX; file mkdir $REPORTS_DIR}

open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${CLOCK_OPT_CTS_BLOCK_NAME} -to ${DESIGN_NAME}/${CLOCK_OPT_OPTO_BLOCK_NAME}
current_block ${DESIGN_NAME}/${CLOCK_OPT_OPTO_BLOCK_NAME}
link_block

## The following only applies to hierarchical designs
## Swap abstracts if abstracts specified for clock_opt_cts and clock_opt_opto are different
if {$DESIGN_STYLE == "hier"} {
	if {$USE_ABSTRACTS_FOR_BLOCKS != "" && ($BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO != $BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS)} {
		puts "RM-info: Swapping from $BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS to $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO abstracts for all blocks."
		change_abstract -references $USE_ABSTRACTS_FOR_BLOCKS -label $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO
		report_abstracts
	}
}

if {$CLOCK_OPT_OPTO_ACTIVE_SCENARIO_LIST != ""} {
	set_scenario_status -active false [get_scenarios -filter active]
	set_scenario_status -active true $CLOCK_OPT_OPTO_ACTIVE_SCENARIO_LIST

        ## Propagate clocks and compute IO latencies for modes or corners which are not active during clock_opt_cts step
        synthesize_clock_trees -propagate_only
        compute_clock_latency
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
set_stage -step post_cts_opto

## GRE - Support for a single focused scenario for routing (optional)
if {$ROUTE_FOCUSED_SCENARIO != ""} {
	set_app_options -name route.common.focus_scenario -value $ROUTE_FOCUSED_SCENARIO
}

## Prefix
set_app_options -name opt.common.user_instance_name_prefix -value clock_opt_opto_
set_app_options -name cts.common.user_instance_name_prefix -value clock_opt_opto_cts_

## For set_qor_strategy -metric timing, disabling the leakage and dynamic power analysis in active scenarios for optimization
## For set_qor_strategy -metric leakage, disabling the dynamic power analysis in active scenarios for optimization
# Scenario power analysis will be renabled after optimization for reporting
if {$SET_QOR_STRATEGY_METRIC == "timing"} {
   set rm_leakage_scenarios [get_object_name [get_scenarios -filter active==true&&leakage_power==true]]
   set rm_dynamic_scenarios [get_object_name [get_scenarios -filter active==true&&dynamic_power==true]]

   if {[llength $rm_leakage_scenarios] > 0 || [llength $rm_dynamic_scenarios] > 0} {
      puts "RM-info: Disabling leakage analysis for $rm_leakage_scenarios"
      puts "RM-info: Disabling dynamic analysis for $rm_dynamic_scenarios"
      set_scenario_status -leakage_power false -dynamic_power false [get_scenarios "$rm_leakage_scenarios $rm_dynamic_scenarios"]
   }
} elseif {$SET_QOR_STRATEGY_METRIC == "leakage_power"} {
   set rm_dynamic_scenarios [get_object_name [get_scenarios -filter active==true&&dynamic_power==true]]

   if {[llength $rm_dynamic_scenarios] > 0} {
      puts "RM-info: Disabling dynamic analysis for $rm_dynamic_scenarios"
      set_scenario_status -dynamic_power false [get_scenarios $rm_dynamic_scenarios]
  }
}


##########################################################################
## IR-driven placement (IRDP)
##########################################################################
if {$ENABLE_IRDP && [check_license -quiet "Digital-AF"]} {
	## Specify addtional IRDP confgurations needed per your design
        ## Example for IRDP with manual RH config :      	examples/TCL_IRDP_CONFIG_FILE.manual.rh.tcl
        ## Example for IRDP with streamlined RH config : 	examples/TCL_IRDP_CONFIG_FILE.streamlined.rh.tcl
        ## Example for IRDP with manual RHSC config :    	examples/TCL_IRDP_CONFIG_FILE.manual.rhsc.tcl
        ## Example for IRDP with streamlined RHSC config : 	examples/TCL_IRDP_CONFIG_FILE.streamlined.rhsc.tcl
	if {[file exists [which $TCL_IRDP_CONFIG_FILE]]} {
		puts "RM-info: Running IRDP by sourcing $TCL_IRDP_CONFIG_FILE"
	       	source $TCL_IRDP_CONFIG_FILE
	} elseif {$TCL_IRDP_CONFIG_FILE != ""} {
	        puts "RM-error: ENABLE_IRDP is enabled but TCL_IRDP_CONFIG_FILE($TCL_IRDP_CONFIG_FILE) is invalid. Please correct it."
	} elseif {$TCL_IRDP_CONFIG_FILE == ""} {
	        puts "RM-error: ENABLE_IRDP is enabled but TCL_IRDP_CONFIG_FILE is not specified. Please correct it."
	}
}

## Redundant via insertion
if {$ENABLE_REDUNDANT_VIA_INSERTION} {
	## Source ICC-II via mapping file for redundant via insertion
	if {[file exists [which $TCL_USER_REDUNDANT_VIA_MAPPING_FILE]]} {
		puts "RM-info: Sourcing [which $TCL_USER_REDUNDANT_VIA_MAPPING_FILE]"
		source $TCL_USER_REDUNDANT_VIA_MAPPING_FILE
		report_via_mapping
	} elseif {$TCL_USER_REDUNDANT_VIA_MAPPING_FILE != ""} {
		puts "RM-error : ENABLE_REDUNDANT_VIA_INSERTION is true but TCL_USER_REDUNDANT_VIA_MAPPING_FILE($TCL_USER_REDUNDANT_VIA_MAPPING_FILE) is invalid. Please correct it."
	}

	## For established nodes, run concurrent redundant via insertion during route_auto and route_opt.
	set_app_options -name route.common.post_detail_route_redundant_via_insertion -value medium ;# default off
}

if {$ENABLE_CREATE_SHIELDS} {
	create_shields
}

##########################################################################################
## Pre-opto customizations
##########################################################################################
if {[file exists [which $TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT]"
	source -echo $TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT
} elseif {$TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT != ""} {
	puts "RM-error: TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT($TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT) is invalid. Please correct it."
}

redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.start {report_app_options -non_default *}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_lib_cell_purpose {report_lib_cell -objects [get_lib_cells] -column {full_name:20 valid_purposes}}

set check_stage_settings_cmd "check_stage_settings -stage pnr -metric \"${SET_QOR_STRATEGY_METRIC}\" -step post_cts_opto"
if {$ENABLE_REDUCED_EFFORT} {lappend check_stage_settings_cmd -reduced_effort}
if {$RESET_CHECK_STAGE_SETTINGS} {lappend check_stage_settings_cmd -reset_app_options}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_stage_settings {eval ${check_stage_settings_cmd}}



## The following only applies to designs with physical hierarchy
## Ignore the sub-blocks (bound to abstracts) internal timing paths
if {$DESIGN_STYLE == "hier" && $PHYSICAL_HIERARCHY_LEVEL != "bottom"} {
	set_timing_paths_disabled_blocks  -all_sub_blocks
}

##########################################################################################
## clock_opt final_opto flow
##########################################################################################
if {[file exists [which $TCL_USER_CLOCK_OPT_OPTO_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_CLOCK_OPT_OPTO_SCRIPT]"
	source -echo $TCL_USER_CLOCK_OPT_OPTO_SCRIPT
} elseif {$TCL_USER_CLOCK_OPT_OPTO_SCRIPT != ""} {
	puts "RM-error: TCL_USER_CLOCK_OPT_OPTO_SCRIPT($TCL_USER_CLOCK_OPT_OPTO_SCRIPT) is invalid. Please correct it."
} else {

	puts "RM-info: Running clock_opt -from final_opto -to final_opto command"
	clock_opt -from final_opto -to final_opto

}

##########################################################################################
## Post-opto customizations
##########################################################################################
if {[file exists [which $TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT]"
	source -echo $TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT
} elseif {$TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT != ""} {
	puts "RM-error: TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT($TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT) is invalid. Please correct it."
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

## Re-enable power analysis if disabled for set_qor_strategy -metric timing
if {[info exists rm_leakage_scenarios] && [llength $rm_leakage_scenarios] > 0} {
   puts "RM-info: Reenabling leakage power analysis for $rm_leakage_scenarios"
   set_scenario_status -leakage_power true [get_scenarios $rm_leakage_scenarios]
}
if {[info exists rm_dynamic_scenarios] && [llength $rm_dynamic_scenarios] > 0} {
   puts "RM-info: Reenabling dynamic power analysis for $rm_dynamic_scenarios"
   set_scenario_status -dynamic_power true [get_scenarios $rm_dynamic_scenarios]
}

## Save block
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
	} elseif { $PHYSICAL_HIERARCHY_LEVEL == "intermediate"} {
	    if { $ABSTRACT_TYPE_FOR_MPH_BLOCKS == "nested"} {
	        ## Create nested abstract for the intermediate level of physical hierarchy
	        create_abstract -read_only
                create_frame -block_all true
	    } elseif { $ABSTRACT_TYPE_FOR_MPH_BLOCKS == "flattened"} {
	        ## Create flattened abstract for the intermediate level of physical hierarchy
	        create_abstract -read_only -preserve_block_instances false
                create_frame -block_all true
	    }
	}
}

##########################################################################################
## Report and output
##########################################################################################
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
echo [date] > clock_opt_opto
exit

