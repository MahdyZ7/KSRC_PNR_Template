set_host_options -name distributed ...
set_app_options -name plan.macro.macro_place_only    -value true
set_editability -from_level 1 -value false
create_placement -floorplan -host_options distributed -effort medium -congestion

