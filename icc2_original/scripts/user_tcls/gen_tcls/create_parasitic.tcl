###########################################################################################
##This script is meant to generate a parasitic tcl file for the various RC corners provided
###########################################################################################
source unset.params
source setup.params

echo "Removing already existing parasitic tcl file"
\rm -rf $parasitic_tcl_file_name

touch $parasitic_tcl_file_name

foreach rc_corner ( $parasitic_corners_list )

	echo "Setting up $rc_corner"
	echo "#####################################################################" >> $parasitic_tcl_file_name
	echo "#Variable setting for rc corner $rc_corner" >> $parasitic_tcl_file_name
	echo "#####################################################################" >> $parasitic_tcl_file_name
	echo "set tluplus_file($rc_corner)   "\""${star_rc_parasitic_techfile_path}/${parasitic_prefix}_${rc_corner}_detailed.${parasitic_postfix}"\""" >> $parasitic_tcl_file_name
	echo "set layer_map_file($rc_corner) "\""${parasitic_layer_map_path}/${parasitic_layer_map_prefix}.${parasitic_layer_map_postfix}"\""" >> $parasitic_tcl_file_name
	echo "#####################################################################" >> $parasitic_tcl_file_name
end

echo "#####################################################################" >> $parasitic_tcl_file_name
echo "#Reading the tlu plus or nxtgrd files" >> $parasitic_tcl_file_name
echo "#####################################################################" >> $parasitic_tcl_file_name
echo "foreach p [array name tluplus_file] {" >> $parasitic_tcl_file_name
echo 'puts "RM-info: read_parasitic_tech -tlup $tluplus_file($p) -layermap $layer_map_file($p) -name $p"' >> $parasitic_tcl_file_name
echo 'read_parasitic_tech -tlup $tluplus_file($p) -layermap $layer_map_file($p) -name $p' >> $parasitic_tcl_file_name
echo "}" >> $parasitic_tcl_file_name

