#change directory to working directory
#cd ../../../sem13f2/DE4_DDR2_UniPHY_zeltnerj/modelsim

vlib work

#vhd files
vcom ../configuration_pkg.vhd
vcom ../lvds_sync_controller.vhd

#testbench files
vcom testbenches/tb_util.vhd
vcom testbenches/lvds_sync_controller_tb.vhd

#simulate
vsim -voptargs=+acc work.lvds_sync_controller_tb 

#load wave
do lvds_sync_controller_wave.do

#run
run 1us
