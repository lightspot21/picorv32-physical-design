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

# Set up PDN

# Create power rings (VDD, VSS)
# (width = spacing = 3 microns, centered in channel
# between core and I/O)
add_rings -nets {VDD VSS} -type core_rings -follow core \
 -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} \
 -width {top 3 bottom 3 left 3 right 3} \
 -spacing {top 3 bottom 3 left 3 right 3} \
 -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
 -center 1 -threshold 0

# Create power stripes (VDD, VSS)
# (3 pairs, same width and spacing as with rings)
add_stripes -nets {VDD VSS} -layer Metal10 \
 -direction vertical \
 -width 3 -spacing 3 -number_of_sets 3

# Connect global nets VDD and VSS
connect_global_net VDD -type pg_pin -pin_base_name VDD -all
connect_global_net VDD -type tie_hi -inst_base_name *
connect_global_net VSS -type pg_pin -pin_base_name VSS -all
connect_global_net VSS -type tie_lo -inst_base_name *

# Create power+ground pins and connect with rings
create_pg_pin -name VDD -net VDD -geom Metal11 0 9 12 18
create_pg_pin -name VSS -net VSS -geom Metal11 0 201.8 8 218.8
update_power_vias -add_vias 1 -top_layer Metal11 -bottom_layer Metal10 -area {10 16 11 17}
