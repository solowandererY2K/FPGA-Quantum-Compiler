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
add wave -noupdate -format Literal /dist_tb/d/index
add wave -noupdate -format Literal /dist_tb/d/mul/x
add wave -noupdate -format Literal /dist_tb/d/mul/y
add wave -noupdate -format Literal /dist_tb/d/mul/out
add wave -noupdate -format Literal /dist_tb/d/mul/a
add wave -noupdate -format Literal /dist_tb/d/mul/b
add wave -noupdate -format Literal /dist_tb/d/mul/c
add wave -noupdate -format Literal /dist_tb/d/mul/d
add wave -noupdate -format Literal /dist_tb/d/mul/ac
add wave -noupdate -format Literal /dist_tb/d/mul/bd
add wave -noupdate -format Literal /dist_tb/d/mul/bc
add wave -noupdate -format Literal /dist_tb/d/mul/ad
add wave -noupdate -format Logic /dist_tb/d/mul/ready
add wave -noupdate -format Logic /dist_tb/d/mul/available
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90560 ps} 0}
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
WaveRestoreZoom {0 ps} {256 ns}
