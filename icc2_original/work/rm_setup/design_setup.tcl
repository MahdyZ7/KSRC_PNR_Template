source ../getenv.tcl


puts "RM-info : Running script [info script]\n"

##########################################################################################
# Script: design_setup.tcl
# Version: R-2020.09-SP4
##########################################################################################

set DESIGN_NAME 		"$my_design_name" 
set LIBRARY_SUFFIX		"$my_library_suffix" 
set DESIGN_LIBRARY 		"${DESIGN_NAME}${LIBRARY_SUFFIX}" 

##########################################################################################
## Variables for design prep which are used by init_design*tcl scripts
##########################################################################################
set INIT_DESIGN_INPUT 		"ASCII"	
set REFERENCE_LIBRARY 		$my_reference_library_list
set COMPRESS_LIBS               "false" 
set LIBRARY_CONFIGURATION_FLOW	false	
set LINK_LIBRARY		""	
##################################################
### 2. Tech files and setup
##################################################
set TECH_FILE 				"$my_tech_file"
set TECH_LIB				""	
set TECH_LIB_INCLUDES_TECH_SETUP_INFO 	false
set TCL_TECH_SETUP_FILE			"$my_tcl_tech_setup_file"
set DESIGN_LIBRARY_SCALE_FACTOR		""	
set ROUTING_LAYER_DIRECTION_OFFSET_LIST "{M1 horizontal 0.052 } {M2 horizontal 0.080 } {C1 vertical 0.045 } {C2 horizontal 0.045 } {C3 vertical 0.045 } {C4 horizontal 0.045 } {C5 vertical 0.045 } {JA horizontal 0.0 } {QA vertical 0.0 } {QB horizontal 0.0 } {LB horizontal 0.0}" 
set MIN_ROUTING_LAYER			"$min_routing_layer"	
set MAX_ROUTING_LAYER			"$max_routing_layer"	

##################################################
### 3. Verilog, dc inputs, upf, mcmm, timing, etc 
##################################################
set UPF_FILE 				"$my_upf_file"	
set UPF_SUPPLEMENTAL_FILE		""      
set UPF_UPDATE_SUPPLY_SET_FILE		""	
set VERILOG_NETLIST_FILES		"$my_verilog_netlist_files"	
set TCL_MCMM_SETUP_FILE			"$my_tcl_mcmm_setup_file"	
set TCL_PARASITIC_SETUP_FILE		"$my_tcl_parasitic_setup_file"
set POCV_CORNER_FILE_MAPPING_LIST 	"" 
set AOCV_CORNER_TABLE_MAPPING_LIST 	"" 
##################################################
### 4. DEF, floorplan, placement constraints, etc 
##################################################
set TCL_FLOORPLAN_FILE			"$my_floorplan_file" 
set DEF_FLOORPLAN_FILES			"$my_def_files" 
set DEF_SITE_NAME_PAIRS			{} 
set SITE_SYMMETRY_LIST			""
set SITE_DEFAULT			"unit" 
set TCL_ADDITIONAL_FLOORPLAN_FILE 	"" 
set TCL_MV_SETUP_FILE			"$my_tcl_mv_setup_file" 
set DEF_SCAN_FILE			"$my_def_scan_file" 
set SCAN_DEF_FLOW			"$scan_def_flow"
#
### TCL_PLACEMENT_CONSTRAINT_FILE_LIST contents 
set TCL_PLACEMENT_CONSTRAINT_FILE_LIST  "$my_placement_constraint_files" 
set TCL_LIB_CELL_PURPOSE_FILE 		"$my_tcl_lib_cell_purpose_file"
##set TCL_LIB_CELL_DONT_USE_FILE          "$my_dont_use_file"
set TCL_PG_CREATION_FILE		"$my_tcl_pg_creation_file" 
set TCL_USER_CONNECT_PG_NET_SCRIPT ""	
set TCL_USER_SPARE_CELL_PRE_SCRIPT	"" 
set TCL_USER_SPARE_CELL_POST_SCRIPT	"" 
########################################################################################## 
## Variables for general optimization use
##########################################################################################

set SAIF_FILE				"" 
set SAIF_FILE_POWER_SCENARIO		"" 
set SAIF_FILE_SOURCE_INSTANCE		"" 
set SAIF_FILE_TARGET_INSTANCE		"" 
set OPTIMIZATION_FREEZE_PORT_LIST 	"" 
set TCL_LIB_CELL_PURPOSE_FILE 		"$my_tcl_lib_cell_purpose_file" 
set TCL_CTS_NDR_RULE_FILE 		"$my_tcl_cts_ndr_rule_file" 
set PREROUTE_CTS_PRIMARY_CORNER		"$my_preroute_cts_primary_corner" 
set TCL_USER_MSCTS_MESH_ROUTING_SCRIPT 	"" 
set TCL_ANTENNA_RULE_FILE		"$my_tcl_antenna_rule_file" 

## For redundant via insertion
set ENABLE_REDUNDANT_VIA_INSERTION	true 
set TCL_USER_REDUNDANT_VIA_MAPPING_FILE "$my_tcl_user_redundant_via_mapping_file" 

########################################################################################## 
## Variables for scenario activation and focused scenario
##########################################################################################
set PLACE_OPT_ACTIVE_SCENARIO_LIST	"$my_place_opt_active_scenario_list" 
set CLOCK_OPT_CTS_ACTIVE_SCENARIO_LIST  "$my_clock_opt_cts_active_scenario_list" 
set ROUTE_OPT_ACTIVE_SCENARIO_LIST 	"$my_route_opt_active_scenario_list" 
set CLOCK_OPT_OPTO_ACTIVE_SCENARIO_LIST "$ROUTE_OPT_ACTIVE_SCENARIO_LIST" 
set ROUTE_AUTO_ACTIVE_SCENARIO_LIST 	"$ROUTE_OPT_ACTIVE_SCENARIO_LIST" 
set CHIP_FINISH_ACTIVE_SCENARIO_LIST 	"$my_chip_finish_active_scenario_list" 
set ICV_IN_DESIGN_ACTIVE_SCENARIO_LIST 	"$my_icv_in_design_active_scenario_list" 
set TIMING_ECO_ACTIVE_SCENARIO_LIST 	"$my_timing_eco_active_scenario_list" 
set ROUTE_FOCUSED_SCENARIO		"$my_route_focused_scenario" 
########################################################################################## 
## Variables for pre and post plugins 
##########################################################################################
set TCL_USER_INIT_DESIGN_POST_SCRIPT ""	
set TCL_USER_NON_PERSISTENT_SCRIPT 	"" 

set TCL_USER_PLACE_OPT_PRE_SCRIPT 	"" 
set TCL_USER_PLACE_OPT_SCRIPT 		"" 
set TCL_USER_PLACE_OPT_POST_SCRIPT 	"" 
set TCL_USER_PLACE_OPT_INCREMENTAL_PLACEMENT_POST_SCRIPT "" 
					   
set TCL_USER_CLOCK_OPT_CTS_PRE_SCRIPT 	"" 
set TCL_USER_CLOCK_OPT_CTS_SCRIPT 	"" 
set TCL_USER_CLOCK_OPT_CTS_POST_SCRIPT 	""

set TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT 	"" 
set TCL_USER_CLOCK_OPT_OPTO_SCRIPT 	"" 
set TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT "" 

set TCL_USER_ROUTE_AUTO_PRE_SCRIPT 	"" 
set TCL_USER_ROUTE_AUTO_SCRIPT 		"" 
set TCL_USER_ROUTE_AUTO_POST_SCRIPT 	"" 

set TCL_USER_ROUTE_OPT_PRE_SCRIPT 	"" 
set TCL_USER_ROUTE_OPT_SCRIPT 		""
set TCL_USER_ROUTE_OPT_1_POST_SCRIPT 	""
set TCL_USER_ROUTE_OPT_POST_SCRIPT 	""

set TCL_USER_TIMING_ECO_PRE_SCRIPT 	""
set TCL_USER_TIMING_ECO_POST_SCRIPT 	""

set TCL_USER_CHIP_FINISH_PRE_SCRIPT 	""
set TCL_USER_CHIP_FINISH_POST_SCRIPT 	""

set TCL_USER_ICV_IN_DESIGN_PRE_SCRIPT 	""
set TCL_USER_ICV_IN_DESIGN_POST_SCRIPT 	""


########################################################################################## 
## Variables for chip finishing related settings (Used by chip_finish.tcl)
##########################################################################################
## Std cell filler and decap cells used by chip_finish step and post ECO refill in timing_eco step
set CHIP_FINISH_METAL_FILLER_PREFIX 		"$my_chip_finish_metal_filler_prefix" 
set CHIP_FINISH_NON_METAL_FILLER_PREFIX 	$CHIP_FINISH_METAL_FILLER_PREFIX 

set CHIP_FINISH_METAL_FILLER_LIB_CELL_LIST 	"$my_chip_finish_metal_filler_lib_cell_list" 
set CHIP_FINISH_NON_METAL_FILLER_LIB_CELL_LIST 	"$my_chip_finish_non_metal_filler_lib_cell_list" 

## Signal EM
set CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FORMAT 	"$my_chip_finish_signal_em_constraint_format" 
set CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FILE 	"$my_chip_finish_signal_em_constraint_file" 
set CHIP_FINISH_SIGNAL_EM_SAIF 			"" 
set CHIP_FINISH_SIGNAL_EM_SCENARIO 		"$my_chip_finish_signal_em_scenario" 
set CHIP_FINISH_SIGNAL_EM_FIXING 		"$my_chip_finish_signal_em_fixing"

############################################################################################ 
#### Variables for ICV in-design related settings (used by icv_in_design.tcl)
############################################################################################
#### signoff_check_drc specific variables
##set ICV_IN_DESIGN_DRC_CHECK_RUNSET 	"" ;# The foundry runset for ICV used by signoff_check_drc
##set ICV_IN_DESIGN_DRC_CHECK_RUNDIR 	"z_check_drc" 
##					   ;# The working directory for the signoff_check_drc before signoff_fix_drc;
##					   ;# The directory that contains the initial DRC error database for signoff_fix_drc.
##
#### singoff_fix_drc specific variables
##set ICV_IN_DESIGN_ADR 			true ;# true|false; true enables signoff_fix_drc in addition to signoff_check_drc; default is true
##set ICV_IN_DESIGN_ADR_RUNDIR 		"z_adr"	;# The working directory for signoff_fix_drc; only takes effect if ICV_IN_DESIGN_ADR is true
##set ICV_IN_DESIGN_POST_ADR_RUNDIR 	"z_post_adr" ;# The working directory for signoff_check_drc after signoff_fix_drc is done; 
##					   ;# only takes effect if ICV_IN_DESIGN_ADR is true 
##
##set ICV_IN_DESIGN_ADR_DPT_RULES 	"" ;# Specify your DPT rules for signoff_fix_drc fixing; only takes effect if ICV_IN_DESIGN_ADR is true
##set ICV_IN_DESIGN_ADR_DPT_RUNDIR	"z_adr_with_dpt" ;# The working directory for signoff_check_drc with DPT rule fixing;
##					   ;# only takes effect if ICV_IN_DESIGN_ADR_DPT_RULES (DPR rules) is specified
##set ICV_IN_DESIGN_POST_ADR_DPT_RUNDIR	"z_post_adr_with_dpt" ;# The working directory for signoff_check_drc after DPT rule fixing is done;
##					   ;# only takes effect if ICV_IN_DESIGN_ADR_DPT_RULES (DPR rules) is specified
##
#### Metal fill specific variables
##set ICV_IN_DESIGN_METAL_FILL 		false ;# Default false; set it to true to enable the metal fill creation feature.
##set ICV_IN_DESIGN_METAL_FILL_RUNDIR	"z_icvFill" ;# The working directory for signoff_create_metal_fill. Optional. Default is z_icvFill.
##set ICV_IN_DESIGN_METAL_FILL_TIMING_DRIVEN_THRESHOLD "" 
##					   ;# Specify the threshold for timing-driven metal fill.
##					   ;# If not specified, timing-driven is not enabled.
##					   ;# If specified, "-timing_preserve_setup_slack_threshold" option is added.
##set ICV_IN_DESIGN_METAL_FILL_TRACK_BASED "off" ;# off | <a technology node> | generic; used for -track_fill option of signoff_create_metal_fill
##					   ;# for non-track-based : specify off 
##					   ;# for track-based : specify either a node (refer to man page) or generic 
##set ICV_IN_DESIGN_METAL_FILL_ECO_THRESHOLD "" ;# Specify the percent change to perform incremental fill.  If unspecified, the tool default value is used.
##set ICV_IN_DESIGN_METAL_FILL_RUNSET	"" ;# Specify the foundry runset for signoff_create_metal_fill command;
##					   ;# required only by non track-based metal fill (ICV_IN_DESIGN_METAL_FILL_TRACK_BASED set to off).
##set ICV_IN_DESIGN_POST_METAL_FILL_RUNDIR "z_MFILL_after" 
##					   ;# The working directory for the signoff_check_drc after signoff_create_metal_fill is completed;
##					   ;# only takes effect if ICV_IN_DESIGN_METAL_FILL is true
##set ICV_IN_DESIGN_METAL_FILL_TRACK_BASED_PARAMETER_FILE "auto" ;# auto | <a parameter file>; default is auto;
##					   ;# this variable is only for track-based metal fill;
##					   ;# specify auto to use tool auto generated track_fill_params.rh file or your own paramter file.
##
########################################################################################## 
## Variables for settings related to write data (used by write_data.tcl)
##########################################################################################
## write_gds related
set WRITE_GDS_LAYER_MAP_FILE 		"$my_write_gds_layer_map_file" 
set WRITE_OASIS_LAYER_MAP_FILE 		"" 

############################################################################################ 
#### Variables for Redhawk & Redhawk-SC (RHSC) in-design related settings 
#### (used by redhawk_in_design_pnr.tcl & rhsc_in_design_pnr.tcl ; SNPS_INDESIGN_RH_RAIL license required)
############################################################################################
##set REDHAWK_SC_DIR                      "" ;# Required; path to RedHawk-SC binary
##set REDHAWK_SC_GRID_FARM	        "" ;# Optional; commands to submit RedHawk-SC in GRID FARM
##
##set REDHAWK_DIR				"" ;# Required; path to RedHawk binary
##					
##set REDHAWK_PAD_FILE_NDM                "" ;# The file include tap points on NDM. Default is top level pins.
##set REDHAWK_PAD_FILE_PLOC               "";
##set REDHAWK_PAD_CUSTOMIZED_SCRIPT       "" ;# User script to run command create_taps with different options 
##					;# Example : ./examples/REDHAWK_PAD_CUSTOMIZED_SCRIPT.txt
##
##set REDHAWK_FREQUENCY			"" ;# Optional to pass frequency to RedHawk 
##set REDHAWK_TEMPERATURE			"" ;# Optional to pass temperature to RedHawk
##set REDHAWK_SCENARIO		        "" ;# Optional to specify current scenario for running RedHawk
##
##set REDHAWK_ANALYSIS_NETS 		"" ;# Required. Specify the list of power and ground nets in pairs and in separate lines for the analysis;
##					   ;# for example, "VDD1 VSS1 VDD2 VSS2 VDD3 VSS3", where VDD* are power nets and VSS* are ground nets.
##
##set REDHAWK_LAYER_MAP_FILE              "" ;# Optional. The file include process layer name and LEF layer name
##
##set REDHAWK_TECH_FILE 			"" ;# Required. Apache Technology File
##set REDHAWK_MACROS 			"" ;# Optional. List of Macro names and macro directories in pairs and in separate lines;
##					   ;# for example, "macro1_name macro1_directory 
##					   ;#		    macro2_name macro2_directory 
##					   ;#		    macro3_name macro3_directory"
##set REDHAWK_SWITCH_MODEL_FILES 		"" ;# Optional. List of switch model files;
##					   ;# for example: "switch_model_file1 
##					   ;#               switch_model_file2 
##					   ;#		    switch_model_file3"
##set REDHAWK_LIB_FILES 			"" ;# Required. List of .lib files in separate lines.
##					   ;# for example: "/home/lib_1.lib 
##					   ;#               /home/lib_2.lib
##					   ;#               /home/lib_3.lib"
##set REDHAWK_APL_FILES			"" ;# Required for dynamic analysis.  List of apl files in separate lines.
##					   ;# for example: "x.cdev cdev
##					   ;#               x.current current
##					   ;#               y.cdev cdev
##					   ;#               y.current current"
##set REDHAWK_EXTRA_GSR 			"" ;# Optional. Provide a file with custom Redhawk settings.
##set REDHAWK_ANALYSIS 			"" ;# Required. Specify of the analyses below:
##                                           ;# For Static analysis: "static"
##                                           ;# For Vector-based Dynamic analysis: "dynamic_vcd"
##                                           ;# For Vectorless Dynamic analysis: "dynamic_vectorless"
##                                           ;# For Effective Resistance analysis: "effective_resistance"
##                                           ;# For Minimum path resistance analysis: "min_path_resistance"
##                                           ;# For Integrity Check: "check_missing_via"
##set REDHAWK_OUTPUT_REPORT 		"" ;# Optional. Specify a file name to have the output report produced:
##                                           ;# For Static or dynamic analysis: the effective voltage drop is reported
##                                           ;# For Effective Resistance analysis: the effective resistance is reported
##                                           ;# For Minimum path resistance analysis: the minimum path resistance is reported
##                                           ;# For Integrity Check: the missing vias are reported
##set REDHAWK_EM_ANALYSIS 	   	false ;# Optional. Set to true if EM analysis to be performed with static or dynamic analysis.
##set REDHAWK_EM_REPORT 			"" ;# Optional. Specify a file name to have the EM output report produced.
##
##set REDHAWK_SCRIPT_FILE 		"" ;# Optional. Specify a file as Redhawk standalone run tcl file.
##set RHSC_PYTHON_SCRIPT_FILE             "" ;# Optional. Specify a file as RHSC standalone run python script
##set RHSC_GENERATE_COLLATERAL	        "" ;# Optional. The command analyze_rail only generate TWF, DEF, SPEF, PLOC files, this work with RHSC_PYTHON_SCRIPT_FILE
##
##set REDHAWK_SWITCHING_ACTIVITY_FILE 	"" ;# Required for vector-based dynamic analysis.  Format is as follows:
##                                           ;# {file_format [file_name] [strip_path]}
##set REDHAWK_FIX_MISSING_VIAS       	false ;# Optional. Set to true to enable inserting vias to missing via locations after the check_missing_via flow is run.
##set REDHAWK_MISSING_VIA_POS_THRESHOLD	"" ;# Optional. Set to positive voltage between two overlapped layers for filtering purpose.  Default is no filtering.
##set REDHAWK_RAIL_DATABASE               RAIL_DATABASE  ;# Optional. Set ICC2 Redhawk Fusion output directory.
##set REDHAWK_PGA_POWER_NET               "" ; #Required.  Set one power net for PGA.
##set REDHAWK_PGA_GROUND_NET              "" ; #Required.  Set one ground net for PGA
##set REDHAWK_PGA_NODE                    "" ; #Required. Set the technology node such as tsmc16.
##set REDHAWK_PGA_ICV_DIR                 "" ; #Required. Set the path to the ICV binary.  Example: /global/apps/icv_2018.06
##set REDHAWK_PGA_CUSTOMIZED_SCRIPT       "" ;# Optional to add customized PGA setting
##					;# Example : ./examples/REDHAWK_PGA_CUSTOMIZED_SCRIPT.txt
##
############################################################################################ 
#### Variables for Timing ECO related settings (used by timing_eco.tcl)
############################################################################################
#### The following ECO_OPT* variables are for ECO fusion.  The PT setup is also needed when implementing the user provided PT change file, as PT reporting is run.
##set ECO_OPT_PT_PATH			"" ;# Required by eco_opt; specify the path to pt_shell; for example: /u/mgr/bin/pt_shell
##					;# if specified, eco_opt
##set ECO_OPT_DB_PATH			"" ;# Optional; specify the paths to .db files of the reference libraries for PT (if not already in your search path)
##					;# For eco_opt, PT needs to read db. 
##set ECO_OPT_TYPE			"" ;# Optional; eco_opt fixing type; timing|setup|hold|drc|leakage_power|dynamic_power|total_power|buffer_removal
##					;# if not specified, works on all types
##set ECO_OPT_RECIPE_FILE			"" ;# Optional; specify a metric type recipe for one or more eco_opt runs.  
##					;# An example file is located in examples/ECO_OPT_RECIPE_FILE.tcl.
##set ECO_OPT_PHYSICAL_MODE		"" ;# Specify none, open_site, or occupied_site to guide physical impact.  If not specified, the tool default of "open_site" is run.
##set ECO_OPT_WITH_PBA 			false ;# Default false; sets time.pba_optimization_mode to path to enable PBA for eco_opt
##set ECO_OPT_EXTRACTION_MODE		"fusion_adv" ;# fusion_adv|in_design|none; default is fusion_adv; sets extract.starrc_mode to corresponding value;
##					;# fusion_adv and in_design modes require ECO_OPT_STARRC_CONFIG_FILE to be specified;
##					;# refer to ROUTE_OPT_STARRC_CONFIG_FILE.example.txt for 
##set ECO_OPT_STARRC_CONFIG_FILE 		"" ;# Required when using fusion_adv or in_design extraction modes; specify the configuration file
##set ECO_OPT_WORK_DIR			"eco_opt_dir" ;# Optional; specify the working directory for eco_opt where PT files and logs are generated;
##					;# if not specified, tool will automatically generate one
##set ECO_OPT_PRE_LINK_SCRIPT		"" ;# Optional; specify the file that contains custom PT script, which is executed before linking in PrimeTime;
##					;# use PT commands that do not require the current design
##set ECO_OPT_POST_LINK_SCRIPT		"" ;# Optional; specify the file that contains custom PT script, which is executed after linking in PrimeTime;
##					;# use PT commands that require the current design
##set ECO_OPT_PT_CORES_PER_SCENARIO	"4" ;# Specify the number of cores per scenario for PT DMSA.
##set ECO_OPT_SIGNOFF_SCENARIO_PAIR	"" ;# Optional; Provide scenario constraints file for PT.  Uses a list of {scenario sdc} pairs.
##set ECO_OPT_FILLER_CELL_PREFIX 		"$CHIP_FINISH_METAL_FILLER_PREFIX" ;# A string to specify the prefix used to identify filler cells to remove prior to running eco_opt.
##					;# The default is set the same as CHIP_FINISH_METAL_FILLER_PREFIX.	
##
#### The following variables apply when using a user provided PT change file.
##set PT_ECO_CHANGE_FILE 			"" ;# The eco_opt mode (default) is run when not set.  When set, this points to the PT change file to implement.
##set PT_ECO_MODE				"default" ;# Specify the preferred flow for the PT-ECO run; default|freeze_silicon
##					   ;# default: sources $PT_ECO_CHANGE_FILE and place_eco_cells in MPI mode
##					   ;# freeze_silicon: add_spare_cells, place_eco_cells, sources $PT_ECO_CHANGE_FILE, and place_freeze_silicon
##set PT_ECO_DISPLACEMENT_THRESHOLD 	"10" ;# A float to specify the maximum displacement threshold value for 
##					   ;# place_eco_cells -eco_changed_cells -legalize_mode minimum_physical_impact -displacement_threshold;
##
############################################################################################ 
#### Variables for Functional ECO related settings (used by functional_eco.tcl)
############################################################################################
##set FUNCTIONAL_ECO_ACTIVE_SCENARIO_LIST	"" ;# Optional; a subset of scenarios to be made active during the step;
##					   ;# once set, the list of active scenarios is saved and carried over to subsequent steps;
##set TCL_USER_FUNCTIONAL_ECO_PRE_SCRIPT	"" ;# An optional Tcl file to be sourced before ECO operations.
##set TCL_USER_FUNCTIONAL_ECO_POST_SCRIPT	"" ;# An optional Tcl file to be sourced after route_eco.
##set FUNCTIONAL_ECO_DISPLACEMENT_THRESHOLD "10" ;# A float to specify the maximum displacement threshold value for 
##					   ;# place_eco_cells -eco_changed_cells -legalize_mode minimum_physical_impact -displacement_threshold;
##set FUNCTIONAL_ECO_VERILOG_FILE		"" ;# Required; the verilog file to be used for functional ECO.
##set FUNCTIONAL_ECO_MODE			"default" ;# Specify the preferred flow; default|freeze_silicon
##					   ;# default: sources $FUNCTIONAL_ECO_CHANGE_FILE and place_eco_cells in MPI mode
##					   ;# freeze_silicon: add_spare_cells, place_eco_cells, sources $FUNCTIONAL_ECO_CHANGE_FILE, and place_freeze_silicon
##
##
##########################################################################################
## Variables and settings for the system (there's no need to change these)
##########################################################################################
## Reporting 
set REPORT_QOR				true 
set REPORT_QOR_REPORT_POWER		true 
set REPORT_QOR_REPORT_CONGESTION	true 
set WRITE_QOR_DATA			true 
set WRITE_QOR_DATA_DIR			"./qor_data"
set COMPARE_QOR_DATA_DIR		"./compare_qor_data"
set REPORT_PARALLEL_SUBMIT_COMMAND 	"" ;# for parallel reporting; if specified, script uses job submission for report_qor.tcl
					;# Note : if specified, enables parallel reporting; if not specified (default) runs sequential reporting
set REPORT_PARALLEL_MAX_CORES 		4 ;# specify core limit for parallel reporting

set search_path [list ./rm_icc2_pnr_scripts ./rm_setup]
lappend search_path .

if {$synopsys_program_name == "icc2_shell"} {
	set_host_options -max_cores 32

	## The default number of significant digits used to display values in reports
	set_app_options -name shell.common.report_default_significant_digits -value 3 ;# tool default is 2

	## Enable on-disk operation for copy_block to save block to disk right away
	#	set_app_options -name design.on_disk_operation -value true ;# default false and global-scoped
}

set sh_continue_on_error true

## Label names (while $DESIGN_NAME is the block name)
set INIT_DESIGN_BLOCK_NAME		"init_design"			;# Label name to be used when saving a block in init_design.tcl
set PLACE_OPT_BLOCK_NAME 		"place_opt" 			;# Label name to be used when saving a block in place_opt.tcl
set CLOCK_OPT_CTS_BLOCK_NAME 		"clock_opt_cts" 		;# Label name to be used when saving a block in clock_opt_cts.tcl
set CLOCK_OPT_OPTO_BLOCK_NAME 		"clock_opt_opto" 		;# Label name to be used when saving a block in clock_opt_opto.tcl
set ROUTE_AUTO_BLOCK_NAME 		"route_auto" 			;# Label name to be used when saving a block in route_auto.tcl
set ROUTE_OPT_BLOCK_NAME 		"route_opt" 			;# Label name to be used when saving a block in route_opt.tcl

set CHIP_FINISH_BLOCK_NAME 		"chip_finish" 			;# Label name to be used when saving a block in chip_finish.tcl
set ICV_IN_DESIGN_FROM_BLOCK_NAME	"chip_finish" 			;# Label name of the input block in icv_in_design.tcl
set ICV_IN_DESIGN_BLOCK_NAME		"icv_in_design" 		;# Label name to be used when saving a block in icv_in_design.tcl

set WRITE_DATA_FROM_BLOCK_NAME 		"chip_finish"				;# Label name of the source block in write_data.tcl;
set WRITE_DATA_BLOCK_NAME 		"$my_design_name" 			;# Label name to be used when saving a block in write_data.tcl
									;# default is ICV_IN_DESIGN_BLOCK_NAME

set TIMING_ECO_FROM_BLOCK_NAME		"icv_in_design"			;# Label name of the input block in timing_eco.tcl
set TIMING_ECO_BLOCK_NAME		"timing_eco" 			;# Label name to be used when saving a block in timing_eco.tcl
set FUNCTIONAL_ECO_FROM_BLOCK_NAME	"icv_in_design" 		;# Label name of the input block in functional_eco.tcl;
set FUNCTIONAL_ECO_BLOCK_NAME		"functional_eco"		;# Label name to be used when saving a block in functional_eco.tcl

set REDHAWK_IN_DESIGN_PNR_FROM_BLOCK_NAME $ROUTE_OPT_BLOCK_NAME		;# Label name of the starting block for redhawk_in_design_pnr.tcl and rhsc_in_design_pnr.tcl;

## Directories
set OUTPUTS_DIR	"./outputs_icc2"	;# Directory to write output data files; mainly used by write_data.tcl
set REPORTS_DIR	"./rpts_icc2"		;# Directory to write reports; mainly used by report_qor.tcl

if {![file exists $OUTPUTS_DIR]} {file mkdir $OUTPUTS_DIR} ;# do not change this line or directory may not be created properly
if {![file exists $REPORTS_DIR]} {file mkdir $REPORTS_DIR} ;# do not change this line or directory may not be created properly
if {$WRITE_QOR_DATA && ![file exists $WRITE_QOR_DATA_DIR]} {file mkdir $WRITE_QOR_DATA_DIR} ;# do not change this line or directory may not be created properly
if {$WRITE_QOR_DATA && ![file exists $COMPARE_QOR_DATA_DIR]} {file mkdir $COMPARE_QOR_DATA_DIR} ;# do not change this line or directory may not be created properly


##########################################################################################
## Variables related to flow controls of flat PNR, hierarchical PNR and transition with DP
##########################################################################################
set DESIGN_STYLE		"flat"	
set PHYSICAL_HIERARCHY_LEVEL	"" 	
set RELEASE_DIR_DP		"" 	
set RELEASE_LABEL_NAME_DP 	"for_pnr"	
set RELEASE_DIR_PNR		"" 
############################################################################################
#### Hierarchical PNR Variables (used by hierarchical PNR implementation)
############################################################################################
#### For designs where the blocks are bound to abstracts
set SUB_BLOCK_REFS                   	[list ] ;# If ABSTRACT_TYPE_FOR_MPH_BLOCKS == flattened , specify design names of the immediate child blocks
##                                                ;# If ABSTRACT_TYPE_FOR_MPH_BLOCKS == nested , specify design names of the physical blocks in all lower levels of physical hierarchy
##                                                ;# Include the blocks that will be bound to abstracts
set USE_ABSTRACTS_FOR_BLOCKS        	[list ] ;# design names of the physical blocks in the next lower level that will be bound to abstracts
##
#### By default, abstracts created after icv_in_design step of lower-level are used to implement the current level
#### Update the following variables if you want to use abstracts created after any other step 
set BLOCK_ABSTRACT_FOR_PLACE_OPT 	"$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_PLACE_OPT label for place_opt
set BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS    "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS label for clock_opt_cts
set BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO   "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO label for clock_opt_opto
set BLOCK_ABSTRACT_FOR_ROUTE_AUTO       "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_ROUTE_AUTO label for route_auto
set BLOCK_ABSTRACT_FOR_ROUTE_OPT        "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_ROUTE_OPT label for route_opt
set BLOCK_ABSTRACT_FOR_CHIP_FINISH      "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CHIP_FINISH for chip_finish
set BLOCK_ABSTRACT_FOR_ICV_IN_DESIGN    "$ICV_IN_DESIGN_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_ICV_IN_DESIGN label for icv_in_design
##
set USE_ABSTRACTS_FOR_POWER_ANALYSIS 	false ;# Default false; false|true;
##                                       	;# sets app option abstract.annotate_power that annotates power information in the abstracts
##                                       	;# set this to true to perform power analysis inside subblocks modeled as abstracts
##
set USE_ABSTRACTS_FOR_SIGNAL_EM_ANALYSIS false ;# Default false; false|true;
##					;# sets app option abstract.enable_signal_em_analysis 
##					;# set this to true to perform signal em analysis inside abstracts
##
set ABSTRACT_TYPE_FOR_MPH_BLOCKS "flattened" ; # "nested | flattened", Default nested. Specifies the type of abstract to be created for MPH blocks (blocks with more than 1 level of physical hierarchy)
##					;# Allowed values are nested and flattened. 
##					;# when this variable is set to nested (default), preserve_block_instances option of create_abstract command is set to true (default value)
##					;# when this variable is set to flattened , preserve_block_instances option of create_abstract command is set to false
##
set CHECK_HIER_TIMING_CONSTRAINTS_CONSISTENCY true ;# Determines whether the consistency of top and block timing constraints is checked during the check_design command
##					;# The variable in turn sets the application option abstract.check_constraints_consistency to true
##
############################################################################################ 
#### Hierarchical PNR Variables for clock_opt_cts related settings (used by clock_opt_cts.tcl)
############################################################################################
set PROMOTE_CLOCK_BALANCE_POINTS	false ;# Default false. When implementing intermediate and top levels of physical hierarchy,
##					;# set this variable to true to promote clock balance points from sub-blocks.
##					;# Leave this variable to its default value, if the needed clock balance points for the pins
##					;# inside sub-blocks are applied from the top-level itself.
##
############################################################################################ 
#### Hierarchical PNR Variables for designs where some of the blocks are bound to ETMs
############################################################################################
set WRITE_DATA_FOR_ETM_GENERATION       false ;# Default false. Set it to true, for writing out required design data for ETM Generation in PrimeTime 
set WRITE_DATA_FOR_ETM_BLOCK_NAME       $ICV_IN_DESIGN_BLOCK_NAME ;# Name of the starting block for the write_data_for_etm step
##
########################################################################################## 
## Message handling
##########################################################################################
suppress_message ATTR-11 ;# suppress the information about that design specific attribute values override over library values
#	set_message_info -id ATTR-11 -limit 1 ;# limit the message normally printed during report_lib_cells to just 1 occurence
puts "RM-info: Hostname: [sh hostname]"; puts "RM-info: Date: [date]"; puts "RM-info: PID: [pid]"; puts "RM-info: PWD: [pwd]"


source rm_utilities.tbc

puts "RM-info : Completed script [info script]\n"

