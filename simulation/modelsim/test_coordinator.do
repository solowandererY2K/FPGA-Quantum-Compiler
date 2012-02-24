proc compile {f} {vlog -reportprogress 300 -work work Z:/fpga-compiler/FPGA-Quantum-Compiler/$f}
compile clockGen.v
compile complex_fix_mul.sv
compile complex_matrix_multiplier.sv
compile gate_matrix_table.sv
compile gate_rom.v
compile mult_unit.v
compile fixmul.v
compile sequence_multiplier.sv
compile coordinator.sv
compile serial_number_decoder.sv
compile serial_matrix_decoder.sv
compile coordinator_tb.sv
vsim -L lpm_ver -L altera_mf_ver -do "source test_coordinator_format.do;run 2000ns" -gui work.coordinator_tb
