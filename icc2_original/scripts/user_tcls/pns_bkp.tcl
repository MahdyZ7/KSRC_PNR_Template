### Example script.  For details please refer to the IC Compiler II Design Planning User Guide and command man pages


################################################################################
#-------------------------------------------------------------------------------
# P G   R I N G   C R E A T I O N
#-------------------------------------------------------------------------------
################################################################################
create_pg_ring_pattern ring_pattern -horizontal_layer C3 \
    -horizontal_width {1} -horizontal_spacing {0.5} \
    -vertical_layer C4 -vertical_width {1} \
    -vertical_spacing {0.5} -corner_bridge false
set_pg_strategy core_ring -core -pattern \
    {{pattern: ring_pattern}{nets: {VDD VSS}}{offset: {0.5 0.5}}} \
    -extension {{stop: innermost_ring}}

################################################################################
#-------------------------------------------------------------------------------
# P A D   T O   R I N G   P G   C O N N E C T I O N S
#-------------------------------------------------------------------------------
################################################################################
#
#create_pg_macro_conn_pattern hm_pattern -pin_conn_type scattered_pin -layer {M5 M6}
#create_pg_macro_conn_pattern pad_pattern -pin_conn_type scattered_pin -layer {M5 M6}
#
#set all_pg_pads [get_cells * -hier -filter "ref_name==VDD_NS || ref_name==VSS_NS"]
#set_pg_strategy s_pad -macros $all_pg_pads  -pattern {{name: pad_pattern} {nets: {VDD VDD_LOW VSS}}}
#
#
################################################################################
#-------------------------------------------------------------------------------
# P G   M E S H   C R E A T I O N
#-------------------------------------------------------------------------------
################################################################################


create_pg_mesh_pattern pg_mesh1 \
   -parameters {w1 p1 w2 f t} \
   -layers {{{vertical_layer: C4} {width: @w1} {spacing: interleaving} \
        {pitch: @p1} {offset: @f} {trim: @t}} \
 	     {{horizontal_layer: C3} {width: @w1} {spacing: interleaving} \
        {pitch: @p1} {offset: @f} {trim: @t}}
		{{vertical_layer: C4} {width: @w2} {spacing: interleaving} \
        {pitch: @p1} {offset: @f} {trim: @t}} \
		{{horizontal_layer: C3} {width: @w2} {spacing: interleaving} \
        {pitch: @p1} {offset: @f} {trim: @t}} \
  	        {{vertical_layer: C2} {width: @w2} {spacing: interleaving} \
        {pitch: @p1} {offset: @f} {trim: @t}}} \
  -via_rule {{intersection: adjacent}{via_master: default}}


set_pg_strategy s_mesh1 \
   -pattern {{pattern: pg_mesh1} {nets: {VDD VSS }} \
{offset_start: 1 1} {parameters: 1 60 1 10 false}} \
   -core -extension {{stop: outermost_ring}}
#
#-blockage {{{nets: VDD} {block: u0_2 u0_3}}} \


################################################################################
#-------------------------------------------------------------------------------
# M A C R O   P G   C O N N E C T I O N S
#-------------------------------------------------------------------------------
################################################################################
#set toplevel_hms [filter_collection [get_cells * -physical_context] "is_hard_macro == true"]
#set_pg_strategy macro_con -macros $toplevel_hms -pattern {{name: hm_pattern} {nets: {VDD VDD_LOW VSS}}}
#
#
################################################################################
#-------------------------------------------------------------------------------
# P G   S T R I P E S   I N   N A R R O W   M A C R O   C H A N N E L           
#-------------------------------------------------------------------------------
################################################################################
set blockages_count [sizeof_collection [get_placement_blockages -quiet ]]
if {$blockages_count} {
         write_def -objects [get_placement_blockages ] placement_blockages.def                                                                                                                                                                        }
remove_placement_blockages -all

set voltage_Area DEFAULT_VA

set hardMacros [get_cells -hierarchical -filter "design_type==macro" -within [get_voltage_areas $voltage_Area] -quiet ]
append_to_collection hardMacros [get_cells -hierarchical -filter "design_type==macro" -intersect [get_voltage_areas $voltage_Area]]

foreach_in_collection hardMacros $hardMacros {
set myBox [get_attribute $hardMacros boundary_bbox]
set macroName [get_attribute $hardMacros name]

 set haloL 0.6
 set haloR 0.6
 set haloT 0.6
 set haloB 0.6

set x1 [expr [lindex [lindex $myBox 0] 0] - $haloL ]
set y1 [expr [lindex [lindex $myBox 0] 1] - $haloB ]
set x2 [expr [lindex [lindex $myBox 1] 0] + $haloR ]
set y2 [expr [lindex [lindex $myBox 1] 1] + $haloT ]

set ll [list [expr $x1] [expr $y1]]
set ur [list [expr $x2] [expr $y2]]
set rowBb [list $ll $ur]
puts "Adding Hard placement blockage :$macroName $x1:$y1-$x2:$y2"

create_placement_blockage -type hard -boundary $rowBb
        }


create_pg_special_pattern channelPattern -insert_channel_straps { \
{layer: C2}{direction: vertical}{width: 1}{channel_threshold: 1} \
{check_one_layer: true}{channel_between_objects: placement_blockage region_boundary voltage_area}}
set_pg_strategy s_channel -voltage_areas $voltage_Area  -pattern {{pattern: channelPattern} {nets: VDD VSS}}
#
#
#
#
#
##
#
################################################################################
#-------------------------------------------------------------------------------
# S T A N D A R D    C E L L    R A I L    I N S E R T I O N
#-------------------------------------------------------------------------------
################################################################################
create_pg_std_cell_conn_pattern \
    std_cell_rail  \
    -layers {M1} \
    -rail_width 0.08

set_pg_strategy rail_strat -core \
    -pattern {{name: std_cell_rail} {nets: VDD VSS} }


set_pg_strategy_via_rule r2 \
   -via_rule { \
        {{{strategies: s_mesh1}{layers: C2}}{{strategies: rail_strat}{layers: M1}} \
                {via_master: default}} \
	 {{strategies: core_ring}{strategies: s_mesh1}} \
        {{intersection: undefined}{via_master: NIL}} \
   } 

compile_pg
#compile_pg -via_rule r2
