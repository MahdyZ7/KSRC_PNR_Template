puts "RM-info : Running script [info script]\n"
##########################################################################################
# Tool: IC Compiler II
# Script: icc2_pnr_setup.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################

echo hi
source -echo ./rm_setup/design_setup.tcl 
echo bye
########################################################################################## 
## Special features
##########################################################################################
## For controlling the set_qor_strategy command options
set SET_QOR_STRATEGY_METRIC		"timing" ;# timing|leakage_power|total_power; default is timing;
					;# Specify one metric for the set_qor_strategy -metric option and the application options will be set to optimize the specified target metric.
set ENABLE_REDUCED_EFFORT		false ;# false|true; RM default false; set it to true to enable the -reduced_effort option for the set_qor_strategy command;
					;# reduces efforts used by the set_qor_strategy command


set RESET_CHECK_STAGE_SETTINGS		false ;# false|true; RM default false; set it to true to enable the -reset_app_options option for the check_stage_settings command;
					;# compares current app option settings against set_technology, set_qor_strategy, set_stage, and select tool default settings which can impact runtime or ppa


## For SPG flow
set ENABLE_SPG 				false ;# false|true; RM default false; set it to true to enable SPG input handling flow in place_opt.tcl;
					;# which skips the first pass of the two-pass placement;
					;# recommended to go with DC-ASCII inputs (set INIT_DESIGN_INPUT DC_ASCII)


## For high utilization designs
set ENABLE_HIGH_UTILIZATION_FLOW	false ;# false|true; RM default false; set it to true to enable extra commands to address high utilization, such as:
					;# remove_buffer_trees -all, create_placement -buffering_aware_timing_driven, and place_opt initial_drc in place_opt.tcl;
					;# these extra commands are enabled only if ENABLE_SPG is set to false

 
##For Multibit Banking
set ENABLE_MULTIBIT                     false ;# false | true; RM default false but will be set to true if SET_QOR_STRATEGY_METRIC is set to total_power. 
                                        ;# In SET_QOR_STRATEGY_METRIC timing or leakage_power, multibit banking is not automatically used. Set  
                                        ;# ENABLE_MULTIBIT to true to enable multibit banking and debanking regardless of the SET_QOR_STRATEGY_METRIC. 


## For DPS
set ENABLE_DPS				false ;# false|true; RM default false; set it to true for set_stage command to enable dynamic power shaping (DPS)
					;# Optimizes peak current and bulk dynamic voltage drop (DVD) by clock scheduling. Reduces DVD across the design. Takes effect during final_opto phase.
					;# Affects timing network latencies to make pre-CTS steps see the impact, and clock balance points to direct tool to implement the offsets in CTS. 
					;# Pls run redhawk fusion after clock_opt/route_opt stage to verify dynamic voltage drop improvements
## For IRDP
set ENABLE_IRDP				false ;# false|true; RM default false; set it to true to enable IR-aware placement (IRDP) in clock_opt_opto.tcl
set TCL_IRDP_CONFIG_FILE		"" ;# (Required for ENABLE_IRDP) Specify a Tcl script for IRDP configuration
        				;# Example for IRDP with manual RH config :      	examples/TCL_IRDP_CONFIG_FILE.manual.rh.tcl
        				;# Example for IRDP with streamlined RH config : 	examples/TCL_IRDP_CONFIG_FILE.streamlined.rh.tcl
        				;# Example for IRDP with manual RHSC config :    	examples/TCL_IRDP_CONFIG_FILE.manual.rhsc.tcl
        				;# Example for IRDP with streamlined RHSC config : 	examples/TCL_IRDP_CONFIG_FILE.streamlined.rhsc.tcl
## For IRD-CCD
set ENABLE_IRDCCD			false ;# false|true; RM default false; set it to true to enable IR-aware CCD (IRD-CCD) in route_opt.tcl
set TCL_IRDCCD_CONFIG_FILE		"" ;# (Required for ENABLE_IRDCCD) Specify a Tcl script for IRD-CCD configuration
					;# Example for IRD-CCD with RH config: 			examples/TCL_IRDCCD_CONFIG_FILE.rh.tcl
					;# Example for IRD-CCD with RHSC config : 		examples/TCL_IRDCCD_CONFIG_FILE.rhsc.tcl


## For CTS & MSCTS
set CTS_STYLE                           "standard" ;# standard|MSCTS; RM default standard; specify MSCTS to enable regular multisource clock tree synthesis flow; 
set TCL_REGULAR_MSCTS_FILE		"mscts.regular.tcl" ;# Specify a Tcl script for regular multisource clock tree synthesis setup and creation,
					;# which will be sourced after initial placement if CTS_STYLE is set to MSCTS in place_opt.tcl
					;# (Required if CTS_STYLE is MSCTS); RM provided script: mscts.regular.tcl


## For shielding
set ENABLE_CREATE_SHIELDS		true ;# false|true; RM default false; enable shielding in the flow;
					;# runs create_shields at the beginning of clock_opt_opto;
					;# sets route.common.reshield_modified_nets to reshield : router unshields modified shielded nets, automatically reshields them, and then reconnects floating shielding;
					;# if router cannot reconnect floating shielding, it removes it. Shielded nets might have been modified by routing or outside of routing such as by optimization.


set ROUTE_OPT_STARRC_CONFIG_FILE 	"" ;# Specify the configuration file for StarRC in-design extraction for route_auto.tcl and route_opt.tcl;
					;# (Required for enabling StarRC in-design extraction); refer to examples/ROUTE_OPT_STARRC_CONFIG_FILE.example.txt for sample content and syntax


## For ECO fusion in route_opt.tcl (enabling eco_opt skips third route_opt)
set ENABLE_ECO_OPT			false ;# Default false; enables eco_opt which replaces 3rd route_opt in route_opt.tcl
set ROUTE_OPT_ECO_OPT_PT_PATH		"" ;# (Required); specify the path to pt_shell; for example: /u/mgr/bin/pt_shell
set ROUTE_OPT_ECO_OPT_STARRC_CONFIG_FILE "" ;# (Required if extract.starrc_mode is set to fusion_adv or in_design); 
					;# specify the configuration file for standalone StarRC extraction; 
					;# Example : examples/ROUTE_OPT_STARRC_CONFIG_FILE.txt
set ROUTE_OPT_ECO_OPT_DB_PATH		"" ;# (Optional); specify the paths to .db files of the reference libraries for PT (if not already in your search path)
					;# For eco_opt, PT needs to read db. 
set ROUTE_OPT_ECO_OPT_TYPE		"" ;# (Optional); eco_opt fixing type; timing|setup|hold|drc|leakage_power|dynamic_power|total_power|buffer_removal
					;# if not specified, works on all types
set ROUTE_OPT_ECO_OPT_WITH_PBA 		false ;# default false; sets time.pba_optimization_mode to path to enable PBA during eco_opt in the route_opt.tcl
set ROUTE_OPT_ECO_OPT_WORK_DIR		"" ;# (Optional); specify the working directory for eco_opt where PT files and logs are generated;
					;# if not specified, tool will automatically generate one
set ROUTE_OPT_ECO_OPT_PRE_LINK_SCRIPT	"" ;# (Optional); specify the file that contains custom PT script, which is executed before linking in PrimeTime;
					;# use PT commands that do not require the current design
set ROUTE_OPT_ECO_OPT_POST_LINK_SCRIPT	"" ;# (Optional); specify the file that contains custom PT script, which is executed after linking in PrimeTime;
					;# use PT commands that require the current design


set EARLY_DATA_CHECK_POLICY		"none" ;# none|lenient|strict ;RM default is none;
					;# lenient and strict trigger corresponding set_early_data_check_policy -policy $EARLY_DATA_CHECK_POLICY command and report_early_data_checks; 
					;# specify none to disable the set_early_data_check_policy command


puts "RM-info: Completed script [info script]\n"

