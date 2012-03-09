source test_utils.do
compile complex_fix_mul_clocked.sv
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
compile sequence_generator.sv
compile sequence_multiplier.sv
compile_tb clockGen.v
compile_tb coordinator_tb.sv
simulate test_coordinator_format coordinator_tb 20000
