# Get global settings
source ./global_vars.tcl

# Set script+report directories
set SYNTH_SCRIPTS $SCRIPTS/synth
set SYNTH_REPORTS $OUTPUT/synth-reports

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
syn_generic

# LEC: check elaboration -> generic (post-generic)
write_netlist -lec > $INTERM_SYNTH/lec/post_generic.v
write_do_lec -top picorv32 -golden_design $INTERM_SYNTH/lec/post_elab.v \
 -revised_design $INTERM_SYNTH/lec/post_generic.v \
 -log_file lec_postgeneric.log > $INTERM_SYNTH/lec/post_generic.do

syn_map

# LEC again: check generic -> map (post-map)
write_netlist -lec > $INTERM_SYNTH/lec/post_map.v
write_do_lec -top picorv32 -golden_design $INTERM_SYNTH/lec/post_generic.v \
 -revised_design $INTERM_SYNTH/lec/post_map.v \
 -log_file lec_postmap.log > $INTERM_SYNTH/lec/post_map.do

syn_opt

# Export reports
report_area > $SYNTH_REPORTS/area.txt
report_power > $SYNTH_REPORTS/power.txt
report_timing > $SYNTH_REPORTS/timing.txt
report_gates > $SYNTH_REPORTS/gates.txt
report_qor > $SYNTH_REPORTS/qor.txt
report_clock_gating > $SYNTH_REPORTS/clockgating.txt

# Export final design+constraints used
write_hdl > $INTERM_SYNTH/design/design.v
write_sdc > $INTERM_SYNTH/design/constraints.sdc

# Export final design files for Innovus
write_design -base_name $INTERM_GENUS_INV/picorv32 -innovus picorv32
