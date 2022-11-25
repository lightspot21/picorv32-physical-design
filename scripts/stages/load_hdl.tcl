# Insert clock gating circuitry
set_db lp_insert_clock_gating true

# Read the Verilog in (with syntax check)
read_hdl picorv32.v

# Parse + optimize the Verilog
#
# NOTE: There are multiple designs that are
# recognized as top-level after read_hdl and a simple
# elaboration. 
# By passing the desired module as argument we
# only work on that and its dependencies -> it's also
# set as top-level automatically
elaborate picorv32

# Check design for completeness
check_design -all

# Top-level module after elaboration is given by
# current_design. If ambiguous (not the case here)
# we can choose with set_top_module which one we
# want to work with.

set MODULE_NAME [ current_design ]
puts "<=INFO=> Current top level module: $MODULE_NAME"
