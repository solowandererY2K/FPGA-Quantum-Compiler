onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /sequence_multiplier_tb/clk
add wave -noupdate -format Logic /sequence_multiplier_tb/reset
add wave -noupdate -format Literal /sequence_multiplier_tb/seq_index
add wave -noupdate -format Literal /sequence_multiplier_tb/seq_gate
add wave -noupdate -format Logic /sequence_multiplier_tb/ready
add wave -noupdate -format Logic /sequence_multiplier_tb/first
add wave -noupdate -format Logic /sequence_multiplier_tb/available
add wave -noupdate -format Literal /sequence_multiplier_tb/result_mtx
add wave -noupdate -format Logic /sequence_multiplier_tb/done
add wave -noupdate -format Literal /sequence_multiplier_tb/mtx_a
add wave -noupdate -format Literal /sequence_multiplier_tb/mtx_b
add wave -noupdate -format Literal /sequence_multiplier_tb/multiplier_result
add wave -noupdate -format Logic /sequence_multiplier_tb/multiplier_ready
add wave -noupdate -format Logic /sequence_multiplier_tb/multiplier_done
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/clk
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/reset
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/seq_index
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/seq_gate
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/ready
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/first
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/available
add wave -noupdate -format Literal -expand /sequence_multiplier_tb/sm/result_mtx
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/done
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/multiplier_a
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/multiplier_b
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/multiplier_ready
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/multiplier_done
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/multiplier_result
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/gate_mtx
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/gate_ready
add wave -noupdate -format Logic /sequence_multiplier_tb/sm/gate_done
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/gate_to_read
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/cache_first
add wave -noupdate -format Literal /sequence_multiplier_tb/sm/state
add wave -noupdate -format Logic /sequence_multiplier_tb/cmm/reset
add wave -noupdate -format Logic /sequence_multiplier_tb/cmm/clk
add wave -noupdate -format Literal /sequence_multiplier_tb/cmm/mtx_a
add wave -noupdate -format Literal /sequence_multiplier_tb/cmm/mtx_b
add wave -noupdate -format Logic /sequence_multiplier_tb/cmm/ready
add wave -noupdate -format Literal /sequence_multiplier_tb/cmm/mtx_r
add wave -noupdate -format Logic /sequence_multiplier_tb/cmm/completed
add wave -noupdate -format Literal -expand /sequence_multiplier_tb/cmm/w_mult_results
add wave -noupdate -format Logic /sequence_multiplier_tb/cmm/mult_completed
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/x}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/y}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/out}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/a}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/b}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/c}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/d}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/ac}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/bd}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/bc}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/ad}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/a}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/b}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/result}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/abs_a}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/abs_b}
add wave -noupdate -format Logic {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/sign}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/full_result}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/unrounded_result}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/mult/dataa}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/mult/datab}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/mult/result}
add wave -noupdate -format Literal {/sequence_multiplier_tb/cmm/R[0]/C[1]/I[1]/cell_mul/mult_ac/mult/sub_wire0}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2998106 ps} 0}
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
WaveRestoreZoom {2991519 ps} {2998728 ps}
