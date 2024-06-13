// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
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


// IP VLNV: xilinx.com:ip:gtwizard_ultrascale:1.7
// IP Revision: 15

(* X_CORE_INFO = "xCORE_CPRI_RUn77_REC_gt_gtwizard_top,Vivado 2022.2.1" *)
(* CHECK_LICENSE_TYPE = "xCORE_CPRI_RUn77_REC_gt,xCORE_CPRI_RUn77_REC_gt_gtwizard_top,{}" *)
(* CORE_GENERATION_INFO = "xCORE_CPRI_RUn77_REC_gt,xCORE_CPRI_RUn77_REC_gt_gtwizard_top,{x_ipProduct=Vivado 2022.2.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=gtwizard_ultrascale,x_ipVersion=1.7,x_ipCoreRevision=15,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_CHANNEL_ENABLE=000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000,C_PCIE_ENABLE=0,C_PCIE_CORECLK_FREQ=250,C_COMMON_SCALING_F\
ACTOR=1,C_CPLL_VCO_FREQUENCY=2578.125,C_FORCE_COMMONS=0,C_FREERUN_FREQUENCY=125.0,C_GT_TYPE=3,C_GT_REV=67,C_INCLUDE_CPLL_CAL=1,C_ENABLE_COMMON_USRCLK=0,C_USER_GTPOWERGOOD_DELAY_EN=1,C_SIM_CPLL_CAL_BYPASS=1,C_LOCATE_COMMON=1,C_LOCATE_RESET_CONTROLLER=1,C_LOCATE_USER_DATA_WIDTH_SIZING=1,C_LOCATE_RX_BUFFER_BYPASS_CONTROLLER=0,C_LOCATE_IN_SYSTEM_IBERT_CORE=2,C_LOCATE_RX_USER_CLOCKING=1,C_LOCATE_TX_BUFFER_BYPASS_CONTROLLER=0,C_LOCATE_TX_USER_CLOCKING=1,C_RESET_CONTROLLER_INSTANCE_CTRL=0,C_RX_BUFFBYPA\
SS_MODE=0,C_RX_BUFFER_BYPASS_INSTANCE_CTRL=0,C_RX_BUFFER_MODE=1,C_RX_CB_DISP=00000000,C_RX_CB_K=00000000,C_RX_CB_MAX_LEVEL=1,C_RX_CB_LEN_SEQ=1,C_RX_CB_NUM_SEQ=0,C_RX_CB_VAL=00000000000000000000000000000000000000000000000000000000000000000000000000000000,C_RX_CC_DISP=00000000,C_RX_CC_ENABLE=0,C_RESET_SEQUENCE_INTERVAL=0,C_RX_CC_K=00000000,C_RX_CC_LEN_SEQ=1,C_RX_CC_NUM_SEQ=0,C_RX_CC_PERIODICITY=5000,C_RX_CC_VAL=00000000000000000000000000000000000000000000000000000000000000000000000000000000,C_RX_C\
OMMA_M_ENABLE=0,C_RX_COMMA_M_VAL=1010000011,C_RX_COMMA_P_ENABLE=0,C_RX_COMMA_P_VAL=0101111100,C_RX_DATA_DECODING=4,C_RX_ENABLE=1,C_RX_INT_DATA_WIDTH=64,C_RX_LINE_RATE=24.33024,C_RX_MASTER_CHANNEL_IDX=4,C_RX_OUTCLK_BUFG_GT_DIV=1,C_RX_OUTCLK_FREQUENCY=368.6400000,C_RX_OUTCLK_SOURCE=4,C_RX_PLL_TYPE=0,C_RX_RECCLK_OUTPUT=0x000000000000000000000000000000000000000000000000,C_RX_REFCLK_FREQUENCY=245.76,C_RX_SLIDE_MODE=0,C_RX_USER_CLOCKING_CONTENTS=0,C_RX_USER_CLOCKING_INSTANCE_CTRL=0,C_RX_USER_CLOCKING_\
RATIO_FSRC_FUSRCLK=1,C_RX_USER_CLOCKING_RATIO_FUSRCLK_FUSRCLK2=1,C_RX_USER_CLOCKING_SOURCE=0,C_RX_USER_DATA_WIDTH=64,C_RX_USRCLK_FREQUENCY=368.6400000,C_RX_USRCLK2_FREQUENCY=368.6400000,C_SECONDARY_QPLL_ENABLE=0,C_SECONDARY_QPLL_REFCLK_FREQUENCY=257.8125,C_TOTAL_NUM_CHANNELS=1,C_TOTAL_NUM_COMMONS=0,C_TOTAL_NUM_COMMONS_EXAMPLE=1,C_TXPROGDIV_FREQ_ENABLE=0,C_TXPROGDIV_FREQ_SOURCE=0,C_TXPROGDIV_FREQ_VAL=368.64,C_TX_BUFFBYPASS_MODE=0,C_TX_BUFFER_BYPASS_INSTANCE_CTRL=0,C_TX_BUFFER_MODE=1,C_TX_DATA_ENC\
ODING=4,C_TX_ENABLE=1,C_TX_INT_DATA_WIDTH=64,C_TX_LINE_RATE=24.33024,C_TX_MASTER_CHANNEL_IDX=4,C_TX_OUTCLK_BUFG_GT_DIV=1,C_TX_OUTCLK_FREQUENCY=368.6400000,C_TX_OUTCLK_SOURCE=4,C_TX_PLL_TYPE=0,C_TX_REFCLK_FREQUENCY=245.76,C_TX_USER_CLOCKING_CONTENTS=0,C_TX_USER_CLOCKING_INSTANCE_CTRL=0,C_TX_USER_CLOCKING_RATIO_FSRC_FUSRCLK=1,C_TX_USER_CLOCKING_RATIO_FUSRCLK_FUSRCLK2=1,C_TX_USER_CLOCKING_SOURCE=0,C_TX_USER_DATA_WIDTH=64,C_TX_USRCLK_FREQUENCY=368.6400000,C_TX_USRCLK2_FREQUENCY=368.6400000}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module xCORE_CPRI_RUn77_REC_gt (
  gtwiz_userclk_tx_reset_in,
  gtwiz_userclk_tx_active_in,
  gtwiz_userclk_rx_active_in,
  gtwiz_reset_tx_done_in,
  gtwiz_reset_rx_done_in,
  gtwiz_gtye4_cpll_cal_txoutclk_period_in,
  gtwiz_gtye4_cpll_cal_cnt_tol_in,
  gtwiz_gtye4_cpll_cal_bufg_ce_in,
  cplllockdetclk_in,
  cplllocken_in,
  cpllpd_in,
  cpllreset_in,
  drpaddr_in,
  drpclk_in,
  drpdi_in,
  drpen_in,
  drpwe_in,
  eyescanreset_in,
  eyescantrigger_in,
  gtrefclk0_in,
  gtrxreset_in,
  gttxreset_in,
  gtyrxn_in,
  gtyrxp_in,
  loopback_in,
  pcsrsvdin_in,
  qpll0clk_in,
  qpll0refclk_in,
  qpll1clk_in,
  qpll1refclk_in,
  rx8b10ben_in,
  rxcdrhold_in,
  rxcommadeten_in,
  rxdfeagcovrden_in,
  rxdfelfovrden_in,
  rxdfelpmreset_in,
  rxdlybypass_in,
  rxdlyen_in,
  rxdlyovrden_in,
  rxdlysreset_in,
  rxgearboxslip_in,
  rxlatclk_in,
  rxlpmen_in,
  rxmcommaalignen_in,
  rxoutclksel_in,
  rxpcommaalignen_in,
  rxpcsreset_in,
  rxphalign_in,
  rxphalignen_in,
  rxphdlypd_in,
  rxphdlyreset_in,
  rxpllclksel_in,
  rxpmareset_in,
  rxpolarity_in,
  rxprbscntreset_in,
  rxprbssel_in,
  rxprogdivreset_in,
  rxrate_in,
  rxsyncallin_in,
  rxsyncin_in,
  rxsyncmode_in,
  rxsysclksel_in,
  rxuserrdy_in,
  rxusrclk_in,
  rxusrclk2_in,
  tx8b10ben_in,
  txctrl0_in,
  txctrl1_in,
  txctrl2_in,
  txdata_in,
  txdiffctrl_in,
  txdlybypass_in,
  txdlyen_in,
  txdlyhold_in,
  txdlyovrden_in,
  txdlysreset_in,
  txdlyupdown_in,
  txheader_in,
  txinhibit_in,
  txlatclk_in,
  txpcsreset_in,
  txphalign_in,
  txphalignen_in,
  txphdlypd_in,
  txphdlyreset_in,
  txphdlytstclk_in,
  txphinit_in,
  txphovrden_in,
  txpippmpd_in,
  txpippmsel_in,
  txpllclksel_in,
  txpmareset_in,
  txpolarity_in,
  txpostcursor_in,
  txprbsforceerr_in,
  txprbssel_in,
  txprecursor_in,
  txprogdivreset_in,
  txsequence_in,
  txsyncallin_in,
  txsyncin_in,
  txsyncmode_in,
  txsysclksel_in,
  txuserrdy_in,
  txusrclk_in,
  txusrclk2_in,
  cplllock_out,
  dmonitorout_out,
  drpdo_out,
  drprdy_out,
  eyescandataerror_out,
  gtpowergood_out,
  gtytxn_out,
  gtytxp_out,
  rxcdrlock_out,
  rxcommadet_out,
  rxctrl0_out,
  rxctrl1_out,
  rxctrl2_out,
  rxctrl3_out,
  rxdata_out,
  rxdatavalid_out,
  rxdlysresetdone_out,
  rxheader_out,
  rxheadervalid_out,
  rxoutclk_out,
  rxphaligndone_out,
  rxpmaresetdone_out,
  rxprbserr_out,
  rxprgdivresetdone_out,
  rxrecclkout_out,
  rxresetdone_out,
  rxstartofseq_out,
  rxsyncdone_out,
  rxsyncout_out,
  txdlysresetdone_out,
  txoutclk_out,
  txphaligndone_out,
  txphinitdone_out,
  txpmaresetdone_out,
  txprgdivresetdone_out,
  txresetdone_out,
  txsyncdone_out,
  txsyncout_out
);

input wire [0 : 0] gtwiz_userclk_tx_reset_in;
input wire [0 : 0] gtwiz_userclk_tx_active_in;
input wire [0 : 0] gtwiz_userclk_rx_active_in;
input wire [0 : 0] gtwiz_reset_tx_done_in;
input wire [0 : 0] gtwiz_reset_rx_done_in;
input wire [17 : 0] gtwiz_gtye4_cpll_cal_txoutclk_period_in;
input wire [17 : 0] gtwiz_gtye4_cpll_cal_cnt_tol_in;
input wire [0 : 0] gtwiz_gtye4_cpll_cal_bufg_ce_in;
input wire [0 : 0] cplllockdetclk_in;
input wire [0 : 0] cplllocken_in;
input wire [0 : 0] cpllpd_in;
input wire [0 : 0] cpllreset_in;
input wire [9 : 0] drpaddr_in;
input wire [0 : 0] drpclk_in;
input wire [15 : 0] drpdi_in;
input wire [0 : 0] drpen_in;
input wire [0 : 0] drpwe_in;
input wire [0 : 0] eyescanreset_in;
input wire [0 : 0] eyescantrigger_in;
input wire [0 : 0] gtrefclk0_in;
input wire [0 : 0] gtrxreset_in;
input wire [0 : 0] gttxreset_in;
input wire [0 : 0] gtyrxn_in;
input wire [0 : 0] gtyrxp_in;
input wire [2 : 0] loopback_in;
input wire [15 : 0] pcsrsvdin_in;
input wire [0 : 0] qpll0clk_in;
input wire [0 : 0] qpll0refclk_in;
input wire [0 : 0] qpll1clk_in;
input wire [0 : 0] qpll1refclk_in;
input wire [0 : 0] rx8b10ben_in;
input wire [0 : 0] rxcdrhold_in;
input wire [0 : 0] rxcommadeten_in;
input wire [0 : 0] rxdfeagcovrden_in;
input wire [0 : 0] rxdfelfovrden_in;
input wire [0 : 0] rxdfelpmreset_in;
input wire [0 : 0] rxdlybypass_in;
input wire [0 : 0] rxdlyen_in;
input wire [0 : 0] rxdlyovrden_in;
input wire [0 : 0] rxdlysreset_in;
input wire [0 : 0] rxgearboxslip_in;
input wire [0 : 0] rxlatclk_in;
input wire [0 : 0] rxlpmen_in;
input wire [0 : 0] rxmcommaalignen_in;
input wire [2 : 0] rxoutclksel_in;
input wire [0 : 0] rxpcommaalignen_in;
input wire [0 : 0] rxpcsreset_in;
input wire [0 : 0] rxphalign_in;
input wire [0 : 0] rxphalignen_in;
input wire [0 : 0] rxphdlypd_in;
input wire [0 : 0] rxphdlyreset_in;
input wire [1 : 0] rxpllclksel_in;
input wire [0 : 0] rxpmareset_in;
input wire [0 : 0] rxpolarity_in;
input wire [0 : 0] rxprbscntreset_in;
input wire [3 : 0] rxprbssel_in;
input wire [0 : 0] rxprogdivreset_in;
input wire [2 : 0] rxrate_in;
input wire [0 : 0] rxsyncallin_in;
input wire [0 : 0] rxsyncin_in;
input wire [0 : 0] rxsyncmode_in;
input wire [1 : 0] rxsysclksel_in;
input wire [0 : 0] rxuserrdy_in;
input wire [0 : 0] rxusrclk_in;
input wire [0 : 0] rxusrclk2_in;
input wire [0 : 0] tx8b10ben_in;
input wire [15 : 0] txctrl0_in;
input wire [15 : 0] txctrl1_in;
input wire [7 : 0] txctrl2_in;
input wire [127 : 0] txdata_in;
input wire [4 : 0] txdiffctrl_in;
input wire [0 : 0] txdlybypass_in;
input wire [0 : 0] txdlyen_in;
input wire [0 : 0] txdlyhold_in;
input wire [0 : 0] txdlyovrden_in;
input wire [0 : 0] txdlysreset_in;
input wire [0 : 0] txdlyupdown_in;
input wire [5 : 0] txheader_in;
input wire [0 : 0] txinhibit_in;
input wire [0 : 0] txlatclk_in;
input wire [0 : 0] txpcsreset_in;
input wire [0 : 0] txphalign_in;
input wire [0 : 0] txphalignen_in;
input wire [0 : 0] txphdlypd_in;
input wire [0 : 0] txphdlyreset_in;
input wire [0 : 0] txphdlytstclk_in;
input wire [0 : 0] txphinit_in;
input wire [0 : 0] txphovrden_in;
input wire [0 : 0] txpippmpd_in;
input wire [0 : 0] txpippmsel_in;
input wire [1 : 0] txpllclksel_in;
input wire [0 : 0] txpmareset_in;
input wire [0 : 0] txpolarity_in;
input wire [4 : 0] txpostcursor_in;
input wire [0 : 0] txprbsforceerr_in;
input wire [3 : 0] txprbssel_in;
input wire [4 : 0] txprecursor_in;
input wire [0 : 0] txprogdivreset_in;
input wire [6 : 0] txsequence_in;
input wire [0 : 0] txsyncallin_in;
input wire [0 : 0] txsyncin_in;
input wire [0 : 0] txsyncmode_in;
input wire [1 : 0] txsysclksel_in;
input wire [0 : 0] txuserrdy_in;
input wire [0 : 0] txusrclk_in;
input wire [0 : 0] txusrclk2_in;
output wire [0 : 0] cplllock_out;
output wire [15 : 0] dmonitorout_out;
output wire [15 : 0] drpdo_out;
output wire [0 : 0] drprdy_out;
output wire [0 : 0] eyescandataerror_out;
output wire [0 : 0] gtpowergood_out;
output wire [0 : 0] gtytxn_out;
output wire [0 : 0] gtytxp_out;
output wire [0 : 0] rxcdrlock_out;
output wire [0 : 0] rxcommadet_out;
output wire [15 : 0] rxctrl0_out;
output wire [15 : 0] rxctrl1_out;
output wire [7 : 0] rxctrl2_out;
output wire [7 : 0] rxctrl3_out;
output wire [127 : 0] rxdata_out;
output wire [1 : 0] rxdatavalid_out;
output wire [0 : 0] rxdlysresetdone_out;
output wire [5 : 0] rxheader_out;
output wire [1 : 0] rxheadervalid_out;
output wire [0 : 0] rxoutclk_out;
output wire [0 : 0] rxphaligndone_out;
output wire [0 : 0] rxpmaresetdone_out;
output wire [0 : 0] rxprbserr_out;
output wire [0 : 0] rxprgdivresetdone_out;
output wire [0 : 0] rxrecclkout_out;
output wire [0 : 0] rxresetdone_out;
output wire [1 : 0] rxstartofseq_out;
output wire [0 : 0] rxsyncdone_out;
output wire [0 : 0] rxsyncout_out;
output wire [0 : 0] txdlysresetdone_out;
output wire [0 : 0] txoutclk_out;
output wire [0 : 0] txphaligndone_out;
output wire [0 : 0] txphinitdone_out;
output wire [0 : 0] txpmaresetdone_out;
output wire [0 : 0] txprgdivresetdone_out;
output wire [0 : 0] txresetdone_out;
output wire [0 : 0] txsyncdone_out;
output wire [0 : 0] txsyncout_out;

  xCORE_CPRI_RUn77_REC_gt_gtwizard_top #(
    .C_CHANNEL_ENABLE(192'B000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000),
    .C_PCIE_ENABLE(0),
    .C_PCIE_CORECLK_FREQ(250),
    .C_COMMON_SCALING_FACTOR(1),
    .C_CPLL_VCO_FREQUENCY(2578.125),
    .C_FORCE_COMMONS(0),
    .C_FREERUN_FREQUENCY(125.0),
    .C_GT_TYPE(3),
    .C_GT_REV(67),
    .C_INCLUDE_CPLL_CAL(1),
    .C_ENABLE_COMMON_USRCLK(0),
    .C_USER_GTPOWERGOOD_DELAY_EN(1),
    .C_SIM_CPLL_CAL_BYPASS(1),
    .C_LOCATE_COMMON(1),
    .C_LOCATE_RESET_CONTROLLER(1),
    .C_LOCATE_USER_DATA_WIDTH_SIZING(1),
    .C_LOCATE_RX_BUFFER_BYPASS_CONTROLLER(0),
    .C_LOCATE_IN_SYSTEM_IBERT_CORE(2),
    .C_LOCATE_RX_USER_CLOCKING(1),
    .C_LOCATE_TX_BUFFER_BYPASS_CONTROLLER(0),
    .C_LOCATE_TX_USER_CLOCKING(1),
    .C_RESET_CONTROLLER_INSTANCE_CTRL(0),
    .C_RX_BUFFBYPASS_MODE(0),
    .C_RX_BUFFER_BYPASS_INSTANCE_CTRL(0),
    .C_RX_BUFFER_MODE(1),
    .C_RX_CB_DISP(8'B00000000),
    .C_RX_CB_K(8'B00000000),
    .C_RX_CB_MAX_LEVEL(1),
    .C_RX_CB_LEN_SEQ(1),
    .C_RX_CB_NUM_SEQ(0),
    .C_RX_CB_VAL(80'B00000000000000000000000000000000000000000000000000000000000000000000000000000000),
    .C_RX_CC_DISP(8'B00000000),
    .C_RX_CC_ENABLE(0),
    .C_RESET_SEQUENCE_INTERVAL(0),
    .C_RX_CC_K(8'B00000000),
    .C_RX_CC_LEN_SEQ(1),
    .C_RX_CC_NUM_SEQ(0),
    .C_RX_CC_PERIODICITY(5000),
    .C_RX_CC_VAL(80'B00000000000000000000000000000000000000000000000000000000000000000000000000000000),
    .C_RX_COMMA_M_ENABLE(0),
    .C_RX_COMMA_M_VAL(10'B1010000011),
    .C_RX_COMMA_P_ENABLE(0),
    .C_RX_COMMA_P_VAL(10'B0101111100),
    .C_RX_DATA_DECODING(4),
    .C_RX_ENABLE(1),
    .C_RX_INT_DATA_WIDTH(64),
    .C_RX_LINE_RATE(24.33024),
    .C_RX_MASTER_CHANNEL_IDX(4),
    .C_RX_OUTCLK_BUFG_GT_DIV(1),
    .C_RX_OUTCLK_FREQUENCY(368.6400000),
    .C_RX_OUTCLK_SOURCE(4),
    .C_RX_PLL_TYPE(0),
    .C_RX_RECCLK_OUTPUT(192'H000000000000000000000000000000000000000000000000),
    .C_RX_REFCLK_FREQUENCY(245.76),
    .C_RX_SLIDE_MODE(0),
    .C_RX_USER_CLOCKING_CONTENTS(0),
    .C_RX_USER_CLOCKING_INSTANCE_CTRL(0),
    .C_RX_USER_CLOCKING_RATIO_FSRC_FUSRCLK(1),
    .C_RX_USER_CLOCKING_RATIO_FUSRCLK_FUSRCLK2(1),
    .C_RX_USER_CLOCKING_SOURCE(0),
    .C_RX_USER_DATA_WIDTH(64),
    .C_RX_USRCLK_FREQUENCY(368.6400000),
    .C_RX_USRCLK2_FREQUENCY(368.6400000),
    .C_SECONDARY_QPLL_ENABLE(0),
    .C_SECONDARY_QPLL_REFCLK_FREQUENCY(257.8125),
    .C_TOTAL_NUM_CHANNELS(1),
    .C_TOTAL_NUM_COMMONS(0),
    .C_TOTAL_NUM_COMMONS_EXAMPLE(1),
    .C_TXPROGDIV_FREQ_ENABLE(0),
    .C_TXPROGDIV_FREQ_SOURCE(0),
    .C_TXPROGDIV_FREQ_VAL(368.64),
    .C_TX_BUFFBYPASS_MODE(0),
    .C_TX_BUFFER_BYPASS_INSTANCE_CTRL(0),
    .C_TX_BUFFER_MODE(1),
    .C_TX_DATA_ENCODING(4),
    .C_TX_ENABLE(1),
    .C_TX_INT_DATA_WIDTH(64),
    .C_TX_LINE_RATE(24.33024),
    .C_TX_MASTER_CHANNEL_IDX(4),
    .C_TX_OUTCLK_BUFG_GT_DIV(1),
    .C_TX_OUTCLK_FREQUENCY(368.6400000),
    .C_TX_OUTCLK_SOURCE(4),
    .C_TX_PLL_TYPE(0),
    .C_TX_REFCLK_FREQUENCY(245.76),
    .C_TX_USER_CLOCKING_CONTENTS(0),
    .C_TX_USER_CLOCKING_INSTANCE_CTRL(0),
    .C_TX_USER_CLOCKING_RATIO_FSRC_FUSRCLK(1),
    .C_TX_USER_CLOCKING_RATIO_FUSRCLK_FUSRCLK2(1),
    .C_TX_USER_CLOCKING_SOURCE(0),
    .C_TX_USER_DATA_WIDTH(64),
    .C_TX_USRCLK_FREQUENCY(368.6400000),
    .C_TX_USRCLK2_FREQUENCY(368.6400000)
  ) inst (
    .gtwiz_userclk_tx_reset_in(gtwiz_userclk_tx_reset_in),
    .gtwiz_userclk_tx_active_in(gtwiz_userclk_tx_active_in),
    .gtwiz_userclk_tx_srcclk_out(),
    .gtwiz_userclk_tx_usrclk_out(),
    .gtwiz_userclk_tx_usrclk2_out(),
    .gtwiz_userclk_tx_active_out(),
    .gtwiz_userclk_rx_reset_in(1'B0),
    .gtwiz_userclk_rx_active_in(gtwiz_userclk_rx_active_in),
    .gtwiz_userclk_rx_srcclk_out(),
    .gtwiz_userclk_rx_usrclk_out(),
    .gtwiz_userclk_rx_usrclk2_out(),
    .gtwiz_userclk_rx_active_out(),
    .gtwiz_buffbypass_tx_reset_in(1'B0),
    .gtwiz_buffbypass_tx_start_user_in(1'B0),
    .gtwiz_buffbypass_tx_done_out(),
    .gtwiz_buffbypass_tx_error_out(),
    .gtwiz_buffbypass_rx_reset_in(1'B0),
    .gtwiz_buffbypass_rx_start_user_in(1'B0),
    .gtwiz_buffbypass_rx_done_out(),
    .gtwiz_buffbypass_rx_error_out(),
    .gtwiz_reset_clk_freerun_in(1'B0),
    .gtwiz_reset_all_in(1'B0),
    .gtwiz_reset_tx_pll_and_datapath_in(1'B0),
    .gtwiz_reset_tx_datapath_in(1'B0),
    .gtwiz_reset_rx_pll_and_datapath_in(1'B0),
    .gtwiz_reset_rx_datapath_in(1'B0),
    .gtwiz_reset_tx_done_in(gtwiz_reset_tx_done_in),
    .gtwiz_reset_rx_done_in(gtwiz_reset_rx_done_in),
    .gtwiz_reset_qpll0lock_in(1'B0),
    .gtwiz_reset_qpll1lock_in(1'B0),
    .gtwiz_reset_rx_cdr_stable_out(),
    .gtwiz_reset_tx_done_out(),
    .gtwiz_reset_rx_done_out(),
    .gtwiz_reset_qpll0reset_out(),
    .gtwiz_reset_qpll1reset_out(),
    .gtwiz_gthe3_cpll_cal_txoutclk_period_in(18'B0),
    .gtwiz_gthe3_cpll_cal_cnt_tol_in(18'B0),
    .gtwiz_gthe3_cpll_cal_bufg_ce_in(1'B0),
    .gtwiz_gthe4_cpll_cal_txoutclk_period_in(18'B0),
    .gtwiz_gthe4_cpll_cal_cnt_tol_in(18'B0),
    .gtwiz_gthe4_cpll_cal_bufg_ce_in(1'B0),
    .gtwiz_gtye4_cpll_cal_txoutclk_period_in(gtwiz_gtye4_cpll_cal_txoutclk_period_in),
    .gtwiz_gtye4_cpll_cal_cnt_tol_in(gtwiz_gtye4_cpll_cal_cnt_tol_in),
    .gtwiz_gtye4_cpll_cal_bufg_ce_in(gtwiz_gtye4_cpll_cal_bufg_ce_in),
    .gtwiz_userdata_tx_in(64'B0),
    .gtwiz_userdata_rx_out(),
    .bgbypassb_in(1'H1),
    .bgmonitorenb_in(1'H1),
    .bgpdb_in(1'H1),
    .bgrcalovrd_in(5'H10),
    .bgrcalovrdenb_in(1'H1),
    .drpaddr_common_in(16'H0000),
    .drpclk_common_in(1'H0),
    .drpdi_common_in(16'H0000),
    .drpen_common_in(1'H0),
    .drpwe_common_in(1'H0),
    .gtgrefclk0_in(1'H0),
    .gtgrefclk1_in(1'H0),
    .gtnorthrefclk00_in(1'H0),
    .gtnorthrefclk01_in(1'H0),
    .gtnorthrefclk10_in(1'H0),
    .gtnorthrefclk11_in(1'H0),
    .gtrefclk00_in(1'H0),
    .gtrefclk01_in(1'H0),
    .gtrefclk10_in(1'H0),
    .gtrefclk11_in(1'H0),
    .gtsouthrefclk00_in(1'H0),
    .gtsouthrefclk01_in(1'H0),
    .gtsouthrefclk10_in(1'H0),
    .gtsouthrefclk11_in(1'H0),
    .pcierateqpll0_in(3'H0),
    .pcierateqpll1_in(3'H0),
    .pmarsvd0_in(8'H00),
    .pmarsvd1_in(8'H00),
    .qpll0clkrsvd0_in(1'H0),
    .qpll0clkrsvd1_in(1'H0),
    .qpll0fbdiv_in(8'H00),
    .qpll0lockdetclk_in(1'H0),
    .qpll0locken_in(1'H1),
    .qpll0pd_in(1'H0),
    .qpll0refclksel_in(3'H1),
    .qpll0reset_in(1'H0),
    .qpll1clkrsvd0_in(1'H0),
    .qpll1clkrsvd1_in(1'H0),
    .qpll1fbdiv_in(8'H00),
    .qpll1lockdetclk_in(1'H0),
    .qpll1locken_in(1'H0),
    .qpll1pd_in(1'H1),
    .qpll1refclksel_in(3'H1),
    .qpll1reset_in(1'H1),
    .qpllrsvd1_in(8'H00),
    .qpllrsvd2_in(5'H00),
    .qpllrsvd3_in(5'H00),
    .qpllrsvd4_in(8'H00),
    .rcalenb_in(1'H1),
    .sdm0data_in(25'H0000000),
    .sdm0reset_in(1'H0),
    .sdm0toggle_in(1'H0),
    .sdm0width_in(2'H0),
    .sdm1data_in(25'H0000000),
    .sdm1reset_in(1'H0),
    .sdm1toggle_in(1'H0),
    .sdm1width_in(2'H0),
    .tcongpi_in(1'B0),
    .tconpowerup_in(1'B0),
    .tconreset_in(1'B0),
    .tconrsvdin1_in(1'B0),
    .ubcfgstreamen_in(1'H0),
    .ubdo_in(16'H0000),
    .ubdrdy_in(1'H0),
    .ubenable_in(1'H0),
    .ubgpi_in(2'H0),
    .ubintr_in(2'H0),
    .ubiolmbrst_in(1'H0),
    .ubmbrst_in(1'H0),
    .ubmdmcapture_in(1'H0),
    .ubmdmdbgrst_in(1'H0),
    .ubmdmdbgupdate_in(1'H0),
    .ubmdmregen_in(4'H0),
    .ubmdmshift_in(1'H0),
    .ubmdmsysrst_in(1'H0),
    .ubmdmtck_in(1'H0),
    .ubmdmtdi_in(1'H0),
    .drpdo_common_out(),
    .drprdy_common_out(),
    .pmarsvdout0_out(),
    .pmarsvdout1_out(),
    .qpll0fbclklost_out(),
    .qpll0lock_out(),
    .qpll0outclk_out(),
    .qpll0outrefclk_out(),
    .qpll0refclklost_out(),
    .qpll1fbclklost_out(),
    .qpll1lock_out(),
    .qpll1outclk_out(),
    .qpll1outrefclk_out(),
    .qpll1refclklost_out(),
    .qplldmonitor0_out(),
    .qplldmonitor1_out(),
    .refclkoutmonitor0_out(),
    .refclkoutmonitor1_out(),
    .rxrecclk0_sel_out(),
    .rxrecclk1_sel_out(),
    .rxrecclk0sel_out(),
    .rxrecclk1sel_out(),
    .sdm0finalout_out(),
    .sdm0testdata_out(),
    .sdm1finalout_out(),
    .sdm1testdata_out(),
    .tcongpo_out(),
    .tconrsvdout0_out(),
    .ubdaddr_out(),
    .ubden_out(),
    .ubdi_out(),
    .ubdwe_out(),
    .ubmdmtdo_out(),
    .ubrsvdout_out(),
    .ubtxuart_out(),
    .cdrstepdir_in(1'H0),
    .cdrstepsq_in(1'H0),
    .cdrstepsx_in(1'H0),
    .cfgreset_in(1'H0),
    .clkrsvd0_in(1'H0),
    .clkrsvd1_in(1'H0),
    .cpllfreqlock_in(1'H0),
    .cplllockdetclk_in(cplllockdetclk_in),
    .cplllocken_in(cplllocken_in),
    .cpllpd_in(cpllpd_in),
    .cpllrefclksel_in(3'H1),
    .cpllreset_in(cpllreset_in),
    .dmonfiforeset_in(1'H0),
    .dmonitorclk_in(1'H0),
    .drpaddr_in(drpaddr_in),
    .drpclk_in(drpclk_in),
    .drpdi_in(drpdi_in),
    .drpen_in(drpen_in),
    .drprst_in(1'H0),
    .drpwe_in(drpwe_in),
    .elpcaldvorwren_in(1'B0),
    .elpcalpaorwren_in(1'B0),
    .evoddphicaldone_in(1'B0),
    .evoddphicalstart_in(1'B0),
    .evoddphidrden_in(1'B0),
    .evoddphidwren_in(1'B0),
    .evoddphixrden_in(1'B0),
    .evoddphixwren_in(1'B0),
    .eyescanmode_in(1'B0),
    .eyescanreset_in(eyescanreset_in),
    .eyescantrigger_in(eyescantrigger_in),
    .freqos_in(1'H0),
    .gtgrefclk_in(1'H0),
    .gthrxn_in(1'B0),
    .gthrxp_in(1'B0),
    .gtnorthrefclk0_in(1'H0),
    .gtnorthrefclk1_in(1'H0),
    .gtrefclk0_in(gtrefclk0_in),
    .gtrefclk1_in(1'H0),
    .gtresetsel_in(1'B0),
    .gtrsvd_in(16'H0000),
    .gtrxreset_in(gtrxreset_in),
    .gtrxresetsel_in(1'H0),
    .gtsouthrefclk0_in(1'H0),
    .gtsouthrefclk1_in(1'H0),
    .gttxreset_in(gttxreset_in),
    .gttxresetsel_in(1'H0),
    .incpctrl_in(1'H0),
    .gtyrxn_in(gtyrxn_in),
    .gtyrxp_in(gtyrxp_in),
    .loopback_in(loopback_in),
    .looprsvd_in(1'B0),
    .lpbkrxtxseren_in(1'B0),
    .lpbktxrxseren_in(1'B0),
    .pcieeqrxeqadaptdone_in(1'H0),
    .pcierstidle_in(1'H0),
    .pciersttxsyncstart_in(1'H0),
    .pcieuserratedone_in(1'H0),
    .pcsrsvdin_in(pcsrsvdin_in),
    .pcsrsvdin2_in(1'B0),
    .pmarsvdin_in(1'B0),
    .qpll0clk_in(qpll0clk_in),
    .qpll0freqlock_in(1'H0),
    .qpll0refclk_in(qpll0refclk_in),
    .qpll1clk_in(qpll1clk_in),
    .qpll1freqlock_in(1'H0),
    .qpll1refclk_in(qpll1refclk_in),
    .resetovrd_in(1'H0),
    .rstclkentx_in(1'B0),
    .rx8b10ben_in(rx8b10ben_in),
    .rxafecfoken_in(1'H1),
    .rxbufreset_in(1'H0),
    .rxcdrfreqreset_in(1'H0),
    .rxcdrhold_in(rxcdrhold_in),
    .rxcdrovrden_in(1'H0),
    .rxcdrreset_in(1'H0),
    .rxcdrresetrsv_in(1'B0),
    .rxchbonden_in(1'H0),
    .rxchbondi_in(5'H00),
    .rxchbondlevel_in(3'H0),
    .rxchbondmaster_in(1'H0),
    .rxchbondslave_in(1'H0),
    .rxckcalreset_in(1'H0),
    .rxckcalstart_in(7'H00),
    .rxcommadeten_in(rxcommadeten_in),
    .rxdfeagcctrl_in(1'B0),
    .rxdccforcestart_in(1'B0),
    .rxdfeagchold_in(1'H0),
    .rxdfeagcovrden_in(rxdfeagcovrden_in),
    .rxdfecfokfcnum_in(4'HD),
    .rxdfecfokfen_in(1'H0),
    .rxdfecfokfpulse_in(1'H0),
    .rxdfecfokhold_in(1'H0),
    .rxdfecfokovren_in(1'H0),
    .rxdfekhhold_in(1'H0),
    .rxdfekhovrden_in(1'H0),
    .rxdfelfhold_in(1'H0),
    .rxdfelfovrden_in(rxdfelfovrden_in),
    .rxdfelpmreset_in(rxdfelpmreset_in),
    .rxdfetap10hold_in(1'H0),
    .rxdfetap10ovrden_in(1'H0),
    .rxdfetap11hold_in(1'H0),
    .rxdfetap11ovrden_in(1'H0),
    .rxdfetap12hold_in(1'H0),
    .rxdfetap12ovrden_in(1'H0),
    .rxdfetap13hold_in(1'H0),
    .rxdfetap13ovrden_in(1'H0),
    .rxdfetap14hold_in(1'H0),
    .rxdfetap14ovrden_in(1'H0),
    .rxdfetap15hold_in(1'H0),
    .rxdfetap15ovrden_in(1'H0),
    .rxdfetap2hold_in(1'H0),
    .rxdfetap2ovrden_in(1'H0),
    .rxdfetap3hold_in(1'H0),
    .rxdfetap3ovrden_in(1'H0),
    .rxdfetap4hold_in(1'H0),
    .rxdfetap4ovrden_in(1'H0),
    .rxdfetap5hold_in(1'H0),
    .rxdfetap5ovrden_in(1'H0),
    .rxdfetap6hold_in(1'H0),
    .rxdfetap6ovrden_in(1'H0),
    .rxdfetap7hold_in(1'H0),
    .rxdfetap7ovrden_in(1'H0),
    .rxdfetap8hold_in(1'H0),
    .rxdfetap8ovrden_in(1'H0),
    .rxdfetap9hold_in(1'H0),
    .rxdfetap9ovrden_in(1'H0),
    .rxdfeuthold_in(1'H0),
    .rxdfeutovrden_in(1'H0),
    .rxdfevphold_in(1'H0),
    .rxdfevpovrden_in(1'H0),
    .rxdfevsen_in(1'B0),
    .rxdfexyden_in(1'H1),
    .rxdlybypass_in(rxdlybypass_in),
    .rxdlyen_in(rxdlyen_in),
    .rxdlyovrden_in(rxdlyovrden_in),
    .rxdlysreset_in(rxdlysreset_in),
    .rxelecidlemode_in(2'H3),
    .rxeqtraining_in(1'H0),
    .rxgearboxslip_in(rxgearboxslip_in),
    .rxlatclk_in(rxlatclk_in),
    .rxlpmen_in(rxlpmen_in),
    .rxlpmgchold_in(1'H0),
    .rxlpmgcovrden_in(1'H0),
    .rxlpmhfhold_in(1'H0),
    .rxlpmhfovrden_in(1'H0),
    .rxlpmlfhold_in(1'H0),
    .rxlpmlfklovrden_in(1'H0),
    .rxlpmoshold_in(1'H0),
    .rxlpmosovrden_in(1'H0),
    .rxmcommaalignen_in(rxmcommaalignen_in),
    .rxmonitorsel_in(2'H0),
    .rxoobreset_in(1'H0),
    .rxoscalreset_in(1'H0),
    .rxoshold_in(1'H0),
    .rxosintcfg_in(1'B0),
    .rxosinten_in(1'B0),
    .rxosinthold_in(1'B0),
    .rxosintovrden_in(1'B0),
    .rxosintstrobe_in(1'B0),
    .rxosinttestovrden_in(1'B0),
    .rxosovrden_in(1'H0),
    .rxoutclksel_in(rxoutclksel_in),
    .rxpcommaalignen_in(rxpcommaalignen_in),
    .rxpcsreset_in(rxpcsreset_in),
    .rxpd_in(2'H0),
    .rxphalign_in(rxphalign_in),
    .rxphalignen_in(rxphalignen_in),
    .rxphdlypd_in(rxphdlypd_in),
    .rxphdlyreset_in(rxphdlyreset_in),
    .rxphovrden_in(1'B0),
    .rxpllclksel_in(rxpllclksel_in),
    .rxpmareset_in(rxpmareset_in),
    .rxpolarity_in(rxpolarity_in),
    .rxprbscntreset_in(rxprbscntreset_in),
    .rxprbssel_in(rxprbssel_in),
    .rxprogdivreset_in(rxprogdivreset_in),
    .rxqpien_in(1'B0),
    .rxrate_in(rxrate_in),
    .rxratemode_in(1'H0),
    .rxslide_in(1'H0),
    .rxslipoutclk_in(1'H0),
    .rxslippma_in(1'H0),
    .rxsyncallin_in(rxsyncallin_in),
    .rxsyncin_in(rxsyncin_in),
    .rxsyncmode_in(rxsyncmode_in),
    .rxsysclksel_in(rxsysclksel_in),
    .rxtermination_in(1'H0),
    .rxuserrdy_in(rxuserrdy_in),
    .rxusrclk_in(rxusrclk_in),
    .rxusrclk2_in(rxusrclk2_in),
    .sigvalidclk_in(1'H0),
    .tstin_in(20'H00000),
    .tx8b10bbypass_in(8'H00),
    .tx8b10ben_in(tx8b10ben_in),
    .txbufdiffctrl_in(1'B0),
    .txcominit_in(1'H0),
    .txcomsas_in(1'H0),
    .txcomwake_in(1'H0),
    .txctrl0_in(txctrl0_in),
    .txctrl1_in(txctrl1_in),
    .txctrl2_in(txctrl2_in),
    .txdata_in(txdata_in),
    .txdataextendrsvd_in(8'H00),
    .txdccforcestart_in(1'H0),
    .txdccreset_in(1'H0),
    .txdeemph_in(2'H0),
    .txdetectrx_in(1'H0),
    .txdiffctrl_in(txdiffctrl_in),
    .txdiffpd_in(1'B0),
    .txdlybypass_in(txdlybypass_in),
    .txdlyen_in(txdlyen_in),
    .txdlyhold_in(txdlyhold_in),
    .txdlyovrden_in(txdlyovrden_in),
    .txdlysreset_in(txdlysreset_in),
    .txdlyupdown_in(txdlyupdown_in),
    .txelecidle_in(1'H0),
    .txelforcestart_in(1'B0),
    .txheader_in(txheader_in),
    .txinhibit_in(txinhibit_in),
    .txlatclk_in(txlatclk_in),
    .txlfpstreset_in(1'H0),
    .txlfpsu2lpexit_in(1'H0),
    .txlfpsu3wake_in(1'H0),
    .txmaincursor_in(7'H50),
    .txmargin_in(3'H0),
    .txmuxdcdexhold_in(1'H0),
    .txmuxdcdorwren_in(1'H0),
    .txoneszeros_in(1'H0),
    .txoutclksel_in(3'H5),
    .txpcsreset_in(txpcsreset_in),
    .txpd_in(2'H0),
    .txpdelecidlemode_in(1'H0),
    .txphalign_in(txphalign_in),
    .txphalignen_in(txphalignen_in),
    .txphdlypd_in(txphdlypd_in),
    .txphdlyreset_in(txphdlyreset_in),
    .txphdlytstclk_in(txphdlytstclk_in),
    .txphinit_in(txphinit_in),
    .txphovrden_in(txphovrden_in),
    .txpippmen_in(1'H0),
    .txpippmovrden_in(1'H0),
    .txpippmpd_in(txpippmpd_in),
    .txpippmsel_in(txpippmsel_in),
    .txpippmstepsize_in(5'H00),
    .txpisopd_in(1'H0),
    .txpllclksel_in(txpllclksel_in),
    .txpmareset_in(txpmareset_in),
    .txpolarity_in(txpolarity_in),
    .txpostcursor_in(txpostcursor_in),
    .txpostcursorinv_in(1'B0),
    .txprbsforceerr_in(txprbsforceerr_in),
    .txprbssel_in(txprbssel_in),
    .txprecursor_in(txprecursor_in),
    .txprecursorinv_in(1'B0),
    .txprogdivreset_in(txprogdivreset_in),
    .txqpibiasen_in(1'B0),
    .txqpistrongpdown_in(1'B0),
    .txqpiweakpup_in(1'B0),
    .txrate_in(3'H0),
    .txratemode_in(1'H0),
    .txsequence_in(txsequence_in),
    .txswing_in(1'H0),
    .txsyncallin_in(txsyncallin_in),
    .txsyncin_in(txsyncin_in),
    .txsyncmode_in(txsyncmode_in),
    .txsysclksel_in(txsysclksel_in),
    .txuserrdy_in(txuserrdy_in),
    .txusrclk_in(txusrclk_in),
    .txusrclk2_in(txusrclk2_in),
    .bufgtce_out(),
    .bufgtcemask_out(),
    .bufgtdiv_out(),
    .bufgtreset_out(),
    .bufgtrstmask_out(),
    .cpllfbclklost_out(),
    .cplllock_out(cplllock_out),
    .cpllrefclklost_out(),
    .dmonitorout_out(dmonitorout_out),
    .dmonitoroutclk_out(),
    .drpdo_out(drpdo_out),
    .drprdy_out(drprdy_out),
    .eyescandataerror_out(eyescandataerror_out),
    .gthtxn_out(),
    .gthtxp_out(),
    .gtpowergood_out(gtpowergood_out),
    .gtrefclkmonitor_out(),
    .gtytxn_out(gtytxn_out),
    .gtytxp_out(gtytxp_out),
    .pcierategen3_out(),
    .pcierateidle_out(),
    .pcierateqpllpd_out(),
    .pcierateqpllreset_out(),
    .pciesynctxsyncdone_out(),
    .pcieusergen3rdy_out(),
    .pcieuserphystatusrst_out(),
    .pcieuserratestart_out(),
    .pcsrsvdout_out(),
    .phystatus_out(),
    .pinrsrvdas_out(),
    .powerpresent_out(),
    .resetexception_out(),
    .rxbufstatus_out(),
    .rxbyteisaligned_out(),
    .rxbyterealign_out(),
    .rxcdrlock_out(rxcdrlock_out),
    .rxcdrphdone_out(),
    .rxchanbondseq_out(),
    .rxchanisaligned_out(),
    .rxchanrealign_out(),
    .rxchbondo_out(),
    .rxckcaldone_out(),
    .rxclkcorcnt_out(),
    .rxcominitdet_out(),
    .rxcommadet_out(rxcommadet_out),
    .rxcomsasdet_out(),
    .rxcomwakedet_out(),
    .rxctrl0_out(rxctrl0_out),
    .rxctrl1_out(rxctrl1_out),
    .rxctrl2_out(rxctrl2_out),
    .rxctrl3_out(rxctrl3_out),
    .rxdata_out(rxdata_out),
    .rxdataextendrsvd_out(),
    .rxdatavalid_out(rxdatavalid_out),
    .rxdlysresetdone_out(rxdlysresetdone_out),
    .rxelecidle_out(),
    .rxheader_out(rxheader_out),
    .rxheadervalid_out(rxheadervalid_out),
    .rxlfpstresetdet_out(),
    .rxlfpsu2lpexitdet_out(),
    .rxlfpsu3wakedet_out(),
    .rxmonitorout_out(),
    .rxosintdone_out(),
    .rxosintstarted_out(),
    .rxosintstrobedone_out(),
    .rxosintstrobestarted_out(),
    .rxoutclk_out(rxoutclk_out),
    .rxoutclkfabric_out(),
    .rxoutclkpcs_out(),
    .rxphaligndone_out(rxphaligndone_out),
    .rxphalignerr_out(),
    .rxpmaresetdone_out(rxpmaresetdone_out),
    .rxprbserr_out(rxprbserr_out),
    .rxprbslocked_out(),
    .rxprgdivresetdone_out(rxprgdivresetdone_out),
    .rxqpisenn_out(),
    .rxqpisenp_out(),
    .rxratedone_out(),
    .rxrecclkout_out(rxrecclkout_out),
    .rxresetdone_out(rxresetdone_out),
    .rxsliderdy_out(),
    .rxslipdone_out(),
    .rxslipoutclkrdy_out(),
    .rxslippmardy_out(),
    .rxstartofseq_out(rxstartofseq_out),
    .rxstatus_out(),
    .rxsyncdone_out(rxsyncdone_out),
    .rxsyncout_out(rxsyncout_out),
    .rxvalid_out(),
    .txbufstatus_out(),
    .txcomfinish_out(),
    .txdccdone_out(),
    .txdlysresetdone_out(txdlysresetdone_out),
    .txoutclk_out(txoutclk_out),
    .txoutclkfabric_out(),
    .txoutclkpcs_out(),
    .txphaligndone_out(txphaligndone_out),
    .txphinitdone_out(txphinitdone_out),
    .txpmaresetdone_out(txpmaresetdone_out),
    .txprgdivresetdone_out(txprgdivresetdone_out),
    .txqpisenn_out(),
    .txqpisenp_out(),
    .txratedone_out(),
    .txresetdone_out(txresetdone_out),
    .txsyncdone_out(txsyncdone_out),
    .txsyncout_out(txsyncout_out)
  );
endmodule