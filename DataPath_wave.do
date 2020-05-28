onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DataPath_tb/clk
add wave -noupdate /DataPath_tb/RegF_W_en
add wave -noupdate /DataPath_tb/MuxS
add wave -noupdate /DataPath_tb/D_WriteEn
add wave -noupdate /DataPath_tb/ALU_S
add wave -noupdate /DataPath_tb/D_Addr
add wave -noupdate /DataPath_tb/RegF_W_addr
add wave -noupdate /DataPath_tb/RegF_Ra_addr
add wave -noupdate /DataPath_tb/RegF_Rb_addr
add wave -noupdate /DataPath_tb/ALU_A
add wave -noupdate /DataPath_tb/ALU_B
add wave -noupdate /DataPath_tb/ALU_Out
add wave -noupdate /DataPath_tb/r_data
add wave -noupdate /DataPath_tb/wData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94 ps} 0}
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
