onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sequence_multiplier_tb/clk
add wave -noupdate /sequence_multiplier_tb/reset
add wave -noupdate /sequence_multiplier_tb/seq_index
add wave -noupdate /sequence_multiplier_tb/seq_gate
add wave -noupdate /sequence_multiplier_tb/ready
add wave -noupdate /sequence_multiplier_tb/first
add wave -noupdate /sequence_multiplier_tb/available
add wave -noupdate /sequence_multiplier_tb/result_mtx
add wave -noupdate /sequence_multiplier_tb/done
add wave -noupdate /sequence_multiplier_tb/mtx_a
add wave -noupdate /sequence_multiplier_tb/mtx_b
add wave -noupdate /sequence_multiplier_tb/multiplier_result
add wave -noupdate /sequence_multiplier_tb/multiplier_ready
add wave -noupdate /sequence_multiplier_tb/multiplier_done
add wave -noupdate /sequence_multiplier_tb/cmm/reset
add wave -noupdate /sequence_multiplier_tb/cmm/clk
add wave -noupdate /sequence_multiplier_tb/cmm/mtx_a
add wave -noupdate /sequence_multiplier_tb/cmm/mtx_b
add wave -noupdate /sequence_multiplier_tb/cmm/ready
add wave -noupdate /sequence_multiplier_tb/cmm/mtx_r
add wave -noupdate /sequence_multiplier_tb/cmm/completed
add wave -noupdate /sequence_multiplier_tb/cmm/w_mult_results
add wave -noupdate /sequence_multiplier_tb/cmm/mult_completed
add wave -noupdate /sequence_multiplier_tb/sm/clk
add wave -noupdate /sequence_multiplier_tb/sm/reset
add wave -noupdate /sequence_multiplier_tb/sm/seq_index
add wave -noupdate /sequence_multiplier_tb/sm/seq_gate
add wave -noupdate /sequence_multiplier_tb/sm/ready
add wave -noupdate /sequence_multiplier_tb/sm/first
add wave -noupdate /sequence_multiplier_tb/sm/available
add wave -noupdate /sequence_multiplier_tb/sm/result_mtx
add wave -noupdate /sequence_multiplier_tb/sm/done
add wave -noupdate -expand /sequence_multiplier_tb/sm/multiplier_a
add wave -noupdate -expand /sequence_multiplier_tb/sm/multiplier_b
add wave -noupdate /sequence_multiplier_tb/sm/multiplier_ready
add wave -noupdate /sequence_multiplier_tb/sm/multiplier_done
add wave -noupdate /sequence_multiplier_tb/sm/multiplier_result
add wave -noupdate -expand /sequence_multiplier_tb/sm/gate_mtx
add wave -noupdate /sequence_multiplier_tb/sm/gate_ready
add wave -noupdate /sequence_multiplier_tb/sm/gate_done
add wave -noupdate /sequence_multiplier_tb/sm/gate_to_read
add wave -noupdate /sequence_multiplier_tb/sm/cache_first
add wave -noupdate /sequence_multiplier_tb/sm/state
add wave -noupdate /sequence_multiplier_tb/sm/gmt/clk
add wave -noupdate /sequence_multiplier_tb/sm/gmt/reset
add wave -noupdate /sequence_multiplier_tb/sm/gmt/gate
add wave -noupdate /sequence_multiplier_tb/sm/gmt/ready
add wave -noupdate /sequence_multiplier_tb/sm/gmt/done
add wave -noupdate /sequence_multiplier_tb/sm/gmt/index
add wave -noupdate /sequence_multiplier_tb/sm/gmt/last_index
add wave -noupdate /sequence_multiplier_tb/sm/gmt/row
add wave -noupdate /sequence_multiplier_tb/sm/gmt/column
add wave -noupdate /sequence_multiplier_tb/sm/gmt/imag
add wave -noupdate /sequence_multiplier_tb/sm/gmt/dataout_sig
add wave -noupdate /sequence_multiplier_tb/sm/gmt/init_busy_sig
add wave -noupdate /sequence_multiplier_tb/sm/gmt/address_sig
add wave -noupdate /sequence_multiplier_tb/sm/gmt/done_pulse
add wave -noupdate /sequence_multiplier_tb/sm/gmt/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1270867 ps} 0}
configure wave -namecolwidth 346
configure wave -valuecolwidth 327
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
WaveRestoreZoom {1005076 ps} {1310026 ps}
