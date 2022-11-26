source ./global_vars.tcl

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

add_rings -nets {VDD VSS} -type core_rings -follow core \
 -layer {top Metal1 bottom Metal1 left Metal2 right Metal2} \
 -width {top 3 bottom 3 left 3 right 3} \
 -spacing {top 3 bottom 3 left 3 right 3} \
 -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
 -center 1 -threshold 0

add_stripes -nets {VDD VSS} -layer Metal1 \
 -direction horizontal \
 -width 3 -spacing 3 -number_of_sets 3


