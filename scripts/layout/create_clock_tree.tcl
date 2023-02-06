# Get global settings
source ./global_vars.tcl

# NDR for clock tree tracks (double spacing+width)
create_route_rule -name NDR_ClockTree \
 -width {Metal1 0.12 Metal2 0.16 Metal3 0.16 Metal4 0.16 Metal5 0.16 Metal6 0.16 Metal7 0.16 Metal8 0.16 Metal9 0.16 Metal10 0.44 Metal11 0.44 } \
 -spacing {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 Metal10 0.4 Metal11 0.4 } \

# Clock tree configuration:
# Routing on layers 9-5 and in between
create_route_type -name ClockTrack \
 -top_preferred_layer 9 -bottom_preferred_layer 5 \ 
 -route_rule NDR_ClockTree \

# Timing targets: max skew 100 ps, max transition time 150 ps
set_db cts_route_type_leaf ClockTrack
set_db cts_route_type_trunk ClockTrack
set_db cts_target_skew 100
set_db cts_target_max_transition_time 150

# Save all constraints (above + SDC)
create_clock_tree_spec -out_file interm/layout/clocktree.spec

# Design clock tree
ccopt_design
