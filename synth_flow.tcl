# Set current directory root as variable
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/

set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set STAGES $SCRIPTS/stages

# Set paths for scripts, Verilog files and library root
set_db init_lib_search_path $LIB_ROOT
set_db init_hdl_search_path $DATA 
set_db script_search_path   $SCRIPTS

source [ file join $STAGES init_libraries.tcl ]
source [ file join $STAGES load_hdl.tcl ]

# Read design constraints (from script searchpath)
#read_sdc { constraints/timing.sdc }
