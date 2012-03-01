onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/clk
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/reset
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/available
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/result
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/reset
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/clk
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/cmm/mtx_a
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/cmm/mtx_b
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/ready
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/cmm/mtx_r
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/available
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/cmm/index
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/r
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/c
add wave -noupdate -format Logic /complex_matrix_multiplier_tb/cmm/i
add wave -noupdate -format Literal /complex_matrix_multiplier_tb/cmm/mult_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4656 ps} 0}
configure wave -namecolwidth 426
configure wave -valuecolwidth 265
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
WaveRestoreZoom {0 ps} {230656 ps}
