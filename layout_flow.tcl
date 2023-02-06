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
#place_design
#opt_design
# or at the same time:
place_opt_design

# Check placement
check_place

# Generate reports
report_area > $LAYOUT_REPORTS/area_prects.txt
report_power > $LAYOUT_REPORTS/power_prects.txt
report_timing > $LAYOUT_REPORTS/timing_prects.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_prects.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_prects.txt

# Early power rail analysis
#source [ file join $LAYOUT_SCRIPTS early_power_rail.tcl ]

# Early global route
source [ file join $LAYOUT_SCRIPTS early_global_route.tcl ]

# Clock tree synthesis
source [ file join $LAYOUT_SCRIPTS create_clock_tree.tcl ]

report_clock_trees > $LAYOUT_REPORTS/clocktree.txt
report_skew_groups > $LAYOUT_REPORTS/clocktree_skew.txt

report_area > $LAYOUT_REPORTS/area_postcts.txt
report_power > $LAYOUT_REPORTS/power_postcts.txt
report_timing > $LAYOUT_REPORTS/timing_postcts.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_postcts.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_postcts.txt

# Commence final detailed routing
set_db route_design_top_routing_layer 11
set_db route_design_bottom_routing_layer 1
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true
route_design -global_detail -via_opt


