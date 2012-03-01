proc compile {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/src/$f}
proc compile_tb {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/tests/$f}
compile complex_fix_mul.sv
compile complex_matrix_multiplier.sv
compile mult_unit.v
compile fix_mul.sv
compile_tb clockGen.v
compile_tb complex_matrix_multiplier_tb.sv
vsim -L lpm_ver -L altera_mf_ver -do "source test_complex_matrix_multiplier_format.do;run 3000ns" -gui work.complex_matrix_multiplier_tb

