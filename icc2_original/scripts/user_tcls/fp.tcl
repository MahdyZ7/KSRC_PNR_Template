initialize_floorplan -control_type die -core_utilization 0.5 -core_offset 5
#initialize_floorplan -control_type die -core_utilization 0.5 -core_offset 50
#initialize_floorplan -side_length {10 10} -core_offset {0.5 0.5 0.5 0.5}
set all_hm [get_cells -hierarchical  -filter "is_hard_macro==true"]
#create_keepout_margin -type hard -outer { 3 3 3 3 } $all_hm
#create_keepout_margin -type routing_blockage -layers {M1 C1}  -outer { 3 3 3 3 } $all_hm

#read_def /KSRC_lab_share/huruy/top_array2/icc2/work/macro_placement.def

#set_individual_pin_constraints -ports [get_ports *] -sides 4
set_individual_pin_constraints -ports [get_ports *]
place_pins -self
