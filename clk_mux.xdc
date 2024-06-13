set_false_path -from [get_pins CPRI_BLOCK/master_lane_reg/C] -to [get_pins CPRI_BLOCK/BUFGMUX_inst/CE1]
set_false_path -from [get_pins CPRI_BLOCK/master_lane_reg/C] -to [get_pins CPRI_BLOCK/BUFGMUX_inst/CE0]

create_generated_clock -name clkmux1 -source [get_pins CPRI_BLOCK/BUFGMUX_inst/I0] -divide_by 1 -add -master_clock rxoutclk_out[0] [get_pins CPRI_BLOCK/BUFGMUX_inst/O]
create_generated_clock -name clkmux2 -source [get_pins CPRI_BLOCK/BUFGMUX_inst/I1] -divide_by 1 -add -master_clock rxoutclk_out[0]_1 [get_pins CPRI_BLOCK/BUFGMUX_inst/O]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {rxoutclk_out[0]}] -group [get_clocks -include_generated_clocks {rxoutclk_out[0]_1}]

