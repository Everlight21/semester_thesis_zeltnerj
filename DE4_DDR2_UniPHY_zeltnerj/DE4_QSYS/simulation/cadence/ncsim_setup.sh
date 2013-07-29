
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

# ACDS 12.1sp1 243 win32 2013.07.29.16:54:54

# ----------------------------------------
# ncsim - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="DE4_QSYS"
QSYS_SIMDIR="./../"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/no_of_cam_channels/
mkdir -p ./libraries/spi_2/
mkdir -p ./libraries/mm_clock_crossing_bridge_io/
mkdir -p ./libraries/button/
mkdir -p ./libraries/led/
mkdir -p ./libraries/timer/
mkdir -p ./libraries/sysid/
mkdir -p ./libraries/jtag_uart/
mkdir -p ./libraries/nios2_qsys/
mkdir -p ./libraries/mem_if_ddr2_emif/
mkdir -p ./libraries/onchip_memory/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/stratixiv_hssi/
mkdir -p ./libraries/stratixiv_pcie_hip/
mkdir -p ./libraries/stratixiv/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_bht_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_dc_tag_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ic_tag_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_rf_ram_b.mif ./
  cp -f $QSYS_SIMDIR/submodules/DE4_QSYS_onchip_memory.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_syn_attributes.vhd"         -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_standard_functions.vhd"     -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/alt_dspbuilder_package.vhd"        -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_europa_support_lib.vhd"     -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_primitives_components.vhd"  -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_primitives.vhd"             -work altera            
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/220pack.vhd"                       -work lpm               
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/220model.vhd"                      -work lpm               
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/sgate_pack.vhd"                    -work sgate             
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/sgate.vhd"                         -work sgate             
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_mf_components.vhd"          -work altera_mf         
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_mf.vhd"                     -work altera_mf         
  ncvlog -sv  "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_lnsim.sv"                   -work altera_lnsim      
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_lnsim_components.vhd"       -work altera_lnsim      
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_hssi_components.vhd"     -work stratixiv_hssi    
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_hssi_atoms.vhd"          -work stratixiv_hssi    
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_pcie_hip_components.vhd" -work stratixiv_pcie_hip
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd"      -work stratixiv_pcie_hip
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_atoms.vhd"               -work stratixiv         
  ncvhdl -v93 "c:/altera/12.1sp1/quartus/eda/sim_lib/stratixiv_components.vhd"          -work stratixiv         
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_no_of_cam_channels.vhd"                   -work no_of_cam_channels          -cdslib ./cds_libs/no_of_cam_channels.cds.lib         
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_spi_2.vhd"                                -work spi_2                       -cdslib ./cds_libs/spi_2.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_mm_clock_crossing_bridge_io.vho"          -work mm_clock_crossing_bridge_io -cdslib ./cds_libs/mm_clock_crossing_bridge_io.cds.lib
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_button.vhd"                               -work button                      -cdslib ./cds_libs/button.cds.lib                     
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_led.vhd"                                  -work led                         -cdslib ./cds_libs/led.cds.lib                        
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_timer.vhd"                                -work timer                       -cdslib ./cds_libs/timer.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_sysid.vho"                                -work sysid                       -cdslib ./cds_libs/sysid.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_jtag_uart.vhd"                            -work jtag_uart                   -cdslib ./cds_libs/jtag_uart.cds.lib                  
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys.vho"                           -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_sysclk.vhd"  -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_tck.vhd"     -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_jtag_debug_module_wrapper.vhd" -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_mult_cell.vhd"                 -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_oci_test_bench.vhd"            -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_nios2_qsys_test_bench.vhd"                -work nios2_qsys                  -cdslib ./cds_libs/nios2_qsys.cds.lib                 
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_mem_if_ddr2_emif.vhd"                     -work mem_if_ddr2_emif            -cdslib ./cds_libs/mem_if_ddr2_emif.cds.lib           
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/DE4_QSYS_onchip_memory.vhd"                        -work onchip_memory               -cdslib ./cds_libs/onchip_memory.cds.lib              
  ncvhdl -v93 "$QSYS_SIMDIR/DE4_QSYS.vhd"                                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_nios2_qsys_jtag_debug_module_translator.vhd"                                                                                                 
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_onchip_memory_s1_translator.vhd"                                                                                                             
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_jtag_uart_avalon_jtag_slave_translator.vhd"                                                                                                  
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_mm_clock_crossing_bridge_io_s0_translator.vhd"                                                                                               
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_button_s1_translator.vhd"                                                                                                                    
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_timer_s1_translator.vhd"                                                                                                                     
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_sysid_control_slave_translator.vhd"                                                                                                          
  ncvhdl -v93 "$QSYS_SIMDIR/de4_qsys_mem_if_ddr2_emif_avl_translator.vhd"                                                                                                         
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  ncelab -access +w+r+c -namemap_mixgen -relax $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi
