#set lib.physical_model.derive_pattern_must_join true
set_app_options -name place.common.pnet_aware_layers -value "C1"
set_app_options -name place.common.pnet_aware_density -value 0.3
set_app_options -name place.coarse.congestion_driven_max_util -value 0.4
set_app_options -name place.coarse.congestion_analysis_effort -value high
set_app_options -name place.coarse.max_density -value 0.2
set_app_options -name place.coarse.auto_density_control -value false
set_app_options -name route.common.connect_within_pins_by_layer_name -value {{M1 via_wire_standard_cell_pins}}
set_app_options -name place.fix_hard_macros -value true

#set_app_options -name ccd.max_prepone -value 0.1
#set_app_options -name ccd.max_postpone -value 0.1
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_20l.tcl
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_20sl.tcl
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_24l.tcl
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_24sl.tcl
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_28l.tcl
source /KSRC_lab_share/usr/ayassin/eda_work5/ayassin/BIGDIV_GDS_5GHz_Temp_Copy/icc2_original/scripts/user_tcls/custom_placement/custom_placement_settings_28sl.tcl

set_app_options -name design.high_fanout_net_threshold -value 65000

#set_app_options  -name route.common.post_detail_route_redundant_via_insertion -value off


#set_app_options -name route.common.concurrent_redundant_via_mode -value reserve_space
#spread_wires -pitch 1.5

;# Optional; A list of files for your placement spacing labels, spacing rules, or abutment rules
;# Example : set_placement_spacing_label -name X -side both -lib_cells [get_lib_cells -of [get_cells]]
;# Example : set_placement_spacing_rule -labels {X SNPS_BOUNDARY} {0 1}

