source test_utils.do
compile dist.sv
compile add_ex.sv
compile complex_fix_mul.sv
compile fix_mul.sv
compile mult_unit.v
compile squarer.v
compile_tb clockGen.v
compile_tb dist_tb.sv
simulate test_dist_format dist_tb "100"

