# +-----------------------------------
# | Specifiy the version of hw.tcl that I am
# | 
package require -exact sopc 9.1 


# +-----------------------------------
# | module mpfe
# | 
set_module_property DESCRIPTION "External memory bandwidth sharing interface"
set_module_property NAME mpfe
set_module_property VERSION 9.1
set_module_property INTERNAL false
set_module_property AUTHOR Altera
set_module_property ICON_PATH "mpfe_icon.jpg"
set_module_property GROUP "Memories and Memory Controllers"
set_module_property DISPLAY_NAME "Multi-port Front-end"
set_module_property TOP_LEVEL_HDL_FILE mpfe_top.v
set_module_property TOP_LEVEL_HDL_MODULE mpfe_top
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file mpfe_arbiter.v {SYNTHESIS SIMULATION}
add_file mpfe_master_port.v {SYNTHESIS SIMULATION}
add_file mpfe_fifo.v {SYNTHESIS SIMULATION}
add_file mpfe_slave_port.v {SYNTHESIS SIMULATION}
add_file mpfe_debug_port.v {SYNTHESIS SIMULATION}
add_file mpfe_top.v {SYNTHESIS SIMULATION}
add_file mpfe_width_adapting_slave_port.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------


# Seems to suppress the rather ridiculous block diagram
add_display_item "" "Block Diagram" GROUP

# +-----------------------------------
# | General settings tab
# | 
add_parameter EXPOSED_SLAVE_PORTS INTEGER 8
set_parameter_property EXPOSED_SLAVE_PORTS ALLOWED_RANGES {2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}
set_parameter_property EXPOSED_SLAVE_PORTS DISPLAY_NAME "Number of slave ports required" 
set_parameter_property EXPOSED_SLAVE_PORTS AFFECTS_GENERATION false
set_parameter_property EXPOSED_SLAVE_PORTS HDL_PARAMETER false

add_parameter SLAVE_COUNT INTEGER 16
set_parameter_property SLAVE_COUNT ALLOWED_RANGES {16}
set_parameter_property SLAVE_COUNT AFFECTS_GENERATION false
set_parameter_property SLAVE_COUNT HDL_PARAMETER true
set_parameter_property SLAVE_COUNT VISIBLE false

add_parameter SLV_ADDR_WIDTH INTEGER 20
set_parameter_property SLV_ADDR_WIDTH DISPLAY_NAME "Slave address bits"
set_parameter_property SLV_ADDR_WIDTH ALLOWED_RANGES { \
"10:10 bits" \
"11:11 bits" \
"12:12 bits" \
"13:13 bits" \
"14:14 bits" \
"15:15 bits" \
"16:16 bits" \
"17:17 bits" \
"18:18 bits" \
"19:19 bits" \
"20:20 bits" \
"21:21 bits" \
"22:22 bits" \
"23:23 bits" \
"24:24 bits" \
"25:25 bits" \
"26:26 bits" \
"27:27 bits" \
"28:28 bits" \
"29:29 bits" \
"30:30 bits" \
"31:31 bits" \
"32:32 bits" \
}
set_parameter_property SLV_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property SLV_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property SLV_ADDR_WIDTH VISIBLE true
set_parameter_property SLV_ADDR_WIDTH DERIVED true

add_parameter MST_ADDR_WIDTH INTEGER 25
set_parameter_property MST_ADDR_WIDTH DISPLAY_NAME "Master address bits"
set_parameter_property MST_ADDR_WIDTH ALLOWED_RANGES { \
"15:15 bits  (32k Bytes)" \
"16:16 bits  (64k Bytes)" \
"17:17 bits (128k Bytes)" \
"18:18 bits (256k Bytes)" \
"19:19 bits (512k Bytes)" \
"20:20 bits   (1M Bytes)" \
"21:21 bits   (2M Bytes)" \
"22:22 bits   (4M Bytes)" \
"23:23 bits   (8M Bytes)" \
"24:24 bits  (16M Bytes)" \
"25:25 bits  (32M Bytes)" \
"26:26 bits  (64M Bytes)" \
"27:27 bits (128M Bytes)" \
"28:28 bits (256M Bytes)" \
"29:29 bits (512M Bytes)" \
"30:30 bits   (1G Bytes)" \
"31:31 bits   (2G Bytes)" \
"32:32 bits   (4G Bytes)" \
}
set_parameter_property MST_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property MST_ADDR_WIDTH HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 256
set_parameter_property DATA_WIDTH DISPLAY_NAME "Width of the master and slave ports"
set_parameter_property DATA_WIDTH ALLOWED_RANGES {"32: 32 bits" "64: 64 bits" "128:128 bits" "256:256 bits" "512:512 bits"}
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter NARROW_DATA_WIDTH INTEGER 32
set_parameter_property NARROW_DATA_WIDTH DISPLAY_NAME "Width of the adapting slave ports"
set_parameter_property NARROW_DATA_WIDTH ALLOWED_RANGES {"32: 32 bits      "}
set_parameter_property NARROW_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property NARROW_DATA_WIDTH HDL_PARAMETER true
set_parameter_property NARROW_DATA_WIDTH DERIVED true
add_parameter OFFSET INTEGER 3
set_parameter_property OFFSET DISPLAY_NAME OFFSET
set_parameter_property OFFSET AFFECTS_GENERATION false
set_parameter_property OFFSET HDL_PARAMETER true
set_parameter_property OFFSET VISIBLE false
set_parameter_property OFFSET DERIVED true
add_parameter BCOUNT_WIDTH INTEGER 3
set_parameter_property BCOUNT_WIDTH DISPLAY_NAME "Maximum supported burst count"
set_parameter_property BCOUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property BCOUNT_WIDTH HDL_PARAMETER true
set_parameter_property BCOUNT_WIDTH ALLOWED_RANGES { \
 "1:No burst support" \
 "2:Bursts of up to  2 " \
 "3:Bursts of up to  4 " \
 "4:Bursts of up to  8 " \
 "5:Bursts of up to 16 " \
 "6:Bursts of up to 32 " \
 "7:Bursts of up to 64 " \
}


add_parameter ENABLE_DEBUG_PORT BOOLEAN 1
set_parameter_property ENABLE_DEBUG_PORT DISPLAY_NAME "Enable debug slave port"
set_parameter_property ENABLE_DEBUG_PORT DISPLAY_HINT boolean
set_parameter_property ENABLE_DEBUG_PORT HDL_PARAMETER false

add_parameter INTERNAL_JTAGNODE INTEGER 0
set_parameter_property INTERNAL_JTAGNODE ALLOWED_RANGES {"0:External" "1:Internal (jtag)"}
set_parameter_property INTERNAL_JTAGNODE DISPLAY_NAME "Host Interface"
set_parameter_property INTERNAL_JTAGNODE AFFECTS_ELABORATION TRUE
set_parameter_property INTERNAL_JTAGNODE HDL_PARAMETER true
set_parameter_property INTERNAL_JTAGNODE AFFECTS_GENERATION false

add_parameter          MONITOR_INSTANCE_ID INTEGER 242
set_parameter_property MONITOR_INSTANCE_ID DISPLAY_NAME MONITOR_INSTANCE_ID
set_parameter_property MONITOR_INSTANCE_ID UNITS None
set_parameter_property MONITOR_INSTANCE_ID ALLOWED_RANGES 0:255
set_parameter_property MONITOR_INSTANCE_ID DISPLAY_HINT ""
set_parameter_property MONITOR_INSTANCE_ID AFFECTS_GENERATION false
set_parameter_property MONITOR_INSTANCE_ID HDL_PARAMETER true


# Create GUI
add_display_item "" "General Settings" GROUP "tab"
add_display_item "General Settings" "General" GROUP
add_display_item "General Settings" "Address Widths" GROUP
add_display_item "General Settings" "Data Widths" GROUP


add_display_item "General" EXPOSED_SLAVE_PORTS parameter
add_display_item "General" BCOUNT_WIDTH parameter
add_display_item "General" ENABLE_DEBUG_PORT parameter
add_display_item "General" INTERNAL_JTAGNODE parameter
add_display_item "General" MONITOR_INSTANCE_ID parameter
add_display_item "Address Widths" MST_ADDR_WIDTH parameter
add_display_item "Address Widths" SLV_ADDR_WIDTH parameter
add_display_item "Data Widths" DATA_WIDTH parameter
add_display_item "Data Widths" NARROW_DATA_WIDTH parameter

# | 
# +-----------------------------------


# +-----------------------------------
# | Bandwidth ratios 
# | 
# 

add_parameter SLV_0_BW_RATIO INTEGER 1
set_parameter_property SLV_0_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 0"
set_parameter_property SLV_0_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_0_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_0_BW_RATIO HDL_PARAMETER true

add_parameter SLV_1_BW_RATIO INTEGER 1
set_parameter_property SLV_1_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 1"
set_parameter_property SLV_1_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_1_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_1_BW_RATIO HDL_PARAMETER true

add_parameter SLV_2_BW_RATIO INTEGER 1
set_parameter_property SLV_2_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 2"
set_parameter_property SLV_2_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_2_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_2_BW_RATIO HDL_PARAMETER true

add_parameter SLV_3_BW_RATIO INTEGER 1
set_parameter_property SLV_3_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 3"
set_parameter_property SLV_3_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_3_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_3_BW_RATIO HDL_PARAMETER true

add_parameter SLV_4_BW_RATIO INTEGER 1
set_parameter_property SLV_4_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 4"
set_parameter_property SLV_4_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_4_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_4_BW_RATIO HDL_PARAMETER true

add_parameter SLV_5_BW_RATIO INTEGER 1
set_parameter_property SLV_5_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 5"
set_parameter_property SLV_5_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_5_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_5_BW_RATIO HDL_PARAMETER true

add_parameter SLV_6_BW_RATIO INTEGER 1
set_parameter_property SLV_6_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 6"
set_parameter_property SLV_6_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_6_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_6_BW_RATIO HDL_PARAMETER true

add_parameter SLV_7_BW_RATIO INTEGER 1
set_parameter_property SLV_7_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 7"
set_parameter_property SLV_7_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_7_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_7_BW_RATIO HDL_PARAMETER true

add_parameter SLV_8_BW_RATIO INTEGER 1
set_parameter_property SLV_8_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 8"
set_parameter_property SLV_8_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_8_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_8_BW_RATIO HDL_PARAMETER true

add_parameter SLV_9_BW_RATIO INTEGER 1
set_parameter_property SLV_9_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 9"
set_parameter_property SLV_9_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_9_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_9_BW_RATIO HDL_PARAMETER true

add_parameter SLV_10_BW_RATIO INTEGER 1
set_parameter_property SLV_10_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 10"
set_parameter_property SLV_10_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_10_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_10_BW_RATIO HDL_PARAMETER true

add_parameter SLV_11_BW_RATIO INTEGER 1
set_parameter_property SLV_11_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 11"
set_parameter_property SLV_11_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_11_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_11_BW_RATIO HDL_PARAMETER true

add_parameter SLV_12_BW_RATIO INTEGER 1
set_parameter_property SLV_12_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 12"
set_parameter_property SLV_12_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_12_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_12_BW_RATIO HDL_PARAMETER true

add_parameter SLV_13_BW_RATIO INTEGER 1
set_parameter_property SLV_13_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 13"
set_parameter_property SLV_13_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_13_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_13_BW_RATIO HDL_PARAMETER true

add_parameter SLV_14_BW_RATIO INTEGER 1
set_parameter_property SLV_14_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 14"
set_parameter_property SLV_14_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_14_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_14_BW_RATIO HDL_PARAMETER true

add_parameter SLV_15_BW_RATIO INTEGER 1
set_parameter_property SLV_15_BW_RATIO DISPLAY_NAME "Bandwidth share to allocate to slave 15"
set_parameter_property SLV_15_BW_RATIO ALLOWED_RANGES {1 2 3 4 8 16 32 64 128 256 512}
set_parameter_property SLV_15_BW_RATIO AFFECTS_GENERATION false
set_parameter_property SLV_15_BW_RATIO HDL_PARAMETER true





# Create GUI
add_display_item "" "Bandwidth Settings" GROUP "tab"

add_display_item "Bandwidth Settings" SLV_0_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_1_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_2_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_3_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_4_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_5_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_6_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_7_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_8_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_9_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_10_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_11_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_12_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_13_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_14_BW_RATIO parameter
add_display_item "Bandwidth Settings" SLV_15_BW_RATIO parameter


# +-----------------------------------
# | Time critical ports
# | 
# 

add_parameter SLV_0_CRITICAL BOOLEAN 1
set_parameter_property SLV_0_CRITICAL DISPLAY_NAME "Slave 0 is time critical"
set_parameter_property SLV_0_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_0_CRITICAL HDL_PARAMETER false

add_parameter SLV_1_CRITICAL BOOLEAN 1
set_parameter_property SLV_1_CRITICAL DISPLAY_NAME "Slave 1 is time critical"
set_parameter_property SLV_1_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_1_CRITICAL HDL_PARAMETER false

add_parameter SLV_2_CRITICAL BOOLEAN 1
set_parameter_property SLV_2_CRITICAL DISPLAY_NAME "Slave 2 is time critical"
set_parameter_property SLV_2_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_2_CRITICAL HDL_PARAMETER false

add_parameter SLV_3_CRITICAL BOOLEAN 1
set_parameter_property SLV_3_CRITICAL DISPLAY_NAME "Slave 3 is time critical"
set_parameter_property SLV_3_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_3_CRITICAL HDL_PARAMETER false

add_parameter SLV_4_CRITICAL BOOLEAN 1
set_parameter_property SLV_4_CRITICAL DISPLAY_NAME "Slave 4 is time critical"
set_parameter_property SLV_4_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_4_CRITICAL HDL_PARAMETER false

add_parameter SLV_5_CRITICAL BOOLEAN 1
set_parameter_property SLV_5_CRITICAL DISPLAY_NAME "Slave 5 is time critical"
set_parameter_property SLV_5_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_5_CRITICAL HDL_PARAMETER false

add_parameter SLV_6_CRITICAL BOOLEAN 0
set_parameter_property SLV_6_CRITICAL DISPLAY_NAME "Slave 6 (32-bit) is time critical"
set_parameter_property SLV_6_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_6_CRITICAL HDL_PARAMETER false

add_parameter SLV_7_CRITICAL BOOLEAN 0
set_parameter_property SLV_7_CRITICAL DISPLAY_NAME "Slave 7 (32-bit) is time critical"
set_parameter_property SLV_7_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_7_CRITICAL HDL_PARAMETER false

add_parameter SLV_8_CRITICAL BOOLEAN 0
set_parameter_property SLV_8_CRITICAL DISPLAY_NAME "Slave 8 is time critical"
set_parameter_property SLV_8_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_8_CRITICAL HDL_PARAMETER false

add_parameter SLV_9_CRITICAL BOOLEAN 0
set_parameter_property SLV_9_CRITICAL DISPLAY_NAME "Slave 9 is time critical"
set_parameter_property SLV_9_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_9_CRITICAL HDL_PARAMETER false

add_parameter SLV_10_CRITICAL BOOLEAN 0
set_parameter_property SLV_10_CRITICAL DISPLAY_NAME "Slave 10 is time critical"
set_parameter_property SLV_10_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_10_CRITICAL HDL_PARAMETER false

add_parameter SLV_11_CRITICAL BOOLEAN 0
set_parameter_property SLV_11_CRITICAL DISPLAY_NAME "Slave 11 is time critical"
set_parameter_property SLV_11_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_11_CRITICAL HDL_PARAMETER false

add_parameter SLV_12_CRITICAL BOOLEAN 0
set_parameter_property SLV_12_CRITICAL DISPLAY_NAME "Slave 12 is time critical"
set_parameter_property SLV_12_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_12_CRITICAL HDL_PARAMETER false

add_parameter SLV_13_CRITICAL BOOLEAN 0
set_parameter_property SLV_13_CRITICAL DISPLAY_NAME "Slave 13 is time critical"
set_parameter_property SLV_13_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_13_CRITICAL HDL_PARAMETER false

add_parameter SLV_14_CRITICAL BOOLEAN 0
set_parameter_property SLV_14_CRITICAL DISPLAY_NAME "Slave 14 is time critical"
set_parameter_property SLV_14_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_14_CRITICAL HDL_PARAMETER false

add_parameter SLV_15_CRITICAL BOOLEAN 0
set_parameter_property SLV_15_CRITICAL DISPLAY_NAME "Slave 15 is time critical"
set_parameter_property SLV_15_CRITICAL DISPLAY_HINT boolean
set_parameter_property SLV_15_CRITICAL HDL_PARAMETER false


add_parameter CRITICAL_PORTS INTEGER 65535
set_parameter_property CRITICAL_PORTS DISPLAY_NAME "Which ports are critical"
set_parameter_property CRITICAL_PORTS AFFECTS_GENERATION false
set_parameter_property CRITICAL_PORTS HDL_PARAMETER true
set_parameter_property CRITICAL_PORTS VISIBLE false
set_parameter_property CRITICAL_PORTS DERIVED true


# Create time-critical ports tab
add_display_item "" "Critical Ports" GROUP "tab"

add_display_item "Critical Ports" SLV_0_CRITICAL parameter 
add_display_item "Critical Ports" SLV_1_CRITICAL parameter 
add_display_item "Critical Ports" SLV_2_CRITICAL parameter 
add_display_item "Critical Ports" SLV_3_CRITICAL parameter 
add_display_item "Critical Ports" SLV_4_CRITICAL parameter 
add_display_item "Critical Ports" SLV_5_CRITICAL parameter 
add_display_item "Critical Ports" SLV_6_CRITICAL parameter 
add_display_item "Critical Ports" SLV_7_CRITICAL parameter 
add_display_item "Critical Ports" SLV_8_CRITICAL parameter 
add_display_item "Critical Ports" SLV_9_CRITICAL parameter 
add_display_item "Critical Ports" SLV_10_CRITICAL parameter 
add_display_item "Critical Ports" SLV_11_CRITICAL parameter 
add_display_item "Critical Ports" SLV_12_CRITICAL parameter 
add_display_item "Critical Ports" SLV_13_CRITICAL parameter 
add_display_item "Critical Ports" SLV_14_CRITICAL parameter 
add_display_item "Critical Ports" SLV_15_CRITICAL parameter 



# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end
set_interface_property clock_reset ptfSchematicName ""

set_interface_property clock_reset ENABLED true

add_interface_port clock_reset clk clk Input 1
add_interface_port clock_reset reset_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point slv_0
# | 
add_interface slv_0 avalon end
set_interface_property slv_0 addressAlignment DYNAMIC
set_interface_property slv_0 bridgesToMaster "avalon_master"
set_interface_property slv_0 burstOnBurstBoundariesOnly false
set_interface_property slv_0 holdTime 0
set_interface_property slv_0 isMemoryDevice false
set_interface_property slv_0 isNonVolatileStorage false
set_interface_property slv_0 linewrapBursts false
set_interface_property slv_0 maximumPendingReadTransactions 4
set_interface_property slv_0 printableDevice false
set_interface_property slv_0 readLatency 0
set_interface_property slv_0 readWaitTime 1
set_interface_property slv_0 setupTime 0
set_interface_property slv_0 timingUnits Cycles
set_interface_property slv_0 writeWaitTime 0

set_interface_property slv_0 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point slv_1
# | 
add_interface slv_1 avalon end
set_interface_property slv_1 addressAlignment DYNAMIC
set_interface_property slv_1 bridgesToMaster "avalon_master"
set_interface_property slv_1 burstOnBurstBoundariesOnly false
set_interface_property slv_1 holdTime 0
set_interface_property slv_1 isMemoryDevice false
set_interface_property slv_1 isNonVolatileStorage false
set_interface_property slv_1 linewrapBursts false
set_interface_property slv_1 maximumPendingReadTransactions 4
set_interface_property slv_1 printableDevice false
set_interface_property slv_1 readLatency 0
set_interface_property slv_1 readWaitTime 1
set_interface_property slv_1 setupTime 0
set_interface_property slv_1 timingUnits Cycles
set_interface_property slv_1 writeWaitTime 0

set_interface_property slv_1 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point slv_2
# | 
add_interface slv_2 avalon end
set_interface_property slv_2 addressAlignment DYNAMIC
set_interface_property slv_2 bridgesToMaster "avalon_master"
set_interface_property slv_2 burstOnBurstBoundariesOnly false
set_interface_property slv_2 holdTime 0
set_interface_property slv_2 isMemoryDevice false
set_interface_property slv_2 isNonVolatileStorage false
set_interface_property slv_2 linewrapBursts false
set_interface_property slv_2 maximumPendingReadTransactions 4
set_interface_property slv_2 printableDevice false
set_interface_property slv_2 readLatency 0
set_interface_property slv_2 readWaitTime 1
set_interface_property slv_2 setupTime 0
set_interface_property slv_2 timingUnits Cycles
set_interface_property slv_2 writeWaitTime 0

set_interface_property slv_2 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_3
# | 
add_interface slv_3 avalon end
set_interface_property slv_3 addressAlignment DYNAMIC
set_interface_property slv_3 bridgesToMaster "avalon_master"
set_interface_property slv_3 burstOnBurstBoundariesOnly false
set_interface_property slv_3 holdTime 0
set_interface_property slv_3 isMemoryDevice false
set_interface_property slv_3 isNonVolatileStorage false
set_interface_property slv_3 linewrapBursts false
set_interface_property slv_3 maximumPendingReadTransactions 4
set_interface_property slv_3 printableDevice false
set_interface_property slv_3 readLatency 0
set_interface_property slv_3 readWaitTime 1
set_interface_property slv_3 setupTime 0
set_interface_property slv_3 timingUnits Cycles
set_interface_property slv_3 writeWaitTime 0

set_interface_property slv_3 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------



# +-----------------------------------
# | connection point slv_4
# | 
add_interface slv_4 avalon end
set_interface_property slv_4 addressAlignment DYNAMIC
set_interface_property slv_4 bridgesToMaster "avalon_master"
set_interface_property slv_4 burstOnBurstBoundariesOnly false
set_interface_property slv_4 holdTime 0
set_interface_property slv_4 isMemoryDevice false
set_interface_property slv_4 isNonVolatileStorage false
set_interface_property slv_4 linewrapBursts false
set_interface_property slv_4 maximumPendingReadTransactions 4
set_interface_property slv_4 printableDevice false
set_interface_property slv_4 readLatency 0
set_interface_property slv_4 readWaitTime 1
set_interface_property slv_4 setupTime 0
set_interface_property slv_4 timingUnits Cycles
set_interface_property slv_4 writeWaitTime 0

set_interface_property slv_4 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_5
# | 
add_interface slv_5 avalon end
set_interface_property slv_5 addressAlignment DYNAMIC
set_interface_property slv_5 bridgesToMaster "avalon_master"
set_interface_property slv_5 burstOnBurstBoundariesOnly false
set_interface_property slv_5 holdTime 0
set_interface_property slv_5 isMemoryDevice false
set_interface_property slv_5 isNonVolatileStorage false
set_interface_property slv_5 linewrapBursts false
set_interface_property slv_5 maximumPendingReadTransactions 4
set_interface_property slv_5 printableDevice false
set_interface_property slv_5 readLatency 0
set_interface_property slv_5 readWaitTime 1
set_interface_property slv_5 setupTime 0
set_interface_property slv_5 timingUnits Cycles
set_interface_property slv_5 writeWaitTime 0

set_interface_property slv_5 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------



# +-----------------------------------
# | connection point slv_6
# | 
add_interface slv_6 avalon end
set_interface_property slv_6 addressAlignment DYNAMIC
set_interface_property slv_6 bridgesToMaster "avalon_master"
set_interface_property slv_6 burstOnBurstBoundariesOnly false
set_interface_property slv_6 holdTime 0
set_interface_property slv_6 isMemoryDevice false
set_interface_property slv_6 isNonVolatileStorage false
set_interface_property slv_6 linewrapBursts false
set_interface_property slv_6 maximumPendingReadTransactions 4
set_interface_property slv_6 printableDevice false
set_interface_property slv_6 readLatency 0
set_interface_property slv_6 readWaitTime 1
set_interface_property slv_6 setupTime 0
set_interface_property slv_6 timingUnits Cycles
set_interface_property slv_6 writeWaitTime 0

set_interface_property slv_6 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------



# +-----------------------------------
# | connection point slv_7
# | 
add_interface slv_7 avalon end
set_interface_property slv_7 addressAlignment DYNAMIC
set_interface_property slv_7 bridgesToMaster "avalon_master"
set_interface_property slv_7 burstOnBurstBoundariesOnly false
set_interface_property slv_7 holdTime 0
set_interface_property slv_7 isMemoryDevice false
set_interface_property slv_7 isNonVolatileStorage false
set_interface_property slv_7 linewrapBursts false
set_interface_property slv_7 maximumPendingReadTransactions 4
set_interface_property slv_7 printableDevice false
set_interface_property slv_7 readLatency 0
set_interface_property slv_7 readWaitTime 1
set_interface_property slv_7 setupTime 0
set_interface_property slv_7 timingUnits Cycles
set_interface_property slv_7 writeWaitTime 0

set_interface_property slv_7 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------



# +-----------------------------------
# | connection point slv_8
# | 
add_interface slv_8 avalon end
set_interface_property slv_8 addressAlignment DYNAMIC
set_interface_property slv_8 bridgesToMaster "avalon_master"
set_interface_property slv_8 burstOnBurstBoundariesOnly false
set_interface_property slv_8 holdTime 0
set_interface_property slv_8 isMemoryDevice false
set_interface_property slv_8 isNonVolatileStorage false
set_interface_property slv_8 linewrapBursts false
set_interface_property slv_8 maximumPendingReadTransactions 4
set_interface_property slv_8 printableDevice false
set_interface_property slv_8 readLatency 0
set_interface_property slv_8 readWaitTime 1
set_interface_property slv_8 setupTime 0
set_interface_property slv_8 timingUnits Cycles
set_interface_property slv_8 writeWaitTime 0

set_interface_property slv_8 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------




# +-----------------------------------
# | connection point slv_9
# | 
add_interface slv_9 avalon end
set_interface_property slv_9 addressAlignment DYNAMIC
set_interface_property slv_9 bridgesToMaster "avalon_master"
set_interface_property slv_9 burstOnBurstBoundariesOnly false
set_interface_property slv_9 holdTime 0
set_interface_property slv_9 isMemoryDevice false
set_interface_property slv_9 isNonVolatileStorage false
set_interface_property slv_9 linewrapBursts false
set_interface_property slv_9 maximumPendingReadTransactions 4
set_interface_property slv_9 printableDevice false
set_interface_property slv_9 readLatency 0
set_interface_property slv_9 readWaitTime 1
set_interface_property slv_9 setupTime 0
set_interface_property slv_9 timingUnits Cycles
set_interface_property slv_9 writeWaitTime 0

set_interface_property slv_9 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_10
# | 
add_interface slv_10 avalon end
set_interface_property slv_10 addressAlignment DYNAMIC
set_interface_property slv_10 bridgesToMaster "avalon_master"
set_interface_property slv_10 burstOnBurstBoundariesOnly false
set_interface_property slv_10 holdTime 0
set_interface_property slv_10 isMemoryDevice false
set_interface_property slv_10 isNonVolatileStorage false
set_interface_property slv_10 linewrapBursts false
set_interface_property slv_10 maximumPendingReadTransactions 4
set_interface_property slv_10 printableDevice false
set_interface_property slv_10 readLatency 0
set_interface_property slv_10 readWaitTime 1
set_interface_property slv_10 setupTime 0
set_interface_property slv_10 timingUnits Cycles
set_interface_property slv_10 writeWaitTime 0

set_interface_property slv_10 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_11
# | 
add_interface slv_11 avalon end
set_interface_property slv_11 addressAlignment DYNAMIC
set_interface_property slv_11 bridgesToMaster "avalon_master"
set_interface_property slv_11 burstOnBurstBoundariesOnly false
set_interface_property slv_11 holdTime 0
set_interface_property slv_11 isMemoryDevice false
set_interface_property slv_11 isNonVolatileStorage false
set_interface_property slv_11 linewrapBursts false
set_interface_property slv_11 maximumPendingReadTransactions 4
set_interface_property slv_11 printableDevice false
set_interface_property slv_11 readLatency 0
set_interface_property slv_11 readWaitTime 1
set_interface_property slv_11 setupTime 0
set_interface_property slv_11 timingUnits Cycles
set_interface_property slv_11 writeWaitTime 0

set_interface_property slv_11 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_12
# | 
add_interface slv_12 avalon end
set_interface_property slv_12 addressAlignment DYNAMIC
set_interface_property slv_12 bridgesToMaster "avalon_master"
set_interface_property slv_12 burstOnBurstBoundariesOnly false
set_interface_property slv_12 holdTime 0
set_interface_property slv_12 isMemoryDevice false
set_interface_property slv_12 isNonVolatileStorage false
set_interface_property slv_12 linewrapBursts false
set_interface_property slv_12 maximumPendingReadTransactions 4
set_interface_property slv_12 printableDevice false
set_interface_property slv_12 readLatency 0
set_interface_property slv_12 readWaitTime 1
set_interface_property slv_12 setupTime 0
set_interface_property slv_12 timingUnits Cycles
set_interface_property slv_12 writeWaitTime 0

set_interface_property slv_12 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_13
# | 
add_interface slv_13 avalon end
set_interface_property slv_13 addressAlignment DYNAMIC
set_interface_property slv_13 bridgesToMaster "avalon_master"
set_interface_property slv_13 burstOnBurstBoundariesOnly false
set_interface_property slv_13 holdTime 0
set_interface_property slv_13 isMemoryDevice false
set_interface_property slv_13 isNonVolatileStorage false
set_interface_property slv_13 linewrapBursts false
set_interface_property slv_13 maximumPendingReadTransactions 4
set_interface_property slv_13 printableDevice false
set_interface_property slv_13 readLatency 0
set_interface_property slv_13 readWaitTime 1
set_interface_property slv_13 setupTime 0
set_interface_property slv_13 timingUnits Cycles
set_interface_property slv_13 writeWaitTime 0

set_interface_property slv_13 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_14
# | 
add_interface slv_14 avalon end
set_interface_property slv_14 addressAlignment DYNAMIC
set_interface_property slv_14 bridgesToMaster "avalon_master"
set_interface_property slv_14 burstOnBurstBoundariesOnly false
set_interface_property slv_14 holdTime 0
set_interface_property slv_14 isMemoryDevice false
set_interface_property slv_14 isNonVolatileStorage false
set_interface_property slv_14 linewrapBursts false
set_interface_property slv_14 maximumPendingReadTransactions 4
set_interface_property slv_14 printableDevice false
set_interface_property slv_14 readLatency 0
set_interface_property slv_14 readWaitTime 1
set_interface_property slv_14 setupTime 0
set_interface_property slv_14 timingUnits Cycles
set_interface_property slv_14 writeWaitTime 0

set_interface_property slv_14 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point slv_15
# | 
add_interface slv_15 avalon end
set_interface_property slv_15 addressAlignment DYNAMIC
set_interface_property slv_15 bridgesToMaster "avalon_master"
set_interface_property slv_15 burstOnBurstBoundariesOnly false
set_interface_property slv_15 holdTime 0
set_interface_property slv_15 isMemoryDevice false
set_interface_property slv_15 isNonVolatileStorage false
set_interface_property slv_15 linewrapBursts false
set_interface_property slv_15 maximumPendingReadTransactions 4
set_interface_property slv_15 printableDevice false
set_interface_property slv_15 readLatency 0
set_interface_property slv_15 readWaitTime 1
set_interface_property slv_15 setupTime 0
set_interface_property slv_15 timingUnits Cycles
set_interface_property slv_15 writeWaitTime 0

set_interface_property slv_15 ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point debug_slv
# | 
add_interface debug_slv avalon end
set_interface_property debug_slv addressAlignment DYNAMIC
set_interface_property debug_slv associatedClock clock_reset
set_interface_property debug_slv burstOnBurstBoundariesOnly false
set_interface_property debug_slv explicitAddressSpan 0
set_interface_property debug_slv holdTime 0
set_interface_property debug_slv isMemoryDevice false
set_interface_property debug_slv isNonVolatileStorage false
set_interface_property debug_slv linewrapBursts false
set_interface_property debug_slv maximumPendingReadTransactions 1
set_interface_property debug_slv printableDevice false
set_interface_property debug_slv readLatency 0
set_interface_property debug_slv readWaitStates 0
set_interface_property debug_slv readWaitTime 0
set_interface_property debug_slv setupTime 0
set_interface_property debug_slv timingUnits Cycles
set_interface_property debug_slv writeWaitTime 0

set_interface_property debug_slv ASSOCIATED_CLOCK clock_reset

# | 
# +-----------------------------------


# +-----------------------------------
# | connection point avalon_master
# | 
add_interface avalon_master avalon start
set_interface_property avalon_master adaptsTo ""
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master linewrapBursts false

set_interface_property avalon_master ASSOCIATED_CLOCK clock_reset
set_interface_property avalon_master ENABLED true

add_interface_port avalon_master mst_write_req write Output 1
add_interface_port avalon_master mst_wdata writedata Output -1
add_interface_port avalon_master mst_waitrequest waitrequest Input 1
add_interface_port avalon_master mst_read_req read Output 1
add_interface_port avalon_master mst_rdata_valid readdatavalid Input 1
add_interface_port avalon_master mst_rdata readdata Input -1
add_interface_port avalon_master mst_byteenable byteenable Output -1
add_interface_port avalon_master mst_burst_count burstcount Output -1
# add_interface_port avalon_master mst_burst_begin arbiterlock Output 1
add_interface_port avalon_master mst_addr address Output -1
# | 
# +-----------------------------------

proc log_2 x "expr {log(\$x)/[expr log(2)]}"
 
# Declare the validation callback.
set_module_property VALIDATION_CALLBACK my_validation_callback

# The validation callback
proc my_validation_callback {} {
    
    # calculate width of slave address bus (which is not byte addressed) 
    set master_addr_bits [get_parameter_value MST_ADDR_WIDTH]
    # set slave_addr_bits [get_parameter_value SLV_ADDR_WIDTH]
    set data_bits [get_parameter_value DATA_WIDTH]
    set_parameter_value SLV_ADDR_WIDTH [expr $master_addr_bits - int([log_2 [expr $data_bits/8 ]])]
    
    # difference in width between the narrow and wide slave ports - fixed at 2^3 for now
    set_parameter_value OFFSET 3
    
    #Work out CRITICAL_PORTS parameter
    set cp0 [expr [expr {[get_parameter_value SLV_0_CRITICAL] == "true"}] << 0] 
    set cp1 [expr [expr {[get_parameter_value SLV_1_CRITICAL] == "true"}] << 1] 
    set cp2 [expr [expr {[get_parameter_value SLV_2_CRITICAL] == "true"}] << 2] 
    set cp3 [expr [expr {[get_parameter_value SLV_3_CRITICAL] == "true"}] << 3] 
    set cp4 [expr [expr {[get_parameter_value SLV_4_CRITICAL] == "true"}] << 4] 
    set cp5 [expr [expr {[get_parameter_value SLV_5_CRITICAL] == "true"}] << 5] 
    set cp6 [expr [expr {[get_parameter_value SLV_6_CRITICAL] == "true"}] << 6] 
    set cp7 [expr [expr {[get_parameter_value SLV_7_CRITICAL] == "true"}] << 7] 
    set cp8 [expr [expr {[get_parameter_value SLV_8_CRITICAL] == "true"}] << 8] 
    set cp9 [expr [expr {[get_parameter_value SLV_9_CRITICAL] == "true"}] << 9] 
    set cp10 [expr [expr {[get_parameter_value SLV_10_CRITICAL] == "true"}] << 10] 
    set cp11 [expr [expr {[get_parameter_value SLV_11_CRITICAL] == "true"}] << 11] 
    set cp12 [expr [expr {[get_parameter_value SLV_12_CRITICAL] == "true"}] << 12] 
    set cp13 [expr [expr {[get_parameter_value SLV_13_CRITICAL] == "true"}] << 13] 
    set cp14 [expr [expr {[get_parameter_value SLV_14_CRITICAL] == "true"}] << 14] 
    set cp15 [expr [expr {[get_parameter_value SLV_15_CRITICAL] == "true"}] << 15] 
    
    set_parameter_value CRITICAL_PORTS [expr $cp0 + $cp1 + $cp2 + $cp3 + $cp4 + $cp5 + $cp6 + $cp7 + $cp8 + $cp9 + $cp10 + $cp11 + $cp12 + $cp13 + $cp14 + $cp15]

    set enable_debug [get_parameter_value ENABLE_DEBUG_PORT]
    if {$enable_debug} {
      set_parameter_property INTERNAL_JTAGNODE ENABLED TRUE
    } else {
      set_parameter_property INTERNAL_JTAGNODE ENABLED FALSE
    }

    set internal_jtagnode [get_parameter_value INTERNAL_JTAGNODE]
    if {$enable_debug} {
        if {$internal_jtagnode == 1} {
            set_parameter_property MONITOR_INSTANCE_ID ENABLED TRUE
        } else {
            set_parameter_property MONITOR_INSTANCE_ID ENABLED FALSE
        }
    } else {
        set_parameter_property MONITOR_INSTANCE_ID ENABLED FALSE
    }

   
}


# declare the callback
set_module_property ELABORATION_CALLBACK my_elaboration_callback

proc my_elaboration_callback {} {

    set num_slaves [get_parameter_value EXPOSED_SLAVE_PORTS ]
    
    set slave_addr_bits  [get_parameter_value SLV_ADDR_WIDTH ]
    set master_addr_bits [get_parameter_value MST_ADDR_WIDTH ]
    set data_bits        [get_parameter_value DATA_WIDTH ]
    set narrow_data_bits [get_parameter_value NARROW_DATA_WIDTH ]
    set offset           [get_parameter_value OFFSET ]
    set burstcount_bits  [get_parameter_value BCOUNT_WIDTH ]
    set byteenables      [expr ${data_bits}/8]
    set narrow_byteen    [expr ${narrow_data_bits}/8]
    
    # set slave_mb [expr (2**$master_addr_bits)/(2**20)]
    set slave_mb [expr (2<<($master_addr_bits-1))/(2<<19)]
    send_message info "Creating $num_slaves slave interfaces to share access to a ${slave_mb}MB slave."
    # send_message info "MPFE: I've got $slave_addr_bits slave_addr_bits, $master_addr_bits master_addr_bits, $data_bits data_bits, $narrow_data_bits narrow_data_bits."
    # send_message info "MPFE: I've got $offset offset, $burstcount_bits burstcount_bits, $byteenables byteenables, $narrow_byteen narrow_byteen."
    
    
    set_port_property mst_byteenable     WIDTH $byteenables
    set_port_property mst_wdata          WIDTH $data_bits
    set_port_property mst_rdata          WIDTH $data_bits
    set_port_property mst_burst_count    WIDTH $burstcount_bits
    set_port_property mst_addr           WIDTH $master_addr_bits   
    
    
    set_interface_property slv_0 enabled false;      set_parameter_property SLV_0_CRITICAL ENABLED false;   set_parameter_property SLV_0_BW_RATIO ENABLED false;
    set_interface_property slv_1 enabled false;      set_parameter_property SLV_1_CRITICAL ENABLED false;   set_parameter_property SLV_1_BW_RATIO ENABLED false;
    set_interface_property slv_2 enabled false;      set_parameter_property SLV_2_CRITICAL ENABLED false;   set_parameter_property SLV_2_BW_RATIO ENABLED false;
    set_interface_property slv_3 enabled false;      set_parameter_property SLV_3_CRITICAL ENABLED false;   set_parameter_property SLV_3_BW_RATIO ENABLED false;
    set_interface_property slv_4 enabled false;      set_parameter_property SLV_4_CRITICAL ENABLED false;   set_parameter_property SLV_4_BW_RATIO ENABLED false;
    set_interface_property slv_5 enabled false;      set_parameter_property SLV_5_CRITICAL ENABLED false;   set_parameter_property SLV_5_BW_RATIO ENABLED false;
    set_interface_property slv_6 enabled false;      set_parameter_property SLV_6_CRITICAL ENABLED false;   set_parameter_property SLV_6_BW_RATIO ENABLED false;
    set_interface_property slv_7 enabled false;      set_parameter_property SLV_7_CRITICAL ENABLED false;   set_parameter_property SLV_7_BW_RATIO ENABLED false;
    set_interface_property slv_8 enabled false;      set_parameter_property SLV_8_CRITICAL ENABLED false;   set_parameter_property SLV_8_BW_RATIO ENABLED false;
    set_interface_property slv_9 enabled false;      set_parameter_property SLV_9_CRITICAL ENABLED false;   set_parameter_property SLV_9_BW_RATIO ENABLED false;
    set_interface_property slv_10 enabled false;     set_parameter_property SLV_10_CRITICAL ENABLED false;  set_parameter_property SLV_10_BW_RATIO ENABLED false;
    set_interface_property slv_11 enabled false;     set_parameter_property SLV_11_CRITICAL ENABLED false;  set_parameter_property SLV_11_BW_RATIO ENABLED false;
    set_interface_property slv_12 enabled false;     set_parameter_property SLV_12_CRITICAL ENABLED false;  set_parameter_property SLV_12_BW_RATIO ENABLED false;
    set_interface_property slv_13 enabled false;     set_parameter_property SLV_13_CRITICAL ENABLED false;  set_parameter_property SLV_13_BW_RATIO ENABLED false;
    set_interface_property slv_14 enabled false;     set_parameter_property SLV_14_CRITICAL ENABLED false;  set_parameter_property SLV_14_BW_RATIO ENABLED false;
    set_interface_property slv_15 enabled false;     set_parameter_property SLV_15_CRITICAL ENABLED false;  set_parameter_property SLV_15_BW_RATIO ENABLED false;
    
    if {($num_slaves >= 1)} {
        set_interface_property slv_0 ENABLED true
        set_parameter_property SLV_0_CRITICAL ENABLED true
        set_parameter_property SLV_0_BW_RATIO ENABLED true
        
        add_interface_port slv_0 slv_0_write_req write Input 1
        add_interface_port slv_0 slv_0_read_req read Input 1
        add_interface_port slv_0 slv_0_byteenable byteenable Input -1
        add_interface_port slv_0 slv_0_waitrequest waitrequest Output 1
        add_interface_port slv_0 slv_0_wdata writedata Input -1
        add_interface_port slv_0 slv_0_rdata_valid readdatavalid Output 1
        add_interface_port slv_0 slv_0_rdata readdata Output -1
        add_interface_port slv_0 slv_0_burst_count burstcount Input -1
        add_interface_port slv_0 slv_0_burst_begin beginbursttransfer Input 1
        add_interface_port slv_0 slv_0_addr address Input -1
        
        set_port_property slv_0_byteenable   WIDTH $byteenables
        set_port_property slv_0_wdata        WIDTH $data_bits
        set_port_property slv_0_rdata        WIDTH $data_bits
        set_port_property slv_0_burst_count  WIDTH $burstcount_bits
        set_port_property slv_0_addr         WIDTH $slave_addr_bits    
    }
    if {($num_slaves >= 2)} {
        set_interface_property slv_1 ENABLED true
        set_parameter_property SLV_1_CRITICAL ENABLED true
        set_parameter_property SLV_1_BW_RATIO ENABLED true
        
        add_interface_port slv_1 slv_1_write_req write Input 1
        add_interface_port slv_1 slv_1_read_req read Input 1
        add_interface_port slv_1 slv_1_byteenable byteenable Input -1
        add_interface_port slv_1 slv_1_waitrequest waitrequest Output 1
        add_interface_port slv_1 slv_1_wdata writedata Input -1
        add_interface_port slv_1 slv_1_rdata_valid readdatavalid Output 1
        add_interface_port slv_1 slv_1_rdata readdata Output -1
        add_interface_port slv_1 slv_1_burst_count burstcount Input -1
        add_interface_port slv_1 slv_1_burst_begin beginbursttransfer Input 1
        add_interface_port slv_1 slv_1_addr address Input -1

        set_port_property slv_1_byteenable   WIDTH $byteenables
        set_port_property slv_1_wdata        WIDTH $data_bits
        set_port_property slv_1_rdata        WIDTH $data_bits
        set_port_property slv_1_burst_count  WIDTH $burstcount_bits
        set_port_property slv_1_addr         WIDTH $slave_addr_bits          
    }
    if {($num_slaves >= 3)} {
        set_interface_property slv_2 ENABLED true
        set_parameter_property SLV_2_CRITICAL ENABLED true
        set_parameter_property SLV_2_BW_RATIO ENABLED true

        add_interface_port slv_2 slv_2_write_req write Input 1
        add_interface_port slv_2 slv_2_read_req read Input 1
        add_interface_port slv_2 slv_2_byteenable byteenable Input -1
        add_interface_port slv_2 slv_2_waitrequest waitrequest Output 1
        add_interface_port slv_2 slv_2_wdata writedata Input -1
        add_interface_port slv_2 slv_2_rdata_valid readdatavalid Output 1
        add_interface_port slv_2 slv_2_rdata readdata Output -1
        add_interface_port slv_2 slv_2_burst_count burstcount Input -1
        add_interface_port slv_2 slv_2_burst_begin beginbursttransfer Input 1
        add_interface_port slv_2 slv_2_addr address Input -1
        
        set_port_property slv_2_byteenable   WIDTH $byteenables
        set_port_property slv_2_wdata        WIDTH $data_bits
        set_port_property slv_2_rdata        WIDTH $data_bits
        set_port_property slv_2_burst_count  WIDTH $burstcount_bits
        set_port_property slv_2_addr         WIDTH $slave_addr_bits       
    } 
    if {($num_slaves >= 4)} {
        set_interface_property slv_3 ENABLED true
        set_parameter_property SLV_3_CRITICAL ENABLED true
        set_parameter_property SLV_3_BW_RATIO ENABLED true
        
        add_interface_port slv_3 slv_3_write_req write Input 1
        add_interface_port slv_3 slv_3_read_req read Input 1
        add_interface_port slv_3 slv_3_byteenable byteenable Input -1
        add_interface_port slv_3 slv_3_waitrequest waitrequest Output 1
        add_interface_port slv_3 slv_3_wdata writedata Input -1
        add_interface_port slv_3 slv_3_rdata_valid readdatavalid Output 1
        add_interface_port slv_3 slv_3_rdata readdata Output -1
        add_interface_port slv_3 slv_3_burst_count burstcount Input -1
        add_interface_port slv_3 slv_3_burst_begin beginbursttransfer Input 1
        add_interface_port slv_3 slv_3_addr address Input -1    

        set_port_property slv_3_byteenable   WIDTH $byteenables
        set_port_property slv_3_wdata        WIDTH $data_bits
        set_port_property slv_3_rdata        WIDTH $data_bits
        set_port_property slv_3_burst_count  WIDTH $burstcount_bits
        set_port_property slv_3_addr         WIDTH $slave_addr_bits  

    }
    if {($num_slaves >= 5)} {
        set_interface_property slv_4 ENABLED true
        set_parameter_property SLV_4_CRITICAL ENABLED true
        set_parameter_property SLV_4_BW_RATIO ENABLED true
        
        add_interface_port slv_4 slv_4_write_req write Input 1
        add_interface_port slv_4 slv_4_read_req read Input 1
        add_interface_port slv_4 slv_4_byteenable byteenable Input -1
        add_interface_port slv_4 slv_4_waitrequest waitrequest Output 1
        add_interface_port slv_4 slv_4_wdata writedata Input -1
        add_interface_port slv_4 slv_4_rdata_valid readdatavalid Output 1
        add_interface_port slv_4 slv_4_rdata readdata Output -1
        add_interface_port slv_4 slv_4_burst_count burstcount Input -1
        add_interface_port slv_4 slv_4_burst_begin beginbursttransfer Input 1
        add_interface_port slv_4 slv_4_addr address Input -1    

        set_port_property slv_4_byteenable   WIDTH $byteenables
        set_port_property slv_4_wdata        WIDTH $data_bits
        set_port_property slv_4_rdata        WIDTH $data_bits
        set_port_property slv_4_burst_count  WIDTH $burstcount_bits
        set_port_property slv_4_addr         WIDTH $slave_addr_bits  
    }
    if {($num_slaves >= 6)} {
        set_interface_property slv_5 ENABLED true
        set_parameter_property SLV_5_CRITICAL ENABLED true
        set_parameter_property SLV_5_BW_RATIO ENABLED true
        
        add_interface_port slv_5 slv_5_write_req write Input 1
        add_interface_port slv_5 slv_5_read_req read Input 1
        add_interface_port slv_5 slv_5_byteenable byteenable Input -1
        add_interface_port slv_5 slv_5_waitrequest waitrequest Output 1
        add_interface_port slv_5 slv_5_wdata writedata Input -1
        add_interface_port slv_5 slv_5_rdata_valid readdatavalid Output 1
        add_interface_port slv_5 slv_5_rdata readdata Output -1
        add_interface_port slv_5 slv_5_burst_count burstcount Input -1
        add_interface_port slv_5 slv_5_burst_begin beginbursttransfer Input 1
        add_interface_port slv_5 slv_5_addr address Input -1    

        set_port_property slv_5_byteenable   WIDTH $byteenables
        set_port_property slv_5_wdata        WIDTH $data_bits
        set_port_property slv_5_rdata        WIDTH $data_bits
        set_port_property slv_5_burst_count  WIDTH $burstcount_bits
        set_port_property slv_5_addr         WIDTH $slave_addr_bits  
    }
    if {($num_slaves >= 7)} {
        set_interface_property slv_6 ENABLED true
        set_parameter_property SLV_6_CRITICAL ENABLED true
        set_parameter_property SLV_6_BW_RATIO ENABLED true
        
        add_interface_port slv_6 slv_6_write_req write Input 1
        add_interface_port slv_6 slv_6_read_req read Input 1
        add_interface_port slv_6 slv_6_byteenable byteenable Input -1
        add_interface_port slv_6 slv_6_waitrequest waitrequest Output 1
        add_interface_port slv_6 slv_6_wdata writedata Input -1
        add_interface_port slv_6 slv_6_rdata_valid readdatavalid Output 1
        add_interface_port slv_6 slv_6_rdata readdata Output -1
        add_interface_port slv_6 slv_6_burst_count burstcount Input -1
        add_interface_port slv_6 slv_6_burst_begin beginbursttransfer Input 1
        add_interface_port slv_6 slv_6_addr address Input -1    

        # width-adapting port
        set_port_property slv_6_byteenable   WIDTH $narrow_byteen
        set_port_property slv_6_wdata        WIDTH $narrow_data_bits
        set_port_property slv_6_rdata        WIDTH $narrow_data_bits
        set_port_property slv_6_burst_count  WIDTH $burstcount_bits
        set_port_property slv_6_addr         WIDTH [expr $slave_addr_bits + $offset]     
    }
    if {($num_slaves >= 8)} {
        set_interface_property slv_7 ENABLED true
        set_parameter_property SLV_7_CRITICAL ENABLED true
        set_parameter_property SLV_7_BW_RATIO ENABLED true
        
        add_interface_port slv_7 slv_7_write_req write Input 1
        add_interface_port slv_7 slv_7_read_req read Input 1
        add_interface_port slv_7 slv_7_byteenable byteenable Input -1
        add_interface_port slv_7 slv_7_waitrequest waitrequest Output 1
        add_interface_port slv_7 slv_7_wdata writedata Input -1
        add_interface_port slv_7 slv_7_rdata_valid readdatavalid Output 1
        add_interface_port slv_7 slv_7_rdata readdata Output -1
        add_interface_port slv_7 slv_7_burst_count burstcount Input -1
        add_interface_port slv_7 slv_7_burst_begin beginbursttransfer Input 1
        add_interface_port slv_7 slv_7_addr address Input -1    

        # width-adapting port
        set_port_property slv_7_byteenable   WIDTH $narrow_byteen
        set_port_property slv_7_wdata        WIDTH $narrow_data_bits
        set_port_property slv_7_rdata        WIDTH $narrow_data_bits
        set_port_property slv_7_burst_count  WIDTH $burstcount_bits
        set_port_property slv_7_addr         WIDTH [expr $slave_addr_bits + $offset]      
    
    }
    if {($num_slaves >= 9)} {
        set_interface_property slv_8 ENABLED true
        set_parameter_property SLV_8_CRITICAL ENABLED true
        set_parameter_property SLV_8_BW_RATIO ENABLED true
        
        add_interface_port slv_8 slv_8_write_req write Input 1
        add_interface_port slv_8 slv_8_read_req read Input 1
        add_interface_port slv_8 slv_8_byteenable byteenable Input -1
        add_interface_port slv_8 slv_8_waitrequest waitrequest Output 1
        add_interface_port slv_8 slv_8_wdata writedata Input -1
        add_interface_port slv_8 slv_8_rdata_valid readdatavalid Output 1
        add_interface_port slv_8 slv_8_rdata readdata Output -1
        add_interface_port slv_8 slv_8_burst_count burstcount Input -1
        add_interface_port slv_8 slv_8_burst_begin beginbursttransfer Input 1
        add_interface_port slv_8 slv_8_addr address Input -1    

        set_port_property slv_8_byteenable   WIDTH $byteenables
        set_port_property slv_8_wdata        WIDTH $data_bits
        set_port_property slv_8_rdata        WIDTH $data_bits
        set_port_property slv_8_burst_count  WIDTH $burstcount_bits
        set_port_property slv_8_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 10)} {
        set_interface_property slv_9 ENABLED true
        set_parameter_property SLV_9_CRITICAL ENABLED true
        set_parameter_property SLV_9_BW_RATIO ENABLED true
        
        add_interface_port slv_9 slv_9_write_req write Input 1
        add_interface_port slv_9 slv_9_read_req read Input 1
        add_interface_port slv_9 slv_9_byteenable byteenable Input -1
        add_interface_port slv_9 slv_9_waitrequest waitrequest Output 1
        add_interface_port slv_9 slv_9_wdata writedata Input -1
        add_interface_port slv_9 slv_9_rdata_valid readdatavalid Output 1
        add_interface_port slv_9 slv_9_rdata readdata Output -1
        add_interface_port slv_9 slv_9_burst_count burstcount Input -1
        add_interface_port slv_9 slv_9_burst_begin beginbursttransfer Input 1
        add_interface_port slv_9 slv_9_addr address Input -1    

        set_port_property slv_9_byteenable   WIDTH $byteenables
        set_port_property slv_9_wdata        WIDTH $data_bits
        set_port_property slv_9_rdata        WIDTH $data_bits
        set_port_property slv_9_burst_count  WIDTH $burstcount_bits
        set_port_property slv_9_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 11)} {
        set_interface_property slv_10 ENABLED true
        set_parameter_property SLV_10_CRITICAL ENABLED true
        set_parameter_property SLV_10_BW_RATIO ENABLED true
        
        add_interface_port slv_10 slv_10_write_req write Input 1
        add_interface_port slv_10 slv_10_read_req read Input 1
        add_interface_port slv_10 slv_10_byteenable byteenable Input -1
        add_interface_port slv_10 slv_10_waitrequest waitrequest Output 1
        add_interface_port slv_10 slv_10_wdata writedata Input -1
        add_interface_port slv_10 slv_10_rdata_valid readdatavalid Output 1
        add_interface_port slv_10 slv_10_rdata readdata Output -1
        add_interface_port slv_10 slv_10_burst_count burstcount Input -1
        add_interface_port slv_10 slv_10_burst_begin beginbursttransfer Input 1
        add_interface_port slv_10 slv_10_addr address Input -1    

        set_port_property slv_10_byteenable   WIDTH $byteenables
        set_port_property slv_10_wdata        WIDTH $data_bits
        set_port_property slv_10_rdata        WIDTH $data_bits
        set_port_property slv_10_burst_count  WIDTH $burstcount_bits
        set_port_property slv_10_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 12)} {
        set_interface_property slv_11 ENABLED true
        set_parameter_property SLV_11_CRITICAL ENABLED true
        set_parameter_property SLV_11_BW_RATIO ENABLED true
        
        add_interface_port slv_11 slv_11_write_req write Input 1
        add_interface_port slv_11 slv_11_read_req read Input 1
        add_interface_port slv_11 slv_11_byteenable byteenable Input -1
        add_interface_port slv_11 slv_11_waitrequest waitrequest Output 1
        add_interface_port slv_11 slv_11_wdata writedata Input -1
        add_interface_port slv_11 slv_11_rdata_valid readdatavalid Output 1
        add_interface_port slv_11 slv_11_rdata readdata Output -1
        add_interface_port slv_11 slv_11_burst_count burstcount Input -1
        add_interface_port slv_11 slv_11_burst_begin beginbursttransfer Input 1
        add_interface_port slv_11 slv_11_addr address Input -1    

        set_port_property slv_11_byteenable   WIDTH $byteenables
        set_port_property slv_11_wdata        WIDTH $data_bits
        set_port_property slv_11_rdata        WIDTH $data_bits
        set_port_property slv_11_burst_count  WIDTH $burstcount_bits
        set_port_property slv_11_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 13)} {
        set_interface_property slv_12 ENABLED true
        set_parameter_property SLV_12_CRITICAL ENABLED true
        set_parameter_property SLV_12_BW_RATIO ENABLED true
        
        add_interface_port slv_12 slv_12_write_req write Input 1
        add_interface_port slv_12 slv_12_read_req read Input 1
        add_interface_port slv_12 slv_12_byteenable byteenable Input -1
        add_interface_port slv_12 slv_12_waitrequest waitrequest Output 1
        add_interface_port slv_12 slv_12_wdata writedata Input -1
        add_interface_port slv_12 slv_12_rdata_valid readdatavalid Output 1
        add_interface_port slv_12 slv_12_rdata readdata Output -1
        add_interface_port slv_12 slv_12_burst_count burstcount Input -1
        add_interface_port slv_12 slv_12_burst_begin beginbursttransfer Input 1
        add_interface_port slv_12 slv_12_addr address Input -1    

        set_port_property slv_12_byteenable   WIDTH $byteenables
        set_port_property slv_12_wdata        WIDTH $data_bits
        set_port_property slv_12_rdata        WIDTH $data_bits
        set_port_property slv_12_burst_count  WIDTH $burstcount_bits
        set_port_property slv_12_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 14)} {
        set_interface_property slv_13 ENABLED true
        set_parameter_property SLV_13_CRITICAL ENABLED true
        set_parameter_property SLV_13_BW_RATIO ENABLED true
        
        add_interface_port slv_13 slv_13_write_req write Input 1
        add_interface_port slv_13 slv_13_read_req read Input 1
        add_interface_port slv_13 slv_13_byteenable byteenable Input -1
        add_interface_port slv_13 slv_13_waitrequest waitrequest Output 1
        add_interface_port slv_13 slv_13_wdata writedata Input -1
        add_interface_port slv_13 slv_13_rdata_valid readdatavalid Output 1
        add_interface_port slv_13 slv_13_rdata readdata Output -1
        add_interface_port slv_13 slv_13_burst_count burstcount Input -1
        add_interface_port slv_13 slv_13_burst_begin beginbursttransfer Input 1
        add_interface_port slv_13 slv_13_addr address Input -1    

        set_port_property slv_13_byteenable   WIDTH $byteenables
        set_port_property slv_13_wdata        WIDTH $data_bits
        set_port_property slv_13_rdata        WIDTH $data_bits
        set_port_property slv_13_burst_count  WIDTH $burstcount_bits
        set_port_property slv_13_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 15)} {
        set_interface_property slv_14 ENABLED true
        set_parameter_property SLV_14_CRITICAL ENABLED true
        set_parameter_property SLV_14_BW_RATIO ENABLED true
        
        add_interface_port slv_14 slv_14_write_req write Input 1
        add_interface_port slv_14 slv_14_read_req read Input 1
        add_interface_port slv_14 slv_14_byteenable byteenable Input -1
        add_interface_port slv_14 slv_14_waitrequest waitrequest Output 1
        add_interface_port slv_14 slv_14_wdata writedata Input -1
        add_interface_port slv_14 slv_14_rdata_valid readdatavalid Output 1
        add_interface_port slv_14 slv_14_rdata readdata Output -1
        add_interface_port slv_14 slv_14_burst_count burstcount Input -1
        add_interface_port slv_14 slv_14_burst_begin beginbursttransfer Input 1
        add_interface_port slv_14 slv_14_addr address Input -1    

        set_port_property slv_14_byteenable   WIDTH $byteenables
        set_port_property slv_14_wdata        WIDTH $data_bits
        set_port_property slv_14_rdata        WIDTH $data_bits
        set_port_property slv_14_burst_count  WIDTH $burstcount_bits
        set_port_property slv_14_addr         WIDTH $slave_addr_bits  
    }    
    if {($num_slaves >= 16)} {
        set_interface_property slv_15 ENABLED true
        set_parameter_property SLV_15_CRITICAL ENABLED true
        set_parameter_property SLV_15_BW_RATIO ENABLED true
        
        add_interface_port slv_15 slv_15_write_req write Input 1
        add_interface_port slv_15 slv_15_read_req read Input 1
        add_interface_port slv_15 slv_15_byteenable byteenable Input -1
        add_interface_port slv_15 slv_15_waitrequest waitrequest Output 1
        add_interface_port slv_15 slv_15_wdata writedata Input -1
        add_interface_port slv_15 slv_15_rdata_valid readdatavalid Output 1
        add_interface_port slv_15 slv_15_rdata readdata Output -1
        add_interface_port slv_15 slv_15_burst_count burstcount Input -1
        add_interface_port slv_15 slv_15_burst_begin beginbursttransfer Input 1
        add_interface_port slv_15 slv_15_addr address Input -1    

        set_port_property slv_15_byteenable   WIDTH $byteenables
        set_port_property slv_15_wdata        WIDTH $data_bits
        set_port_property slv_15_rdata        WIDTH $data_bits
        set_port_property slv_15_burst_count  WIDTH $burstcount_bits
        set_port_property slv_15_addr         WIDTH $slave_addr_bits  
    }    

    # enable or disable the debug slave port    
    set_interface_property debug_slv ENABLED false

    set debug_slave_enabled [get_parameter_value ENABLE_DEBUG_PORT]
    set internal_jtag_enabled [get_parameter_value INTERNAL_JTAGNODE]

    if {$debug_slave_enabled} {
        if {$internal_jtag_enabled == 0} {
            set_interface_property debug_slv ENABLED true
            add_interface_port debug_slv dbg_write_req write Input 1
            add_interface_port debug_slv dbg_read_req read Input 1
            add_interface_port debug_slv dbg_addr address Input 8
            add_interface_port debug_slv dbg_wdata writedata Input 32
            add_interface_port debug_slv dbg_rdata_valid readdatavalid Output 1
            add_interface_port debug_slv dbg_rdata readdata Output 32
        }
    }
    
   
}

