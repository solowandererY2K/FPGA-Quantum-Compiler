onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /coordinator_tb/coord/clk
add wave -noupdate -format Logic /coordinator_tb/coord/reset
add wave -noupdate -format Literal /coordinator_tb/coord/received_byte
add wave -noupdate -format Logic /coordinator_tb/coord/received_ready
add wave -noupdate -format Literal /coordinator_tb/coord/transmit_byte
add wave -noupdate -format Logic /coordinator_tb/coord/transmit_available
add wave -noupdate -format Logic /coordinator_tb/coord/transmit_ready
add wave -noupdate -format Literal /coordinator_tb/coord/green_leds
add wave -noupdate -format Literal /coordinator_tb/coord/state
add wave -noupdate -format Literal /coordinator_tb/coord/last_state
add wave -noupdate -format Literal /coordinator_tb/coord/snd_num
add wave -noupdate -format Logic /coordinator_tb/coord/snd_done
add wave -noupdate -format Logic /coordinator_tb/coord/snd_reset
add wave -noupdate -format Literal /coordinator_tb/coord/smd_mtx
add wave -noupdate -format Logic /coordinator_tb/coord/smd_done
add wave -noupdate -format Logic /coordinator_tb/coord/smd_reset
add wave -noupdate -format Literal /coordinator_tb/coord/dist_tolerance
add wave -noupdate -format Literal /coordinator_tb/coord/max_gate_length
add wave -noupdate -format Logic /coordinator_tb/coord/snd/clk
add wave -noupdate -format Logic /coordinator_tb/coord/snd/reset
add wave -noupdate -format Literal /coordinator_tb/coord/snd/received_byte
add wave -noupdate -format Logic /coordinator_tb/coord/snd/received_ready
add wave -noupdate -format Literal /coordinator_tb/coord/snd/num
add wave -noupdate -format Logic /coordinator_tb/coord/snd/done
add wave -noupdate -format Literal /coordinator_tb/coord/snd/byte_index
add wave -noupdate -format Literal /coordinator_tb/coord/snd/bytes
add wave -noupdate -format Logic /coordinator_tb/coord/smd/reset
add wave -noupdate -format Logic /coordinator_tb/coord/smd/clk
add wave -noupdate -format Literal /coordinator_tb/coord/smd/matrix_cell
add wave -noupdate -format Logic /coordinator_tb/coord/smd/ready
add wave -noupdate -format Logic /coordinator_tb/coord/smd/done
add wave -noupdate -format Literal /coordinator_tb/coord/smd/index
add wave -noupdate -format Logic /coordinator_tb/coord/smd/r
add wave -noupdate -format Logic /coordinator_tb/coord/smd/c
add wave -noupdate -format Logic /coordinator_tb/coord/smd/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 364
configure wave -valuecolwidth 226
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
WaveRestoreZoom {0 ns} {1616 ns}
