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

# Place design (no opts)
place_design
opt_design

# Early power rail analysis
source [ file join $LAYOUT_SCRIPTS early_power_rail.tcl ]
