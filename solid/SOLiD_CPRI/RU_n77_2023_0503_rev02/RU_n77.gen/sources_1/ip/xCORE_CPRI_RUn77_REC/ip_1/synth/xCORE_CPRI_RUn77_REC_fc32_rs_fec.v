// (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:fc32_rs_fec:1.0
// IP Revision: 23

(* X_CORE_INFO = "fc32_rs_fec_v1_0_23,Vivado 2022.2.1" *)
(* CHECK_LICENSE_TYPE = "xCORE_CPRI_RUn77_REC_fc32_rs_fec,fc32_rs_fec_v1_0_23,{}" *)
(* CORE_GENERATION_INFO = "xCORE_CPRI_RUn77_REC_fc32_rs_fec,fc32_rs_fec_v1_0_23,{x_ipProduct=Vivado 2022.2.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=fc32_rs_fec,x_ipVersion=1.0,x_ipCoreRevision=23,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_ELABORATION_DIR=./,C_XDEVICEFAMILY=zynquplus,C_ECC=0,x_ipLicense=fc32_rs_fec@2016.10(bought)}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module xCORE_CPRI_RUn77_REC_fc32_rs_fec (
  tx_clk,
  tx_resetn,
  rx_clk,
  rx_resetn,
  tx_mac_cw_start,
  tx_mac_data,
  rx_mac_data,
  rx_phy_data,
  tx_phy_data,
  ctrl_bypass_indication_enable,
  ctrl_rapid_alignment_mode,
  stat_corrected_cw_inc,
  stat_uncorrected_cw_inc,
  stat_cw_inc,
  stat_symbol_errors_inc,
  stat_rx_delay,
  stat_rx_align_status
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tx_clk_intf, ASSOCIATED_RESET tx_resetn, FREQ_HZ 425000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 tx_clk_intf CLK" *)
input wire tx_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tx_resetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 tx_resetn_intf RST" *)
input wire tx_resetn;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rx_clk_intf, ASSOCIATED_RESET rx_resetn, FREQ_HZ 425000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 rx_clk_intf CLK" *)
input wire rx_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rx_resetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rx_resetn_intf RST" *)
input wire rx_resetn;
input wire tx_mac_cw_start;
input wire [65 : 0] tx_mac_data;
output wire [65 : 0] rx_mac_data;
input wire [65 : 0] rx_phy_data;
output wire [65 : 0] tx_phy_data;
input wire ctrl_bypass_indication_enable;
input wire ctrl_rapid_alignment_mode;
output wire stat_corrected_cw_inc;
output wire stat_uncorrected_cw_inc;
output wire stat_cw_inc;
output wire [2 : 0] stat_symbol_errors_inc;
output wire [6 : 0] stat_rx_delay;
output wire stat_rx_align_status;

  fc32_rs_fec_v1_0_23 #(
    .C_ELABORATION_DIR("./"),
    .C_XDEVICEFAMILY("zynquplus"),
    .C_ECC(0)
  ) inst (
    .tx_clk(tx_clk),
    .tx_resetn(tx_resetn),
    .rx_clk(rx_clk),
    .rx_resetn(rx_resetn),
    .tx_mac_cw_start(tx_mac_cw_start),
    .tx_mac_data(tx_mac_data),
    .rx_mac_data(rx_mac_data),
    .rx_phy_data(rx_phy_data),
    .tx_phy_data(tx_phy_data),
    .ctrl_bypass_indication_enable(ctrl_bypass_indication_enable),
    .ctrl_rapid_alignment_mode(ctrl_rapid_alignment_mode),
    .stat_corrected_cw_inc(stat_corrected_cw_inc),
    .stat_uncorrected_cw_inc(stat_uncorrected_cw_inc),
    .stat_cw_inc(stat_cw_inc),
    .stat_symbol_errors_inc(stat_symbol_errors_inc),
    .stat_rx_delay(stat_rx_delay),
    .stat_rx_align_status(stat_rx_align_status)
  );
endmodule
