onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lvds_sync_controller/ClkxCI
add wave -noupdate /lvds_sync_controller/RstxRBI
add wave -noupdate /lvds_sync_controller/LVDSDataxDI
add wave -noupdate /lvds_sync_controller/ButtonxSI
add wave -noupdate /lvds_sync_controller/FrameReqxSI
add wave -noupdate /lvds_sync_controller/AlignxSO
add wave -noupdate /lvds_sync_controller/PixelChannel1xDO
add wave -noupdate /lvds_sync_controller/PixelChannel5xDO
add wave -noupdate /lvds_sync_controller/PixelChannel9xDO
add wave -noupdate /lvds_sync_controller/PixelChannel13xDO
add wave -noupdate /lvds_sync_controller/FrameReqxSO
add wave -noupdate /lvds_sync_controller/PixelValidxSO
add wave -noupdate /lvds_sync_controller/RowValidxSO
add wave -noupdate /lvds_sync_controller/FrameValidxSO
add wave -noupdate /lvds_sync_controller/LedxSO
add wave -noupdate /lvds_sync_controller/ClkxC
add wave -noupdate /lvds_sync_controller/RstxRB
add wave -noupdate /lvds_sync_controller/LVDSDataxD
add wave -noupdate /lvds_sync_controller/ButtonxS
add wave -noupdate /lvds_sync_controller/FrameReqxS
add wave -noupdate /lvds_sync_controller/AlignxS
add wave -noupdate /lvds_sync_controller/PixelValidxS
add wave -noupdate /lvds_sync_controller/RowValidxS
add wave -noupdate /lvds_sync_controller/FrameValidxS
add wave -noupdate /lvds_sync_controller/LedxS
add wave -noupdate /lvds_sync_controller/PixelChannelxD
add wave -noupdate /lvds_sync_controller/StatexDP
add wave -noupdate /lvds_sync_controller/StatexDN
add wave -noupdate /lvds_sync_controller/InitCounterxDP
add wave -noupdate /lvds_sync_controller/InitCounterxDN
add wave -noupdate /lvds_sync_controller/CameraReadyxSP
add wave -noupdate /lvds_sync_controller/CameraReadyxSN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {521 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {38752 ps} {116256 ps}
