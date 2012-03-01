proc compile {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/src/$f}
proc compile_tb {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/tests/$f}
compile complex_fix_mul.sv
compile complex_matrix_multiplier.sv
compile gate_matrix_table.sv
compile gate_rom.v
compile mult_unit.v
compile fix_mul.sv
compile sequence_multiplier.sv
compile_tb clockGen.v
compile_tb sequence_multiplier_tb.sv
vsim -L lpm_ver -L altera_mf_ver -do "source test_sequence_generator_format.do;run 3000ns" -gui work.sequence_multiplier_tb

