onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RegisterFile_tb/wrAddr
add wave -noupdate /RegisterFile_tb/rdAddrA
add wave -noupdate /RegisterFile_tb/rdAddrB
add wave -noupdate /RegisterFile_tb/wrData
add wave -noupdate /RegisterFile_tb/rdDataB
add wave -noupdate /RegisterFile_tb/rdDataA
add wave -noupdate /RegisterFile_tb/clk
add wave -noupdate /RegisterFile_tb/writeEn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
