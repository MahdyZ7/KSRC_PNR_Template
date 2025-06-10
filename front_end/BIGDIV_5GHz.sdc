###################################################################

# Created by write_sdc on Tue Sep  3 23:56:28 2024

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance fF -voltage V -current mA
set_operating_conditions SSG_0P72V_0P00V_0P00V_0P00V_M40C -library             \
GF22FDX_SC8T_104CPP_BASE_CSC20L_SSG_0P72V_0P00V_0P00V_0P00V_M40C
create_clock [get_ports clk]  -name CLK  -period 0.1  -waveform {0 0.05}
#set_max_delay 0.1  -from [list [get_ports reset] [get_ports clk] [get_ports VDD] [get_ports VSS]]  -to [list [get_ports #VDD] [get_ports VSS] [get_ports div4] [get_ports div8]   \
#[get_ports div9] [get_ports div12] [get_ports div80]]
set_false_path   -from [get_ports reset]
