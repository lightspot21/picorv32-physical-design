source ./global_vars.tcl

# Prepare Innovus with Genus exported design
source $INTERM_GENUS_INV/picorv32.invs_setup.tcl

# Set up floorplan
# (aspect ratio 1, core util 75%, 15 micron
# margin all sides for I/O)
#
create_floorplan -site CoreSite -core_density_size 1 0.75 15 15 15 15

