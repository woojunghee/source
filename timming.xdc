
####  Timing Constraint
set_system_jitter 0.010

create_clock -period 4.069 -name jesd_clk [get_ports JESD_REF_CLK_P]
create_clock -period 4.069 -name cpri_clk [get_ports CPRI_REF_CLK_P]
create_clock -period 40.000 -name clk_25m [get_ports FPGA_25MHZ]
create_clock -period 10.000 -name clk_100m
create_clock -period 100.000 -name spi_clk
create_clock -period 130.208 -name rec_clk
create_clock -period 33.333 -name MXL_RSSI_CLK -waveform {0.000 16.667} [get_ports MXL_RSSI_CLK]

set_clock_groups -name ASYNCHRONOUS_CLOCK_GROUP_0 -asynchronous -group [get_clocks -include_generated_clocks jesd_clk]
set_clock_groups -name ASYNCHRONOUS_CLOCK_GROUP_1 -asynchronous -group [get_clocks -include_generated_clocks cpri_clk]
set_clock_groups -name ASYNCHRONOUS_CLOCK_GROUP_2 -asynchronous -group [get_clocks -include_generated_clocks -of_objects [get_pins inst_zynq_ps_wrapper/clk_wiz_0/inst/mmcme4_adv_inst/CLKIN1]]

#create_clock -period 2.712 -name rxoutclk_out[0] [get_pins {CPRI_BLOCK/CPRI_CORE_bank[0].cpri_blk/U0/gt_and_clocks_i/cpri_24g_gt_i/inst/gen_gtwizard_gtye4_top.cpri_24g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[1].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
#create_clock -period 2.712 -name rxoutclk_out[0]_1 [get_pins {CPRI_BLOCK/CPRI_CORE_bank[1].cpri_blk/U0/gt_and_clocks_i/cpri_24g_gt_i/inst/gen_gtwizard_gtye4_top.cpri_24g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[1].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
#create_clock -period 2.712 -name rxoutclk_out[0]_2 [get_pins {CPRI_BLOCK/CPRI_CORE_bank[2].cpri_blk/U0/gt_and_clocks_i/cpri_24g_gt_i/inst/gen_gtwizard_gtye4_top.cpri_24g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[1].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
#create_clock -period 2.712 -name rxoutclk_out[0]_3 [get_pins {CPRI_BLOCK/CPRI_CORE_bank[3].cpri_blk/U0/gt_and_clocks_i/cpri_24g_gt_i/inst/gen_gtwizard_gtye4_top.cpri_24g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[1].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM1DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]

set_max_delay -datapath_only -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells -hier -filter {name =~ *i_rsfec/rx_cdc_i[*].i_rsfec/G_R21_TIMER*.average_handshake_i/q_reg[*]}]] -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/cdc_average_int_reg[*]}]] 8.000
set_max_delay -datapath_only -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells -hier -filter {name =~ *i_rsfec/gen_latency[*].hfec_handshake_i/q_reg[*]}]] -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/hard_fec_lat_val.hfec_fifo_latency_int_reg[*]}]] 8.000


#set_false_path -from [get_pins CPRI_BLOCK/master_lane_reg/C] -to [get_pins CPRI_BLOCK/BUFGMUX_inst/CE1]
#set_false_path -from [get_pins CPRI_BLOCK/master_lane_reg/C] -to [get_pins CPRI_BLOCK/BUFGMUX_inst/CE0]
#
#create_generated_clock -name clkmux1 -source [get_pins CPRI_BLOCK/BUFGMUX_inst/I0] -divide_by 1 -add -master_clock rxoutclk_out[0] [get_pins CPRI_BLOCK/BUFGMUX_inst/O]
#create_generated_clock -name clkmux2 -source [get_pins CPRI_BLOCK/BUFGMUX_inst/I1] -divide_by 1 -add -master_clock rxoutclk_out[0]_1 [get_pins CPRI_BLOCK/BUFGMUX_inst/O]
#set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {rxoutclk_out[0]}] -group [get_clocks -include_generated_clocks {rxoutclk_out[0]_1}]



#set_output_delay -clock rec_clk -max 0.400 [get_ports CPRI_REC_CLK_P]
#set_output_delay -clock rec_clk -min -0.400 [get_ports CPRI_REC_CLK_P]
#
#set_false_path -to [get_ports CPRI_REC_CLK_P]
#
#set_false_path -to [get_ports AFE0_JESD_RX_SYNC_P]
#set_false_path -to [get_ports AFE1_JESD_RX_SYNC_P]
#
#set_false_path -from [get_ports AFE0_JESD_TX_SYNC_P]
#set_false_path -from [get_ports AFE1_JESD_TX_SYNC_P]
#
#set_output_delay -clock jesd_clk -max 0.400 [get_ports AFE0_JESD_RX_SYNC_P]
#set_output_delay -clock jesd_clk -min -0.400 [get_ports AFE0_JESD_RX_SYNC_P]
#set_output_delay -clock jesd_clk -max 0.400 [get_ports AFE1_JESD_RX_SYNC_P]
#set_output_delay -clock jesd_clk -min -0.400 [get_ports AFE1_JESD_RX_SYNC_P]
#
#set_input_delay -clock jesd_clk -max 0.400 [get_ports JESD_SYS_REF_P]
#set_input_delay -clock jesd_clk -min -0.400 [get_ports JESD_SYS_REF_P]
#
#set_input_delay -clock jesd_clk -max 0.400 [get_ports AFE0_JESD_TX_SYNC_P]
#set_input_delay -clock jesd_clk -min -0.400 [get_ports AFE0_JESD_TX_SYNC_P]
#set_input_delay -clock jesd_clk -max 0.400 [get_ports AFE1_JESD_TX_SYNC_P]
#set_input_delay -clock jesd_clk -min -0.400 [get_ports AFE1_JESD_TX_SYNC_P]
#
#set_input_delay -clock clk_100m -max 0.000 [get_ports PL_SRST_B]
#set_input_delay -clock clk_100m -min -0.500 [get_ports PL_SRST_B]
#
#set_output_delay -clock clk_25m -max 0.000 [get_ports L1_RESET]
#set_output_delay -clock clk_25m -min -0.500 [get_ports L1_RESET]
#
#set_output_delay -clock clk_100m -max 0.000 [get_ports {LED_G[*]}]
#set_output_delay -clock clk_100m -min -0.500 [get_ports {LED_G[*]}]
#
#set_output_delay -clock clk_100m -max 0.000 [get_ports {LED_R[*]}]
#set_output_delay -clock clk_100m -min -0.500 [get_ports {LED_R[*]}]
#
#set_input_delay -clock clk_100m -max 0.000 [get_ports {PLL_LOCK[*]}]
#set_input_delay -clock clk_100m -min -0.500 [get_ports {PLL_LOCK[*]}]
#set_input_delay -clock clk_100m -max 0.000 [get_ports {PLL_TYPE[*]}]
#set_input_delay -clock clk_100m -min -0.500 [get_ports {PLL_TYPE[*]}]
#set_input_delay -clock clk_100m -max 0.000 [get_ports SFP_FAULT]
#set_input_delay -clock clk_100m -min -0.500 [get_ports SFP_FAULT]
#set_input_delay -clock clk_100m -max 0.000 [get_ports SFP_INSERT]
#set_input_delay -clock clk_100m -min -0.500 [get_ports SFP_INSERT]
#set_input_delay -clock clk_100m -max 0.000 [get_ports SFP_LOS]
#set_input_delay -clock clk_100m -min -0.500 [get_ports SFP_LOS]
#set_output_delay -clock clk_100m -max 0.000 [get_ports SFP_DIS]
#set_output_delay -clock clk_100m -min -0.500 [get_ports SFP_DIS]
#
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_RSTN]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_RSTN]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_FBTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_FBTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_FBTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_FBTDD2]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_TXTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_TXTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_TXTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_TXTDD2]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_RXTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_RXTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE0_RXTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE0_RXTDD2]
#
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_RSTN]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_RSTN]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_FBTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_FBTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_FBTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_FBTDD2]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_TXTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_TXTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_TXTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_TXTDD2]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_RXTDD1]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_RXTDD1]
#set_output_delay -clock clk_100m -max 0.000 [get_ports AFE1_RXTDD2]
#set_output_delay -clock clk_100m -min -0.500 [get_ports AFE1_RXTDD2]
#
#set_input_delay -clock spi_clk -max 1.000 [get_ports AFE0_SPI_MISO]
#set_input_delay -clock spi_clk -min -1.000 [get_ports AFE0_SPI_MISO]
#set_input_delay -clock spi_clk -max 1.000 [get_ports AFE1_SPI_MISO]
#set_input_delay -clock spi_clk -min -1.000 [get_ports AFE1_SPI_MISO]
#set_input_delay -clock spi_clk -max 1.000 [get_ports PLL_SPI_MISO]
#set_input_delay -clock spi_clk -min -1.000 [get_ports PLL_SPI_MISO]
#
#set_output_delay -clock spi_clk -max 1.000 [get_ports {AFE0_SPIACLK AFE0_SPIAEN AFE0_SPI_MOSI}]
#set_output_delay -clock spi_clk -min -1.000 [get_ports {AFE0_SPIACLK AFE0_SPIAEN AFE0_SPI_MOSI}]
#set_output_delay -clock spi_clk -max 1.000 [get_ports {AFE1_SPIACLK AFE1_SPIAEN AFE1_SPI_MOSI}]
#set_output_delay -clock spi_clk -min -1.000 [get_ports {AFE1_SPIACLK AFE1_SPIAEN AFE1_SPI_MOSI}]
#set_output_delay -clock spi_clk -max 1.000 [get_ports {PLL_SPI_CLK PLL_SPI_CSB PLL_SPI_MOSI}]
#set_output_delay -clock spi_clk -min -1.000 [get_ports {PLL_SPI_CLK PLL_SPI_CSB PLL_SPI_MOSI}]
#
#set_output_delay -clock clk_100m -max 0.000 [get_ports {ATT_CLK ATT_DATA ATT_LE_700 ATT_LE_800 ATT_LE_900 ATT_LE_1P5 ATT_LE_1P7 ATT_LE_2P1}]
#set_output_delay -clock clk_100m -min -0.500 [get_ports {ATT_CLK ATT_DATA ATT_LE_700 ATT_LE_800 ATT_LE_900 ATT_LE_1P5 ATT_LE_1P7 ATT_LE_2P1}]
#set_output_delay -clock clk_100m -max 0.000 [get_ports {PA_EN_700 PA_EN_800 PA_EN_900 PA_EN_1P5 PA_EN_1P7 PA_EN_2P1}]
#set_output_delay -clock clk_100m -min -0.500 [get_ports {PA_EN_700 PA_EN_800 PA_EN_900 PA_EN_1P5 PA_EN_1P7 PA_EN_2P1}]
#set_output_delay -clock clk_100m -max 0.000 [get_ports {PA_SW_700 PA_SW_800 PA_SW_900 PA_SW_1P5 PA_SW_1P7 PA_SW_2P1}]
#set_output_delay -clock clk_100m -min -0.500 [get_ports {PA_SW_700 PA_SW_800 PA_SW_900 PA_SW_1P5 PA_SW_1P7 PA_SW_2P1}]
#














