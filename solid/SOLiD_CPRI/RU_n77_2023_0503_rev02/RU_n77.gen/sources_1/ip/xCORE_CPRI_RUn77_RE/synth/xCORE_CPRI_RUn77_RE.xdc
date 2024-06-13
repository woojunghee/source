# Title      : Example block level constraints for CPRI
# Project    : cpri_v8_11_14
#----------------------------------------------------------------------
# File       : xCORE_CPRI_RUn77_RE.xdc
# Author     : Xilinx
#----------------------------------------------------------------------
# Description: User Constraint file for the block level design for CPRI.
#
#----------------------------------------------------------------------
# (c) Copyright 2021 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.


# The following GT Common input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM1DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]

# The following BUFG_GT input pins change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]

# The following GT Channel input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ TXPLLCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ RXPLLCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ TXSYSCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ RXSYSCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ TXPLLCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ RXPLLCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ TXSYSCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ RXSYSCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ RXOUTCLKSEL[2]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ RXOUTCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ RXOUTCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ TXOUTCLKSEL[2]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ TXOUTCLKSEL[1]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME =~ TXOUTCLKSEL[0]} -of [get_cells -hier -filter {name =~ *gt*e*_channel_gen.gen_gt*e*_channel_inst[*].GT*E*_CHANNEL_PRIM_INST}]]

#Ignore timing on the comma alignment
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ RXPCOMMAALIGNEN} -of [get_cells -hier -filter {name =~ *gt_and_clocks_i/xCORE_CPRI_RUn77_RE_gt_i/inst/gen_gtwizard_gtye4_top.xCORE_CPRI_RUn77_RE_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[*].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ RXMCOMMAALIGNEN} -of [get_cells -hier -filter {name =~ *gt_and_clocks_i/xCORE_CPRI_RUn77_RE_gt_i/inst/gen_gtwizard_gtye4_top.xCORE_CPRI_RUn77_RE_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[*].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]]

# False paths on unused picoblaze ports
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ DINBDIN[*]} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/picoblaze_i/*.program/kcpsm6_rom}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ DINPBDINP[*]} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/picoblaze_i/*.program/kcpsm6_rom}]]

# False paths to reset synchronizers
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ PRE} -of [get_cells -hier -filter {name =~ *cdc_async_rst_i/arststages_ff_reg[*]}]]

# False paths to gtwiz_reset_block synchronizers
set_false_path -to [get_cells -hier -filter {name =~ *gt_and_clocks_i/gtwiz_reset_block_i/reset_synchronizer*inst/rst_in*reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *gt_and_clocks_i/gtwiz_reset_block_i/bit_synchronizer*inst/i_in*reg && IS_SEQUENTIAL}]

# Ignore timing on the line rate output. This signal will remain static over long periods.
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/G_LINE_RATE*.line_rate_i_reg* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/speed_select_reg* && IS_SEQUENTIAL}]

# Management clock to recovered clock
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/protocol_ver_i_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/clk_sync_i/no_hard_fec_protocol.rec_protocol_version_reg[*]}] -datapath_only 2.712
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/protocol_ver_toggle_i_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/clk_sync_i/no_hard_fec_protocol.protocol_ver_td_i/d*_reg}] -datapath_only 2.712

# Management clock to ethernet clock
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/gap_bytes_int_reg[*]}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/jam_bytes_int_reg[*]}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/tx_eth_pointer_i_reg[*]}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/tx_eth_pointer_toggle_i_reg*}]

# Management clock to core clock
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/hdlc_byte_valid_int_reg[*]}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/G_NOT_AGN_TX_CW_RAM.tx_cw_ram_reg* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/tx_hdlc_rate_i_reg[*]}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/tx_hdlc_rate_toggle_i_reg*}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/protocol_write_6g.scrambler_seed_tx_int_reg[*]}]

# Hires clock to managment clock
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/G_R21_TIMER*.average_handshake_i/q_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/cdc_average_int_reg[*]}] -datapath_only 8.000

# Ethernet XPM FIFO constraints
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/tx_eth_mii_I/tx_eth_packet_was_written_i_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/packet_was_written_d1_reg}] -datapath_only 2.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_ETH_INST.rx_ethernet_I/rx_eth_mii_I/*MII_NEXT_STATE_GEN.rx_eth_packet_was_read_int_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_ETH_INST.rx_ethernet_I/RX_ETH_CPRI_*64BIT.rx_eth_cpri_I/rx_eth_packet_was_read_del_reg}] -datapath_only 2.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_RESETS.reset_tx_eth_synch_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/*MII_FIFO_GEN.tx_buffer_I/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.fifo*_reg}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_RESETS.reset_tx_eth_synch_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/*MII_FIFO_GEN.tx_buffer_I/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_pf_ic_rc.gaf_ic.ram_afull_i_reg}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_RESETS.reset_tx_eth_synch_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/*MII_FIFO_GEN.tx_buffer_I/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_pf_ic_rc.gpf_ic.prog_full_i_reg}] -datapath_only 8.000
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/*MII_FIFO_GEN.tx_buffer_I/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_pf_ic_rc.gaf_ic.ram_afull_i_reg}]
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/TX_ETH_INST.tx_ethernet_i/TX_ETH_CPRI_*64BIT.tx_eth_cpri_I/*MII_FIFO_GEN.tx_buffer_I/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_pf_ic_rc.gpf_ic.prog_full_i_reg}]

# Core clock to managment, and hires clocks
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_CW_VOTE_INST.rx_cw_vote_i/rx_cw_eth_ptr_vote_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/aux_rx_cw_eth_ptr_vote_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_CW_VOTE_INST.rx_cw_vote_i/rx_cw_protocol_vote_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/aux_rx_cw_protocol_vote_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_CW_VOTE_INST.rx_cw_vote_i/rx_cw_hdlc_rate_vote_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/aux_rx_cw_hdlc_rate_vote_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_CW_VOTE_INST.rx_cw_vote_i/rx_cw_alarms_vote_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/aux_rx_cw_alarms_vote_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/tx_modules_I/tx_framing_i/basic_frame_cnt_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/link_manager_i/tx_hfn_toggle_d1_reg}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/rx_framing_i/rx_control_word_sc2_toggle_i_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/sc2_toggle_detect_i/d*_reg}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/R21_timer_interface.r21_timer_counter_I/time_cnt_int_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/r21_time_int_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/rd_error_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/mgmnt_rd_data_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/rd_addr_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/G_R21_TIMER*.cnt_i/rd_addr_inc_d_reg}] -datapath_only 2.631

# Recovered clock to hires and management clocks
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_HFNSYNC_64BIT.rx_hfnsync_i*seed_out_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/aux_recovered_seed_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/RX_HFNSYNC_64BIT.rx_hfnsync_i/seed_toggle_i_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/aux_sync_i/seed_toggle_detect_i/d*_reg}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/wr_error_sync_i/cdc_single_i/syncstages_ff_reg[3]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/mgmnt_rd_data_reg[*]}] -datapath_only 8.000
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/wr_addr_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/G_R21_TIMER*.cnt_i/wr_addr_inc_d_reg}] -datapath_only 2.631

set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/NO_HARD_FEC_CLK_DOMAIN.hfn_reset_reg*}]

# Clock crossing paths in CDC FIFO
set_false_path -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/STANDARD_CDC_FIFO.wr_fifo_go_reg}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/d1_reg}]
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/rd_addr_gray_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/wr_rd_addr_gray_reg[*]}] -datapath_only 2.712
set_max_delay -from [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/wr_addr_gray_reg[*]}] -to [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/rd_wr_addr_gray_reg[*]}] -datapath_only 2.712
set_max_delay -from [get_pins -filter {REF_PIN_NAME =~ CLK} -of [get_cells -hier -filter {name =~ *G_CDC_SLAVE.cdc_i/fifo_i/G_DIST_RAM.d.ram_reg*/RAM*}]] -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/rx_modules_I/G_CDC_SLAVE.cdc_i/fifo_i/G_DIST_RAM.d.rd_data_dist_i_reg[*]}]] -datapath_only 2.712

# Waivers
# CDC-1
create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {gap_bytes_int_reg is safe as it only changes at start up} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*mgmnt_i/gap_bytes_int_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*gap_count_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {jam_bytes_int_reg is safe as it only changes at start up} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*mgmnt_i/jam_bytes_int_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*jam_count_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {hdlc_byte_valid_int_reg is safe as it only changes at start up} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*mgmnt_i/hdlc_byte_valid_int_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*hdlc_*_reg}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {scrambler_seed_tx_int_reg is safe as it only changes at start up} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*mgmnt_i/protocol_write_6g.scrambler_seed_tx_int_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*tx_mux_i/*lfsr_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {tx_cw_ram_reg writing sub-address 2 data to tx mux is safe} \
  -from [get_pins -filter {REF_PIN_NAME=~CLK} -of [get_cells -hier -filter {name=~*link_manager_i/G_NOT_AGN_TX_CW_RAM.tx_cw_ram_reg*}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*tx_mux_i/*_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {line_rate_i_reg is safe as it only changes at link negotiation} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*link_manager_i/*.line_rate_i_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~*} -of [get_cells -hier -filter {name=~*cpri_i/fec_gen.fec_en_*clk_reg*}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {line_rate_i_reg is safe as it only changes at link negotiation} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*link_manager_i/*.line_rate_i_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*rx_eth_mii_I/gap_count_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-1 -description {line_rate_i_reg is safe as it only changes at link negotiation} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*link_manager_i/*.line_rate_i_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*rx_eth_cpri_I/codeword_length_reg[*]*}] ]

# CDC-4
create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-4 -description {tx_hdlc_rate_reg is safe as it is synchronized through a handshake synchronizer} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*link_manager_i/tx_hdlc_rate_i_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*clk_sync_i/clk_tx_hdlc_rate_reg[*]}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-4 -description {scrambler_seed_tx_int_reg is safe as it only changes at start up} \
  -from [get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*mgmnt_i/protocol_write_6g.scrambler_seed_tx_int_reg[*]}] ] \
  -to   [get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*tx_mux_i/*lfsr_reg[*]}] ]

# CDC-11
create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-11 -description {GT Wizard Reset block synchronizers are safe} \
  -from [ get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*gt_and_clocks_i/plllock_in_i_reg}] ] \
  -to   [ get_pins -filter {REF_PIN_NAME=~D} -of [get_cells -hier -filter {name=~*bit_synchronizer_plllock_*x_inst/i_in_meta_reg}] ]

create_waiver -internal -scope -quiet -user cpri -tags 1035981 -type CDC -id CDC-11 -description {GT Wizard Reset block synchronizers are safe} \
  -from [ get_pins -filter {REF_PIN_NAME=~C} -of [get_cells -hier -filter {name=~*gt_and_clocks_i/plllock_in_i_reg}] ] \
  -to   [ get_pins -filter {REF_PIN_NAME=~PRE} -of [get_cells -hier -filter {name=~*reset_synchronizer_txprogdivreset_inst/rst_in_meta_reg}] ]

