# Get global settings
source ./global_vars.tcl

# Set script+report directories
set LAYOUT_SCRIPTS $SCRIPTS/layout
set LAYOUT_REPORTS $OUTPUT/layout-reports

# Intermediate files output
set LAYOUT_INTERM  $INTERMEDIATE/layout

# Prepare Innovus with Genus exported design

read_mmmc $INTERM_GENUS_INV/picorv32.mmmc.tcl
read_physical -lef [ list "$LIB_ROOT/lef/gsclib045_tech.lef" "$LIB_ROOT/lef/gsclib045_macro.lef" ]
read_netlist $INTERM_GENUS_INV/picorv32.v

set_db init_power_nets VDD
set_db init_ground_nets VSS

init_design

# Set up floorplan
# (aspect ratio 1, core util 75%, 15 micron
# margin all sides for I/O)
#
create_floorplan -site CoreSite -core_density_size 1 0.75 15 15 15 15

# Create PDN
source [ file join $LAYOUT_SCRIPTS create_pdn.tcl ]

# Perform cell placement
source [ file join $LAYOUT_SCRIPTS configure_placement.tcl ]

# Place design 
# Note to self: plain place_design => -1.blabla slack
# but opt_design => +6.kati slack. plain place puts cells
# too far away from each other while opt packs them
# as close as possible
place_design
opt_design

# Check placement
check_place

# Generate reports
report_area > $LAYOUT_REPORTS/area_prects.txt
report_power > $LAYOUT_REPORTS/power_prects.txt
time_design -pre_cts -slack_report > $LAYOUT_REPORTS/timing_setup_prects.txt
time_design -pre_cts -hold -slack_report > $LAYOUT_REPORTS/timing_hold_prects.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_prects.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_prects.txt

# Early power rail analysis
source [ file join $LAYOUT_SCRIPTS early_power_rail.tcl ]

# Early global route
source [ file join $LAYOUT_SCRIPTS early_global_route.tcl ]

# Clock tree synthesis
source [ file join $LAYOUT_SCRIPTS create_clock_tree.tcl ]

report_clock_trees > $LAYOUT_REPORTS/clocktree.txt
report_skew_groups > $LAYOUT_REPORTS/clocktree_skew.txt

report_area > $LAYOUT_REPORTS/area_postcts.txt
report_power > $LAYOUT_REPORTS/power_postcts.txt
time_design -post_cts -slack_report > $LAYOUT_REPORTS/timing_setup_postcts.txt
time_design -post_cts -hold -slack_report > $LAYOUT_REPORTS/timing_hold_postcts.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_postcts.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_postcts.txt

# Commence final detailed routing
# (layers 1-11, high effort on vias, timing+SI driven)
set_db route_design_top_routing_layer 11
set_db route_design_bottom_routing_layer 1
set_db route_design_concurrent_minimize_via_count_effort high
set_db route_design_detail_fix_antenna true
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true

route_design -global_detail -via_opt

report_area > $LAYOUT_REPORTS/area_postroute.txt
report_power > $LAYOUT_REPORTS/power_postroute.txt
# default is 'single'
set_db timing_analysis_type ocv
time_design -post_route -slack_report > $LAYOUT_REPORTS/timing_setup_postroute.txt
time_design -post_route -hold -slack_report > $LAYOUT_REPORTS/timing_hold_postroute.txt
set_db timing_analysis_type single
report_gate_count -out_file $LAYOUT_REPORTS/gates_postroute.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_postroute.txt

# Run DRC+connectivity checks
set_db check_drc_disable_rules {}
set_db check_drc_implant true
set_db check_drc_implant_across_rows false
set_db check_drc_ndr_spacing false
set_db check_drc_check_only default
set_db check_drc_inside_via_def false
set_db check_drc_exclude_pg_net false
set_db check_drc_ignore_trial_route false
set_db check_drc_use_min_spacing_on_block_obs auto
set_db check_drc_report $LAYOUT_REPORTS/picorv32.drc.rpt
set_db check_drc_limit 1000

check_drc
check_connectivity -type all

# Fill unused space with metal
set_metal_fill -layer { Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11 } -opc_active_spacing 0.200 -min_density 10.00
add_metal_fill -layer { Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11 } -nets { VSS VDD }

#
#set_db extract_rc_engine post_route
#set_db extract_rc_effort_level signoff
#set_db extract_rc_coupled true 
