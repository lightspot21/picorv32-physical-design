# Early power rail analysis

#set_power_analysis_mode -reset
#set_analysis_view
#set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
#
#
#set_rail_analysis_mode -method era_static -power_switch_eco false -generate_movies false -save_voltage_waveforms false -generate_decap_eco true -accuracy xd -analysis_view default_emulate_view -process_techgen_em_rules false -enable_rlrp_analysis false -extraction_tech_file ../../../../../apps/prebuilt/EDA/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch -vsrc_search_distance 50 -ignore_shorts false -enable_manufacturing_effects false -report_via_current_direction false
#set_rail_analysis_config -method era_static -power_switch_eco false -write_movies false -write_voltage_waveforms false -write_decap_eco true -accuracy xd -analysis_view default_emulate_view -process_techgen_em_rules false -enable_rlrp_analysis false -extraction_tech_file ../../../../../apps/prebuilt/EDA/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch -voltage_source_search_distance 50 -ignore_shorts false -enable_mfg_effects false -report_via_current_direction false
