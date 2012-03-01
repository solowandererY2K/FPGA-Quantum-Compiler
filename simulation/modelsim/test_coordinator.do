proc compile {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/src/$f}
proc compile_tb {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/tests/$f}
compile complex_fix_mul.sv
compile complex_matrix_multiplier.sv
compile gate_matrix_table.sv
compile gate_rom.v
compile mult_unit.v
compile fix_mul.sv
compile sequence_multiplier.sv
compile coordinator.sv
compile serial_number_decoder.sv
compile serial_matrix_decoder.sv
compile serial_number_encoder.sv
compile serial_matrix_encoder.sv
compile_tb clockGen.v
compile_tb coordinator_tb.sv
vsim -L lpm_ver -L altera_mf_ver -do "source test_coordinator_format.do;run 8000ns" -gui work.coordinator_tb

