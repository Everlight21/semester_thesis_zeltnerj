
# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 12.1sp1 243 win32 2013.07.29.16:54:52

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize the variable
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
} 

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "DE4_QSYS"
} elseif { ![ string match "" $TOP_LEVEL_NAME ] } { 
  set TOP_LEVEL_NAME "$TOP_LEVEL_NAME"
} 

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
} elseif { ![ string match "" $QSYS_SIMDIR ] } { 
  set QSYS_SIMDIR "$QSYS_SIMDIR"
} 


# ----------------------------------------
# Copy ROM/RAM files to simulation directory
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.dat ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.hex ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.mif ./
file copy -force $QSYS_SIMDIR/submodules/DE4_QSYS_onchip_memory.hex ./

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if { ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] } {
  ensure_lib                    ./libraries/altera/            
  vmap       altera             ./libraries/altera/            
  ensure_lib                    ./libraries/lpm/               
  vmap       lpm                ./libraries/lpm/               
  ensure_lib                    ./libraries/sgate/             
  vmap       sgate              ./libraries/sgate/             
  ensure_lib                    ./libraries/altera_mf/         
  vmap       altera_mf          ./libraries/altera_mf/         
  ensure_lib                    ./libraries/altera_lnsim/      
  vmap       altera_lnsim       ./libraries/altera_lnsim/      
  ensure_lib                    ./libraries/stratixiv_hssi/    
  vmap       stratixiv_hssi     ./libraries/stratixiv_hssi/    
  ensure_lib                    ./libraries/stratixiv_pcie_hip/
  vmap       stratixiv_pcie_hip ./libraries/stratixiv_pcie_hip/
  ensure_lib                    ./libraries/stratixiv/         
  vmap       stratixiv          ./libraries/stratixiv/         
}
ensure_lib                             ./libraries/no_of_cam_channels/         
vmap       no_of_cam_channels          ./libraries/no_of_cam_channels/         
ensure_lib                             ./libraries/spi_2/                      
vmap       spi_2                       ./libraries/spi_2/                      
ensure_lib                             ./libraries/mm_clock_crossing_bridge_io/
vmap       mm_clock_crossing_bridge_io ./libraries/mm_clock_crossing_bridge_io/
ensure_lib                             ./libraries/button/                     
vmap       button                      ./libraries/button/                     
ensure_lib                             ./libraries/led/                        
vmap       led                         ./libraries/led/                        
ensure_lib                             ./libraries/timer/                      
vmap       timer                       ./libraries/timer/                      
ensure_lib                             ./libraries/sysid/                      
vmap       sysid                       ./libraries/sysid/                      
ensure_lib                             ./libraries/jtag_uart/                  
vmap       jtag_uart                   ./libraries/jtag_uart/                  
ensure_lib                             ./libraries/nios2_qsys/                 
vmap       nios2_qsys                  ./libraries/nios2_qsys/                 
ensure_lib                             ./libraries/mem_if_ddr2_emif/           
vmap       mem_if_ddr2_emif            ./libraries/mem_if_ddr2_emif/           
ensure_lib                             ./libraries/onchip_memory/              
vmap       onchip_memory               ./libraries/onchip_memory/              

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if { ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] } {
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_syn_attributes.vhd"         -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_standard_functions.vhd"     -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/alt_dspbuilder_package.vhd"        -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_europa_support_lib.vhd"     -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_primitives_components.vhd"  -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_primitives.vhd"             -work altera            
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/220pack.vhd"                       -work lpm               
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/220model.vhd"                      -work lpm               
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/sgate_pack.vhd"                    -work sgate             
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/sgate.vhd"                         -work sgate             
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_mf_components.vhd"          -work altera_mf         
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_mf.vhd"                     -work altera_mf         
    vlog -sv "c:/altera/12.1sp1/quartus/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv"   -work altera_lnsim      
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_lnsim_components.vhd"       -work altera_lnsim      
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_hssi_components.vhd"     -work stratixiv_hssi    
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_hssi_atoms.vhd"          -work stratixiv_hssi    
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_pcie_hip_components.vhd" -work stratixiv_pcie_hip
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd"      -work stratixiv_pcie_hip
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_atoms.vhd"               -work stratixiv         
    vcom     "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_components.vhd"          -work stratixiv         
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_no_of_cam_channels.vhd"                   -work no_of_cam_channels         
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_spi_2.vhd"                                -work spi_2                      
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_mm_clock_crossing_bridge_io.vho"          -work mm_clock_crossing_bridge_io
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_button.vhd"                               -work button                     
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_led.vhd"                                  -work led                        
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_timer.vhd"                                -work timer                      
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_sysid.vho"                                -work sysid                      
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_jtag_uart.vhd"                            -work jtag_uart                  
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys.vho"                           -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_sysclk.vhd"  -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_tck.vhd"     -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_wrapper.vhd" -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_mult_cell.vhd"                 -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_oci_test_bench.vhd"            -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_test_bench.vhd"                -work nios2_qsys                 
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_mem_if_ddr2_emif.vhd"                     -work mem_if_ddr2_emif           
  vcom "$QSYS_SIMDIR/submodules/DE4_QSYS_onchip_memory.vhd"                        -work onchip_memory              
  vcom "$QSYS_SIMDIR/DE4_QSYS.vhd"                                                                                  
  vcom "$QSYS_SIMDIR/de4_qsys_nios2_qsys_jtag_debug_module_translator.vhd"                                          
  vcom "$QSYS_SIMDIR/de4_qsys_onchip_memory_s1_translator.vhd"                                                      
  vcom "$QSYS_SIMDIR/de4_qsys_jtag_uart_avalon_jtag_slave_translator.vhd"                                           
  vcom "$QSYS_SIMDIR/de4_qsys_mm_clock_crossing_bridge_io_s0_translator.vhd"                                        
  vcom "$QSYS_SIMDIR/de4_qsys_button_s1_translator.vhd"                                                             
  vcom "$QSYS_SIMDIR/de4_qsys_timer_s1_translator.vhd"                                                              
  vcom "$QSYS_SIMDIR/de4_qsys_sysid_control_slave_translator.vhd"                                                   
  vcom "$QSYS_SIMDIR/de4_qsys_mem_if_ddr2_emif_avl_translator.vhd"                                                  
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  vsim -t ps -L work -L work_lib -L no_of_cam_channels -L spi_2 -L mm_clock_crossing_bridge_io -L button -L led -L timer -L sysid -L jtag_uart -L nios2_qsys -L mem_if_ddr2_emif -L onchip_memory -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L stratixiv_hssi -L stratixiv_pcie_hip -L stratixiv $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  vsim -novopt -t ps -L work -L work_lib -L no_of_cam_channels -L spi_2 -L mm_clock_crossing_bridge_io -L button -L led -L timer -L sysid -L jtag_uart -L nios2_qsys -L mem_if_ddr2_emif -L onchip_memory -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L stratixiv_hssi -L stratixiv_pcie_hip -L stratixiv $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
}
h
