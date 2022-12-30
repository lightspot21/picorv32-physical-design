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
create_pg_pin -name VDD -net VDD -geom Metal11 0 13 12 19
create_pg_pin -name VSS -net VSS -geom Metal11 0 201 6 207
update_power_vias -add_vias 1 -top_layer Metal11 -bottom_layer Metal10 -area {9 13 12 19}
update_power_vias -add_vias 1 -top_layer Metal11 -bottom_layer Metal10 -area {3 201 6 207}

# Create follow pins (logic-to-power connections)
set_db route_special_via_connect_to_shape { stripe }
route_special -connect core_pin \
 -layer_change_range { Metal1(1) Metal11(11) } \
 -block_pin_target nearest_target \
 -core_pin_target first_after_row_end \
 -allow_jogging 1 \
 -crossover_via_layer_range { Metal1(1) Metal11(11) } \
 -nets { VSS VDD } -allow_layer_change 1 \
 -target_via_layer_range { Metal1(1) Metal11(11) }
