#set_power_output_dir interm/layout/power_analysis
#set_default_switching_activity -input_activity 0.2 -period 10.0
#read_activity_file -reset
#set_power -reset
#set_powerup_analysis -reset
#set_dynamic_power_simulation -reset
#report_power -rail_analysis_format VS -out_file interm/layout/power_analysis/picorv32.rpt

# Early power rail analysis
# NOTE: xd (accelerated) accuracy means early, hd means signoff
#set_rail_analysis_config -method era_static \
# -power_switch_eco false -write_movies false \
# -write_voltage_waveforms false \
# -write_decap_eco true \
# -accuracy xd \
# -analysis_view default_emulate_view \
# -process_techgen_em_rules false \
# -enable_rlrp_analysis false \
# -extraction_tech_file ../../../../../apps/prebuilt/EDA/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch \
# -voltage_source_search_distance 50 \
# -ignore_shorts false -enable_mfg_effects false \
# -report_via_current_direction false
