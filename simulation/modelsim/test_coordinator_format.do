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
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/clk
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/reset
add wave -noupdate -format Literal /coordinator_tb/coord/seq_gen/max_length
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/start
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/complete
add wave -noupdate -format Literal /coordinator_tb/coord/seq_gen/seq_index
add wave -noupdate -format Literal /coordinator_tb/coord/seq_gen/seq_gate
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/ready
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/first
add wave -noupdate -format Logic /coordinator_tb/coord/seq_gen/available
add wave -noupdate -format Literal /coordinator_tb/coord/seq_gen/state
add wave -noupdate -format Literal /coordinator_tb/coord/seq_gen/i
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/clk
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/reset
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/seq_index
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/seq_gate
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/ready
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/first
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/available
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/result_mtx
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/done
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/multiplier_a
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/multiplier_b
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/multiplier_ready
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/multiplier_done
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/multiplier_result
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/gate_mtx
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/gate_ready
add wave -noupdate -format Logic /coordinator_tb/coord/seq_mult/gate_done
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/gate_to_read
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/cache_first
add wave -noupdate -format Literal /coordinator_tb/coord/seq_mult/state
add wave -noupdate -format Logic /coordinator_tb/coord/dst/reset
add wave -noupdate -format Logic /coordinator_tb/coord/dst/clk
add wave -noupdate -format Literal /coordinator_tb/coord/dst/mtx_a
add wave -noupdate -format Literal /coordinator_tb/coord/dst/mtx_b
add wave -noupdate -format Logic /coordinator_tb/coord/dst/ready
add wave -noupdate -format Literal -radix decimal /coordinator_tb/coord/dst/dist2
add wave -noupdate -format Logic /coordinator_tb/coord/dst/finished
add wave -noupdate -format Literal /coordinator_tb/coord/dst/mults
add wave -noupdate -format Literal /coordinator_tb/coord/dst/sums
add wave -noupdate -format Literal /coordinator_tb/coord/dst/final_sum
add wave -noupdate -format Literal /coordinator_tb/coord/dst/squares
add wave -noupdate -format Literal /coordinator_tb/coord/dst/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1940753 ps} 0}
configure wave -namecolwidth 290
configure wave -valuecolwidth 211
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
WaveRestoreZoom {1752489 ps} {2222889 ps}
