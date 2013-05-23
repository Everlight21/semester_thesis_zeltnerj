#! /bin/tcsh -f

# example file to compile RTL sourcecode


#set VER=10.0d
set VER=10.1b
set LIB=work


if (-e ${LIB}) then
  rm -rf ${LIB}
endif

vlib-${VER} ${LIB}

# sourcecode

vcom-${VER}  -work ${LIB} -check_synthesis ../../../dvi_master.vhd


# GUI
#echo "vsim-${VER} -lib ${LIB} lvds_sync_controller_tb &"
