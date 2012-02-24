proc compile {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/$f}
compile clockGen.v
compile complex_fix_mul.sv
compile complex_matrix_multiplier.sv
compile gate_matrix_table.sv
compile gate_rom.v
compile mult_unit.v
compile fixmul.v
compile sequence_multiplier.sv
compile sequence_multiplier_tb.sv
vsim -L lpm_ver -L altera_mf_ver -do FPGACompiler_run_msim_rtl_verilog.do -l msim_transcript -gui work.sequence_multiplier_tb
source test_sequence_generator_format.do
run 3000ns
