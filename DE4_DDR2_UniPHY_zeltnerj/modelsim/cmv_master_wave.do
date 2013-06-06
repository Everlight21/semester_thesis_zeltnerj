onerror {resume}
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(7 downto 0)} test
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(31 downto 0)} bufout0
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(63 downto 32)} buf1oup
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(95 downto 64)} bufOut3
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(127 downto 96)} bufOut4
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(7 downto 0)} bufOut1
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(39 downto 32)} bufOut1001
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(71 downto 64)} bufOut2
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(104 downto 97)} bufOut3001
quietly virtual signal -install /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1 { /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(103 downto 96)} bufOut3002
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmv_master_tb/ClkxC
add wave -noupdate /cmv_master_tb/ClkLvdsRxxC
add wave -noupdate /cmv_master_tb/RstxRB
add wave -noupdate /cmv_master_tb/PixelValidxS
add wave -noupdate /cmv_master_tb/RowValidxS
add wave -noupdate /cmv_master_tb/FrameValidxS
add wave -noupdate /cmv_master_tb/DataInxD
add wave -noupdate /cmv_master_tb/DataRegxDP
add wave -noupdate /cmv_master_tb/DataRegxDN
add wave -noupdate /cmv_master_tb/AMWaitReqxS
add wave -noupdate -radix hexadecimal /cmv_master_tb/AMAddressxD
add wave -noupdate /cmv_master_tb/AMWriteDataxD
add wave -noupdate /cmv_master_tb/AMWritexS
add wave -noupdate /cmv_master_tb/AMBurstCountxS
add wave -noupdate /cmv_master_tb/PixelValidCounterxDP
add wave -noupdate /cmv_master_tb/PixelValidCounterxDN
add wave -noupdate /cmv_master_tb/FrameValidCounterxDP
add wave -noupdate /cmv_master_tb/FrameValidCounterxDN
add wave -noupdate -divider cmv_master_interace
add wave -noupdate /cmv_master_tb/cmv_master_1/ClkxCI
add wave -noupdate /cmv_master_tb/cmv_master_1/ClkLvdsRxxCI
add wave -noupdate /cmv_master_tb/cmv_master_1/RstxRBI
add wave -noupdate /cmv_master_tb/cmv_master_1/PixelValidxSI
add wave -noupdate /cmv_master_tb/cmv_master_1/RowValidxSI
add wave -noupdate /cmv_master_tb/cmv_master_1/FrameValidxSI
add wave -noupdate /cmv_master_tb/cmv_master_1/DataInxDI
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWaitReqxSI
add wave -noupdate -radix hexadecimal /cmv_master_tb/cmv_master_1/AMAddressxDO
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWriteDataxDO
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWritexSO
add wave -noupdate /cmv_master_tb/cmv_master_1/AMBurstCountxSO
add wave -noupdate -divider cmv_master
add wave -noupdate /cmv_master_tb/cmv_master_1/ClkxC
add wave -noupdate /cmv_master_tb/cmv_master_1/ClkLvdsRxxC
add wave -noupdate /cmv_master_tb/cmv_master_1/RstxRB
add wave -noupdate /cmv_master_tb/cmv_master_1/PixelValidxS
add wave -noupdate /cmv_master_tb/cmv_master_1/RowValidxS
add wave -noupdate /cmv_master_tb/cmv_master_1/FrameValidxS
add wave -noupdate /cmv_master_tb/cmv_master_1/DataInxD
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWaitReqxS
add wave -noupdate -radix hexadecimal /cmv_master_tb/cmv_master_1/AMAddressxD
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWriteDataxD
add wave -noupdate /cmv_master_tb/cmv_master_1/AMWritexS
add wave -noupdate -radix unsigned /cmv_master_tb/cmv_master_1/AMBurstCountxS
add wave -noupdate /cmv_master_tb/cmv_master_1/BufDataInxD
add wave -noupdate /cmv_master_tb/cmv_master_1/BufDataOutxD
add wave -noupdate /cmv_master_tb/cmv_master_1/BufReadReqxS
add wave -noupdate /cmv_master_tb/cmv_master_1/BufWriteEnxS
add wave -noupdate -radix unsigned -childformat {{/cmv_master_tb/cmv_master_1/BufNoOfWordsxS(1) -radix unsigned} {/cmv_master_tb/cmv_master_1/BufNoOfWordsxS(2) -radix unsigned} {/cmv_master_tb/cmv_master_1/BufNoOfWordsxS(3) -radix unsigned} {/cmv_master_tb/cmv_master_1/BufNoOfWordsxS(4) -radix unsigned}} -subitemconfig {/cmv_master_tb/cmv_master_1/BufNoOfWordsxS(1) {-height 15 -radix unsigned} /cmv_master_tb/cmv_master_1/BufNoOfWordsxS(2) {-height 15 -radix unsigned} /cmv_master_tb/cmv_master_1/BufNoOfWordsxS(3) {-height 15 -radix unsigned} /cmv_master_tb/cmv_master_1/BufNoOfWordsxS(4) {-height 15 -radix unsigned}} /cmv_master_tb/cmv_master_1/BufNoOfWordsxS
add wave -noupdate /cmv_master_tb/cmv_master_1/BufFullxS
add wave -noupdate /cmv_master_tb/cmv_master_1/ChannelSelectxSP
add wave -noupdate /cmv_master_tb/cmv_master_1/ChannelSelectxSN
add wave -noupdate /cmv_master_tb/cmv_master_1/NoOfPacketsInRowxDP
add wave -noupdate /cmv_master_tb/cmv_master_1/NoOfPacketsInRowxDN
add wave -noupdate -radix unsigned /cmv_master_tb/cmv_master_1/AMWriteAddressxDP
add wave -noupdate -radix unsigned /cmv_master_tb/cmv_master_1/AMWriteAddressxDN
add wave -noupdate /cmv_master_tb/cmv_master_1/BurstWordCountxDP
add wave -noupdate /cmv_master_tb/cmv_master_1/BurstWordCountxDN
add wave -noupdate /cmv_master_tb/cmv_master_1/RowCounterxDP
add wave -noupdate /cmv_master_tb/cmv_master_1/RowCounterxDN
add wave -noupdate /cmv_master_tb/cmv_master_1/StatexDP
add wave -noupdate /cmv_master_tb/cmv_master_1/StatexDN
add wave -noupdate /cmv_master_tb/cmv_master_1/getCmvDataStatexDP
add wave -noupdate /cmv_master_tb/cmv_master_1/getCmvDataStatexDN
add wave -noupdate /cmv_master_tb/cmv_master_1/BufClearxSP
add wave -noupdate /cmv_master_tb/cmv_master_1/BufClearxSN
add wave -noupdate -divider {cmv_ram_fifo 1}
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/aclr
add wave -noupdate -expand -group {cmv_ram_fifo
} -label {bufinput
} -radix decimal -childformat {{/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(7) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(6) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(5) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(4) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(3) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(2) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(1) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test(0) -radix decimal}} -subitemconfig {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(7) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(6) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(5) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(4) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(3) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(2) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(1) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data(0) {-radix decimal}} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/test
add wave -noupdate -expand -group {cmv_ram_fifo
} -label {bufOut0
} -radix decimal /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut1
add wave -noupdate -expand -group {cmv_ram_fifo
} -label {bufOut1
} -radix decimal /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut1001
add wave -noupdate -expand -group {cmv_ram_fifo
} -radix decimal /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut2
add wave -noupdate -expand -group {cmv_ram_fifo
} -label {bufOut3
} -radix decimal -childformat {{/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(103) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(102) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(101) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(100) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(99) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(98) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(97) -radix decimal} {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002(96) -radix decimal}} -subitemconfig {/cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(103) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(102) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(101) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(100) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(99) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(98) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(97) {-radix decimal} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q(96) {-radix decimal}} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/bufOut3002
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/data
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/rdclk
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/rdreq
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/wrclk
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/wrreq
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/q
add wave -noupdate -expand -group {cmv_ram_fifo
} -radix decimal /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/rdusedw
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/wrfull
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/sub_wire0
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/sub_wire1
add wave -noupdate -expand -group {cmv_ram_fifo
} /cmv_master_tb/cmv_master_1/fifo_instances(1)/cmv_ram_fifo_1/sub_wire2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1800000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 166
configure wave -valuecolwidth 77
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
WaveRestoreZoom {499745796 ps} {500417321 ps}
bookmark add wave {bookmark45} {{27975089 ps} {29660337 ps}} 26
bookmark add wave {bookmark46} {{27906516425 ps} {27908201673 ps}} 0
bookmark add wave {bookmark47} {{28269980 ps} {28691292 ps}} 26
bookmark add wave {bookmark48} {{10169190 ps} {10357990 ps}} 4
bookmark add wave {bookmark49} {{27852789360 ps} {27853210673 ps}} 0
bookmark add wave {bookmark50} {{27912168655 ps} {27913511703 ps}} 28
