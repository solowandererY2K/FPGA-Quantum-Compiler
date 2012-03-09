onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/x
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/y
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/out
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/a
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/b
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/c
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/d
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/ac
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/bd
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/bc
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/ad
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/aw
add wave -noupdate -format Literal /complex_fix_mul_clocked_tb/cfm/bw
add wave -noupdate -format Logic /complex_fix_mul_clocked_tb/cfm/clk
add wave -noupdate -format Logic /complex_fix_mul_clocked_tb/cfm/reset
add wave -noupdate -format Logic /complex_fix_mul_clocked_tb/cfm/ready
add wave -noupdate -format Logic /complex_fix_mul_clocked_tb/cfm/available
add wave -noupdate -format Logic /complex_fix_mul_clocked_tb/cfm/switch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 321
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2097152 ps}
