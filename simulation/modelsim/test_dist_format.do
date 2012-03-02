onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /dist_tb/clk
add wave -noupdate -format Logic /dist_tb/reset
add wave -noupdate -format Literal /dist_tb/dist2
add wave -noupdate -format Logic /dist_tb/finished
add wave -noupdate -format Logic /dist_tb/d/reset
add wave -noupdate -format Logic /dist_tb/d/clk
add wave -noupdate -format Literal /dist_tb/d/mtx_a
add wave -noupdate -format Literal /dist_tb/d/mtx_b
add wave -noupdate -format Logic /dist_tb/d/ready
add wave -noupdate -format Literal /dist_tb/d/dist2
add wave -noupdate -format Logic /dist_tb/d/finished
add wave -noupdate -format Literal /dist_tb/d/mults
add wave -noupdate -format Literal /dist_tb/d/sums
add wave -noupdate -format Literal /dist_tb/d/final_sum
add wave -noupdate -format Literal /dist_tb/d/squares
add wave -noupdate -format Literal /dist_tb/d/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 169
configure wave -valuecolwidth 267
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
WaveRestoreZoom {978036 ps} {994036 ps}
