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
syn_generic
syn_map
syn_opt

# Export reports
report_area > $SYNTH_REPORTS/area.txt
report_power > $SYNTH_REPORTS/power.txt
report_timing > $SYNTH_REPORTS/timing.txt
report_gates > $SYNTH_REPORTS/gates.txt
report_qor > $SYNTH_REPORTS/qor.txt
report_clock_gating > $SYNTH_REPORTS/clockgating.txt

# Export final design+constraints used
write_hdl > $SYNTH_INTERM/design/design.v
write_sdc > $SYNTH_INTERM/design/constraints.sdc

# Export final design files for Innovus
write_design -base_name $INTERM_GENUS_INV/picorv32 -innovus picorv32
