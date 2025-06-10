 remove_pg_strategies -all
 remove_routes -stripe
 remove_routes -lib_cell_pin_connect
 remove_routes -ring
 remove_routes -macro_pin_connect

### Example script.  For details please refer to the IC Compiler II Design Planning User Guide and command man pages
############################################################################################
####### UNCOMMENT THE LINES BELOW FOR DESIGN WITH MEMORY MACROS ###################
#connect_pg_net -net VDD   [get_pins  -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "name==VDD"]
#connect_pg_net -net VSS   [get_pins  -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "name==VSS"]
#connect_pg_net -net VSS [get_pins -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "name==VBN"]
#connect_pg_net -net VSS [get_pins -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "name==VBP"]
#connect_pg_net -net VDD_ARR [get_pins -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "name==VCS"]

#create_pg_region -polygon {{5.9830 546.7780} {2698.4290 726.0240}} memory_pg
################################################################################
#-------------------------------------------------------------------------------
# P G   R I N G   C R E A T I O N
#-------------------------------------------------------------------------------
################################################################################
#create_pg_ring_pattern ring_pattern -horizontal_layer QB \
#    -horizontal_width {3} -horizontal_spacing {1.5} \
#    -vertical_layer QA -vertical_width {3} \
#    -vertical_spacing {1.5} -corner_bridge false
#set_pg_strategy core_ring -core -pattern \
#    {{pattern: ring_pattern}{nets: {VDD VSS VDD_ARR VNW_N VPW_P}}{offset: {2 2}}} \
#    -extension {{stop: innermost_ring}}

#compile_pg -strategies core_ring

##################################################
########### QA VDD VSS PATTERN ##################
################################################

#create_pg_mesh_pattern pg_vdd_vss_mesh1 \
#-parameters {w p t s f} \
#-layers {{{vertical_layer: QA} {width: @w} {spacing: @s} {offset: @f}\
#{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}


#set_pg_strategy s_mesh1 \
#-pattern {{pattern: pg_vdd_vss_mesh1} {nets: { VDD VSS VDD VSS }} \
#{parameters: 4.8 61.1 false 12.3 10 }} \
#-core


#set_pg_strategy s_mesh1 \
#-pattern {{pattern: pg_vdd_vss_mesh1} {nets: { VDD VSS VDD VSS }} \
#{parameters: 4.8 70.1 false 15.3 10 }} \
#-core

# compile_pg -strategies s_mesh1

###################################################
########## QA VDD_ARR VPW_P VNW_N ################
###################################################
#
#create_pg_mesh_pattern pg_vdd_arr_mesh \
#-parameters {w p t f s1 s2 s3} \
#-layers {{{vertical_layer: QA} {width: @w} {spacing: @s1 @s2 @s1 @s2 @s1 @s3} \
#{pitch: @p} {offset: @f} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}
#
##set_pg_strategy s_mesh2 \
##-pattern {{pattern: pg_vdd_arr_mesh} {nets: { VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR }} \
##{parameters: 2.4 61.1 false 16.1 2.5 9.8 24.9 }} \
## -core
#
#set_pg_strategy s_mesh2 \
#-pattern {{pattern: pg_vdd_arr_mesh} {nets: { VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR }} \
#{parameters: 4 70.1 false 17.1 1.9 10.2 20 }} \
# -core
#
# compile_pg -strategies s_mesh2

#####################################################
############# JA VDD_ARR VPW_P VNW_N #################
#####################################################

#create_pg_mesh_pattern pg_vdd_arr_mesh2 \
#-parameters {w p t f s1 s2 s3 } \
#-layers {{{horizontal_layer: JA} {width: @w} {spacing: @s1 @s2 @s1 @s2 @s1 @s2 @s3} \
#{pitch: @p} {offset: @f} {trim: @t}}}   -via_rule {{intersection: adjacent}{via_master: default}}
#
#set_pg_strategy s_mesh4 \
#-pattern {{pattern: pg_vdd_arr_mesh2} {nets: { VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR VDD_ARR }} \
#{parameters: 1.44 49.824 false 14.993 2 8.546 21.972 }} \
#-core
#create_pg_mesh_pattern pg_vdd_arr_mesh2 \
#-parameters {w p t f s1 } \
#-layers {{{horizontal_layer: JA} {width: @w} {spacing: @s1} \
#{pitch: @p} {offset: @f} {trim: @t}}}   -via_rule {{intersection: adjacent}{via_master: default}}
#
#set_pg_strategy s_mesh4 \
#-pattern {{pattern: pg_vdd_arr_mesh2} {nets: { VDD_ARR VDD_ARR }} \
#{parameters: 1.44 26.861 false 16.713 11.986 }} \
#-core
#compile_pg -strategies s_mesh4

#######################################################
############# JA VDD VSS PATTERN ######################
#######################################################

create_pg_mesh_pattern pg_vss_mesh1 \
-parameters {w p t s f} \
-layers {{{horizontal_layer: JA} {width: @w} {spacing: @s} {offset: @f}\
{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}

set_pg_strategy s_mesh3 \
-pattern {{pattern: pg_vss_mesh1} {nets: { VDD VSS VDD VSS }} \
{parameters: 4.546 53.704 false 8.88 10 }} \
-core

#set_pg_strategy s_mesh3 \
#-pattern {{pattern: pg_vss_mesh1} {nets: { VDD VSS VDD VSS }} \
#{parameters: 4.546 84.23 false 16.846 10 }} \
#-core
#compile_pg -strategies s_mesh3

#########################################################
############ C3 VDD VSS PATTERN #########################
#########################################################

create_pg_mesh_pattern pg_vdd_vss_C3_mesh \
-parameters {w1 w2 p t s1 s2 s3 f} \
-layers {{{vertical_layer: C3} {width: @w1 @w2} {spacing: @s1 @s2 @s3} {offset: @f}\
{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}


set_pg_strategy s_mesh5 \
-pattern {{pattern: pg_vdd_vss_C3_mesh} {nets: { VDD VSS VSS }} \
{parameters: 0.68 0.68  24.75 false 6.240 2.810 18.559 13.815 }} \
-core

#compile_pg -strategies s_mesh5

#######################################################
############### C1 VPW_P VNW_N #########################
########################################################

#create_pg_mesh_pattern pg_vnw_vpw_c1_mesh \
#-parameters {w1 w2 p t s1 f} \
#-layers {{{vertical_layer: C1} {width: @w1 @w2} {spacing: @s1} {offset: @f}\
#{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}
#
#
#set_pg_strategy s_mesh6 \
#-pattern {{pattern: pg_vnw_vpw_c1_mesh} {nets: { VNW_N VPW_P }} \
#{parameters: 0.046 0.046  24.752 false 0.314 12.645 }} \
#-core 

#compile_pg -strategies s_mesh6
#{parameters: 0.046 0.046  24.787 false 0.322 8.909 }} \


#########################################################
############## C5 JA VDD_ARR ##############################
########################################################
#create_pg_mesh_pattern VDD_ARR_macro_pin_C5_mesh \
#-parameters {w1 w2 w3 p t s1 f} \
#-layers {{{vertical_layer: C5} {width: @w1 @w2 @w3} {spacing: @s1} {offset: @f}\
#{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}
#
#
#set_pg_strategy s_mesh7 \
#-pattern {{pattern: VDD_ARR_macro_pin_C5_mesh} {nets: { VDD VDD_ARR VSS }} \
#{parameters: 0.68 0.68 0.68  50 false 5 10 }} \
# -pg_region {memory_pg}
#



# create_pg_mesh_pattern VDD_ARR_macro_pin_JA_mesh \
#-parameters {w1 w2 w3 p t s1 f} \
#-layers {{{horizontal_layer: JA} {width: @w1 @w2} {spacing: @s1} {offset: @f}\
#{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}
#
#
#set_pg_strategy s_mesh8 \
#-pattern {{pattern: VDD_ARR_macro_pin_JA_mesh} {nets: { VDD VDD_ARR VSS }} \
#{parameters: 1.44 1.44 1.44  50 false 5 10 }} \
# -pg_region {memory_pg}
#################################################################################
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

#
#-blockage {{{nets: VDD} {block: u0_2 u0_3}}} \


################################################################################
#-------------------------------------------------------------------------------
# M A C R O   P G   C O N N E C T I O N S
#-------------------------------------------------------------------------------
################################################################################
#connect_pg_net -net VDD_ARR   [get_pins  -of_objects [get_cells -hierarchical -filter "design_type==macro"] -filter "port_type==power"]
#create_pg_macro_conn_pattern hm_pattern -pin_conn_type scattered_pin -layer {C2 C3}
#set toplevel_hms [filter_collection [get_cells * -physical_context] "is_hard_macro == true"]
#set_pg_strategy macro_con -macros $toplevel_hms -pattern {{name: hm_pattern} {nets: {VSS VDD_ARR}}}


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

 set haloL 3
 set haloR 3
 set haloT 3
 set haloB 3

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
{layer: C3}{direction: vertical}{width: 0.68}{channel_threshold: 1} \
{check_one_layer: true}{channel_between_objects: placement_blockage region_boundary voltage_area}}
set_pg_strategy s_channel -voltage_areas $voltage_Area  -pattern {{pattern: channelPattern} {nets: VDD VSS}}

#compile_pg -strategies s_channel

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
        {{{strategies: s_mesh5}{layers: C3}}{{strategies: rail_strat}{layers: M1}} \
                {via_master: default}} \
        {{{strategies: s_mesh3 s_mesh4 }{layers: JA}}{{strategies: s_mesh5 s_mesh6}{layers: C3}}
                {via_master: default }} \
        
        {{{strategies: s_channel}{layers C3}}{{strategies: s_mesh3}} \
                {via_master: default}} \
	{{{strategies: s_channel}}{{strategies: rail_strat}} \
                {via_master: default}} \
                {{intersection: undefined}{via_master: NIL}} \
                }

#set_pg_strategy_via_rule r2 \
#   -via_rule { \
#        {{{strategies: s_mesh5}{layers: C3}}{{strategies: rail_strat}{layers: M1}} \
#                {via_master: default}} \
#        {{{strategies: s_mesh3 s_mesh4 }{layers: JA}}{{strategies: s_mesh5 s_mesh6}{layers: C3}}
#                {via_master: VIA03_BAR_V_23_23_23_23_A1 VIA04_BAR_V_0_36_0_36_A2 VIA05_BAR_V_23_23_23_23_A3 VIA06_BAR_V_23_23_23_23_A4 #VIA07_18_72_18_72_VV_YS }} \
        
#        {{{strategies: s_channel}{layers C3}}{{strategies: s_mesh3}} \
#                {via_master: VIA03_BAR_V_23_23_23_23_A1 VIA04_BAR_V_0_36_0_36_A2 VIA05_BAR_V_23_23_23_23_A3 VIA06_BAR_V_23_23_23_23_A4 VIA07_18_72_18_72_VV_YS }} \
#	{{{strategies: s_channel}}{{strategies: rail_strat}} \
#                {via_master: default}} \
#                {{intersection: undefined}{via_master: NIL}} \
#                }


compile_pg -via_rule r2
#create_pg_vias -from_layer JA -to_layers C5 -nets { VSS VDD VDD_ARR} -via_masters VIA07_18_72_18_72_VV_YS
#create_pg_vias -from_layers QB -to_layers QA -nets {VDD VDD_ARR VSS VPW_P VNW_N}
#                                                                                                     }
####END#####
