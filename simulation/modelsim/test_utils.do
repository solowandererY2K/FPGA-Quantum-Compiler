set base_dir [file normalize [file join [file dirname [info script]] ".." ".."]]
set include_dir [file normalize [file join $base_dir "include"]]
set src_dir [file normalize [file join $base_dir "src"]]
set test_dir [file normalize [file join $base_dir "tests"]]
proc compile_item {f} {vlog +incdir+$::include_dir -reportprogress 300 -work work $f}
proc compile {f} {compile_item [file join $::src_dir $f]}
proc compile_tb {f} {compile_item [file join $::test_dir $f]}
proc simulate {init module ns} {vsim -L lpm_ver -L altera_mf_ver -do "source $init.do;run ${ns}ns" -gui work.$module}
