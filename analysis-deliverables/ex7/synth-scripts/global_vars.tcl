# Set current directory root as variable
set ROOT [file normalize [file dirname [info script]]]
set LIB_ROOT /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045/

set DATA $ROOT/data
set SCRIPTS $ROOT/scripts
set OUTPUT $ROOT/out
set INTERMEDIATE $ROOT/interm
set INTERM_GENUS_INV $INTERMEDIATE/genus_to_innovus
set INTERM_SYNTH $INTERMEDIATE/synth
