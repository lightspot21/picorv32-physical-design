# Select timing library, physical lib cells (lef)
# and parasitic capacitances (qrc)
#
# NOTE: Relative paths here since search paths for
# libraries are already set

puts $LIB_ROOT
set_db library { timing/slow_vdd1v0_basicCells.lib }
set_db lef_library { lef/gsclib045_tech.lef lef/gsclib045_macro.lef }
read_qrc qrc/qx/gpdk045.tch

# Don't let Genus insert clock gating cells
set_db lp_insert_clock_gating false

