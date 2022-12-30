# Floorplan mode (fast placement, may be illegal)
# Also implies set_db place_global_cong_effort low
set_db place_design_floorplan_mode true

# Whether to perform legal
set_db place_design_refine_place true

# Control congestion effort (low/med/high/auto)
set_db place_global_cong_effort auto

# whether to place i/o pins based on placement inst
set_db place_global_place_io_pins true

# Control timing-driven place effort
# (by default place_design runs timing-based placement)
set_db place_global_timing_effort high

# Clock-gate-aware placement
set_db place_global_clock_gate_aware true

# Power-driven placement (activity+clock)
# set_db place_global_activity_power_driven
# set_db place_global_activity_power_driven_effort
# set_db place_global_clock_power_driven_effort
# set_db place_global_clock_power_driven

# Simplify netlist
set_db opt_remove_redundant_insts true

# Reclaim area (default/false/true)
# (this is for preroute, postroute: opt_post_route_area_reclaim)
# (In case of custom target slack: opt_setup_target_slack)
set_db opt_area_recovery default
