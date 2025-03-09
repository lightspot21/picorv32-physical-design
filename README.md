# PicoRV32 physical design

This is a Cadence IC flow for analysis and implementation of the
[PicoRV32](https://github.com/YosysHQ/picorv32) RISC-V CPU, done
as a 6-month-long course project for my digital VLSI design class.

This implementation is based around `gpdk045`, which is a generic
45nm PDK (process development kit) included with the Cadence suite.

# Usage

You need access to the Cadence IC design suite for these to work.
First of all, run the synthesis step (Verilog to netlist):
```
genus
source synth-flow.tcl
```

Afterwards, use Innovus for physical implementation:
```
innovus
source layout-flow.tcl
```

For any tweaks, refer to the relevant Tcl source file.
