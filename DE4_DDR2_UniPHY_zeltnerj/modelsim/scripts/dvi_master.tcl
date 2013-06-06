#change directory to working directory
#cd ../../../semester_thesis_zeltnerj/de4_DDR2_UniPHY_zeltnerj/modelsim

vlib work

#vhd files
vcom ../configuration_pkg.vhd
vcom ../ram_dvi_fifo.vhd
vcom ../dvi_master.vhd

#testbench files
vcom testbenches/tb_util.vhd
vcom testbenches/dvi_master_tb.vhd

#simulate
vsim -voptargs=+acc work.dvi_master_tb 

#load wave
do dvi_master_wave.do

#run
run 15us
