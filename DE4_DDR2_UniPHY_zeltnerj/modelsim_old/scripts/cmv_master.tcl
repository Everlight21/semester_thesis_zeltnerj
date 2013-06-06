#change directory to working directory
#cd ../../../semester_thesis_zeltnerj/de4_DDR2_UniPHY_zeltnerj/modelsim

vlib work

#vhd files
vcom ../configuration_pkg.vhd
vcom ../cmv_ram_fifo.vhd
vcom ../cmv_master.vhd

#testbench files
vcom testbenches/tb_util.vhd
vcom testbenches/cmv_master_tb.vhd

#simulate
vsim -voptargs=+acc work.cmv_master_tb 

#load wave
do cmv_master_wave.do

#run
run 10us
