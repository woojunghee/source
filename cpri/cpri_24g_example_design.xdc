# Title      : Example top level constraints for CPRI
# Project    : cpri_v8_11_12
#----------------------------------------------------------------------
# File       : cpri_example.xdc
# Author     : Xilinx
#----------------------------------------------------------------------
# Description: User Constraint file for the CPRI example design.
#---------------------------------------------------------------------
# (c) Copyright 2004 - 2020 Xilinx, Inc. All rights reserved.
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

# Transceiver reference clock
create_clock -name refclk -period 4.069 [get_ports refclk_p]

# The following GT Common input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM1DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]

# The following BUFG_GT input pins change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.

# Auxiliary clock
create_clock -name aux_clk -period 10.000 [get_ports s_axi_aclk]

# Reset block clock
# Slower than transceiver user clock @ lowest supported line rate
create_clock -name reset_block_clk -period 130.208 [get_ports gtwiz_reset_clk_freerun_in]

# High resolution clock
create_clock -name hires_clk -period 2.631 [get_ports hires_clk]
set_max_delay -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells -hier -filter {name =~ *i_rsfec/rx_cdc_i[*].i_rsfec/G_R21_TIMER*.average_handshake_i/q_reg[*]}]] -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/cdc_average_int_reg[*]}]] -datapath_only 8.000
set_max_delay -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells -hier -filter {name =~ *i_rsfec/gen_latency[*].hfec_handshake_i/q_reg[*]}]]                      -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -hier -filter {name =~ *cpri_i/cpri_i/mgmnt_i/hard_fec_lat_val.hfec_fifo_latency_int_reg[*]}]] -datapath_only 8.000

# Clock crossing constraints for the data generators and monitors in the example design top level
set_false_path -from [get_clocks aux_clk] -to [get_cells {iq_rx_chk_enable_clk_reg[0]}]
set_false_path -from [get_cells {iq_rx_chk_i/error_count_i_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {iq_rx_chk_i/frame_count_i_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {iq_rx_chk_i/nodebfn_rx_nr_store_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {mii_tx_rx_i/rx_error_counter_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {mii_tx_rx_i/tx_frame_counter_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {mii_tx_rx_i/rx_frame_counter_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {vendor_tx_rx_i/error_count_i_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {vendor_tx_rx_i/word_count_i_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {hdlc_tx_rx_i/error_count_i_reg[*]}] -to [get_clocks aux_clk]
set_false_path -from [get_cells {hdlc_tx_rx_i/bit_count_i_reg[*]}] -to [get_clocks aux_clk]


################################################################################
# Example Transceiver Location Constraints.
# The GT and Refclk locations are selected in the CPRI GUI, but can be overriden here.
# Place the reference clock IBUFDS in the same clocking region as the common block.
# Full details of available transceiver locations can be found in the UltraScale documentation.
# These are example constraints, please use correct locations for your chosen device.
#set_property LOC GTYE4_CHANNEL_X0Y1 [get_cells cpri_block_i/cpri_i/U0/gt_and_clocks_i/cpri_24g_gt_i/inst/gen_gtwizard_gtye4_top.cpri_24g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[*].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTHE3_CHANNEL_PRIM_INST]
set_property LOC GTYE4_COMMON_X0Y1 [get_cells refclk_ibufds]

################################################################################
# Example CMAC (Hard FEC) Location Constraint.
# The CMAC location is selected in the CPRI GUI, but can be overriden here.
# This is a sample constraint, please use correct location for your chosen device using the same constraint format.
# The CMAC must be placed in the same row of the device as the transceiver to gaurantee timing closure. See UG575 for details.
#set_property LOC CMACE4_X0Y1 [get_cells -hierarchical -filter {NAME =~ *inst/i_*_top/* && REF_NAME==CMACE4}]

# Example design IO constraints
set_false_path -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells recclkout_gen]] -to [get_ports recclk_out]
