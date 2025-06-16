#quit current sim session
quit -sim

#Design path cd {C:\Users\hani.saleh\OneDrive - ku.ac.ae\Desktop\Vivado\mul_sample_TB}

set RTL_DIR       ./.
# Create a list with multiple design file names
set fileList [list "traffic_light_controller.sv" "tb_traffic_light_controller.sv" ]


# CHANGE THIS TO YOUR TB Module name
set TB_MODULE_NAME tb_traffic_light_controller 

# set library name to uppercase of your TB name
set LIB_NAME [string toupper $TB_MODULE_NAME]

# Create teh logical library in memory
vlib $LIB_NAME

# Mab the logical library to a directory with the same name
vmap $LIB_NAME $LIB_NAME 

# Iterate over the list of files and compile them
foreach file $fileList {
    exec vlog -sv  -work $LIB_NAME  +acc  $RTL_DIR/$file
}
 

#Load the TB into simulator
vsim     -voptargs=+acc $LIB_NAME.$TB_MODULE_NAME

#############################################

#create a wave window with all signals in the design
if { [file exists "wave.do"] } {
    do wave.do
} else {
    add wave -r /*
}

#Load signals in wave window
#do wave.do

# Run the simulation
run -all
