onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dvi_master_tb/ClkxC
add wave -noupdate /dvi_master_tb/ClkDvixC
add wave -noupdate /dvi_master_tb/RstxRB
add wave -noupdate /dvi_master_tb/DviDataOutxD
add wave -noupdate /dvi_master_tb/DviNewLinexD
add wave -noupdate /dvi_master_tb/DviNewFramexD
add wave -noupdate /dvi_master_tb/DviPixelAvxS
add wave -noupdate /dvi_master_tb/AmWaitReqxS
add wave -noupdate /dvi_master_tb/AmAddressxD
add wave -noupdate /dvi_master_tb/AmReadDataxD
add wave -noupdate /dvi_master_tb/AmReadxS
add wave -noupdate /dvi_master_tb/AmReadDataValidxS
add wave -noupdate /dvi_master_tb/AmBurstCountxD
add wave -noupdate /dvi_master_tb/DataRegxDP
add wave -noupdate /dvi_master_tb/DataRegxDN
add wave -noupdate /dvi_master_tb/DataCounterxDP
add wave -noupdate /dvi_master_tb/DataCounterxDN
add wave -noupdate -divider dvi_master
add wave -noupdate /dvi_master_tb/dvi_master_1/ClkxCI
add wave -noupdate /dvi_master_tb/dvi_master_1/ClkDvixCI
add wave -noupdate /dvi_master_tb/dvi_master_1/RstxRBI
add wave -noupdate /dvi_master_tb/dvi_master_1/DviDataOutxDO
add wave -noupdate /dvi_master_tb/dvi_master_1/DviNewLinexDI
add wave -noupdate /dvi_master_tb/dvi_master_1/DviNewFramexDI
add wave -noupdate /dvi_master_tb/dvi_master_1/DviPixelAvxSI
add wave -noupdate /dvi_master_tb/dvi_master_1/AmWaitReqxSI
add wave -noupdate /dvi_master_tb/dvi_master_1/AmAddressxDO
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadDataxDI
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadxSO
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadDataValidxSI
add wave -noupdate /dvi_master_tb/dvi_master_1/AmBurstCountxDO
add wave -noupdate /dvi_master_tb/dvi_master_1/ClkxC
add wave -noupdate /dvi_master_tb/dvi_master_1/ClkDvixC
add wave -noupdate /dvi_master_tb/dvi_master_1/RstxRB
add wave -noupdate /dvi_master_tb/dvi_master_1/DviDataOutxD
add wave -noupdate /dvi_master_tb/dvi_master_1/DviNewLinexD
add wave -noupdate /dvi_master_tb/dvi_master_1/DviNewFramexD
add wave -noupdate /dvi_master_tb/dvi_master_1/DviPixelAvxS
add wave -noupdate /dvi_master_tb/dvi_master_1/AmWaitReqxS
add wave -noupdate -radix hexadecimal /dvi_master_tb/dvi_master_1/AmAddressxD
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadDataxD
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadxS
add wave -noupdate /dvi_master_tb/dvi_master_1/AmReadDataValidxS
add wave -noupdate /dvi_master_tb/dvi_master_1/AmBurstCountxD
add wave -noupdate /dvi_master_tb/dvi_master_1/BufDataInxD
add wave -noupdate /dvi_master_tb/dvi_master_1/BufDataOutxD
add wave -noupdate /dvi_master_tb/dvi_master_1/BufReadReqxS
add wave -noupdate /dvi_master_tb/dvi_master_1/BufWriteEnxS
add wave -noupdate /dvi_master_tb/dvi_master_1/BufNoOfWordsxS
add wave -noupdate /dvi_master_tb/dvi_master_1/BufEmptyxS
add wave -noupdate /dvi_master_tb/dvi_master_1/BufClearxS
add wave -noupdate /dvi_master_tb/dvi_master_1/PendingReadOutsxDP
add wave -noupdate /dvi_master_tb/dvi_master_1/PendingReadOutsxDN
add wave -noupdate -radix hexadecimal /dvi_master_tb/dvi_master_1/ReadAddressxDP
add wave -noupdate /dvi_master_tb/dvi_master_1/ReadAddressxDN
add wave -noupdate /dvi_master_tb/dvi_master_1/StatexDP
add wave -noupdate /dvi_master_tb/dvi_master_1/StatexDN
add wave -noupdate -divider fifo
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/aclr
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/data
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/rdclk
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/rdreq
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/wrclk
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/wrreq
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/q
add wave -noupdate /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/rdempty
add wave -noupdate -radix decimal /dvi_master_tb/dvi_master_1/ram_dvi_fifo_1/wrusedw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7357587 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 176
configure wave -valuecolwidth 58
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7125322 ps} {7531722 ps}
bookmark add wave {bookmark0} {{10169190 ps} {10357990 ps}} 4
