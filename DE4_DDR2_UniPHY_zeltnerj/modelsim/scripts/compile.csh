#! /bin/tcsh -f

# example file to compile RTL sourcecode


set VER=10.0d
set LIB=work


if (-e ${LIB}) then
  rm -rf ${LIB}
endif

vlib-${VER} ${LIB}

# sourcecode

vcom-${VER}  -work ${LIB} -check_synthesis ../../../lvds_sync_controller.vhd


# GUI
echo "vsim-${VER} -lib ${LIB} gf2m_arithm_tb &"
