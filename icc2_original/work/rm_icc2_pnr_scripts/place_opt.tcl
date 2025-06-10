##########################################################################################
# Script: place_opt.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################
set_host_options -max_core 32
source -echo ./rm_setup/icc2_pnr_setup.tcl
set REPORT_PREFIX $PLACE_OPT_BLOCK_NAME
if {$REPORT_PARALLEL_SUBMIT_COMMAND != ""} {set REPORTS_DIR $REPORTS_DIR/$REPORT_PREFIX; file mkdir $REPORTS_DIR}

open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${INIT_DESIGN_BLOCK_NAME} -to ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME}
current_block ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME}

if {$EARLY_DATA_CHECK_POLICY != "none"} {
	## Design check manager
	set_early_data_check_policy -policy $EARLY_DATA_CHECK_POLICY -if_not_exist
}

link_block

## For top and intermediate level of hierarchical designs, check the editability of the sub-blocks;
## if the editability is true for any sub-block, set it to false
## In RM, we are setting the editability of all the sub-blocks to false in the init_design.tcl script
## The following check is implemented to ensure that the editability of the sub-blocks is set to false in flows not running the init_design.tcl script
if {$USE_ABSTRACTS_FOR_BLOCKS != ""} {
      	foreach_in_collection c [get_blocks -hierarchical] {
	  	if {[get_editability -blocks ${c}] == true } {
			set_editability -blocks ${c} -value false
   	  	}
      	}
	report_editability -blocks [get_blocks -hierarchical]
}

## Set active scenarios for the step (please include CTS and hold scenarios for CCD)
if {$PLACE_OPT_ACTIVE_SCENARIO_LIST != ""} {
	set_scenario_status -active false [get_scenarios -filter active]
	set_scenario_status -active true $PLACE_OPT_ACTIVE_SCENARIO_LIST
}

if {[sizeof_collection [get_scenarios -filter "hold && active"]] == 0} {
	puts "RM-warning: No active hold scenario is found. Recommended to enable hold scenarios here such that CCD skewing can consider them." 
	puts "RM-info: Please activate hold scenarios for place_opt if they are available." 
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

## set_qor_strategy : a commmand which folds various settings of placement, optimization, timing, CTS, and routing, etc.
## - To query the target metric being set, use the "get_attribute [current_design] metric_target" command
set set_qor_strategy_cmd "set_qor_strategy -stage pnr -metric \"${SET_QOR_STRATEGY_METRIC}\""
if {$ENABLE_REDUCED_EFFORT} {lappend set_qor_strategy_cmd -reduced_effort}
puts "RM-info: Running $set_qor_strategy_cmd" 
eval ${set_qor_strategy_cmd}

## set_stage : a command to apply stage-based application options; intended to be used after set_qor_strategy within RM scripts.
set_stage -step placement

## Prefix
set_app_options -name opt.common.user_instance_name_prefix -value place_opt_
set_app_options -name cts.common.user_instance_name_prefix -value place_opt_cts_

## Routing 
## Set max routing layer
if {$MAX_ROUTING_LAYER != ""} {set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER}
## Set min routing layer
if {$MIN_ROUTING_LAYER != ""} {set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER}

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

##########################################################################################
## Additional setup
##########################################################################################
## Create clock NDR - specify TCL_CTS_NDR_RULE_FILE with your script to create and associate your clock NDR rules.
## RM default is cts_ndr.tcl which is an RM provided example. Refer to the script for setup and details.
## You need to also specify CTS_NDR_RULE_NAME, CTS_INTERNAL_NDR_RULE_NAME, or CTS_LEAF_NDR_RULE_NAME for it to take effect.
if {[file exists [which $TCL_CTS_NDR_RULE_FILE]]} {
	source -echo $TCL_CTS_NDR_RULE_FILE
} elseif {$TCL_CTS_NDR_RULE_FILE != ""} {
	puts "RM-error: TCL_CTS_NDR_RULE_FILE($TCL_CTS_NDR_RULE_FILE) is invalid. Please correct it!"
}

## Report NDR and clock settings
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_routing_rules {report_routing_rules -verbose}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_routing_rules {report_clock_routing_rules}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_settings {report_clock_settings}

## CTS primary corner
## CTS automatically picks a corner with worst delay as the primary corner for its compile stage, 
## which inserts buffers to balance clock delays in all modes of the corner; 
## this setting allows you to manually specify a corner for the tool to use instead
if {$PREROUTE_CTS_PRIMARY_CORNER != ""} {
	puts "RM-info: Setting cts.compile.primary_corner to $PREROUTE_CTS_PRIMARY_CORNER (tool default unspecified)"
	set_app_options -name cts.compile.primary_corner -value $PREROUTE_CTS_PRIMARY_CORNER
}

## Lib cell usage restrictions (set_lib_cell_purpose)
## By default, RM sources set_lib_cell_purpose.tcl for dont use, tie cell, hold fixing, CTS and CTS-exclusive cell restrictions.
## For advanced nodes, set_lib_cell_purpose.tcl sources node specific dont use sidefile for the corresponding node.  
## You can replace it with your own script by specifying the TCL_LIB_CELL_PURPOSE_FILE variable.  
if {[file exists [which $TCL_LIB_CELL_PURPOSE_FILE]]} {
	puts "RM-info: Sourcing [which $TCL_LIB_CELL_PURPOSE_FILE]"
	source $TCL_LIB_CELL_PURPOSE_FILE
} elseif {$TCL_LIB_CELL_PURPOSE_FILE != ""} {
	puts "RM-error: TCL_LIB_CELL_PURPOSE_FILE($TCL_LIB_CELL_PURPOSE_FILE) is invalid. Please correct it."
}

## Placement spacing labels and rules (TCL_PLACEMENT_SPACING_LABEL_RULE_FILE) is done in init_design.tcl before tap cell insertion

## read_saif 
if {[file exists [which $SAIF_FILE]]} {
	if {$SAIF_FILE_POWER_SCENARIO != ""} {
		set read_saif_cmd "read_saif $SAIF_FILE -scenarios \"$SAIF_FILE_POWER_SCENARIO\""
	} else {
		set read_saif_cmd "read_saif $SAIF_FILE"
	}
	if {$SAIF_FILE_SOURCE_INSTANCE != ""} {lappend read_saif_cmd -strip_path $SAIF_FILE_SOURCE_INSTANCE}
	if {$SAIF_FILE_TARGET_INSTANCE != ""} {lappend read_saif_cmd -path $SAIF_FILE_TARGET_INSTANCE}
	puts "RM-info: Running $read_saif_cmd"
        eval ${read_saif_cmd}
} elseif {$SAIF_FILE != ""} {
	puts "RM-error: SAIF_FILE($SAIF_FILE) is invalid. Please correct it."	
}

## Spare cell insertion before place_opt
if {[file exists [which $TCL_USER_SPARE_CELL_PRE_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_SPARE_CELL_PRE_SCRIPT]"
	source $TCL_USER_SPARE_CELL_PRE_SCRIPT
} elseif {$TCL_USER_SPARE_CELL_PRE_SCRIPT != ""} {
	puts "RM-error: TCL_USER_SPARE_CELL_PRE_SCRIPT($TCL_USER_SPARE_CELL_PRE_SCRIPT) is invalid. Please correct it."
}

if {$OPTIMIZATION_FREEZE_PORT_LIST != ""} {
	puts "RM-info: Setting opt.dft.hier_preservation to true (tool default false)"
	set_app_options -name opt.dft.hier_preservation -value true ;# honors hierarchy port preservation during dft optimization
	set_freeze_port -all [get_cells $OPTIMIZATION_FREEZE_PORT_LIST] ;# sets freeze_clock_ports and freeze_data_ports attributes on the specified cells
}


##########################################################################################
## Pre-place_opt customizations
##########################################################################################
if {[file exists [which $TCL_USER_PLACE_OPT_PRE_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_PLACE_OPT_PRE_SCRIPT]"
	source -echo $TCL_USER_PLACE_OPT_PRE_SCRIPT
} elseif {$TCL_USER_PLACE_OPT_PRE_SCRIPT != ""} {
	puts "RM-error: TCL_USER_PLACE_OPT_PRE_SCRIPT($TCL_USER_PLACE_OPT_PRE_SCRIPT) is invalid. Please correct it."
}

redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.start {report_app_options -non_default *}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_lib_cell_purpose {report_lib_cell -objects [get_lib_cells] -column {full_name:20 valid_purposes}}

set check_stage_settings_cmd "check_stage_settings -stage pnr -metric \"${SET_QOR_STRATEGY_METRIC}\" -step placement"
if {$ENABLE_REDUCED_EFFORT} {lappend check_stage_settings_cmd -reduced_effort}
if {$RESET_CHECK_STAGE_SETTINGS} {lappend check_stage_settings_cmd -reset_app_options}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_stage_settings {eval ${check_stage_settings_cmd}}

puts "RM-info: Marking clock network as ideal"
set currentMode [current_mode]
foreach_in_collection mode [all_modes] {
    current_mode $mode
    set clock_tree [all_fanout -flat -clock_tree]
    if { [sizeof_collection $clock_tree] > 0 } {
        set_ideal_network $clock_tree
        remove_propagated_clock [get_pins -hierarchical]
        remove_propagated_clock [get_ports]
        remove_propagated_clock [all_clocks]
    }
}
current_mode $currentMode

## The following only applies to designs with physical hierarchy
## Ignore the sub-blocks (bound to abstracts) internal timing paths
if {$DESIGN_STYLE == "hier" && $PHYSICAL_HIERARCHY_LEVEL != "bottom"} {
	set_timing_paths_disabled_blocks -all_sub_blocks
}

## Clock NDR modeling 
## mark_clock_trees makes place_opt recognize clock NDR to model the congestion impact
puts "RM-info: Running mark_clock_trees -routing_rules to model clock NDR impact during place_opt"
mark_clock_trees -routing_rules

##########################################################################################
## place_opt flow
##########################################################################################
if {[file exists [which $TCL_USER_PLACE_OPT_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_PLACE_OPT_SCRIPT]"
	source -echo $TCL_USER_PLACE_OPT_SCRIPT
} elseif {$TCL_USER_PLACE_OPT_SCRIPT != ""} {
	puts "RM-error:TCL_USER_PLACE_OPT_SCRIPT($TCL_USER_PLACE_OPT_SCRIPT) is invalid. Please correct it."
} else {

	##########################################################################
	## Non-SPG flow (ENABLE_SPG set to false)
	##########################################################################
	if {!$ENABLE_SPG} {

		if {$ENABLE_HIGH_UTILIZATION_FLOW} {
			puts "RM-info: Special feature ENABLE_HIGH_UTILIZATION_FLOW is true."
			puts "RM-info: Disabling AWP and running remove_buffer_trees -all, create_placement -buffering_aware_timing_driven, and place_opt initial_drc before place_opt commands."
			reset_app_options time.delay_calc_wareform_analysis_mode
			remove_buffer_trees -all
			create_placement -buffering_aware_timing_driven -congestion -congestion_effort high
			place_opt -from initial_drc -to initial_drc
		}

		##########################################################################
		## Two pass place_opt: first pass
		##########################################################################
		puts "RM-info: Running place_opt -from initial_place -to initial_place" ;# initial_place phase is buffering-aware with CDR
		place_opt -from initial_place -to initial_place

	        ## Regular MSCTS at place_opt 
	        if {$CTS_STYLE == "MSCTS"} {
	                if {[file exists [which $TCL_REGULAR_MSCTS_FILE]]} {
				puts "RM-info: Sourcing [which $TCL_REGULAR_MSCTS_FILE]"
	                       	source $TCL_REGULAR_MSCTS_FILE
	                        save_block -as ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME}_MSCTS
	
	                } elseif {$TCL_REGULAR_MSCTS_FILE != ""} {
	                        puts "RM-error: TCL_REGULAR_MSCTS_FILE($TCL_REGULAR_MSCTS_FILE) is invalid. Please correct it."
	                }
	
	        } elseif {$CTS_STYLE != "standard"} {
			puts "RM-error: Specified CTS_STYLE($CTS_STYLE) is not supported, standard will be used." 
		}

		puts "RM-info: Running place_opt -from initial_drc -to initial_drc"
		place_opt -from initial_drc -to initial_drc
		puts "RM-info: Running update_timing -full"
		update_timing -full

		##########################################################################
		## Two pass place_opt: second pass
		##########################################################################
		puts "RM-info: Running create_placement -incremental -timing_driven -congestion"
		# Note: to increase the congestion alleviation effort, add -congestion_effort high
		create_placement -incremental -timing_driven -congestion
		save_block -as ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME}_two_pass_placement

		if {[file exists [which $TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT]]} {
			puts "RM-info: Sourcing [which $TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT]"
			source -echo $TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT
		} elseif {$TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT != ""} {
			puts "RM-error: TCL_USER_PLACE_OPT_PRE_SCRIPT($TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT) is invalid. Please correct it."
		}

		puts "RM-info: Running place_opt -from initial_drc"
		place_opt -from initial_drc

		if {$ENABLE_HIGH_UTILIZATION_FLOW} {
			puts "RM-info: Special feature ENABLE_HIGH_UTILIZATION_FLOW is true. Running extra place_opt -from final_place after default place_opt commands."
			place_opt -from final_place
		}
	} 

	##########################################################################
	## SPG flow (ENABLE_SPG set to true)
	##########################################################################
	if {$ENABLE_SPG} {

	        ## Regular MSCTS at place_opt 
	        if {$CTS_STYLE == "MSCTS"} {
	                if {[file exists [which $TCL_REGULAR_MSCTS_FILE]]} {
				puts "RM-info: Sourcing [which $TCL_REGULAR_MSCTS_FILE]"
	                        source $TCL_REGULAR_MSCTS_FILE
	                        save_block -as ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME}_MSCTS
	
	                } elseif {$TCL_REGULAR_MSCTS_FILE != ""} {
	                        puts "RM-error: TCL_REGULAR_MSCTS_FILE($TCL_REGULAR_MSCTS_FILE) is invalid. Please correct it."
	                } 
	
	        } elseif {$CTS_STYLE != "standard"} {
			puts "RM-error: Specified CTS_STYLE($CTS_STYLE) is not supported, standard will be used."
		}
 
		place_opt
	
	}
}

##########################################################################################
## Post-place_opt customizations
##########################################################################################
if {[file exists [which $TCL_USER_PLACE_OPT_POST_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_PLACE_OPT_POST_SCRIPT]"
	source -echo $TCL_USER_PLACE_OPT_POST_SCRIPT
} elseif {$TCL_USER_PLACE_OPT_POST_SCRIPT != ""} {
	puts "RM-error:TCL_USER_PLACE_OPT_POST_SCRIPT($TCL_USER_PLACE_OPT_POST_SCRIPT) is invalid. Please correct it."
}

## Spare cell insertion after place_opt
if {[file exists [which $TCL_USER_SPARE_CELL_POST_SCRIPT]]} {
	puts "RM-info: Sourcing [which $TCL_USER_SPARE_CELL_POST_SCRIPT]"
	source $TCL_USER_SPARE_CELL_POST_SCRIPT
} elseif {$TCL_USER_SPARE_CELL_POST_SCRIPT != ""} {
	puts "RM-error: TCL_USER_SPARE_CELL_POST_SCRIPT($TCL_USER_SPARE_CELL_POST_SCRIPT) is invalid. Please correct it."
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
echo [date] > place_opt
exit

