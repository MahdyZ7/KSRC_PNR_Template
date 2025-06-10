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

 set haloL 5
 set haloR 5
 set haloT 5
 set haloB 5

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
