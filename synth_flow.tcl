# Get global settings
source ./global_vars.tcl

# Set script+report directories
set SYNTH_SCRIPTS $SCRIPTS/synth
set SYNTH_REPORTS $OUTPUT/synth-reports

# Intermediate files used between flows
set SYNTH_INTERM $INTERMEDIATE/synth

# Set paths for scripts, Verilog files and library root
set_db init_lib_search_path $LIB_ROOT
set_db init_hdl_search_path $DATA 
set_db script_search_path   $SYNTH_SCRIPTS

# Load technology libraries
source [ file join $SYNTH_SCRIPTS init_libraries.tcl ]
# Prepare HDL
source [ file join $SYNTH_SCRIPTS load_hdl.tcl ]
# Declare timing constraints
source [ file join $SYNTH_SCRIPTS make_sdc.tcl]

# Check if timing constraints are complete
check_timing_intent

# If we're ok after all these, synthesize!
# (with optimizations too)
# TODO: add Logic Equivalence Checking (LEC) steps
# in the flow between elaboration+generic+map+opt

set_db / .dft_scan_style muxed_scan
set_db / .dft_prefix DFT_
set_db / .dft_identify_top_level_test_clocks true
set_db / .dft_identify_test_signals true
set_db / .dft_identify_internal_test_clocks false
set_db / .use_scan_seqs_for_non_dft false

set_db "design:picorv32" .dft_scan_map_mode tdrc_pass
set_db "design:picorv32" .dft_connect_shift_enable_during_mapping tie_off
set_db "design:picorv32" .dft_connect_scan_data_pins_during_mapping loopback
set_db "design:picorv32" .dft_scan_output_preference auto
set_db "design:picorv32" .dft_lockup_element_type preferred_level_sensitive
set_db "design:picorv32" .dft_mix_clock_edges_in_scan_chains true

define_test_clock -name scanclk -period 5000 [get_clock_ports]
define_shift_enable -name se -active high -create_port se
define_test_mode -name test_mode -active high -create_port test_mode
define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -shift_enable se -create_ports

check_dft_rules > $SYNTH_REPORTS/dft_rules.txt

report_scan_registers > $SYNTH_REPORTS/dft_scan_regs.txt
report_scan_setup > $SYNTH_REPORTS/dft_scan_setup.txt

report_area > $SYNTH_REPORTS/area_pregen.txt
report_power > $SYNTH_REPORTS/power_pregen.txt
report_timing > $SYNTH_REPORTS/timing_pregen.txt
report_gates > $SYNTH_REPORTS/gates_pregen.txt
report_qor > $SYNTH_REPORTS/qor_pregen.txt
report_clock_gating > $SYNTH_REPORTS/clockgating_pregen.txt

syn_generic
syn_map
syn_opt

# Export reports
report_area > $SYNTH_REPORTS/area_postopt.txt
report_power > $SYNTH_REPORTS/power_postopt.txt
report_timing > $SYNTH_REPORTS/timing_postopt.txt
report_gates > $SYNTH_REPORTS/gates_postopt.txt
report_qor > $SYNTH_REPORTS/qor_postopt.txt
report_clock_gating > $SYNTH_REPORTS/clockgating_postopt.txt

check_dft_rules -advanced > $SYNTH_REPORTS/dft_rules_adv.txt
connect_scan_chains -auto_create_chains
report_scan_chains > $SYNTH_REPORTS/dft_scan_chains.txt
check_design -undriven -report_scan_pins

# Export final design+constraints used
write_hdl > $SYNTH_INTERM/design/design.v
write_sdc > $SYNTH_INTERM/design/constraints.sdc

# Export final design files for Innovus
write_design -base_name $INTERM_GENUS_INV/picorv32 -innovus picorv32
