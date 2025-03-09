#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Feb  8 14:13:55 2023                
#                                                     
#######################################################

#@(#)CDS: Innovus v19.11-s128_1 (64bit) 08/20/2019 20:54 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 19.11-s128_1 NR190815-2055/19_11-UB (database version 18.20, 469.7.1) {superthreading v1.51}
#@(#)CDS: AAE 19.11-s034 (64bit) 08/20/2019 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 19.11-s040_1 () Aug  1 2019 08:53:57 ( )
#@(#)CDS: SYNTECH 19.11-e010_1 () Jul 15 2019 20:31:02 ( )
#@(#)CDS: CPE v19.11-s006
#@(#)CDS: IQuantus/TQuantus 19.1.2-s245 (64bit) Thu Aug 1 10:22:01 PDT 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

#@ Begin verbose source layout_flow.tcl (pre)
#@ Begin verbose source ./global_vars.tcl (pre)
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/
set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set OUTPUT $ROOT/out
set INTERMEDIATE $ROOT/interm
set INTERM_GENUS_INV $INTERMEDIATE/genus_to_innovus
#@ End verbose source ./global_vars.tcl
set LAYOUT_SCRIPTS $SCRIPTS/layout
set LAYOUT_REPORTS $OUTPUT/layout-reports
set LAYOUT_INTERM  $INTERMEDIATE/layout
read_mmmc $INTERM_GENUS_INV/picorv32.mmmc.tcl
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/interm/genus_to_innovus/picorv32.mmmc.tcl (pre)
create_library_set -name default_emulate_libset_max \
    -timing { /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045//timing/fast_vdd1v0_basicCells.lib }
create_opcond -name default_emulate_opcond -process 1.0 -voltage 1.1 -temperature 0.0
create_timing_condition -name default_emulate_timing_cond_max \
    -opcond default_emulate_opcond \
    -library_sets { default_emulate_libset_max }
create_rc_corner -name default_emulate_rc_corner \
    -temperature 0.0 \
    -qrc_tech /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045//qrc/qx/gpdk045.tch \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}
create_delay_corner -name default_emulate_delay_corner \
    -early_timing_condition { default_emulate_timing_cond_max } \
    -late_timing_condition { default_emulate_timing_cond_max } \
    -early_rc_corner default_emulate_rc_corner \
    -late_rc_corner default_emulate_rc_corner
create_constraint_mode -name default_emulate_constraint_mode \
    -sdc_files { /mnt/scratch_b/users/g/grigpavl/project-asic-2022/interm/genus_to_innovus/picorv32.default_emulate_constraint_mode.sdc }
create_analysis_view -name default_emulate_view \
    -constraint_mode default_emulate_constraint_mode \
    -delay_corner default_emulate_delay_corner
set_analysis_view -setup { default_emulate_view } \
                  -hold { default_emulate_view }
#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/interm/genus_to_innovus/picorv32.mmmc.tcl
read_physical -lef [ list "$LIB_ROOT/lef/gsclib045_tech.lef" "$LIB_ROOT/lef/gsclib045_macro.lef" ]
read_netlist $INTERM_GENUS_INV/picorv32.v
set_db init_power_nets VDD
set_db init_ground_nets VSS
init_design
create_floorplan -site CoreSite -core_density_size 1 0.75 15 15 15 15
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/create_pdn.tcl (pre)
add_rings -nets {VDD VSS} -type core_rings -follow core \
 -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} \
 -width {top 3 bottom 3 left 3 right 3} \
 -spacing {top 3 bottom 3 left 3 right 3} \
 -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
 -center 1 -threshold 0
add_stripes -nets {VDD VSS} -layer Metal10 \
 -direction vertical \
 -width 3 -spacing 3 -number_of_sets 3
connect_global_net VDD -type pg_pin -pin_base_name VDD -all
connect_global_net VDD -type tie_hi -inst_base_name *
connect_global_net VSS -type pg_pin -pin_base_name VSS -all
connect_global_net VSS -type tie_lo -inst_base_name *
create_pg_pin -name VDD -net VDD -geom Metal11 0 13 12 19
create_pg_pin -name VSS -net VSS -geom Metal11 0 201 6 207
update_power_vias -add_vias 1 -top_layer Metal11 -bottom_layer Metal10 -area {9 13 12 19}
update_power_vias -add_vias 1 -top_layer Metal11 -bottom_layer Metal10 -area {3 201 6 207}
set_db route_special_via_connect_to_shape { stripe }
route_special -connect core_pin \
 -layer_change_range { Metal1(1) Metal11(11) } \
 -block_pin_target nearest_target \
 -core_pin_target first_after_row_end \
 -allow_jogging 1 \
 -crossover_via_layer_range { Metal1(1) Metal11(11) } \
 -nets { VSS VDD } -allow_layer_change 1 \
 -target_via_layer_range { Metal1(1) Metal11(11) }
#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/create_pdn.tcl
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/configure_placement.tcl (pre)
set_db place_design_floorplan_mode false
set_db place_design_refine_place true
set_db place_global_cong_effort auto
set_db place_global_place_io_pins true
set_db opt_effort high 
set_db opt_power_effort none 
set_db opt_remove_redundant_insts true
set_db opt_area_recovery default
set_db opt_leakage_to_dynamic_ratio 1.0
#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/configure_placement.tcl
place_design
opt_design -pre_cts
check_place
report_area > $LAYOUT_REPORTS/area_prects.txt
report_power > $LAYOUT_REPORTS/power_prects.txt
time_design -pre_cts -slack_report > $LAYOUT_REPORTS/timing_setup_prects.txt
time_design -pre_cts -hold -slack_report > $LAYOUT_REPORTS/timing_hold_prects.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_prects.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_prects.txt
report_route -summary > $LAYOUT_REPORTS/route_prects.txt
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/early_power_rail.tcl (pre)
set_db power_method static
set_db power_view default_emulate_view
set_db power_corner max
set_db power_write_db true
set_db power_write_static_currents true
set_db power_honor_negative_energy true
set_db power_ignore_control_signals true
set_power_output_dir interm/layout/power_analysis
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
set_power -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -out_file interm/layout/power_analysis/picorv32.rpt
set_rail_analysis_config -method era_static \
 -power_switch_eco false -write_movies false \
 -write_voltage_waveforms false \
 -write_decap_eco true \
 -accuracy xd \
 -analysis_view default_emulate_view \
 -process_techgen_em_rules false \
 -enable_rlrp_analysis false \
 -extraction_tech_file ../../../../../apps/prebuilt/EDA/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch \
 -voltage_source_search_distance 50 \
 -ignore_shorts false -enable_mfg_effects false \
 -report_via_current_direction false
write_power_pads -auto_fetch -net VDD -voltage_source_file interm/layout/power_analysis/picorv32_vdd.pp
set_pg_nets -net VDD -voltage 1.1 -threshold 1.0
set_power_data -format current -scale 1 interm/layout/power_analysis/static_VDD.ptiavg
set_power_pads -net VDD -format xy -file interm/layout/power_analysis/picorv32_vdd.pp
set_package -spice_model_file {} -mapping_file {}
report_rail -type net -results_directory interm/layout/power_analysis VDD
read_power_rail_results \
 -power_db interm/layout/power_analysis/power.db \
 -rail_directory interm/layout/power_analysis/VDD_25C_avg_1 \
 -instance_voltage_window { timing whole } \
 -instance_voltage_method { worst best avg worstavg } \

#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/early_power_rail.tcl
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/early_global_route.tcl (pre)
#@ Begin verbose source ./global_vars.tcl (pre)
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/
set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set OUTPUT $ROOT/out
set INTERMEDIATE $ROOT/interm
set INTERM_GENUS_INV $INTERMEDIATE/genus_to_innovus
#@ End verbose source ./global_vars.tcl
set_db route_early_global_bottom_routing_layer 1
set_db route_early_global_top_routing_layer 11
route_early_global
#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/early_global_route.tcl
#@ Begin verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/create_clock_tree.tcl (pre)
#@ Begin verbose source ./global_vars.tcl (pre)
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/
set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set OUTPUT $ROOT/out
set INTERMEDIATE $ROOT/interm
set INTERM_GENUS_INV $INTERMEDIATE/genus_to_innovus
#@ End verbose source ./global_vars.tcl
create_route_rule -name NDR_ClockTree \
 -width {Metal1 0.12 Metal2 0.16 Metal3 0.16 Metal4 0.16 Metal5 0.16 Metal6 0.16 Metal7 0.16 Metal8 0.16 Metal9 0.16 Metal10 0.44 Metal11 0.44 } \
 -spacing {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 Metal10 0.4 Metal11 0.4 } \

create_route_type -name ClockTrack -top_preferred_layer 9 -bottom_preferred_layer 5 -route_rule NDR_ClockTree
set_db cts_route_type_leaf ClockTrack
set_db cts_route_type_trunk ClockTrack
set_db cts_target_skew 0.1
set_db cts_target_max_transition_time 0.15
create_clock_tree_spec -out_file interm/layout/clocktree.spec
ccopt_design
#@ End verbose source /mnt/scratch_b/users/g/grigpavl/project-asic-2022/scripts/layout/create_clock_tree.tcl
report_clock_trees > $LAYOUT_REPORTS/clocktree.txt
report_skew_groups > $LAYOUT_REPORTS/clocktree_skew.txt
opt_design -post_cts
report_area > $LAYOUT_REPORTS/area_postcts.txt
report_power > $LAYOUT_REPORTS/power_postcts.txt
time_design -post_cts -slack_report > $LAYOUT_REPORTS/timing_setup_postcts.txt
time_design -post_cts -hold -slack_report > $LAYOUT_REPORTS/timing_hold_postcts.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_postcts.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_postcts.txt
report_route -summary > $LAYOUT_REPORTS/route_postcts.txt
set_db route_design_top_routing_layer 11
set_db route_design_bottom_routing_layer 1
set_db route_design_concurrent_minimize_via_count_effort high
set_db route_design_detail_fix_antenna true
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true
route_design -global_detail -via_opt
set_db timing_analysis_type ocv
opt_design -post_route
report_area > $LAYOUT_REPORTS/area_postroute.txt
report_power > $LAYOUT_REPORTS/power_postroute.txt
report_gate_count -out_file $LAYOUT_REPORTS/gates_postroute.txt
report_qor -format text -file $LAYOUT_REPORTS/qor_postroute.txt
report_route -summary > $LAYOUT_REPORTS/route_postroute.txt
time_design -post_route -slack_report > $LAYOUT_REPORTS/timing_setup_postroute.txt
time_design -post_route -hold -slack_report > $LAYOUT_REPORTS/timing_hold_postroute.txt
set_db timing_analysis_type single
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
set_metal_fill -layer { Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11 } -opc_active_spacing 0.200 -min_density 10.00
add_metal_fill -layer { Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11 } -nets { VSS VDD }
#@ End verbose source layout_flow.tcl
