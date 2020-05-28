onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ControlUnit_1_tb/clk
add wave -noupdate /ControlUnit_1_tb/PC_clr
add wave -noupdate /ControlUnit_1_tb/PC_up
add wave -noupdate /ControlUnit_1_tb/IR_ld
add wave -noupdate /ControlUnit_1_tb/IR_Out
add wave -noupdate /ControlUnit_1_tb/data
add wave -noupdate /ControlUnit_1_tb/addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43 ps} 0}
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
