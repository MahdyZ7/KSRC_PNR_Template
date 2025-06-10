puts "RM-info: Running script [info script]\n"

##########################################################################################
# Script: set_lib_cell_purpose.tcl
# Version: R-2020.09-SP4
# Copyright (C) 2014-2021 Synopsys, Inc. All rights reserved.
##########################################################################################
set TCL_LIB_CELL_DONT_USE_FILE 		"../scripts/user_tcls/dont_use.tcl"
set TIE_LIB_CELL_PATTERN_LIST           "*TIE*"
set HOLD_FIX_LIB_CELL_PATTERN_LIST      "*BUF* *INV* *DLY*"

set CTS_LIB_CELL_PATTERN_LIST           ""
set CTS_ONLY_LIB_CELL_PATTERN_LIST      " *SC8T_CKBUF* *SC8T_CKINV* "
#set CTS_LIB_CELL_PATTERN_LIST      "SC8T_CKAN2I* SC8T_CKAN2X* SC8T_CKBUF* SC8T_CKGPRELAT* SC8T_CKINVX* SC8T_CKMUX2* SC8T_CKND2X* SC8T_CKNR2X* SC8T_CKOA21* SC8T_CKOR2X* SC8T_CKXOR2X*"

########################################################################
## Sample commands for general restrictions
########################################################################
suppress_message ATTR-11 ;# suppress the information about that design specific attribute values override over library values

## Excluded cells
#  Specify a file with your excluded lib cell constraints with "set_lib_cell_purpose -exclude <purpose>" commands
if {[file exists [which $TCL_LIB_CELL_DONT_USE_FILE]]} {
	puts "RM-info: Sourcing [which $TCL_LIB_CELL_DONT_USE_FILE]"
	source $TCL_LIB_CELL_DONT_USE_FILE
} elseif {$TCL_LIB_CELL_DONT_USE_FILE != ""} {
	puts "RM-error: TCL_LIB_CELL_DONT_USE_FILE($TCL_LIB_CELL_DONT_USE_FILE) is invalid. Please correct it."
}

## Tie cells 
if {$TIE_LIB_CELL_PATTERN_LIST != ""} {
	set_dont_touch [get_lib_cells $TIE_LIB_CELL_PATTERN_LIST] false
	set_lib_cell_purpose -include optimization [get_lib_cells $TIE_LIB_CELL_PATTERN_LIST]
}

## Hold time fixing cells 
if {$HOLD_FIX_LIB_CELL_PATTERN_LIST != ""} {
	set_dont_touch [get_lib_cells $HOLD_FIX_LIB_CELL_PATTERN_LIST] false
	#set_lib_cell_purpose -exclude hold [get_lib_cells */*]
	set_lib_cell_purpose -include hold [get_lib_cells $HOLD_FIX_LIB_CELL_PATTERN_LIST]
}

##########################################################################################
## Sample commands for CTS restrictions
##########################################################################################
## CTS cells (non-exclusive) 
## Please make sure to include always-on cells (for MV-CTS), clock gate cells (for sizing),
## and equivalent gates for other types of pre-existing clock cells such as muxes (for sizing).
## You should also include flops (CCD can size them for timing improvement) in the list.
## Here's an example if you want to include flops that are already available to optimization :
#	set_lib_cell_purpose -include cts [get_lib_cells */SDFF* -filter "valid_purposes=~*optimization*"]		 
if {$CTS_LIB_CELL_PATTERN_LIST != "" || $CTS_ONLY_LIB_CELL_PATTERN_LIST != ""} {
	set_lib_cell_purpose -exclude cts [get_lib_cells */*]
	set_lib_cell_purpose -include cts [get_lib_cells */* -filter "valid_purposes=~*optimization*"]		 
}

if {$CTS_LIB_CELL_PATTERN_LIST != ""} {
	set_dont_touch [get_lib_cells $CTS_LIB_CELL_PATTERN_LIST] false ;# In ICC-II, CTS respects dont_touch
	set_lib_cell_purpose -include cts [get_lib_cells $CTS_LIB_CELL_PATTERN_LIST]
} 

## CTS cells (exclusive)
## These are the lib cells to be used by CTS exclusively, such as CTS specific buffers and inverters.
## Please be aware that these cells will be applied with only cts purpose and nothing else.
## If you want to use these lib cells for other purposes, such as optimization and hold,
## specify them in CTS_LIB_CELL_PATTERN_LIST instead.
if {$CTS_ONLY_LIB_CELL_PATTERN_LIST != ""} {
	set_dont_touch [get_lib_cells $CTS_ONLY_LIB_CELL_PATTERN_LIST] false ;# In ICC-II, CTS respects dont_touch
	set_lib_cell_purpose -include none [get_lib_cells $CTS_ONLY_LIB_CELL_PATTERN_LIST]
	set_lib_cell_purpose -include cts [get_lib_cells $CTS_ONLY_LIB_CELL_PATTERN_LIST]
	set_lib_cell_purpose -exclude cts {*/SC8T_BUF* */SC8T_INV* */SC8T_DLY*}
}

puts "RM-info: Completed script [info script]\n"
