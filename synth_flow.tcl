# Set current directory root as variable
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/

set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set STAGES $SCRIPTS/stages
set OUTPUT $ROOT/out
set OUT_RPT $OUTPUT/reports

# Intermediate files used between flows
set OUTPUT_INTER $OUTPUT/intermediate
set OUT_DSN $OUTPUT_INTER/design
set OUT_GEN $OUTPUT_INTER/genus_to_innovus

# Set paths for scripts, Verilog files and library root
set_db init_lib_search_path $LIB_ROOT
set_db init_hdl_search_path $DATA 
set_db script_search_path   $SCRIPTS

# Load technology libraries
source [ file join $STAGES init_libraries.tcl ]
# Prepare HDL
source [ file join $STAGES load_hdl.tcl ]
# Declare timing constraints
source [ file join $STAGES make_sdc.tcl]

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
report_area > $OUT_RPT/area.txt
report_power > $OUT_RPT/power.txt
report_timing > $OUT_RPT/timing.txt
report_gates > $OUT_RPT/gates.txt
report_qor > $OUT_RPT/qor.txt

# Export final design+constraints used
write_hdl > $OUT_DSN/design.v
write_sdc > $OUT_DSN/constraints.sdc

# Export final design files for Innovus
write_design -innovus picorv32
file rename ./genus_invs_des $OUT_GEN
