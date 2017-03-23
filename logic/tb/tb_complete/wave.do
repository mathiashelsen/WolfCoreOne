onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /DE0_NANO_SOC_Default/clk
add wave -noupdate -radix hexadecimal /DE0_NANO_SOC_Default/rst
add wave -noupdate -radix hexadecimal /DE0_NANO_SOC_Default/TxD
add wave -noupdate -radix hexadecimal /DE0_NANO_SOC_Default/CPU/instrInput
add wave -noupdate -radix hexadecimal /DE0_NANO_SOC_Default/CPU/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {79000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
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
WaveRestoreZoom {44681 ps} {103017 ps}
