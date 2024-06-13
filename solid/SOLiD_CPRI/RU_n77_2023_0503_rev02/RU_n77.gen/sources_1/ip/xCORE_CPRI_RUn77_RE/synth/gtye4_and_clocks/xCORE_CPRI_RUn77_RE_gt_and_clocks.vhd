-----------------------------------------------------------------------
-- Title      : Transceiver, clock resources and reset logic for CPRI
--              design on Ultrascale.
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_RE_gt_and_clocks.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: This block creates the clocking and reset logic for
--              the Ultrascale GT which is also instanced here.
-----------------------------------------------------------------------
-- (c) Copyright 2009 - 2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_14;
use cpri_v8_11_14.all;

library gtwizard_ultrascale_v1_7_15;
use gtwizard_ultrascale_v1_7_15.all;

entity xCORE_CPRI_RUn77_RE_gt_and_clocks is
generic (
  WRAPPER_SIM_GTXRESET_SPEEDUP : integer := 0);
port (
  gt_txresetdone          : out std_logic;
  gt_rxresetdone          : out std_logic;
  -- Input clocks & resets
  refclk                  : in  std_logic;
  aux_clk                 : in  std_logic;
  gtwiz_reset_clk_freerun_in : in std_logic;
  reset                   : in  std_logic;
  watchdog_reset          : in  std_logic;
  mmcm_reset_req          : in  std_logic;

  -- Output clocks & resets
  blocksync               : out std_logic;
  rec_clk_rst             : out std_logic;
  txoutclk                : out std_logic;
  txresetdone_o           : out std_logic;

  -- GT Common Ports
  qpll0clk                : in  std_logic;
  qpll0refclk             : in  std_logic;
  qpll1clk                : in  std_logic;
  qpll1refclk             : in  std_logic;
  qpll0lock               : in  std_logic;
  qpll0_pd                : out std_logic;
  qpll1lock               : in  std_logic;
  qpll1_pd                : out std_logic;

  -- serial I/O
  txn                     : out std_logic;
  txp                     : out std_logic;
  rxn                     : in  std_logic;
  rxp                     : in  std_logic;

  -- Transmit datapath from core
  txcharisk               : in  std_logic_vector( 7 downto 0);
  txdata                  : in  std_logic_vector(63 downto 0);

  txheader                : in  std_logic_vector(1 downto 0);
  txsequence              : in  std_logic_vector(6 downto 0);

  -- Receive datapath to core
  rxdata                  : out std_logic_vector(63 downto 0);
  rxchariscomma           : out std_logic_vector( 7 downto 0);
  rxcharisk               : out std_logic_vector( 7 downto 0);
  rxcharerr               : out std_logic_vector( 7 downto 0);

  rxdatavalid             : out std_logic;
  rxheader                : out std_logic_vector(1 downto 0);
  rxheadervalid           : out std_logic;

  -- FEC alignment control
  fec_alignment_en        : in  std_logic;

  -- GTX control
  loopback                : in  std_logic_vector( 2 downto 0);
  txinhibit               : in  std_logic;
  encommaalign            : in  std_logic;

  -- Core DRP
  core_drp_arb_req        : in  std_logic;
  core_drp_arb_gnt        : out std_logic;
  core_drp_dout           : in  std_logic_vector(15 downto 0);
  core_drp_daddr          : in  std_logic_vector(7 downto 0);
  core_drp_dwe            : in  std_logic;
  core_gt_din             : out std_logic_vector(15 downto 0);
  core_gt_den             : in  std_logic;
  core_gt_drdy            : out std_logic;
  -- User DRP - GT only
  user_drp_dout           : in  std_logic_vector(15 downto 0);
  user_drp_daddr          : in  std_logic_vector(9 downto 0);
  user_drp_dwe            : in  std_logic;
  user_gt_din             : out std_logic_vector(15 downto 0);
  user_gt_den             : in  std_logic;
  user_gt_drdy            : out std_logic;

  -- Line rate
  speed_select            : in  std_logic_vector(10 downto 0);
  qpll_select             : in  std_logic;
  mmcm_rst                : out std_logic;
  rxoutclk                : out std_logic;
  rxrecclkout             : out std_logic;
  txusrclk                : in  std_logic;
  txusrclk2               : in  std_logic;
  rxusrclk2               : in  std_logic;
  hires_clk               : in  std_logic;
  gtreset_sm_done         : out std_logic;
  userclk_tx_reset        : out std_logic;
  userclk_rx_reset        : out std_logic;
  txdlyen                 : in  std_logic;
  txphinit                : in  std_logic;
  phase_alignment_done    : in  std_logic;
  txdlysreset             : in  std_logic;
  txphalign               : in  std_logic;
  txphaligndone           : out std_logic;
  txphinitdone_o          : out std_logic;
  txdlysresetdone         : out std_logic;
  txsyncdone_o            : out std_logic);
end xCORE_CPRI_RUn77_RE_gt_and_clocks;

architecture rtl of xCORE_CPRI_RUn77_RE_gt_and_clocks is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component xCORE_CPRI_RUn77_RE_drp_arbiter
  port (
    clk               : in  std_logic;
    reset             : in  std_logic;
    -- Core DRP
    core_drp_arb_req  : in  std_logic;
    core_drp_arb_gnt  : out std_logic;
    core_drp_dout     : in  std_logic_vector(15 downto 0);
    core_drp_daddr    : in  std_logic_vector(9 downto 0);
    core_drp_dwe      : in  std_logic;
    core_gt_din       : out std_logic_vector(15 downto 0);
    core_gt_den       : in  std_logic;
    core_gt_drdy      : out std_logic;
    -- User DRP - GT only
    user_drp_arb_req  : in  std_logic;
    user_drp_arb_gnt  : out std_logic;
    user_drp_dout     : in  std_logic_vector(15 downto 0);
    user_drp_daddr    : in  std_logic_vector(9 downto 0);
    user_drp_dwe      : in  std_logic;
    user_gt_din       : out std_logic_vector(15 downto 0);
    user_gt_den       : in  std_logic;
    user_gt_drdy      : out std_logic;
    -- State machine DRP
    sm_drp_arb_req    : in  std_logic;
    sm_drp_arb_gnt    : out std_logic;
    sm_drp_dout       : in  std_logic_vector(15 downto 0);
    sm_drp_daddr      : in  std_logic_vector(9 downto 0);
    sm_drp_dwe        : in  std_logic;
    sm_gt_din         : out std_logic_vector(15 downto 0);
    sm_gt_den         : in  std_logic;
    sm_gt_drdy        : out std_logic;
    --- DRP Outputs
    drp_arb_req       : out std_logic;
    drp_arb_gnt       : in  std_logic;
    drp_dout          : out std_logic_vector(15 downto 0);
    drp_daddr         : out std_logic_vector(9 downto 0);
    drp_dwe           : out std_logic;
    gt_din            : in  std_logic_vector(15 downto 0);
    gt_den            : out std_logic;
    gt_drdy           : in  std_logic);
  end component;

 --------------------------------------------------------------------------
 -- Component declaration for the GTHE3 transceiver container
 --------------------------------------------------------------------------
  component xCORE_CPRI_RUn77_RE_gt
  port(
    cplllock_out : out std_logic_vector(0 downto 0);
    cplllockdetclk_in : in std_logic_vector(0 downto 0);
    cplllocken_in : in std_logic_vector(0 downto 0);
    cpllpd_in : in std_logic_vector(0 downto 0);
    cpllreset_in : in std_logic_vector(0 downto 0);
    dmonitorout_out : out std_logic_vector(15 downto 0);
    drpaddr_in : in std_logic_vector(9 downto 0);
    drpclk_in : in std_logic_vector(0 downto 0);
    drpdi_in : in std_logic_vector(15 downto 0);
    drpdo_out : out std_logic_vector(15 downto 0);
    drpen_in : in std_logic_vector(0 downto 0);
    drprdy_out : out std_logic_vector(0 downto 0);
    drpwe_in : in std_logic_vector(0 downto 0);
    eyescandataerror_out : out std_logic_vector(0 downto 0);
    eyescanreset_in : in std_logic_vector(0 downto 0);
    eyescantrigger_in : in std_logic_vector(0 downto 0);
    gtpowergood_out : out std_logic_vector(0 downto 0);
    gtrefclk0_in : in std_logic_vector(0 downto 0);
    gtrxreset_in : in std_logic_vector(0 downto 0);
    gttxreset_in : in std_logic_vector(0 downto 0);
    gtwiz_gtye4_cpll_cal_bufg_ce_in : in std_logic_vector(0 downto 0);
    gtwiz_gtye4_cpll_cal_cnt_tol_in : in std_logic_vector(17 downto 0);
    gtwiz_gtye4_cpll_cal_txoutclk_period_in : in std_logic_vector(17 downto 0);
    gtwiz_reset_rx_done_in : in std_logic_vector(0 downto 0);
    gtwiz_reset_tx_done_in : in std_logic_vector(0 downto 0);
    gtwiz_userclk_rx_active_in : in std_logic_vector(0 downto 0);
    gtwiz_userclk_tx_active_in : in std_logic_vector(0 downto 0);
    gtwiz_userclk_tx_reset_in : in std_logic_vector(0 downto 0);
    gtyrxn_in : in std_logic_vector(0 downto 0);
    gtyrxp_in : in std_logic_vector(0 downto 0);
    gtytxn_out : out std_logic_vector(0 downto 0);
    gtytxp_out : out std_logic_vector(0 downto 0);
    loopback_in : in std_logic_vector(2 downto 0);
    pcsrsvdin_in : in std_logic_vector(15 downto 0);
    qpll0clk_in : in std_logic_vector(0 downto 0);
    qpll0refclk_in : in std_logic_vector(0 downto 0);
    qpll1clk_in : in std_logic_vector(0 downto 0);
    qpll1refclk_in : in std_logic_vector(0 downto 0);
    rx8b10ben_in : in std_logic_vector(0 downto 0);
    rxcdrhold_in : in std_logic_vector(0 downto 0);
    rxcdrlock_out : out std_logic_vector(0 downto 0);
    rxcommadet_out : out std_logic_vector(0 downto 0);
    rxcommadeten_in : in std_logic_vector(0 downto 0);
    rxctrl0_out : out std_logic_vector(15 downto 0);
    rxctrl1_out : out std_logic_vector(15 downto 0);
    rxctrl2_out : out std_logic_vector(7 downto 0);
    rxctrl3_out : out std_logic_vector(7 downto 0);
    rxdata_out : out std_logic_vector(127 downto 0);
    rxdatavalid_out : out std_logic_vector(1 downto 0);
    rxdfeagcovrden_in : in std_logic_vector(0 downto 0);
    rxdfelfovrden_in : in std_logic_vector(0 downto 0);
    rxdfelpmreset_in : in std_logic_vector(0 downto 0);
    rxdlybypass_in : in std_logic_vector(0 downto 0);
    rxdlyen_in : in std_logic_vector(0 downto 0);
    rxdlyovrden_in : in std_logic_vector(0 downto 0);
    rxdlysreset_in : in std_logic_vector(0 downto 0);
    rxdlysresetdone_out : out std_logic_vector(0 downto 0);
    rxgearboxslip_in : in std_logic_vector(0 downto 0);
    rxheader_out : out std_logic_vector(5 downto 0);
    rxheadervalid_out : out std_logic_vector(1 downto 0);
    rxlatclk_in : in std_logic_vector(0 downto 0);
    rxlpmen_in : in std_logic_vector(0 downto 0);
    rxmcommaalignen_in : in std_logic_vector(0 downto 0);
    rxoutclk_out : out std_logic_vector(0 downto 0);
    rxoutclksel_in : in std_logic_vector(2 downto 0);
    rxpcommaalignen_in : in std_logic_vector(0 downto 0);
    rxpcsreset_in : in std_logic_vector(0 downto 0);
    rxphalign_in : in std_logic_vector(0 downto 0);
    rxphaligndone_out : out std_logic_vector(0 downto 0);
    rxphalignen_in : in std_logic_vector(0 downto 0);
    rxphdlypd_in : in std_logic_vector(0 downto 0);
    rxphdlyreset_in : in std_logic_vector(0 downto 0);
    rxpllclksel_in : in std_logic_vector(1 downto 0);
    rxpmareset_in : in std_logic_vector(0 downto 0);
    rxpmaresetdone_out : out std_logic_vector(0 downto 0);
    rxpolarity_in : in std_logic_vector(0 downto 0);
    rxprbscntreset_in : in std_logic_vector(0 downto 0);
    rxprbserr_out : out std_logic_vector(0 downto 0);
    rxprbssel_in : in std_logic_vector(3 downto 0);
    rxprgdivresetdone_out : out std_logic_vector(0 downto 0);
    rxprogdivreset_in : in std_logic_vector(0 downto 0);
    rxrate_in : in std_logic_vector(2 downto 0);
    rxrecclkout_out : out std_logic_vector(0 downto 0);
    rxresetdone_out : out std_logic_vector(0 downto 0);
    rxstartofseq_out : out std_logic_vector(1 downto 0);
    rxsyncallin_in : in std_logic_vector(0 downto 0);
    rxsyncdone_out : out std_logic_vector(0 downto 0);
    rxsyncin_in : in std_logic_vector(0 downto 0);
    rxsyncmode_in : in std_logic_vector(0 downto 0);
    rxsyncout_out : out std_logic_vector(0 downto 0);
    rxsysclksel_in : in std_logic_vector(1 downto 0);
    rxuserrdy_in : in std_logic_vector(0 downto 0);
    rxusrclk2_in : in std_logic_vector(0 downto 0);
    rxusrclk_in : in std_logic_vector(0 downto 0);
    tx8b10ben_in : in std_logic_vector(0 downto 0);
    txctrl0_in : in std_logic_vector(15 downto 0);
    txctrl1_in : in std_logic_vector(15 downto 0);
    txctrl2_in : in std_logic_vector(7 downto 0);
    txdata_in : in std_logic_vector(127 downto 0);
    txdiffctrl_in : in std_logic_vector(4 downto 0);
    txdlybypass_in : in std_logic_vector(0 downto 0);
    txdlyen_in : in std_logic_vector(0 downto 0);
    txdlyhold_in : in std_logic_vector(0 downto 0);
    txdlyovrden_in : in std_logic_vector(0 downto 0);
    txdlysreset_in : in std_logic_vector(0 downto 0);
    txdlysresetdone_out : out std_logic_vector(0 downto 0);
    txdlyupdown_in : in std_logic_vector(0 downto 0);
    txheader_in : in std_logic_vector(5 downto 0);
    txinhibit_in : in std_logic_vector(0 downto 0);
    txlatclk_in : in std_logic_vector(0 downto 0);
    txoutclk_out : out std_logic_vector(0 downto 0);
    txpcsreset_in : in std_logic_vector(0 downto 0);
    txphalign_in : in std_logic_vector(0 downto 0);
    txphaligndone_out : out std_logic_vector(0 downto 0);
    txphalignen_in : in std_logic_vector(0 downto 0);
    txphdlypd_in : in std_logic_vector(0 downto 0);
    txphdlyreset_in : in std_logic_vector(0 downto 0);
    txphdlytstclk_in : in std_logic_vector(0 downto 0);
    txphinit_in : in std_logic_vector(0 downto 0);
    txphinitdone_out : out std_logic_vector(0 downto 0);
    txphovrden_in : in std_logic_vector(0 downto 0);
    txpippmpd_in : in std_logic_vector(0 downto 0);
    txpippmsel_in : in std_logic_vector(0 downto 0);
    txpllclksel_in : in std_logic_vector(1 downto 0);
    txpmareset_in : in std_logic_vector(0 downto 0);
    txpmaresetdone_out : out std_logic_vector(0 downto 0);
    txpolarity_in : in std_logic_vector(0 downto 0);
    txpostcursor_in : in std_logic_vector(4 downto 0);
    txprbsforceerr_in : in std_logic_vector(0 downto 0);
    txprbssel_in : in std_logic_vector(3 downto 0);
    txprecursor_in : in std_logic_vector(4 downto 0);
    txprgdivresetdone_out : out std_logic_vector(0 downto 0);
    txprogdivreset_in : in std_logic_vector(0 downto 0);
    txresetdone_out : out std_logic_vector(0 downto 0);
    txsequence_in : in std_logic_vector(6 downto 0);
    txsyncallin_in : in std_logic_vector(0 downto 0);
    txsyncdone_out : out std_logic_vector(0 downto 0);
    txsyncin_in : in std_logic_vector(0 downto 0);
    txsyncmode_in : in std_logic_vector(0 downto 0);
    txsyncout_out : out std_logic_vector(0 downto 0);
    txsysclksel_in : in std_logic_vector(1 downto 0);
    txuserrdy_in : in std_logic_vector(0 downto 0);
    txusrclk2_in : in std_logic_vector(0 downto 0);
    txusrclk_in : in std_logic_vector(0 downto 0)
  );  end component;


  component xCORE_CPRI_RUn77_RE_reset_synchronizer is
  port (
    reset_in  : in  std_logic;
    clk       : in  std_logic;
    reset_out : out std_logic);
  end component;

  component xCORE_CPRI_RUn77_RE_synchronizer is
    port (
      q     : out std_logic;
      clk   : in  std_logic;
      d     : in  std_logic);
  end component;

  component xCORE_CPRI_RUn77_RE_block_sync_sm is
  generic (
    SH_CNT_MAX         : integer := 64;
    SH_INVALID_CNT_MAX : integer := 16);
  port (
    blocksync_out      : out std_logic;
    rxgearboxslip_out  : out std_logic;
    rxheader_in        : in  std_logic_vector(2 downto 0);
    rxheadervalid_in   : in  std_logic;
    user_clk           : in  std_logic;
    system_reset       : in  std_logic);
  end component;

  component xCORE_CPRI_RUn77_RE_speed_change is
  port (
    reset                : in  std_logic;
    clk                  : in  std_logic;
    speed_select         : in  std_logic_vector(10 downto 0);
    qpll_select          : in  std_logic;

    gt_daddr             : out std_logic_vector(9 downto 0);
    gt_den               : out std_logic;
    gt_dwe               : out std_logic;
    gt_di                : out std_logic_vector(15 downto 0);
    gt_drdy              : in  std_logic;
    gt_do                : in  std_logic_vector(15 downto 0);

    sm_busy              : out std_logic;
    sm_drp_arb_gnt       : in  std_logic;
    gt_reset_req_toggle  : out std_logic;
    cpllreset            : in  std_logic;
    cplllkdet            : in  std_logic);
  end component;

  component gtwizard_ultrascale_v1_7_15_gtwiz_reset is
    generic (P_TX_PLL_TYPE  : integer   := 0);
    port (
      -- User interface ports
      gtwiz_reset_clk_freerun_in          : in  std_logic;
      gtwiz_reset_all_in                  : in  std_logic;
      gtwiz_reset_tx_pll_and_datapath_in  : in  std_logic;
      gtwiz_reset_tx_datapath_in          : in  std_logic;
      gtwiz_reset_rx_pll_and_datapath_in  : in  std_logic;
      gtwiz_reset_rx_datapath_in          : in  std_logic;
      gtwiz_reset_rx_cdr_stable_out       : out std_logic;
      gtwiz_reset_tx_done_out             : out std_logic;
      gtwiz_reset_rx_done_out             : out std_logic;
      gtwiz_reset_userclk_tx_active_in    : in  std_logic;
      gtwiz_reset_userclk_rx_active_in    : in  std_logic;

      -- Transceiver interface ports
      gtpowergood_in                      : in  std_logic;
      txusrclk2_in                        : in  std_logic;
      plllock_tx_in                       : in  std_logic;
      txresetdone_in                      : in  std_logic;
      rxusrclk2_in                        : in  std_logic;
      plllock_rx_in                       : in  std_logic;
      rxcdrlock_in                        : in  std_logic;
      rxresetdone_in                      : in  std_logic;
      pllreset_tx_out                     : out std_logic;
      txprogdivreset_out                  : out std_logic;
      gttxreset_out                       : out std_logic;
      txuserrdy_out                       : out std_logic;
      pllreset_rx_out                     : out std_logic;
      rxprogdivreset_out                  : out std_logic;
      gtrxreset_out                       : out std_logic;
      rxuserrdy_out                       : out std_logic;

      -- Tie-offs based on core configuration
      tx_enabled_tie_in                   : in  std_logic;
      rx_enabled_tie_in                   : in  std_logic;
      shared_pll_tie_in                   : in  std_logic);
  end component;

  component cpri_v8_11_14_rx_buffer_bypass is
    port (
      -- User interface ports
      gtwiz_buffbypass_rx_clk_in        : in  std_logic;
      gtwiz_buffbypass_rx_reset_in      : in  std_logic;
      gtwiz_buffbypass_rx_start_user_in : in  std_logic;
      gtwiz_buffbypass_rx_resetdone_in  : in  std_logic;
      gtwiz_buffbypass_rx_done_out      : out std_logic;
      gtwiz_buffbypass_rx_error_out     : out std_logic;
      -- Transceiver interface ports
      rxphaligndone_in                  : in  std_logic;
      rxdlysresetdone_in                : in  std_logic;
      rxsyncout_in                      : in  std_logic;
      rxsyncdone_in                     : in  std_logic;
      rxphdlyreset_out                  : out std_logic;
      rxphalign_out                     : out std_logic;
      rxphalignen_out                   : out std_logic;
      rxphdlypd_out                     : out std_logic;
      rxphovrden_out                    : out std_logic;
      rxdlysreset_out                   : out std_logic;
      rxdlybypass_out                   : out std_logic;
      rxdlyen_out                       : out std_logic;
      rxdlyovrden_out                   : out std_logic;
      rxsyncmode_out                    : out std_logic;
      rxsyncallin_out                   : out std_logic;
      rxsyncin_out                      : out std_logic);
  end component;

  -- GTHE3 ports
  ------------------- Receive Ports - RX Data Path interface -----------------
  signal rxdatavalid_gt                : std_logic;
  signal rxheader_gt                   : std_logic_vector(1 downto 0);
  signal rxheadervalid_gt              : std_logic;
  signal rxdata_gt                     : std_logic_vector(63 downto 0);
  ----------------------- Receive Ports - 8b10b Decoder ----------------------
  signal rxchariscomma_gt              : std_logic_vector(7 downto 0);
  signal rxcharisk_gt                  : std_logic_vector(7 downto 0);
  signal rxdisperr_gt                  : std_logic_vector(7 downto 0);
  signal rxnotintable_gt               : std_logic_vector(7 downto 0);
  signal rxcharisk28_5                 : std_logic_vector(7 downto 0);
  signal rxcharerr_i                   : std_logic_vector(7 downto 0);

  signal rxdatavalid_r                 : std_logic;
  signal rxheader_r                    : std_logic_vector(1 downto 0);
  signal rxheadervalid_r               : std_logic;
  signal rxdata_r                      : std_logic_vector(63 downto 0);
  signal rxdisperr_r                   : std_logic_vector(7 downto 0);
  signal rxnotintable_r                : std_logic_vector(7 downto 0);
  signal rxcharisk_r                   : std_logic_vector(7 downto 0);
  signal rxchariscomma_r               : std_logic_vector(7 downto 0);
  ------------------------ Receive Ports - RX PLL Ports ----------------------
  signal rxprogdivreset_in_i           : std_logic;
  signal plllock                       : std_logic;
  ----------------------- Transmit Ports - TX PLL Ports ----------------------
  signal gtxreset                      : std_logic;
  signal pll_reset                     : std_logic;
  signal tx_clk_gen_reset              : std_logic;
  signal txprogdivreset_in_i           : std_logic;
  signal rx_sync_rst                   : std_logic;

  signal gt_daddr                      : std_logic_vector(9 downto 0);
  signal gt_den                        : std_logic;
  signal gt_di                         : std_logic_vector(15 downto 0);
  signal gt_do                         : std_logic_vector(15 downto 0);
  signal gt_dwe                        : std_logic;
  signal gt_drdy                       : std_logic;
  signal gt_drdy_r                     : std_logic := '0';
  signal mmcm_reset                    : std_logic;

  signal speed_select_r1               : std_logic_vector(10 downto 0);
  signal speed_select_r2               : std_logic_vector(10 downto 0);
  signal blocksync_i                   : std_logic;
  signal blocksync_out                 : std_logic;
  signal blocksync_auxclk              : std_logic;
  signal line_rate_64b66b              : std_logic;
  signal line_rate_64b66b_rx_sync      : std_logic;
  signal line_rate_64b66b_tx_sync      : std_logic;
  signal rxresetdone_n                 : std_logic;
  signal rxgearboxslip_i               : std_logic;

  signal gtwiz_buffbypass_rx_reset_in  : std_logic;
  signal gtwiz_buffbypass_rx_done_out  : std_logic;
  signal gtwiz_bufbyp_rxdone_sync      : std_logic;
  signal gtwiz_buffbypass_rx_reset_int : std_logic;

  signal sm_busy                       : std_logic;
  signal rxresetdone_sync              : std_logic := '0';
  signal txresetdone_sync              : std_logic := '0';


  signal sysclksel                     : std_logic_vector(1 downto 0);
  signal pllclksel                     : std_logic_vector(1 downto 0);
  type t_state_pd is (IDLE, WAIT_FOR_SPEED_CHANGE, POWER_UP, WAIT_CPLL_RST);
  signal cpll_pd                       : std_logic;
  signal qpll0lkdet_r                  : std_logic;
  signal qpll1lkdet_r                  : std_logic;
  signal plllock_in_i                  : std_logic;
  signal rxplllkdet                    : std_logic;
  signal pd_sm_state                   : t_state_pd;
  signal cplllkdet_r                   : std_logic;
  signal cpll_rst                      : std_logic;
  signal cpll_rst_sync                 : std_logic;

  type tx_reset_state is (TX_START, TX_IDLE);
  type rx_reset_state is (RX_START, RX_IDLE);
  signal tx_state                      : tx_reset_state;
  signal rx_state                      : rx_reset_state;
  signal tx_reset_recovery             : std_logic;
  signal rx_reset_recovery             : std_logic;
  signal rx_reset_rec_watchdog         : std_logic;
  signal gtwiz_reset_tx_done_in_sync   : std_logic;
  signal gtwiz_reset_rx_done_in_sync   : std_logic;
  signal sm_busy_sync                  : std_logic;
  signal watchdog_reset_sync           : std_logic;

  signal gt_reset_req_toggle           : std_logic := '0';
  signal gt_reset_req_toggle_r         : std_logic;
  signal gt_reset_req                  : std_logic;
  signal gt_reset_req_i                : std_logic;

  signal fec_alignment_en_sync         : std_logic;

  -- Signals to and from the GTHE3_CHANNEL
  signal cplllock_out : std_logic;
  signal cplllock_out_int : std_logic_vector(0 downto 0);
  signal cplllockdetclk_in : std_logic;
  signal cplllockdetclk_in_int : std_logic_vector(0 downto 0);
  signal cplllocken_in : std_logic;
  signal cplllocken_in_int : std_logic_vector(0 downto 0);
  signal cpllpd_in : std_logic;
  signal cpllpd_in_int : std_logic_vector(0 downto 0);
  signal cpllreset_in : std_logic;
  signal cpllreset_in_int : std_logic_vector(0 downto 0);
  signal dmonitorout_out : std_logic_vector(15 downto 0);
  signal drpaddr_in : std_logic_vector(9 downto 0);
  signal drpclk_in : std_logic;
  signal drpclk_in_int : std_logic_vector(0 downto 0);
  signal drpdi_in : std_logic_vector(15 downto 0);
  signal drpdo_out : std_logic_vector(15 downto 0);
  signal drpen_in : std_logic;
  signal drpen_in_int : std_logic_vector(0 downto 0);
  signal drprdy_out : std_logic;
  signal drprdy_out_int : std_logic_vector(0 downto 0);
  signal drpwe_in : std_logic;
  signal drpwe_in_int : std_logic_vector(0 downto 0);
  signal eyescandataerror_out : std_logic;
  signal eyescandataerror_out_int : std_logic_vector(0 downto 0);
  signal eyescanreset_in : std_logic;
  signal eyescanreset_in_int : std_logic_vector(0 downto 0);
  signal eyescantrigger_in : std_logic;
  signal eyescantrigger_in_int : std_logic_vector(0 downto 0);
  signal gtpowergood_out : std_logic;
  signal gtpowergood_out_int : std_logic_vector(0 downto 0);
  signal gtrefclk0_in : std_logic;
  signal gtrefclk0_in_int : std_logic_vector(0 downto 0);
  signal gtrxreset_in : std_logic;
  signal gtrxreset_in_int : std_logic_vector(0 downto 0);
  signal gttxreset_in : std_logic;
  signal gttxreset_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_gtye4_cpll_cal_bufg_ce_in : std_logic;
  signal gtwiz_gtye4_cpll_cal_bufg_ce_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_gtye4_cpll_cal_cnt_tol_in : std_logic_vector(17 downto 0);
  signal gtwiz_gtye4_cpll_cal_txoutclk_period_in : std_logic_vector(17 downto 0);
  signal gtwiz_reset_rx_done_in : std_logic;
  signal gtwiz_reset_rx_done_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_reset_tx_done_in : std_logic;
  signal gtwiz_reset_tx_done_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_active_in : std_logic;
  signal gtwiz_userclk_rx_active_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_active_in : std_logic;
  signal gtwiz_userclk_tx_active_in_int : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_reset_in : std_logic;
  signal gtwiz_userclk_tx_reset_in_int : std_logic_vector(0 downto 0);
  signal gtyrxn_in : std_logic;
  signal gtyrxn_in_int : std_logic_vector(0 downto 0);
  signal gtyrxp_in : std_logic;
  signal gtyrxp_in_int : std_logic_vector(0 downto 0);
  signal gtytxn_out : std_logic;
  signal gtytxn_out_int : std_logic_vector(0 downto 0);
  signal gtytxp_out : std_logic;
  signal gtytxp_out_int : std_logic_vector(0 downto 0);
  signal loopback_in : std_logic_vector(2 downto 0);
  signal pcsrsvdin_in : std_logic_vector(15 downto 0);
  signal qpll0clk_in : std_logic;
  signal qpll0clk_in_int : std_logic_vector(0 downto 0);
  signal qpll0refclk_in : std_logic;
  signal qpll0refclk_in_int : std_logic_vector(0 downto 0);
  signal qpll1clk_in : std_logic;
  signal qpll1clk_in_int : std_logic_vector(0 downto 0);
  signal qpll1refclk_in : std_logic;
  signal qpll1refclk_in_int : std_logic_vector(0 downto 0);
  signal rx8b10ben_in : std_logic;
  signal rx8b10ben_in_int : std_logic_vector(0 downto 0);
  signal rxcdrhold_in : std_logic;
  signal rxcdrhold_in_int : std_logic_vector(0 downto 0);
  signal rxcdrlock_out : std_logic;
  signal rxcdrlock_out_int : std_logic_vector(0 downto 0);
  signal rxcommadet_out : std_logic;
  signal rxcommadet_out_int : std_logic_vector(0 downto 0);
  signal rxcommadeten_in : std_logic;
  signal rxcommadeten_in_int : std_logic_vector(0 downto 0);
  signal rxctrl0_out : std_logic_vector(15 downto 0);
  signal rxctrl1_out : std_logic_vector(15 downto 0);
  signal rxctrl2_out : std_logic_vector(7 downto 0);
  signal rxctrl3_out : std_logic_vector(7 downto 0);
  signal rxdata_out : std_logic_vector(127 downto 0);
  signal rxdatavalid_out : std_logic_vector(1 downto 0);
  signal rxdfeagcovrden_in : std_logic;
  signal rxdfeagcovrden_in_int : std_logic_vector(0 downto 0);
  signal rxdfelfovrden_in : std_logic;
  signal rxdfelfovrden_in_int : std_logic_vector(0 downto 0);
  signal rxdfelpmreset_in : std_logic;
  signal rxdfelpmreset_in_int : std_logic_vector(0 downto 0);
  signal rxdlybypass_in : std_logic;
  signal rxdlybypass_in_int : std_logic_vector(0 downto 0);
  signal rxdlyen_in : std_logic;
  signal rxdlyen_in_int : std_logic_vector(0 downto 0);
  signal rxdlyovrden_in : std_logic;
  signal rxdlyovrden_in_int : std_logic_vector(0 downto 0);
  signal rxdlysreset_in : std_logic;
  signal rxdlysreset_in_int : std_logic_vector(0 downto 0);
  signal rxdlysresetdone_out : std_logic;
  signal rxdlysresetdone_out_int : std_logic_vector(0 downto 0);
  signal rxgearboxslip_in : std_logic;
  signal rxgearboxslip_in_int : std_logic_vector(0 downto 0);
  signal rxheader_out : std_logic_vector(5 downto 0);
  signal rxheadervalid_out : std_logic_vector(1 downto 0);
  signal rxlatclk_in : std_logic;
  signal rxlatclk_in_int : std_logic_vector(0 downto 0);
  signal rxlpmen_in : std_logic;
  signal rxlpmen_in_int : std_logic_vector(0 downto 0);
  signal rxmcommaalignen_in : std_logic;
  signal rxmcommaalignen_in_int : std_logic_vector(0 downto 0);
  signal rxoutclk_out : std_logic;
  signal rxoutclk_out_int : std_logic_vector(0 downto 0);
  signal rxoutclksel_in : std_logic_vector(2 downto 0);
  signal rxpcommaalignen_in : std_logic;
  signal rxpcommaalignen_in_int : std_logic_vector(0 downto 0);
  signal rxpcsreset_in : std_logic;
  signal rxpcsreset_in_int : std_logic_vector(0 downto 0);
  signal rxphalign_in : std_logic;
  signal rxphalign_in_int : std_logic_vector(0 downto 0);
  signal rxphaligndone_out : std_logic;
  signal rxphaligndone_out_int : std_logic_vector(0 downto 0);
  signal rxphalignen_in : std_logic;
  signal rxphalignen_in_int : std_logic_vector(0 downto 0);
  signal rxphdlypd_in : std_logic;
  signal rxphdlypd_in_int : std_logic_vector(0 downto 0);
  signal rxphdlyreset_in : std_logic;
  signal rxphdlyreset_in_int : std_logic_vector(0 downto 0);
  signal rxpllclksel_in : std_logic_vector(1 downto 0);
  signal rxpmareset_in : std_logic;
  signal rxpmareset_in_int : std_logic_vector(0 downto 0);
  signal rxpmaresetdone_out : std_logic;
  signal rxpmaresetdone_out_int : std_logic_vector(0 downto 0);
  signal rxpolarity_in : std_logic;
  signal rxpolarity_in_int : std_logic_vector(0 downto 0);
  signal rxprbscntreset_in : std_logic;
  signal rxprbscntreset_in_int : std_logic_vector(0 downto 0);
  signal rxprbserr_out : std_logic;
  signal rxprbserr_out_int : std_logic_vector(0 downto 0);
  signal rxprbssel_in : std_logic_vector(3 downto 0);
  signal rxprgdivresetdone_out : std_logic;
  signal rxprgdivresetdone_out_int : std_logic_vector(0 downto 0);
  signal rxprogdivreset_in : std_logic;
  signal rxprogdivreset_in_int : std_logic_vector(0 downto 0);
  signal rxrate_in : std_logic_vector(2 downto 0);
  signal rxrecclkout_out : std_logic;
  signal rxrecclkout_out_int : std_logic_vector(0 downto 0);
  signal rxresetdone_out : std_logic;
  signal rxresetdone_out_int : std_logic_vector(0 downto 0);
  signal rxstartofseq_out : std_logic_vector(1 downto 0);
  signal rxsyncallin_in : std_logic;
  signal rxsyncallin_in_int : std_logic_vector(0 downto 0);
  signal rxsyncdone_out : std_logic;
  signal rxsyncdone_out_int : std_logic_vector(0 downto 0);
  signal rxsyncin_in : std_logic;
  signal rxsyncin_in_int : std_logic_vector(0 downto 0);
  signal rxsyncmode_in : std_logic;
  signal rxsyncmode_in_int : std_logic_vector(0 downto 0);
  signal rxsyncout_out : std_logic;
  signal rxsyncout_out_int : std_logic_vector(0 downto 0);
  signal rxsysclksel_in : std_logic_vector(1 downto 0);
  signal rxuserrdy_in : std_logic;
  signal rxuserrdy_in_int : std_logic_vector(0 downto 0);
  signal rxusrclk2_in : std_logic;
  signal rxusrclk2_in_int : std_logic_vector(0 downto 0);
  signal rxusrclk_in : std_logic;
  signal rxusrclk_in_int : std_logic_vector(0 downto 0);
  signal tx8b10ben_in : std_logic;
  signal tx8b10ben_in_int : std_logic_vector(0 downto 0);
  signal txctrl0_in : std_logic_vector(15 downto 0);
  signal txctrl1_in : std_logic_vector(15 downto 0);
  signal txctrl2_in : std_logic_vector(7 downto 0);
  signal txdata_in : std_logic_vector(127 downto 0);
  signal txdiffctrl_in : std_logic_vector(4 downto 0);
  signal txdlybypass_in : std_logic;
  signal txdlybypass_in_int : std_logic_vector(0 downto 0);
  signal txdlyen_in : std_logic;
  signal txdlyen_in_int : std_logic_vector(0 downto 0);
  signal txdlyhold_in : std_logic;
  signal txdlyhold_in_int : std_logic_vector(0 downto 0);
  signal txdlyovrden_in : std_logic;
  signal txdlyovrden_in_int : std_logic_vector(0 downto 0);
  signal txdlysreset_in : std_logic;
  signal txdlysreset_in_int : std_logic_vector(0 downto 0);
  signal txdlysresetdone_out : std_logic;
  signal txdlysresetdone_out_int : std_logic_vector(0 downto 0);
  signal txdlyupdown_in : std_logic;
  signal txdlyupdown_in_int : std_logic_vector(0 downto 0);
  signal txheader_in : std_logic_vector(5 downto 0);
  signal txinhibit_in : std_logic;
  signal txinhibit_in_int : std_logic_vector(0 downto 0);
  signal txlatclk_in : std_logic;
  signal txlatclk_in_int : std_logic_vector(0 downto 0);
  signal txoutclk_out : std_logic;
  signal txoutclk_out_int : std_logic_vector(0 downto 0);
  signal txpcsreset_in : std_logic;
  signal txpcsreset_in_int : std_logic_vector(0 downto 0);
  signal txphalign_in : std_logic;
  signal txphalign_in_int : std_logic_vector(0 downto 0);
  signal txphaligndone_out : std_logic;
  signal txphaligndone_out_int : std_logic_vector(0 downto 0);
  signal txphalignen_in : std_logic;
  signal txphalignen_in_int : std_logic_vector(0 downto 0);
  signal txphdlypd_in : std_logic;
  signal txphdlypd_in_int : std_logic_vector(0 downto 0);
  signal txphdlyreset_in : std_logic;
  signal txphdlyreset_in_int : std_logic_vector(0 downto 0);
  signal txphdlytstclk_in : std_logic;
  signal txphdlytstclk_in_int : std_logic_vector(0 downto 0);
  signal txphinit_in : std_logic;
  signal txphinit_in_int : std_logic_vector(0 downto 0);
  signal txphinitdone_out : std_logic;
  signal txphinitdone_out_int : std_logic_vector(0 downto 0);
  signal txphovrden_in : std_logic;
  signal txphovrden_in_int : std_logic_vector(0 downto 0);
  signal txpippmpd_in : std_logic;
  signal txpippmpd_in_int : std_logic_vector(0 downto 0);
  signal txpippmsel_in : std_logic;
  signal txpippmsel_in_int : std_logic_vector(0 downto 0);
  signal txpllclksel_in : std_logic_vector(1 downto 0);
  signal txpmareset_in : std_logic;
  signal txpmareset_in_int : std_logic_vector(0 downto 0);
  signal txpmaresetdone_out : std_logic;
  signal txpmaresetdone_out_int : std_logic_vector(0 downto 0);
  signal txpolarity_in : std_logic;
  signal txpolarity_in_int : std_logic_vector(0 downto 0);
  signal txpostcursor_in : std_logic_vector(4 downto 0);
  signal txprbsforceerr_in : std_logic;
  signal txprbsforceerr_in_int : std_logic_vector(0 downto 0);
  signal txprbssel_in : std_logic_vector(3 downto 0);
  signal txprecursor_in : std_logic_vector(4 downto 0);
  signal txprgdivresetdone_out : std_logic;
  signal txprgdivresetdone_out_int : std_logic_vector(0 downto 0);
  signal txprogdivreset_in : std_logic;
  signal txprogdivreset_in_int : std_logic_vector(0 downto 0);
  signal txresetdone_out : std_logic;
  signal txresetdone_out_int : std_logic_vector(0 downto 0);
  signal txsequence_in : std_logic_vector(6 downto 0);
  signal txsyncallin_in : std_logic;
  signal txsyncallin_in_int : std_logic_vector(0 downto 0);
  signal txsyncdone_out : std_logic;
  signal txsyncdone_out_int : std_logic_vector(0 downto 0);
  signal txsyncin_in : std_logic;
  signal txsyncin_in_int : std_logic_vector(0 downto 0);
  signal txsyncmode_in : std_logic;
  signal txsyncmode_in_int : std_logic_vector(0 downto 0);
  signal txsyncout_out : std_logic;
  signal txsyncout_out_int : std_logic_vector(0 downto 0);
  signal txsysclksel_in : std_logic_vector(1 downto 0);
  signal txuserrdy_in : std_logic;
  signal txuserrdy_in_int : std_logic_vector(0 downto 0);
  signal txusrclk2_in : std_logic;
  signal txusrclk2_in_int : std_logic_vector(0 downto 0);
  signal txusrclk_in : std_logic;
  signal txusrclk_in_int : std_logic_vector(0 downto 0);


  function speedup_convert(sim_speedup : integer) return string is
   begin
      if (sim_speedup = 0) then
        return "FALSE";
      else
        return "TRUE";
      end if;
  end function;

  constant GND   : std_logic := '0';
  constant K28_5 : std_logic_vector(7 downto 0) := x"BC";

  signal cal_block_busy                : std_logic;

  signal drp_arb_req                   : std_logic;
  signal drp_dout                      : std_logic_vector(15 downto 0);
  signal gt_drpen_i                    : std_logic;
  signal gt_drprdy_i                   : std_logic;
  signal gt_drpdaddr_i                 : std_logic_vector(9 downto 0);
  signal core_drp_daddr_i              : std_logic_vector(9 downto 0);
  signal gt_drpwe_i                    : std_logic;
  signal gt_drpdi_i                    : std_logic_vector(15 downto 0);
  signal gt_drp_drdy                   : std_logic;
  signal gt_drp_do                     : std_logic_vector(15 downto 0);
  signal sm_drp_arb_req                : std_logic;
  signal sm_drp_arb_gnt                : std_logic;
  signal user_gt_drdy_i                : std_logic;
  signal user_drp_arb_req              : std_logic;
  signal user_drp_arb_gnt              : std_logic;
  signal user_gt_den_i                 : std_logic;
  signal user_drp_arb_gnt_r            : std_logic;
  signal user_drp_dout_i               : std_logic_vector(15 downto 0);
  signal user_drp_dwe_i                : std_logic;
  signal user_drp_dwe_int              : std_logic;
  signal user_drp_daddr_i              : std_logic_vector(9 downto 0);

  constant Ffreerunmult : real := (245.76 * 16000)/(80 * 125.0);
  constant cpll_cal_frequency_odd            : integer := integer(Ffreerunmult * 12.5);
  constant cpll_cal_frequency_even           : integer := integer(Ffreerunmult * 10.0);
  constant cpll_cal_frequency_even_9g        : integer := integer(Ffreerunmult * 20.0);
  constant cpll_cal_frequency_odd_div100     : integer := integer((Ffreerunmult * 12.5)/100.0);
  constant cpll_cal_frequency_even_div100    : integer := integer((Ffreerunmult * 10.0)/100.0);
  constant cpll_cal_frequency_even_div100_9g : integer := integer((Ffreerunmult * 20.0)/100.0);

  attribute dont_touch : string;
  attribute dont_touch of plllock_in_i : signal is "true";

begin

  txdiffctrl_in <= "01100";

  -- Map single bits to unit-length vectors...
  cplllock_out <= cplllock_out_int(0);
  cplllockdetclk_in_int(0) <= cplllockdetclk_in;
  cplllocken_in_int(0) <= cplllocken_in;
  cpllpd_in_int(0) <= cpllpd_in;
  cpllreset_in_int(0) <= cpllreset_in;
  drpclk_in_int(0) <= drpclk_in;
  drpen_in_int(0) <= drpen_in;
  drprdy_out <= drprdy_out_int(0);
  drpwe_in_int(0) <= drpwe_in;
  eyescandataerror_out <= eyescandataerror_out_int(0);
  eyescanreset_in_int(0) <= eyescanreset_in;
  eyescantrigger_in_int(0) <= eyescantrigger_in;
  gtpowergood_out <= gtpowergood_out_int(0);
  gtrefclk0_in_int(0) <= gtrefclk0_in;
  gtrxreset_in_int(0) <= gtrxreset_in;
  gttxreset_in_int(0) <= gttxreset_in;
  gtwiz_gtye4_cpll_cal_bufg_ce_in_int(0) <= gtwiz_gtye4_cpll_cal_bufg_ce_in;
  gtwiz_reset_rx_done_in_int(0) <= gtwiz_reset_rx_done_in;
  gtwiz_reset_tx_done_in_int(0) <= gtwiz_reset_tx_done_in;
  gtwiz_userclk_rx_active_in_int(0) <= gtwiz_userclk_rx_active_in;
  gtwiz_userclk_tx_active_in_int(0) <= gtwiz_userclk_tx_active_in;
  gtwiz_userclk_tx_reset_in_int(0) <= gtwiz_userclk_tx_reset_in;
  gtyrxn_in_int(0) <= gtyrxn_in;
  gtyrxp_in_int(0) <= gtyrxp_in;
  gtytxn_out <= gtytxn_out_int(0);
  gtytxp_out <= gtytxp_out_int(0);
  qpll0clk_in_int(0) <= qpll0clk_in;
  qpll0refclk_in_int(0) <= qpll0refclk_in;
  qpll1clk_in_int(0) <= qpll1clk_in;
  qpll1refclk_in_int(0) <= qpll1refclk_in;
  rx8b10ben_in_int(0) <= rx8b10ben_in;
  rxcdrhold_in_int(0) <= rxcdrhold_in;
  rxcdrlock_out <= rxcdrlock_out_int(0);
  rxcommadet_out <= rxcommadet_out_int(0);
  rxcommadeten_in_int(0) <= rxcommadeten_in;
  rxdfeagcovrden_in_int(0) <= rxdfeagcovrden_in;
  rxdfelfovrden_in_int(0) <= rxdfelfovrden_in;
  rxdfelpmreset_in_int(0) <= rxdfelpmreset_in;
  rxdlybypass_in_int(0) <= rxdlybypass_in;
  rxdlyen_in_int(0) <= rxdlyen_in;
  rxdlyovrden_in_int(0) <= rxdlyovrden_in;
  rxdlysreset_in_int(0) <= rxdlysreset_in;
  rxdlysresetdone_out <= rxdlysresetdone_out_int(0);
  rxgearboxslip_in_int(0) <= rxgearboxslip_in;
  rxlatclk_in_int(0) <= rxlatclk_in;
  rxlpmen_in_int(0) <= rxlpmen_in;
  rxmcommaalignen_in_int(0) <= rxmcommaalignen_in;
  rxoutclk_out <= rxoutclk_out_int(0);
  rxpcommaalignen_in_int(0) <= rxpcommaalignen_in;
  rxpcsreset_in_int(0) <= rxpcsreset_in;
  rxphalign_in_int(0) <= rxphalign_in;
  rxphaligndone_out <= rxphaligndone_out_int(0);
  rxphalignen_in_int(0) <= rxphalignen_in;
  rxphdlypd_in_int(0) <= rxphdlypd_in;
  rxphdlyreset_in_int(0) <= rxphdlyreset_in;
  rxpmareset_in_int(0) <= rxpmareset_in;
  rxpmaresetdone_out <= rxpmaresetdone_out_int(0);
  rxpolarity_in_int(0) <= rxpolarity_in;
  rxprbscntreset_in_int(0) <= rxprbscntreset_in;
  rxprbserr_out <= rxprbserr_out_int(0);
  rxprgdivresetdone_out <= rxprgdivresetdone_out_int(0);
  rxprogdivreset_in_int(0) <= rxprogdivreset_in;
  rxrecclkout_out <= rxrecclkout_out_int(0);
  rxresetdone_out <= rxresetdone_out_int(0);
  rxsyncallin_in_int(0) <= rxsyncallin_in;
  rxsyncdone_out <= rxsyncdone_out_int(0);
  rxsyncin_in_int(0) <= rxsyncin_in;
  rxsyncmode_in_int(0) <= rxsyncmode_in;
  rxsyncout_out <= rxsyncout_out_int(0);
  rxuserrdy_in_int(0) <= rxuserrdy_in;
  rxusrclk2_in_int(0) <= rxusrclk2_in;
  rxusrclk_in_int(0) <= rxusrclk_in;
  tx8b10ben_in_int(0) <= tx8b10ben_in;
  txdlybypass_in_int(0) <= txdlybypass_in;
  txdlyen_in_int(0) <= txdlyen_in;
  txdlyhold_in_int(0) <= txdlyhold_in;
  txdlyovrden_in_int(0) <= txdlyovrden_in;
  txdlysreset_in_int(0) <= txdlysreset_in;
  txdlysresetdone_out <= txdlysresetdone_out_int(0);
  txdlyupdown_in_int(0) <= txdlyupdown_in;
  txinhibit_in_int(0) <= txinhibit_in;
  txlatclk_in_int(0) <= txlatclk_in;
  txoutclk_out <= txoutclk_out_int(0);
  txpcsreset_in_int(0) <= txpcsreset_in;
  txphalign_in_int(0) <= txphalign_in;
  txphaligndone_out <= txphaligndone_out_int(0);
  txphalignen_in_int(0) <= txphalignen_in;
  txphdlypd_in_int(0) <= txphdlypd_in;
  txphdlyreset_in_int(0) <= txphdlyreset_in;
  txphdlytstclk_in_int(0) <= txphdlytstclk_in;
  txphinit_in_int(0) <= txphinit_in;
  txphinitdone_out <= txphinitdone_out_int(0);
  txphovrden_in_int(0) <= txphovrden_in;
  txpippmpd_in_int(0) <= txpippmpd_in;
  txpippmsel_in_int(0) <= txpippmsel_in;
  txpmareset_in_int(0) <= txpmareset_in;
  txpmaresetdone_out <= txpmaresetdone_out_int(0);
  txpolarity_in_int(0) <= txpolarity_in;
  txprbsforceerr_in_int(0) <= txprbsforceerr_in;
  txprgdivresetdone_out <= txprgdivresetdone_out_int(0);
  txprogdivreset_in_int(0) <= txprogdivreset_in;
  txresetdone_out <= txresetdone_out_int(0);
  txsyncallin_in_int(0) <= txsyncallin_in;
  txsyncdone_out <= txsyncdone_out_int(0);
  txsyncin_in_int(0) <= txsyncin_in;
  txsyncmode_in_int(0) <= txsyncmode_in;
  txsyncout_out <= txsyncout_out_int(0);
  txuserrdy_in_int(0) <= txuserrdy_in;
  txusrclk2_in_int(0) <= txusrclk2_in;
  txusrclk_in_int(0) <= txusrclk_in;


  -- Instance of GT
  xCORE_CPRI_RUn77_RE_gt_i : xCORE_CPRI_RUn77_RE_gt
  port map(
    cplllock_out => cplllock_out_int,
    cplllockdetclk_in => cplllockdetclk_in_int,
    cplllocken_in => cplllocken_in_int,
    cpllpd_in => cpllpd_in_int,
    cpllreset_in => cpllreset_in_int,
    dmonitorout_out => dmonitorout_out,
    drpaddr_in => drpaddr_in,
    drpclk_in => drpclk_in_int,
    drpdi_in => drpdi_in,
    drpdo_out => drpdo_out,
    drpen_in => drpen_in_int,
    drprdy_out => drprdy_out_int,
    drpwe_in => drpwe_in_int,
    eyescandataerror_out => eyescandataerror_out_int,
    eyescanreset_in => eyescanreset_in_int,
    eyescantrigger_in => eyescantrigger_in_int,
    gtpowergood_out => gtpowergood_out_int,
    gtrefclk0_in => gtrefclk0_in_int,
    gtrxreset_in => gtrxreset_in_int,
    gttxreset_in => gttxreset_in_int,
    gtwiz_gtye4_cpll_cal_bufg_ce_in => gtwiz_gtye4_cpll_cal_bufg_ce_in_int,
    gtwiz_gtye4_cpll_cal_cnt_tol_in => gtwiz_gtye4_cpll_cal_cnt_tol_in,
    gtwiz_gtye4_cpll_cal_txoutclk_period_in => gtwiz_gtye4_cpll_cal_txoutclk_period_in,
    gtwiz_reset_rx_done_in => gtwiz_reset_rx_done_in_int,
    gtwiz_reset_tx_done_in => gtwiz_reset_tx_done_in_int,
    gtwiz_userclk_rx_active_in => gtwiz_userclk_rx_active_in_int,
    gtwiz_userclk_tx_active_in => gtwiz_userclk_tx_active_in_int,
    gtwiz_userclk_tx_reset_in => gtwiz_userclk_tx_reset_in_int,
    gtyrxn_in => gtyrxn_in_int,
    gtyrxp_in => gtyrxp_in_int,
    gtytxn_out => gtytxn_out_int,
    gtytxp_out => gtytxp_out_int,
    loopback_in => loopback_in,
    pcsrsvdin_in => pcsrsvdin_in,
    qpll0clk_in => qpll0clk_in_int,
    qpll0refclk_in => qpll0refclk_in_int,
    qpll1clk_in => qpll1clk_in_int,
    qpll1refclk_in => qpll1refclk_in_int,
    rx8b10ben_in => rx8b10ben_in_int,
    rxcdrhold_in => rxcdrhold_in_int,
    rxcdrlock_out => rxcdrlock_out_int,
    rxcommadet_out => rxcommadet_out_int,
    rxcommadeten_in => rxcommadeten_in_int,
    rxctrl0_out => rxctrl0_out,
    rxctrl1_out => rxctrl1_out,
    rxctrl2_out => rxctrl2_out,
    rxctrl3_out => rxctrl3_out,
    rxdata_out => rxdata_out,
    rxdatavalid_out => rxdatavalid_out,
    rxdfeagcovrden_in => rxdfeagcovrden_in_int,
    rxdfelfovrden_in => rxdfelfovrden_in_int,
    rxdfelpmreset_in => rxdfelpmreset_in_int,
    rxdlybypass_in => rxdlybypass_in_int,
    rxdlyen_in => rxdlyen_in_int,
    rxdlyovrden_in => rxdlyovrden_in_int,
    rxdlysreset_in => rxdlysreset_in_int,
    rxdlysresetdone_out => rxdlysresetdone_out_int,
    rxgearboxslip_in => rxgearboxslip_in_int,
    rxheader_out => rxheader_out,
    rxheadervalid_out => rxheadervalid_out,
    rxlatclk_in => rxlatclk_in_int,
    rxlpmen_in => rxlpmen_in_int,
    rxmcommaalignen_in => rxmcommaalignen_in_int,
    rxoutclk_out => rxoutclk_out_int,
    rxoutclksel_in => rxoutclksel_in,
    rxpcommaalignen_in => rxpcommaalignen_in_int,
    rxpcsreset_in => rxpcsreset_in_int,
    rxphalign_in => rxphalign_in_int,
    rxphaligndone_out => rxphaligndone_out_int,
    rxphalignen_in => rxphalignen_in_int,
    rxphdlypd_in => rxphdlypd_in_int,
    rxphdlyreset_in => rxphdlyreset_in_int,
    rxpllclksel_in => rxpllclksel_in,
    rxpmareset_in => rxpmareset_in_int,
    rxpmaresetdone_out => rxpmaresetdone_out_int,
    rxpolarity_in => rxpolarity_in_int,
    rxprbscntreset_in => rxprbscntreset_in_int,
    rxprbserr_out => rxprbserr_out_int,
    rxprbssel_in => rxprbssel_in,
    rxprgdivresetdone_out => rxprgdivresetdone_out_int,
    rxprogdivreset_in => rxprogdivreset_in_int,
    rxrate_in => rxrate_in,
    rxrecclkout_out => rxrecclkout_out_int,
    rxresetdone_out => rxresetdone_out_int,
    rxstartofseq_out => rxstartofseq_out,
    rxsyncallin_in => rxsyncallin_in_int,
    rxsyncdone_out => rxsyncdone_out_int,
    rxsyncin_in => rxsyncin_in_int,
    rxsyncmode_in => rxsyncmode_in_int,
    rxsyncout_out => rxsyncout_out_int,
    rxsysclksel_in => rxsysclksel_in,
    rxuserrdy_in => rxuserrdy_in_int,
    rxusrclk2_in => rxusrclk2_in_int,
    rxusrclk_in => rxusrclk_in_int,
    tx8b10ben_in => tx8b10ben_in_int,
    txctrl0_in => txctrl0_in,
    txctrl1_in => txctrl1_in,
    txctrl2_in => txctrl2_in,
    txdata_in => txdata_in,
    txdiffctrl_in => txdiffctrl_in,
    txdlybypass_in => txdlybypass_in_int,
    txdlyen_in => txdlyen_in_int,
    txdlyhold_in => txdlyhold_in_int,
    txdlyovrden_in => txdlyovrden_in_int,
    txdlysreset_in => txdlysreset_in_int,
    txdlysresetdone_out => txdlysresetdone_out_int,
    txdlyupdown_in => txdlyupdown_in_int,
    txheader_in => txheader_in,
    txinhibit_in => txinhibit_in_int,
    txlatclk_in => txlatclk_in_int,
    txoutclk_out => txoutclk_out_int,
    txpcsreset_in => txpcsreset_in_int,
    txphalign_in => txphalign_in_int,
    txphaligndone_out => txphaligndone_out_int,
    txphalignen_in => txphalignen_in_int,
    txphdlypd_in => txphdlypd_in_int,
    txphdlyreset_in => txphdlyreset_in_int,
    txphdlytstclk_in => txphdlytstclk_in_int,
    txphinit_in => txphinit_in_int,
    txphinitdone_out => txphinitdone_out_int,
    txphovrden_in => txphovrden_in_int,
    txpippmpd_in => txpippmpd_in_int,
    txpippmsel_in => txpippmsel_in_int,
    txpllclksel_in => txpllclksel_in,
    txpmareset_in => txpmareset_in_int,
    txpmaresetdone_out => txpmaresetdone_out_int,
    txpolarity_in => txpolarity_in_int,
    txpostcursor_in => txpostcursor_in,
    txprbsforceerr_in => txprbsforceerr_in_int,
    txprbssel_in => txprbssel_in,
    txprecursor_in => txprecursor_in,
    txprgdivresetdone_out => txprgdivresetdone_out_int,
    txprogdivreset_in => txprogdivreset_in_int,
    txresetdone_out => txresetdone_out_int,
    txsequence_in => txsequence_in,
    txsyncallin_in => txsyncallin_in_int,
    txsyncdone_out => txsyncdone_out_int,
    txsyncin_in => txsyncin_in_int,
    txsyncmode_in => txsyncmode_in_int,
    txsyncout_out => txsyncout_out_int,
    txsysclksel_in => txsysclksel_in,
    txuserrdy_in => txuserrdy_in_int,
    txusrclk2_in => txusrclk2_in_int,
    txusrclk_in => txusrclk_in_int
  );


  block_sync_sm_i : xCORE_CPRI_RUn77_RE_block_sync_sm
  generic map (
    SH_CNT_MAX              =>  64,
    SH_INVALID_CNT_MAX      =>  16)
  port map (
    blocksync_out           =>  blocksync_i,
    rxgearboxslip_out       =>  rxgearboxslip_i,
    rxheader_in(2)          =>  '0',
    rxheader_in(1 downto 0) =>  rxheader_gt,
    rxheadervalid_in        =>  rxheadervalid_gt,
    user_clk                =>  rxusrclk2,
    system_reset            =>  rxresetdone_n);

  -- rxgearboxslip goes to transceiver for 64b/66b gearbox slip alignment
  -- blocksync_out used for rx_sync_rst
  fec_alignment_en_sync_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
    q     => fec_alignment_en_sync,
    clk   => rxusrclk2,
    d     => fec_alignment_en);

  -- Disable both signals when Soft FEC is in use, SFEC does its own slip alignment.
  rxgearboxslip_in <= '0' when fec_alignment_en = '1' else rxgearboxslip_i;

  blocksync_p : process(rxusrclk2)
  begin
    if rising_edge(rxusrclk2) then
      if fec_alignment_en_sync = '1' then
        blocksync_out <= '1';
      else
        blocksync_out <= blocksync_i;
      end if;
    end if;
  end process;

  blocksync <= blocksync_out;

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      line_rate_64b66b <= speed_select(10) or speed_select(9) or speed_select(8) or speed_select(7);
    end if;
  end process;

  line_rate_64b66b_rx_sync_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
    q     => line_rate_64b66b_rx_sync,
    clk   => rxusrclk2,
    d     => line_rate_64b66b);

  line_rate_64b66b_tx_sync_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
    q     => line_rate_64b66b_tx_sync,
    clk   => txusrclk2,
    d     => line_rate_64b66b);

  process(rxusrclk2)
  begin
    if rising_edge(rxusrclk2) then
      rxresetdone_n <= not(rxresetdone_out) or not(line_rate_64b66b_rx_sync);
    end if;
  end process;

  --===========================================================================
  -- Datapath signal connections

  --Detect K28.5 data
  -- Register GTX outputs
  gtxoutreg : process(rxusrclk2)
  begin
    if rising_edge(rxusrclk2) then
      rxdatavalid_r   <= rxdatavalid_gt;
      rxheader_r      <= rxheader_gt;
      rxheadervalid_r <= rxheadervalid_gt;
      rxdata_r        <= rxdata_gt;
      rxchariscomma_r <= rxchariscomma_gt;
      rxdisperr_r     <= rxdisperr_gt;
      rxnotintable_r  <= rxnotintable_gt;
      rxcharisk_r     <= rxcharisk_gt;
    end if;
  end process;

  rxchariscomma <= rxchariscomma_r;
  rxcharisk     <= rxcharisk_r;
  --Detect K28.5 data
  rxcharisk28_5(0) <= '1' when rxdata_r(7 downto 0)   = K28_5 else '0';
  rxcharisk28_5(1) <= '1' when rxdata_r(15 downto 8)  = K28_5 else '0';
  rxcharisk28_5(2) <= '1' when rxdata_r(23 downto 16) = K28_5 else '0';
  rxcharisk28_5(3) <= '1' when rxdata_r(31 downto 24) = K28_5 else '0';
  rxcharisk28_5(4) <= '1' when rxdata_r(39 downto 32) = K28_5 else '0';
  rxcharisk28_5(5) <= '1' when rxdata_r(47 downto 40) = K28_5 else '0';
  rxcharisk28_5(6) <= '1' when rxdata_r(55 downto 48) = K28_5 else '0';
  rxcharisk28_5(7) <= '1' when rxdata_r(63 downto 56) = K28_5 else '0';

  rxdatavalid   <= rxdatavalid_r;
  rxheader      <= rxheader_r;
  rxheadervalid <= rxheadervalid_r;

  -- Signal an error on either disparity error or not in table or K char that isn't 28.5
  rxcharerr_i(0) <= rxheadervalid_r and not(rxheader_r(0) xor rxheader_r(1)) when line_rate_64b66b_rx_sync = '1' else
                    rxdisperr_r(0) or rxnotintable_r(0) or (rxcharisk_r(0) and (not rxcharisk28_5(0)));
  rxcharerr_i(1) <= '0' when line_rate_64b66b_rx_sync = '1' else
                    rxdisperr_r(1) or rxnotintable_r(1) or (rxcharisk_r(1) and (not rxcharisk28_5(1)));
  rxcharerr_i(2) <= '0' when line_rate_64b66b_rx_sync = '1' else
                    rxdisperr_r(2) or rxnotintable_r(2) or (rxcharisk_r(2) and (not rxcharisk28_5(2)));
  rxcharerr_i(3) <= '0' when line_rate_64b66b_rx_sync = '1' else
                    rxdisperr_r(3) or rxnotintable_r(3) or (rxcharisk_r(3) and (not rxcharisk28_5(3)));
  rxcharerr_i(4) <= rxheadervalid_r and not(rxheader_r(0) xor rxheader_r(1)) when line_rate_64b66b_rx_sync = '1' else '0';
  rxcharerr_i(5) <= '0';
  rxcharerr_i(6) <= '0';
  rxcharerr_i(7) <= '0';

  grxerrreg : process(rxusrclk2)
  begin
    if rising_edge(rxusrclk2) then
      rxcharerr <= rxcharerr_i;
    end if;
  end process;

  rxdata        <= rxdata_r;

  --===========================================================================
  -- MMCM Reset
  mmcm_reset       <= tx_clk_gen_reset or sm_busy;
  mmcm_rst         <= mmcm_reset;

  -- State machine to carry out the speed change process
  speed_change_sm_i : xCORE_CPRI_RUn77_RE_speed_change
  port map (
    reset                => reset,
    clk                  => aux_clk,
    speed_select         => speed_select,
    qpll_select          => qpll_select,

    gt_daddr             => gt_daddr,
    gt_den               => gt_den,
    gt_dwe               => gt_dwe,
    gt_di                => gt_di,
    gt_drdy              => gt_drdy,
    gt_do                => gt_do,

    sm_busy              => sm_busy,
    sm_drp_arb_gnt       => sm_drp_arb_gnt,
    gt_reset_req_toggle  => gt_reset_req_toggle,
    cpllreset            => cpll_rst_sync,
    cplllkdet            => cplllkdet_r
  );

  gt_drp_do   <= gt_do;
  gt_drp_drdy <= gt_drdy;

  -- Create reset pulse from toggle and synchronize to the gtwiz_reset_clk_freerun_in domain.
  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      gt_reset_req_toggle_r <= gt_reset_req_toggle;
      gt_reset_req          <= gt_reset_req_toggle xor gt_reset_req_toggle_r;
    end if;
  end process;

  gt_reset_req_sync_i : xCORE_CPRI_RUn77_RE_reset_synchronizer
  port map (
    reset_in  => gt_reset_req,
    clk       => gtwiz_reset_clk_freerun_in,
    reset_out => gt_reset_req_i);

  -- Synchronize cpll_rst onto aux_clk domain
  cpll_rst_sync_i : xCORE_CPRI_RUn77_RE_reset_synchronizer
  port map (
    reset_in  => cpll_rst,
    clk       => aux_clk,
    reset_out => cpll_rst_sync);

  --===========================================================================
  -- Resets
  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      gtxreset <= reset or gt_reset_req;
    end if;
  end process;

  -- When the CPLL calibration block is busy the DRP instructions from
  -- this block are ignored. Generate a busy signal here.
  cal_block_busy_gen : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if reset = '1' then
        cal_block_busy <= '0';
      else
        if cpll_rst_sync = '1' and cpll_pd = '0' then
          cal_block_busy <= '1';
        elsif cplllkdet_r = '1' then
          cal_block_busy <= '0';
        end if;
      end if;
    end if;
  end process;

  pll_reset  <= reset;

  -- Synchronize the PLL lock outputs from the transceiver to the
  -- aux_clk as they are used in the following state machine.
  qpll0lkdet_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => qpll0lkdet_r,
      clk   => aux_clk,
      d     => qpll0lock);

  qpll1lkdet_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => qpll1lkdet_r,
      clk   => aux_clk,
      d     => qpll1lock);

  cplllkdet_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => cplllkdet_r,
      clk   => aux_clk,
      d     => cplllock_out);

  -- State machine to enable and disable the QPLL or CPLL depending on
  -- the line rate. If the core is running at 9.8304Gbps then the QPLL is
  -- enabled and the CPLL is powered down. At all other speeds the CPLL is
  -- enabled and the QPLL is powered down.
  pd_speed_change_det : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if reset = '1' then
        speed_select_r1  <= (others => '0');
        speed_select_r2  <= (others => '0');
      else
        if cal_block_busy = '0' and sm_busy = '0' then
          speed_select_r1  <= speed_select;
          speed_select_r2  <= speed_select_r1;
        end if;
      end if;
    end if;
  end process pd_speed_change_det;

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if speed_select(10 downto 7) = "0000" then
        rxplllkdet   <= cplllkdet_r;
      else
        if qpll_select = '0' then
          rxplllkdet <= qpll0lkdet_r;
        else
          rxplllkdet <= qpll1lkdet_r;
        end if;
      end if;
    end if;
  end process;

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if reset = '1' then
        cpll_pd    <= '1';
        -- Starts in 10G
        if qpll_select = '0' then
          qpll0_pd <= '0';
          qpll1_pd <= '1';
        else
          qpll0_pd <= '1';
          qpll1_pd <= '0';
        end if;
        sysclksel   <= '1' & qpll_select;
        pd_sm_state <= IDLE;
      else
        case pd_sm_state is
          when IDLE =>
            if speed_select_r2 /= speed_select_r1 then
              pd_sm_state <= WAIT_FOR_SPEED_CHANGE;
            end if;
          when WAIT_FOR_SPEED_CHANGE =>
            if speed_select_r1 /= speed_select then
              pd_sm_state <= IDLE;
            elsif sm_busy = '0' then
              pd_sm_state <= WAIT_CPLL_RST;
            end if;
          when WAIT_CPLL_RST =>
            if cpll_rst_sync = '0' then
              pd_sm_state <= POWER_UP;
            end if;
          when POWER_UP =>
            if speed_select_r1 /= speed_select then
              pd_sm_state <= IDLE;
            else
              if speed_select(10 downto 7) = "0000" and speed_select /= "00000000000" then
                cpll_pd     <= '0';
                sysclksel   <= "00";
                -- Power down the QPLL
                qpll0_pd    <= '1';
                qpll1_pd    <= '1';
                pd_sm_state <= IDLE;
              else
                cpll_pd     <= '1';
                sysclksel   <= '1' & qpll_select;
                -- Power up the QPLL
                if qpll_select = '0' then
                  qpll0_pd  <= '0';
                  qpll1_pd  <= '1';
                else
                  qpll0_pd  <= '1';
                  qpll1_pd  <= '0';
                end if;
                pd_sm_state <= IDLE;
              end if;
            end if;
          when others =>
            pd_sm_state <= IDLE;
        end case;
      end if;
    end if;
  end process;

  -- tie off the other unused individual section resets
  txpmareset_in     <= '0';
  txpcsreset_in     <= '0';
  rxpmareset_in     <= '0';
  rxpcsreset_in     <= '0';
  rxrate_in         <= "000";
  eyescantrigger_in <= '0';
  eyescanreset_in   <= '0';
  rxpolarity_in     <= '0';
  txpolarity_in     <= '0';
  rxdfelpmreset_in  <= '0';
  rxdfeagcovrden_in <= '0';
  rxdfelfovrden_in  <= '0';

  rxdfegen : process (speed_select)
  begin
    case speed_select is
      when "10000000000" =>
        rxlpmen_in  <= '0';
      when "01000000000" =>
        rxlpmen_in  <= '0';
      when "00100000000" =>
        rxlpmen_in  <= '0';
      when "00010000000" =>
        rxlpmen_in  <= '0';
      when "00001000000" =>
        rxlpmen_in  <= '0';
      when "00000100000" =>
        rxlpmen_in  <= '0';
      when "00000010000" =>
        rxlpmen_in  <= '0';
      when "00000001000" =>
        rxlpmen_in  <= '1';
      when "00000000100" =>
        rxlpmen_in  <= '1';
      when "00000000010" =>
        rxlpmen_in  <= '1';
      when others =>
        rxlpmen_in  <= '1';
    end case;
  end process;

  txprecursor_in    <= "00000";
  txpostcursor_in   <= "00000" when speed_select(10 downto 4) = "0000000" else "10100";
  txprbsforceerr_in <= '0';
  txprbssel_in      <= "0000";
  rxprbssel_in      <= "0000";
  rxprbscntreset_in <= '0';
  rxcdrhold_in      <= '0';
  pcsrsvdin_in      <= x"0000";

  -- Chose between the quad PLL lock and the channel PLL lock depending on line rate
  plllock <= rxplllkdet;

  -- Tx Clock reset on external reset or speed switch, and held until GTX PLL locks
  tx_clk_gen_reset <= not(plllock) or reset or mmcm_reset_req;

  -- Rx Sync reset held until Rx PLL locked and GTX Rx Reset done, and by watchdog reset
  rx_sync_rst <= (not(blocksync_auxclk) and line_rate_64b66b) or not(plllock) or
                 (not(gtwiz_bufbyp_rxdone_sync) and not(line_rate_64b66b));

  blocksync_auxclk_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
    q    => blocksync_auxclk,
    clk  => aux_clk,
    d    => blocksync_out);

  gtwiz_bufbyp_rxdone_sync_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
    q    => gtwiz_bufbyp_rxdone_sync,
    clk  => aux_clk,
    d    => gtwiz_buffbypass_rx_done_out);

  -- output rec_clk domain reset
  rec_clk_rst <= rx_sync_rst;

  -- output clocks from GT
  gtreset_sm_done <= '1';

  gt_txresetdone      <= txresetdone_out;
  gt_rxresetdone      <= rxresetdone_out;

-- Instantiate reset block from the GT wizard
  gtwiz_reset_block_i : gtwizard_ultrascale_v1_7_15_gtwiz_reset
    generic map (P_TX_PLL_TYPE  => 2)
    port map (
      gtwiz_reset_clk_freerun_in              => gtwiz_reset_clk_freerun_in,
      gtwiz_reset_all_in                      => gtxreset,
      gtwiz_reset_tx_pll_and_datapath_in      => tx_reset_recovery,
      gtwiz_reset_tx_datapath_in              => '0',
      gtwiz_reset_rx_pll_and_datapath_in      => rx_reset_rec_watchdog,
      gtwiz_reset_rx_datapath_in              => '0',
      gtwiz_reset_rx_cdr_stable_out           => open,
      gtwiz_reset_tx_done_out                 => gtwiz_reset_tx_done_in,
      gtwiz_reset_rx_done_out                 => gtwiz_reset_rx_done_in,
      gtwiz_reset_userclk_tx_active_in        => '1',
      gtwiz_reset_userclk_rx_active_in        => '1',

      gtpowergood_in                          => gtpowergood_out,
      txusrclk2_in                            => txusrclk2,
      plllock_tx_in                           => plllock_in_i,
      txresetdone_in                          => txresetdone_sync,
      rxusrclk2_in                            => rxusrclk2,
      plllock_rx_in                           => plllock_in_i,
      rxcdrlock_in                            => rxcdrlock_out,
      rxresetdone_in                          => rxresetdone_sync,
      pllreset_tx_out                         => cpll_rst,
      txprogdivreset_out                      => txprogdivreset_in_i,
      gttxreset_out                           => gttxreset_in,
      txuserrdy_out                           => txuserrdy_in,
      pllreset_rx_out                         => open,
      rxprogdivreset_out                      => rxprogdivreset_in_i,
      gtrxreset_out                           => gtrxreset_in,
      rxuserrdy_out                           => rxuserrdy_in,
      tx_enabled_tie_in                       => '1',
      rx_enabled_tie_in                       => '1',
      shared_pll_tie_in                       => '0');

  -- Synchronize the sm_busy signal onto the gtwiz_reset_clk_freerun_in clock domain
  sm_busy_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => sm_busy_sync,
      clk   => gtwiz_reset_clk_freerun_in,
      d     => sm_busy);

  -- Synchronize the gtwiz_reset_tx_done_in signal onto the
  -- gtwiz_reset_clk_freerun_in clock domain
  reset_tx_done_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => gtwiz_reset_tx_done_in_sync,
      clk   => gtwiz_reset_clk_freerun_in,
      d     => gtwiz_reset_tx_done_in);

  -- State machine to monitor txresetdone and assert tx_reset_recovery if plllock
  -- is lost, this is to recover the gtwiz_reset_block from a stuck state.
  tx_reset_done_monitor : process(gtwiz_reset_clk_freerun_in)
  begin
    if rising_edge(gtwiz_reset_clk_freerun_in) then
      if sm_busy_sync = '1' then
        tx_state <= TX_START;
        tx_reset_recovery <= '0';
      else
        case tx_state is
          when TX_START =>
            tx_reset_recovery <= '0';
            if gtwiz_reset_tx_done_in_sync = '1' then
              tx_state <= TX_IDLE;
            else
              tx_state <= TX_START;
            end if;

          when TX_IDLE =>
            if gtwiz_reset_tx_done_in_sync = '0' then
              tx_state <= TX_START;
              tx_reset_recovery <= '1';
            else
              tx_state <= TX_IDLE;
              tx_reset_recovery <= '0';
            end if;

          when others =>
            NULL;
        end case;
      end if;
    end if;
  end process tx_reset_done_monitor;

  -- Synchronize the gtwiz_reset_rx_done_in signal onto the gtwiz_reset_clk_freerun_in clock domain
  reset_rx_done_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => gtwiz_reset_rx_done_in_sync,
      clk   => gtwiz_reset_clk_freerun_in,
      d     => gtwiz_reset_rx_done_in);

  -- State machine to monitor rxresetdone and assert rx_reset_recovery if plllock
  -- is lost, this is to recover the gtwiz_reset_block from a stuck state.
  rx_reset_done_monitor : process(gtwiz_reset_clk_freerun_in)
  begin
    if rising_edge(gtwiz_reset_clk_freerun_in) then
      if sm_busy_sync = '1' then
        rx_state <= RX_START;
        rx_reset_recovery <= '0';
      else
        case rx_state is
          when RX_START =>
            rx_reset_recovery <= '0';
            if gtwiz_reset_rx_done_in_sync = '1' then
              rx_state <= RX_IDLE;
            else
              rx_state <= RX_START;
            end if;

          when RX_IDLE =>
            if gtwiz_reset_rx_done_in_sync = '0' then
              rx_state <= RX_START;
              rx_reset_recovery <= '1';
            else
              rx_state <= RX_IDLE;
              rx_reset_recovery <= '0';
            end if;

          when others =>
            NULL;
        end case;
      end if;
    end if;
  end process rx_reset_done_monitor;

  watchdog_reset_sync_i : xCORE_CPRI_RUn77_RE_reset_synchronizer
  port map (
    reset_in  => watchdog_reset,
    clk       => gtwiz_reset_clk_freerun_in,
    reset_out => watchdog_reset_sync);

  process(gtwiz_reset_clk_freerun_in)
  begin
    if rising_edge(gtwiz_reset_clk_freerun_in) then
      rx_reset_rec_watchdog <= rx_reset_recovery or watchdog_reset_sync;
      txprogdivreset_in     <= txprogdivreset_in_i or gt_reset_req_i;
      rxprogdivreset_in     <= rxprogdivreset_in_i or gt_reset_req_i;
    end if;
  end process;

  rxresetdone_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => rxresetdone_sync,
      clk   => gtwiz_reset_clk_freerun_in,
      d     => rxresetdone_out);

  txresetdone_sync_rsm_i : xCORE_CPRI_RUn77_RE_synchronizer
  port map (
      q     => txresetdone_sync,
      clk   => gtwiz_reset_clk_freerun_in,
      d     => txresetdone_out);

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if speed_select(10 downto 7) = "0000" then
        plllock_in_i <= cplllkdet_r;
      else
        if qpll_select = '0' then
          plllock_in_i <= qpll0lkdet_r;
        else
          plllock_in_i <= qpll1lkdet_r;
        end if;
      end if;
    end if;
  end process;

  -- Assign GT ports
  cplllockdetclk_in                 <= aux_clk;

  drpaddr_in                        <= gt_drpdaddr_i;
  drpclk_in                         <= aux_clk;
  drpdi_in                          <= gt_drpdi_i;
  drp_dout                          <= drpdo_out;
  drpen_in                          <= gt_drpen_i;
  gt_drprdy_i                       <= drprdy_out;
  drpwe_in                          <= gt_drpwe_i;

  gtyrxn_in                         <= rxn;
  gtyrxp_in                         <= rxp;
  txn                               <= gtytxn_out;
  txp                               <= gtytxp_out;

  gtrefclk0_in                      <= refclk;

  txlatclk_in                       <= hires_clk;
  rxlatclk_in                       <= hires_clk;
  rxdatavalid_gt                    <= rxdatavalid_out(0);
  rxheader_gt                       <= rxheader_out(1 downto 0);
  rxheadervalid_gt                  <= rxheadervalid_out(0);
  rxchariscomma_gt                  <= rxctrl2_out(7 downto 0);
  rxcharisk_gt                      <= rxctrl0_out(7 downto 0);
  rxdisperr_gt                      <= rxctrl1_out(7 downto 0);
  rxnotintable_gt                   <= rxctrl3_out(7 downto 0);

  rxdata_gt                         <= rxdata_out(63 downto 0);
  rxmcommaalignen_in                <= encommaalign;
  rxpcommaalignen_in                <= encommaalign;
  rx8b10ben_in                      <= not(line_rate_64b66b_rx_sync);
  rxcommadeten_in                   <= not(line_rate_64b66b_rx_sync);
  rxoutclksel_in                    <= "101" when line_rate_64b66b = '1' else "010";
  txdlybypass_in                    <= '1' when line_rate_64b66b = '1' else '0';
  txphdlypd_in                      <= '1' when line_rate_64b66b = '1' else '0';
  txpippmpd_in                      <= '0' when line_rate_64b66b = '1' else '1';
  txpippmsel_in                     <= '1' when line_rate_64b66b = '1' else '0';

  rxoutclk                          <= rxoutclk_out;
  txoutclk                          <= txoutclk_out;
  rxrecclkout                       <= rxrecclkout_out;
  rxusrclk_in                       <= rxusrclk2;
  txusrclk_in                       <= txusrclk;
  rxusrclk2_in                      <= rxusrclk2;
  txusrclk2_in                      <= txusrclk2;

  txctrl0_in                        <= x"0000";
  txctrl1_in                        <= x"0000";

  txsequence_in                     <= txsequence;
  txheader_in(1 downto 0)           <= txheader;
  txheader_in(5 downto 2)           <= "0000";
  txctrl2_in(7 downto 0)            <= txcharisk;
  txdata_in(63 downto 0)            <= txdata;
  txdata_in(127 downto 64)          <= x"0000000000000000";
  tx8b10ben_in                      <= not(line_rate_64b66b_tx_sync);

  txinhibit_in                      <= txinhibit;
  loopback_in                       <= loopback;

  gtwiz_userclk_rx_active_in        <= '1';
  gtwiz_userclk_tx_active_in        <= '1';
  txresetdone_o                     <= gtwiz_reset_tx_done_in;

  -- Reset the RX buffer bypass circuit
  reset_rx_buffer_bypass_gen : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if reset = '1' or watchdog_reset = '1' or rxpmaresetdone_out = '0' or line_rate_64b66b = '1' then
        gtwiz_buffbypass_rx_reset_int <= '1';
      else
        gtwiz_buffbypass_rx_reset_int <= '0';
      end if;
    end if;
  end process;

  gtwiz_buffbypass_rx_reset_in_sync_i : xCORE_CPRI_RUn77_RE_reset_synchronizer
  port map (
    reset_in  => gtwiz_buffbypass_rx_reset_int,
    clk       => rxusrclk2,
    reset_out => gtwiz_buffbypass_rx_reset_in);

  txdlyen_in          <= txdlyen;
  txdlyhold_in        <= '0';
  txdlyovrden_in      <= '0';
  txdlysreset_in      <= txdlysreset;
  txdlysresetdone     <= txdlysresetdone_out;
  txdlyupdown_in      <= '0';
  txphalign_in        <= txphalign;
  txphaligndone       <= txphaligndone_out;
  txphalignen_in      <= '0' when line_rate_64b66b = '1' else '1';
  txphdlyreset_in     <= '0';
  txphdlytstclk_in    <= '0';
  txphinit_in         <= txphinit;
  txphinitdone_o      <= txphinitdone_out;
  txphovrden_in       <= '0';
  txsyncallin_in      <=  txphaligndone_out;
  txsyncin_in         <=  txsyncout_out;
  txsyncmode_in       <=  '1';
  txsyncdone_o        <= txsyncdone_out;
  qpll0clk_in         <= qpll0clk;
  qpll0refclk_in      <= qpll0refclk;
  qpll1clk_in         <= qpll1clk;
  qpll1refclk_in      <= qpll1refclk;
  rxsysclksel_in      <= sysclksel;
  txsysclksel_in      <= sysclksel;
  pllclksel           <= sysclksel(1) & not(sysclksel(0)) when speed_select(10 downto 7) /= "0000" else sysclksel;
  rxpllclksel_in      <= pllclksel;
  txpllclksel_in      <= pllclksel;
  cplllocken_in       <= '1';
  cpllreset_in        <= '0';

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      cpllpd_in <= cpll_pd or cpll_rst_sync;
    end if;
  end process;

  userclk_tx_reset_i : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if line_rate_64b66b = '1' then
        userclk_tx_reset <= not(txprgdivresetdone_out);
      else
        userclk_tx_reset <= not(txprgdivresetdone_out and txpmaresetdone_out);
      end if;
    end if;
  end process;

  userclk_rx_reset_i : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if line_rate_64b66b = '1' then
        userclk_rx_reset <= not(rxprgdivresetdone_out);
      else
        userclk_rx_reset <= not(rxpmaresetdone_out);
      end if;
    end if;
  end process;

  gtwiz_userclk_reset_i : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if line_rate_64b66b = '0' then
        gtwiz_userclk_tx_reset_in <= not(txprgdivresetdone_out and txpmaresetdone_out);
      else
        gtwiz_userclk_tx_reset_in <= not(txprgdivresetdone_out);
      end if;
    end if;
  end process;

  -- Calculate the TXOUTCLK frequency for each line rate and input to the CPLL calibration block.
  gtwiz_gtye4_cpll_cal_bufg_ce_in <= '1';

  txoutclk_period_gen : process(speed_select)
  begin
    case speed_select is
      when "00001000000" =>
        gtwiz_gtye4_cpll_cal_txoutclk_period_in <= std_logic_vector(to_unsigned(cpll_cal_frequency_even_9g, 18));
        gtwiz_gtye4_cpll_cal_cnt_tol_in         <= std_logic_vector(to_unsigned(cpll_cal_frequency_even_div100_9g, 18));
      when "00000000000" | "00000000001" | "00000000010" | "00000000100" | "00000010000" =>
        gtwiz_gtye4_cpll_cal_txoutclk_period_in <= std_logic_vector(to_unsigned(cpll_cal_frequency_even, 18));
        gtwiz_gtye4_cpll_cal_cnt_tol_in         <= std_logic_vector(to_unsigned(cpll_cal_frequency_even_div100, 18));
      when others =>
        gtwiz_gtye4_cpll_cal_txoutclk_period_in <= std_logic_vector(to_unsigned(cpll_cal_frequency_odd, 18));
        gtwiz_gtye4_cpll_cal_cnt_tol_in         <= std_logic_vector(to_unsigned(cpll_cal_frequency_odd_div100, 18));
    end case;
  end process;

  drp_arbiter_i : xCORE_CPRI_RUn77_RE_drp_arbiter
  port map (
    clk               => aux_clk,
    reset             => reset,
    -- Core DRP
    core_drp_arb_req  => core_drp_arb_req,
    core_drp_arb_gnt  => core_drp_arb_gnt,
    core_drp_dout     => core_drp_dout,
    core_drp_daddr    => core_drp_daddr_i,
    core_drp_dwe      => core_drp_dwe,
    core_gt_din       => core_gt_din,
    core_gt_den       => core_gt_den,
    core_gt_drdy      => core_gt_drdy,
    -- User DRP - GT only
    user_drp_arb_req  => '0',
    user_drp_arb_gnt  => open,
    user_drp_dout     => x"0000",
    user_drp_daddr    => "0000000000",
    user_drp_dwe      => '0',
    user_gt_din       => open,
    user_gt_den       => '0',
    user_gt_drdy      => open,
    -- State machine DRP
    sm_drp_arb_req    => sm_drp_arb_req,
    sm_drp_arb_gnt    => sm_drp_arb_gnt,
    sm_drp_dout       => gt_di,
    sm_drp_daddr      => gt_daddr,
    sm_drp_dwe        => gt_dwe,
    sm_gt_din         => gt_do,
    sm_gt_den         => gt_den,
    sm_gt_drdy        => gt_drdy,
    -- DRP Outputs
    drp_arb_req       => drp_arb_req,
    drp_arb_gnt       => '1',
    drp_dout          => gt_drpdi_i,
    drp_daddr         => gt_drpdaddr_i,
    drp_dwe           => gt_drpwe_i,
    gt_din            => drp_dout,
    gt_den            => gt_drpen_i,
    gt_drdy           => gt_drprdy_i);

  sm_drp_arb_req <= '1' when sm_busy = '1' else '0';

  core_drp_daddr_i <= "10" & x"50" when core_drp_daddr = x"4E" else "10" & core_drp_daddr;

  -- Drive to zero undriven outputs.
  user_gt_din  <= (others => '0');
  user_gt_drdy <= '0';

  -- Instantiate rx_buffer_bypass block from the GT wizard
  rx_buffer_bypass_block_i : cpri_v8_11_14_rx_buffer_bypass
    port map (
      -- User interface ports
      gtwiz_buffbypass_rx_clk_in        => rxusrclk2,
      gtwiz_buffbypass_rx_reset_in      => gtwiz_buffbypass_rx_reset_in,
      gtwiz_buffbypass_rx_start_user_in => '0',
      gtwiz_buffbypass_rx_resetdone_in  => gtwiz_reset_rx_done_in,
      gtwiz_buffbypass_rx_done_out      => gtwiz_buffbypass_rx_done_out,
      gtwiz_buffbypass_rx_error_out     => open,
      -- Transceiver interface ports
      rxphaligndone_in                  => rxphaligndone_out,
      rxdlysresetdone_in                => rxdlysresetdone_out,
      rxsyncout_in                      => rxsyncout_out,
      rxsyncdone_in                     => rxsyncdone_out,
      rxphdlyreset_out                  => rxphdlyreset_in,
      rxphalign_out                     => rxphalign_in,
      rxphalignen_out                   => rxphalignen_in,
      rxphdlypd_out                     => rxphdlypd_in,
      rxphovrden_out                    => open,
      rxdlysreset_out                   => rxdlysreset_in,
      rxdlybypass_out                   => rxdlybypass_in,
      rxdlyen_out                       => rxdlyen_in,
      rxdlyovrden_out                   => rxdlyovrden_in,
      rxsyncmode_out                    => rxsyncmode_in,
      rxsyncallin_out                   => rxsyncallin_in,
      rxsyncin_out                      => rxsyncin_in);

end rtl;
