source ./global_vars.tcl

if { ![is_common_ui_mode] } {
    error "Run this script with Stylus. 'innovus -stylus -files <script.tcl>"
}

read_mmmc $INTERM_GENUS_INV/genus.mmmc.tcl
read_physical -lef { $LIB_ROOT/lef/gsclib045_tech.lef $LIB_ROOT/lef/gsclib045_macro.lef }

read_netlist $INTERM_GENUS_INV/genus.v

init_design
