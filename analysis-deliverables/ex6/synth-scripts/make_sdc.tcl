# Assumptions:
#
# 1 time unit        (TU) -> 1 nsec
# 1 capacitance unit (CU) -> 1 pF

# Main clock settings
#
# Name: clk
# Period: 10 nsec with 50% duty cycle             (10   TU)
# Latency: 400 psec                               (0.4  TU)
# Uncertainty: 50 psec, both setup + hold         (0.05 TU)
# Transition time: 100 psec, both rise + fall     (0.1  TU)
# (1% of period: 10 TU * 0.01 = 0.1 TU)

create_clock -name clk -period 10 -waveform {0 5} [ get_ports clk ]
set_clock_latency 0.4 [ get_clocks clk ]
set_clock_uncertainty -setup 0.05 [ get_clocks clk ]
set_clock_uncertainty -hold 0.05 [ get_clocks clk ]
set_clock_transition 0.1 [ get_clocks clk ]

# Input/output delay settings
# 
# On setup analysis: 1 nsec  (1.0 TU)
# On hold analysis: 0.4 nsec (0.4 TU)
set_input_delay -clock clk -network_latency_included -max 1.0 [ all_inputs ]
set_output_delay -clock clk -network_latency_included -max 1.0 [ all_outputs ]

set_input_delay -clock clk -network_latency_included -min 0.4 [ all_inputs ]
set_output_delay -clock clk -network_latency_included -min 0.4 [ all_outputs ]

# Output pin load settings
# 
# On setup analysis: 0.5  pF (0.5  CU)
# On hold analysis:  0.01 pF (0.01 CU)
# (NOTE: these may not be correct, exercise says
# that 0.5 is for setup time analysis and I assume
# it is, manual talks about worst/best case. Need
# to review slides)

set_load 0.5 -max -pin_load [ all_outputs ]
set_load 0.01 -min -pin_load [ all_outputs ] 

# Input driving cell settings
# 
# On setup analysis: BUFX2
# On hold analysis: BUFX16

set_driving_cell -lib_cell BUFX2 -max [ all_inputs ]
set_driving_cell -lib_cell BUFX16 -min [ all_inputs ]
