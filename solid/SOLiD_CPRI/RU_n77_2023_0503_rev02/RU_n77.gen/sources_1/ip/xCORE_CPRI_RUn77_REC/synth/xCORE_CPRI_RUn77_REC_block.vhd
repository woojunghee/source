-----------------------------------------------------------------------
-- Title      : Block level for CPRI design
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_REC_block.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: This block defines the logic (including the core itself) that
--              should be replicated for multiple instances of a CPRI link.
--              It does not include the input IBUFGDS for the reference clock,
--              this is in the example_design level.
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2022 Xilinx, Inc. All rights reserved.
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

entity xCORE_CPRI_RUn77_REC_block is
  port (
    reset                    : in  std_logic;

    -- I/Q interface
    iq_tx_enable             : out std_logic;
    basic_frame_first_word   : out std_logic;
    iq_tx                    : in  std_logic_vector(63 downto 0);
    iq_rx                    : out std_logic_vector(63 downto 0);

    -- GT Common Ports
    qpll0clk_in              : in  std_logic;
    qpll0refclk_in           : in  std_logic;
    qpll1clk_in              : in  std_logic;
    qpll1refclk_in           : in  std_logic;
    qpll0lock_in             : in  std_logic;
    qpll0_pd                 : out std_logic;
    qpll1lock_in             : in  std_logic;
    qpll1_pd                 : out std_logic;

    -- Vendor Specific Data
    vendor_tx_data           : in  std_logic_vector(127 downto 0);
    vendor_tx_xs             : out std_logic_vector(1 downto 0);
    vendor_tx_ns             : out std_logic_vector(5 downto 0);
    vendor_rx_data           : out std_logic_vector(127 downto 0);
    vendor_rx_xs             : out std_logic_vector(1 downto 0);
    vendor_rx_ns             : out std_logic_vector(5 downto 0);
    vs_negotiation_complete  : in  std_logic;

    -- Synchronization
    nodebfn_tx_strobe        : in  std_logic;
    nodebfn_tx_nr            : in  std_logic_vector(11 downto 0);
    nodebfn_rx_strobe        : out std_logic;
    nodebfn_rx_nr            : out std_logic_vector(11 downto 0);

    -- Ethernet interface
    eth_txd                  : in  std_logic_vector(7 downto 0);
    eth_tx_er                : in  std_logic;
    eth_tx_en                : in  std_logic;
    eth_col                  : out std_logic;
    eth_crs                  : out std_logic;
    eth_rxd                  : out std_logic_vector(7 downto 0);
    eth_rx_er                : out std_logic;
    eth_rx_dv                : out std_logic;
    eth_rx_avail             : out std_logic;
    eth_rx_ready             : in  std_logic;
    rx_fifo_almost_full      : out std_logic;
    rx_fifo_full             : out std_logic;
    eth_tx_clk               : in  std_logic;
    eth_rx_clk               : in  std_logic;

    -- HDLC interface
    hdlc_rx_data             : out std_logic;
    hdlc_tx_data             : in  std_logic;
    hdlc_rx_data_valid       : out std_logic;
    hdlc_tx_enable           : out std_logic;

    -- Status interface
    stat_alarm               : out std_logic;
    stat_code                : out std_logic_vector(3 downto 0);
    stat_speed               : out std_logic_vector(14 downto 0);
    reset_request_in         : in  std_logic;
    sdi_request_in           : in  std_logic;
    reset_acknowledge_out    : out std_logic;
    sdi_request_out          : out std_logic;
    local_los                : out std_logic;
    local_lof                : out std_logic;
    local_rai                : out std_logic;
    remote_los               : out std_logic;
    remote_lof               : out std_logic;
    remote_rai               : out std_logic;
    fifo_transit_time        : out std_logic_vector(13 downto 0);
    coarse_timer_value       : out std_logic_vector(17 downto 0);
    barrel_shift_value       : out std_logic_vector(6 downto 0);
    tx_gb_latency_value      : out std_logic_vector(15 downto 0);
    rx_gb_latency_value      : out std_logic_vector(15 downto 0);
    stat_rx_delay_value      : out std_logic_vector(6 downto 0);
    hyperframe_number        : out std_logic_vector(7 downto 0);

    -- AXI-Lite Interface
    -----------------
    s_axi_aclk               : in  std_logic;
    s_axi_aresetn            : in  std_logic;
    s_axi_awaddr             : in  std_logic_vector(11 downto 0);
    s_axi_awvalid            : in  std_logic;
    s_axi_awready            : out std_logic;
    s_axi_wdata              : in  std_logic_vector(31 downto 0);
    s_axi_wvalid             : in  std_logic;
    s_axi_wready             : out std_logic;
    s_axi_bresp              : out std_logic_vector(1 downto 0);
    s_axi_bvalid             : out std_logic;
    s_axi_bready             : in  std_logic;
    s_axi_araddr             : in  std_logic_vector(11 downto 0);
    s_axi_arvalid            : in  std_logic;
    s_axi_arready            : out std_logic;
    s_axi_rdata              : out std_logic_vector(31 downto 0);
    s_axi_rresp              : out std_logic_vector(1 downto 0);
    s_axi_rvalid             : out std_logic;
    s_axi_rready             : in  std_logic;
    l1_timer_expired         : in  std_logic;

    -- Transceiver interface
    txp                      : out std_logic;
    txn                      : out std_logic;
    rxp                      : in  std_logic;
    rxn                      : in  std_logic;
    lossoflight              : in  std_logic;
    txinhibit                : out std_logic;

    -- Clocks
    refclk                   : in  std_logic;
    aux_clk_out              : out std_logic;
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk                : in  std_logic;
    hires_clk_ok             : in  std_logic;
    qpll_select              : in  std_logic;
    core_is_master           : in  std_logic;
    recclk_ok                : out std_logic;
    txoutclk                 : out std_logic;
    mmcm_rst                 : out std_logic;
    rxoutclk                 : out std_logic;
    rxrecclkout              : out std_logic;
    txresetdone_out          : out std_logic;
    clk_in                   : in  std_logic;
    clk_ok_in                : in  std_logic;
    txusrclk                 : in  std_logic;
    recclk_in                : in  std_logic;
    gtreset_sm_done          : out std_logic;
    userclk_tx_reset         : out std_logic;
    userclk_rx_reset         : out std_logic;
    txdlyen_in               : in  std_logic;
    txphinit_in              : in  std_logic;
    phase_alignment_done_in  : in  std_logic;
    txdlysreset_in           : in  std_logic;
    txphalign_in             : in  std_logic;
    txphaligndone_out        : out std_logic;
    txdlysresetdone_out      : out std_logic;
    txsyncdone_out           : out std_logic;
    txphinitdone_out         : out std_logic);
end xCORE_CPRI_RUn77_REC_block;


architecture rtl of xCORE_CPRI_RUn77_REC_block is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component cpri_v8_11_14
  generic (
    C_ELABORATION_TRANSIENT_DIR : string := "";
    C_COMPONENT_NAME            : string := "";
    C_TRANSCEIVER_TYPE          : integer := 0;
    C_IS_VERSAL                 : boolean := false;
    EGW_IS_PARENT_IP            : boolean := false;
    C_DATAPATH_BYTES            : integer := 1;
    C_USE_32BIT                 : boolean := false;
    C_USE_64BIT                 : boolean := false;
    C_AGNOSTIC_MODE             : boolean := false;
    C_VENDOR_WIDTH              : integer := 40;
    C_RT_VENDOR_WIDTH           : integer := 32;
    C_ADDR_WIDTH                : integer := 8;
    C_SPEED_SEL_WIDTH           : integer := 4;
    C_IQ_DATA_WIDTH             : integer := 16;
    C_ETH_DATA_WIDTH            : integer := 4;
    C_CDC_IS_EXTENDED           : integer := 0;
    C_IS_MASTER                 : boolean := true;
    C_LINE_RATE                 : integer := 0;
    C_REF_CLK_SPEED             : integer := 0;
    C_USE_ETHERNET              : boolean := true;
    C_USE_GMII                  : boolean := false;
    C_USE_ORI                   : boolean := false;
    C_R21_TIMER                 : boolean := true;
    C_AXI_IPIF                  : boolean := false;
    C_FREE_RUNNING_RX_REFERENCE : boolean := false;
    C_BYPASS_BUFFER             : boolean := false;
    C_RT_VENDOR_SUPPORT         : boolean := false;
    C_GT_TYPE                   : integer := 0;
    C_USE_FEC                   : boolean := false;
    C_USE_HARD_FEC              : boolean := false;
    C_USE_0_6144G               : boolean := true;
    C_USE_1_2288G               : boolean := true;
    C_USE_2_4576G               : boolean := true;
    C_USE_3_072G                : boolean := true;
    C_USE_4_9152G               : boolean := false;
    C_USE_6_144G                : boolean := false;
    C_USE_8_11008G              : boolean := false;
    C_USE_9_8304G               : boolean := false;
    C_USE_10_1376G              : boolean := false;
    C_USE_12_16512G             : boolean := false;
    C_USE_24_33024G             : boolean := false;
    C_MAJOR_VERSION             : integer := 0;
    C_MINOR_VERSION             : integer := 0;
    C_REVISION                  : integer := 0);
  port (
    tx_axis_agn_tdata                : in  std_logic_vector(C_IQ_DATA_WIDTH-1 downto 0) := (others => '0');
    rx_axis_agn_tdata                : out std_logic_vector(C_IQ_DATA_WIDTH-1 downto 0);
    tx_axis_agn_tlast                : in  std_logic;
    tx_axis_agn_tready               : out std_logic;
    tx_axis_agn_tvalid               : in  std_logic;
    rx_axis_agn_tlast                : out std_logic;
    rx_axis_agn_tready               : in  std_logic;
    rx_axis_agn_tvalid               : out std_logic;
    agn_line_speed                   : in  std_logic_vector(C_SPEED_SEL_WIDTH-1 downto 0) := (others => '0');
    iq_tx_enable                     : out std_logic;
    iq_tx                            : in  std_logic_vector(C_IQ_DATA_WIDTH-1 downto 0) := (others => '0');
    iq_rx                            : out std_logic_vector(C_IQ_DATA_WIDTH-1 downto 0);
    basic_frame_first_word           : out std_logic;
    vendor_tx_data                   : in  std_logic_vector(C_VENDOR_WIDTH-1 downto 0) := (others => '0');
    rt_vendor_tx_data                : in  std_logic_vector(C_RT_VENDOR_WIDTH-1 downto 0) := (others => '0');
    vendor_tx_xs                     : out std_logic_vector(1 downto 0);
    vendor_tx_ns                     : out std_logic_vector(5 downto 0);
    vendor_rx_data                   : out std_logic_vector(C_VENDOR_WIDTH-1 downto 0);
    rt_vendor_rx_data                : out std_logic_vector(C_RT_VENDOR_WIDTH-1 downto 0) := (others => '0');
    vendor_rx_xs                     : out std_logic_vector(1 downto 0);
    vendor_rx_ns                     : out std_logic_vector(5 downto 0);
    nodebfn_tx_strobe                : in  std_logic := '0';
    nodebfn_tx_nr                    : in  std_logic_vector(11 downto 0) := (others => '0');
    nodebfn_rx_strobe                : out std_logic;
    nodebfn_rx_nr                    : out std_logic_vector(11 downto 0);
    eth_tx_clk                       : in  std_logic := '0';
    eth_txd                          : in  std_logic_vector(C_ETH_DATA_WIDTH-1 downto 0) := (others => '0');
    eth_tx_er                        : in  std_logic := '0';
    eth_tx_en                        : in  std_logic := '0';
    eth_col                          : out std_logic;
    eth_crs                          : out std_logic;
    eth_rx_clk                       : in  std_logic := '0';
    eth_rxd                          : out std_logic_vector(C_ETH_DATA_WIDTH-1 downto 0);
    eth_rx_er                        : out std_logic;
    eth_rx_dv                        : out std_logic;
    eth_rx_avail                     : out std_logic;
    eth_rx_ready                     : in  std_logic;
    rx_fifo_almost_full              : out std_logic;
    rx_fifo_full                     : out std_logic;
    eth_ref_clk                      : in  std_logic := '0';
    tx_axis_eth_tdata                : in  std_logic_vector(7 downto 0) := (others => '0');
    tx_axis_eth_tvalid               : in  std_logic := '0';
    tx_axis_eth_tuser                : in  std_logic := '0';
    tx_axis_eth_tlast                : in  std_logic := '0';
    tx_axis_eth_tready               : out std_logic;
    rx_axis_eth_tdata                : out std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid               : out std_logic;
    rx_axis_eth_tuser                : out std_logic;
    rx_axis_eth_tlast                : out std_logic;
    hdlc_rx_data                     : out std_logic;
    hdlc_tx_data                     : in  std_logic := '0';
    hdlc_rx_data_valid               : out std_logic;
    hdlc_tx_enable                   : out std_logic;
    stat_alarm                       : out std_logic;
    stat_code                        : out std_logic_vector(3 downto 0);
    ser_txd                          : out std_logic_vector(C_IQ_DATA_WIDTH-1 downto 0);
    ser_tx_k                         : out std_logic_vector((C_IQ_DATA_WIDTH/8)-1 downto 0);
    ser_txheader                     : out std_logic_vector(1 downto 0);
    ser_txsequence                   : out std_logic_vector(6 downto 0);
    ser_rxd                          : in  std_logic_vector(C_DATAPATH_BYTES*8-1 downto 0) := (others => '0');
    ser_rx_err                       : in  std_logic_vector(C_DATAPATH_BYTES-1 downto 0)   := (others => '0');
    ser_rx_iscomma                   : in  std_logic_vector(C_DATAPATH_BYTES-1 downto 0)   := (others => '0');
    ser_rxdval                       : in  std_logic;
    ser_rxheader                     : in  std_logic_vector(1 downto 0);
    ser_rxhval                       : in  std_logic;
    ser_rx_realign_en                : out std_logic;
    ser_tx_inhibit                   : out std_logic;
    ser_lol                          : in  std_logic := '0';
    loopback                         : out std_logic_vector(1 downto 0);
    hfnsync                          : out std_logic;
    fec_alignment_en                 : out std_logic;
    mgmnt_addr                       : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
    mgmnt_wr_data                    : in  std_logic_vector(31 downto 0) := (others => '0');
    mgmnt_req                        : in  std_logic := '0';
    mgmnt_rnw                        : in  std_logic := '0';
    mgmnt_rd_data                    : out std_logic_vector(31 downto 0);
    mgmnt_ack                        : out std_logic;
    l1_timer_expired                 : in  std_logic := '0';
    vs_negotiation_complete          : in  std_logic := '0';
    reset_request_in                 : in  std_logic := '0';
    reset_acknowledge_in             : in  std_logic := '0';
    sdi_request_in                   : in  std_logic := '0';
    reset_request_out                : out std_logic;
    reset_acknowledge_out            : out std_logic;
    sdi_request_out                  : out std_logic;
    local_los                        : out std_logic;
    local_lof                        : out std_logic;
    local_rai                        : out std_logic;
    remote_los                       : out std_logic;
    remote_lof                       : out std_logic;
    remote_rai                       : out std_logic;
    fifo_transit_time                : out std_logic_vector(15 downto 0);
    fifo_transit_time_tx             : out std_logic_vector(13 downto 0);
    coarse_timer_value               : out std_logic_vector(17 downto 0);
    barrel_shift_value               : out std_logic_vector(6 downto 0);
    tx_gb_latency_value              : out std_logic_vector(15 downto 0);
    rx_gb_latency_value              : out std_logic_vector(15 downto 0);
    stat_rx_delay_value              : out std_logic_vector(6 downto 0);
    hfec_fifo_latency_value          : out std_logic_vector(15 downto 0);
    hyperframe_number                : out std_logic_vector(7 downto 0);
    drp_arb_req                      : out std_logic;
    drp_arb_gnt                      : in  std_logic := '0';
    drp_daddr                        : out std_logic_vector(7 downto 0);
    drp_dout                         : out std_logic_vector(15 downto 0);
    drp_dwe                          : out std_logic;
    gt_den                           : out std_logic;
    gt_din                           : in  std_logic_vector(15 downto 0) := (others => '0');
    gt_drdy                          : in  std_logic := '0';
    pll_den                          : out std_logic;
    pll_din                          : in  std_logic_vector(15 downto 0) := (others => '0');
    pll_drdy                         : in  std_logic := '0';
    datapath_reset_req               : out std_logic;
    speed_select                     : out std_logic_vector(C_SPEED_SEL_WIDTH-1 downto 0);
    core_is_master                   : in  std_logic := '0';
    recovered_clk                    : in  std_logic := '0';
    rec_gt_clk                       : in  std_logic := '0';
    clk                              : in  std_logic := '0';
    clk_ok                           : in  std_logic := '0';
    clk_316                          : in  std_logic := '0';
    hires_clk                        : in  std_logic := '0';
    aux_clk                          : in  std_logic := '0';
    reset_hires_clk                  : in  std_logic := '0';
    reset_recclk                     : in  std_logic := '0';
    reset_aux_clk                    : in  std_logic := '0';
    reset                            : in  std_logic := '0';
    blocksync                        : in  std_logic := '0';
    gt_rxresetdone                   : in  std_logic;
    watchdog_timeout_value           : out std_logic_vector(31 downto 0);
    tl_tx_clk                        : out std_logic;
    tl_tx_resetn                     : out std_logic;
    tl_rx_clk                        : out std_logic;
    tl_rx_resetn                     : out std_logic;
    tl_tx_mac_cw_start               : out std_logic;
    tl_tx_mac_data                   : out std_logic_vector(65 downto 0);
    tl_rx_mac_data                   : in  std_logic_vector(65 downto 0);
    tl_tx_phy_data                   : in  std_logic_vector(65 downto 0);
    tl_rx_phy_data                   : out std_logic_vector(65 downto 0);
    tl_ctrl_bypass_indication_enable : out std_logic;
    tl_ctrl_rapid_alignment_mode     : out std_logic;
    tl_stat_corrected_cw_inc         : in  std_logic;
    tl_stat_uncorrected_cw_inc       : in  std_logic;
    tl_stat_cw_inc                   : in  std_logic;
    tl_stat_symbol_errors_inc        : in  std_logic_vector(2 downto 0);
    tl_stat_rx_delay                 : in  std_logic_vector(6 downto 0);
    tl_stat_rx_align_status          : in  std_logic;
    hfec_enable                      : out std_logic;
    hfec_cdc_reset                   : out std_logic;
    hfec_fifo_fill_level             : out std_logic_vector( 8 downto 0);
    hfec_average                     : in  std_logic_vector(16 downto 0);
    hfec_average_rdy                 : in  std_logic;
    hfec_average_ack                 : out std_logic;
    hfec_fifo_error                  : in  std_logic;
    hfec_cdc_rxdata                  : in  std_logic_vector(63 downto 0);
    hfec_cdc_rxheader                : in  std_logic_vector(1 downto 0);
    hfec_fifo_latency                : in  std_logic_vector(15 downto 0);
    hfec_fifo_latency_rdy            : in  std_logic;
    hfec_fifo_latency_ack            : out std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_fc32_rs_fec
  port (
    tx_clk                        : in  std_logic;
    tx_resetn                     : in  std_logic;
    rx_clk                        : in  std_logic;
    rx_resetn                     : in  std_logic;
    tx_mac_cw_start               : in  std_logic;
    tx_mac_data                   : in  std_logic_vector(65 downto 0);
    rx_mac_data                   : out std_logic_vector(65 downto 0);
    tx_phy_data                   : out std_logic_vector(65 downto 0);
    rx_phy_data                   : in  std_logic_vector(65 downto 0);
    ctrl_bypass_indication_enable : in  std_logic;
    ctrl_rapid_alignment_mode     : in  std_logic;
    stat_corrected_cw_inc         : out std_logic;
    stat_uncorrected_cw_inc       : out std_logic;
    stat_cw_inc                   : out std_logic;
    stat_symbol_errors_inc        : out std_logic_vector(2 downto 0);
    stat_rx_delay                 : out std_logic_vector(6 downto 0);
    stat_rx_align_status          : out std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_gt_and_clocks
  port (
    gt_txresetdone          : out std_logic;
    gt_rxresetdone          : out std_logic;
    -- Input clocks & resets
    refclk                   : in  std_logic;
    aux_clk                  : in  std_logic;
    gtwiz_reset_clk_freerun_in : in std_logic;
    reset                    : in  std_logic;
    watchdog_reset           : in  std_logic;
    mmcm_reset_req           : in  std_logic;

    -- Output clocks & resets
    blocksync                : out std_logic;
    rec_clk_rst              : out std_logic;
    txoutclk                 : out std_logic;
    txresetdone_o            : out std_logic;

    -- GT Common Ports
    qpll0clk                 : in  std_logic;
    qpll0refclk              : in  std_logic;
    qpll1clk                 : in  std_logic;
    qpll1refclk              : in  std_logic;
    qpll0lock                : in  std_logic;
    qpll0_pd                 : out std_logic;
    qpll1lock                : in  std_logic;
    qpll1_pd                 : out std_logic;

    -- serial I/O
    txn                      : out std_logic;
    txp                      : out std_logic;
    rxn                      : in  std_logic;
    rxp                      : in  std_logic;

    -- Transmit datapath from core
    txdata                   : in  std_logic_vector(63 downto 0);
    txcharisk                : in  std_logic_vector( 7 downto 0);
    txheader                 : in  std_logic_vector(1 downto 0);
    txsequence               : in  std_logic_vector(6 downto 0);

    -- Receive datapath to core
    rxdata                   : out std_logic_vector(63 downto 0);
    rxchariscomma            : out std_logic_vector( 7 downto 0);
    rxcharisk                : out std_logic_vector( 7 downto 0);
    rxcharerr                : out std_logic_vector( 7 downto 0);
    rxdatavalid              : out std_logic;
    rxheader                 : out std_logic_vector (1 downto 0);
    rxheadervalid            : out std_logic;

    -- FEC alignment control
    fec_alignment_en         : in  std_logic;

    -- Transceiver control
    loopback                 : in  std_logic_vector(2 downto 0);
    txinhibit                : in  std_logic;
    encommaalign             : in  std_logic;
    qpll_select              : in  std_logic;

    -- Core DRP
    core_drp_arb_req         : in  std_logic;
    core_drp_arb_gnt         : out std_logic;
    core_drp_dout            : in  std_logic_vector(15 downto 0);
    core_drp_daddr           : in  std_logic_vector(7 downto 0);
    core_drp_dwe             : in  std_logic;
    core_gt_din              : out std_logic_vector(15 downto 0);
    core_gt_den              : in  std_logic;
    core_gt_drdy             : out std_logic;

    -- User DRP - GT only
    user_drp_dout            : in  std_logic_vector(15 downto 0);
    user_drp_daddr           : in  std_logic_vector(9 downto 0);
    user_drp_dwe             : in  std_logic;
    user_gt_din              : out std_logic_vector(15 downto 0);
    user_gt_den              : in  std_logic;
    user_gt_drdy             : out std_logic;

    -- Line rate
    -- FEC line rates use abbreviated 11bit vector
    speed_select             : in  std_logic_vector(10 downto 0);
    mmcm_rst                 : out std_logic;
    rxoutclk                 : out std_logic;
    rxrecclkout              : out std_logic;
    txusrclk                 : in  std_logic;
    txusrclk2                : in  std_logic;
    rxusrclk2                : in  std_logic;
    hires_clk                : in  std_logic;
    gtreset_sm_done          : out std_logic;
    userclk_tx_reset         : out std_logic;
    userclk_rx_reset         : out std_logic;
    txdlyen                  : in  std_logic;
    txphinit                 : in  std_logic;
    phase_alignment_done     : in  std_logic;
    txdlysreset              : in  std_logic;
    txphalign                : in  std_logic;
    txphaligndone            : out std_logic;
    txdlysresetdone          : out std_logic;
    txphinitdone_o           : out std_logic;
    txsyncdone_o             : out std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_axi_lite_ipif_wrapper
    port (
       --System signals
      S_AXI_ACLK            : in  std_logic;
      S_AXI_ARESETN         : in  std_logic;
      S_AXI_AWADDR          : in  std_logic_vector(31 downto 0);
      S_AXI_AWVALID         : in  std_logic;
      S_AXI_AWREADY         : out std_logic;
      S_AXI_WDATA           : in  std_logic_vector(31 downto 0);
      S_AXI_WSTRB           : in  std_logic_vector(3 downto 0);
      S_AXI_WVALID          : in  std_logic;
      S_AXI_WREADY          : out std_logic;
      S_AXI_BRESP           : out std_logic_vector(1 downto 0);
      S_AXI_BVALID          : out std_logic;
      S_AXI_BREADY          : in  std_logic;
      S_AXI_ARADDR          : in  std_logic_vector(31 downto 0);
      S_AXI_ARVALID         : in  std_logic;
      S_AXI_ARREADY         : out std_logic;
      S_AXI_RDATA           : out std_logic_vector(31 downto 0);
      S_AXI_RRESP           : out std_logic_vector(1 downto 0);
      S_AXI_RVALID          : out std_logic;
      S_AXI_RREADY          : in  std_logic;
      -- Controls to the IP/IPIF modules
      Bus2IP_Clk            : out std_logic;
      Bus2IP_Resetn         : out std_logic;
      Bus2IP_Addr           : out std_logic_vector(31 downto 0);
      Bus2IP_RNW            : out std_logic;
      Bus2IP_BE             : out std_logic_vector(3 downto 0);
      Bus2IP_RdCE           : out std_logic_vector(0 downto 0);
      Bus2IP_WrCE           : out std_logic_vector(0 downto 0);
      Bus2IP_Data           : out std_logic_vector(31 downto 0);
      IP2Bus_Data           : in  std_logic_vector(31 downto 0);
      IP2Bus_WrAck          : in  std_logic;
      IP2Bus_RdAck          : in  std_logic;
      IP2Bus_Error          : in  std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_watchdog is
    port (
      clk                      : in std_logic;
      hfnsync                  : in std_logic;
      reset                    : in std_logic;
      watchdog_timeout_value   : in  std_logic_vector(31 downto 0);
      done                     : out std_logic;
      hfnsync_achieved_rising  : out std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_synchronizer is
    port (
      q     : out std_logic;
      clk   : in  std_logic;
      d     : in  std_logic);
  end component;

  component xCORE_CPRI_RUn77_REC_reset_synchronizer is
    port (
      reset_in  : in  std_logic;
      clk       : in  std_logic;
      reset_out : out std_logic);
  end component;

  -- Signal declarations
  signal txdata                   : std_logic_vector(63 downto 0);
  signal txcharisk                : std_logic_vector(7 downto 0);
  signal txheader                 : std_logic_vector(1 downto 0);
  signal txsequence               : std_logic_vector(6 downto 0);
  signal rxdata                   : std_logic_vector(63 downto 0);
  signal rxcharisk                : std_logic_vector(7 downto 0);
  signal rxchariscomma            : std_logic_vector(7 downto 0);
  signal rxcharerr                : std_logic_vector(7 downto 0);
  signal rxheader                 : std_logic_vector(1 downto 0);
  signal rxheadervalid            : std_logic;
  signal rxdatavalid              : std_logic;
  signal encommaalign             : std_logic;
  signal stat_code_i              : std_logic_vector(3 downto 0);
  signal hfnsync                  : std_logic;
  signal fec_alignment_en_i       : std_logic;
  signal fec_alignment_en_r       : std_logic;
  signal gt_rxresetdone_i         : std_logic;
  signal speed_select_full        : std_logic_vector(14 downto 0); -- Full 15bit vector
  signal speed_select_i           : std_logic_vector(10 downto 0); -- Abbreviated 11bit vector
  signal core_disabled            : std_logic;
  signal lossoflight_i            : std_logic;
  signal txinhibit_i              : std_logic;
  signal txinhibit_tmp            : std_logic;
  signal txinhibit_r              : std_logic;
  signal loopback                 : std_logic_vector(1 downto 0);
  signal loopback_qual            : std_logic_vector(2 downto 0);
  signal blocksync_i              : std_logic;
  signal tx_clk_ok_i              : std_logic;
  signal recclk_ok_i              : std_logic;
  signal reset_core               : std_logic;
  signal reset_aux_clk            : std_logic;
  signal clk_ok_i                 : std_logic;
  signal gt_txresetdone_i         : std_logic;
  signal reset_hires_clk          : std_logic;
  signal rec_rst_i                : std_logic;
  signal reset_recclk             : std_logic;
  signal datapath_reset_req       : std_logic;
  signal aux_hfnsync              : std_logic;
  signal watchdog_reset           : std_logic;
  signal bus2ip_addr              : std_logic_vector(31 downto 0);
  signal bus2ip_rnw               : std_logic;
  signal bus2ip_be                : std_logic_vector(3 downto 0);
  signal bus2ip_rdce              : std_logic_vector(0 downto 0);
  signal bus2ip_wrce              : std_logic_vector(0 downto 0);
  signal ip2bus_wrack             : std_logic;
  signal ip2bus_rdack             : std_logic;
  signal ip2bus_error             : std_logic;
  signal mgmnt_addr               : std_logic_vector(7 downto 0);
  signal mgmnt_wr_data            : std_logic_vector(31 downto 0);
  signal mgmnt_req                : std_logic;
  signal mgmnt_rnw                : std_logic;
  signal mgmnt_rd_data            : std_logic_vector(31 downto 0);
  signal mgmnt_ack                : std_logic;
  signal bus2ip_clk               : std_logic;
  signal bus2ip_resetn            : std_logic;
  signal bus2ip_reset             : std_logic;
  signal aux_clk                  : std_logic;
  signal s_axi_awaddr_i           : std_logic_vector(31 downto 0);
  signal s_axi_araddr_i           : std_logic_vector(31 downto 0);
  signal core_drp_arb_req         : std_logic;
  signal core_drp_arb_gnt         : std_logic;
  signal core_drp_dout            : std_logic_vector(15 downto 0);
  signal core_drp_daddr           : std_logic_vector(7 downto 0);
  signal core_drp_dwe             : std_logic;
  signal core_gt_din              : std_logic_vector(15 downto 0);
  signal core_gt_den              : std_logic;
  signal core_gt_drdy             : std_logic;
  signal user_drp_dout            : std_logic_vector(15 downto 0);
  signal user_drp_daddr           : std_logic_vector(9 downto 0);
  signal user_drp_dwe             : std_logic;
  signal user_gt_din              : std_logic_vector(15 downto 0);
  signal user_gt_den              : std_logic;
  signal user_gt_drdy             : std_logic;
  signal drp_arb_req              : std_logic;
  signal drp_arb_gnt              : std_logic;
  signal mmcm_rst_i               : std_logic;
  signal watchdog_timeout_value   : std_logic_vector(31 downto 0);
  signal fifo_transit_time_int    : std_logic_vector(15 downto 0);
  signal tl_tx_clk                        : std_logic;
  signal tl_tx_resetn                     : std_logic;
  signal tl_rx_clk                        : std_logic;
  signal tl_rx_resetn                     : std_logic;
  signal tl_tx_mac_cw_start               : std_logic;
  signal tl_tx_mac_data                   : std_logic_vector(65 downto 0);
  signal tl_rx_mac_data                   : std_logic_vector(65 downto 0);
  signal tl_tx_phy_data                   : std_logic_vector(65 downto 0);
  signal tl_rx_phy_data                   : std_logic_vector(65 downto 0);
  signal tl_ctrl_bypass_indication_enable : std_logic;
  signal tl_ctrl_rapid_alignment_mode     : std_logic;
  signal tl_stat_corrected_cw_inc         : std_logic;
  signal tl_stat_uncorrected_cw_inc       : std_logic;
  signal tl_stat_cw_inc                   : std_logic;
  signal tl_stat_symbol_errors_inc        : std_logic_vector(2 downto 0);
  signal tl_stat_rx_delay                 : std_logic_vector(6 downto 0);
  signal tl_stat_rx_align_status          : std_logic;

begin


  -- cpri_block
  cpri_i : cpri_v8_11_14
    generic map (
      C_TRANSCEIVER_TYPE          => 6,
      C_IS_VERSAL                 => false,
      EGW_IS_PARENT_IP            => false,
      C_DATAPATH_BYTES            => 8,
      C_USE_32BIT                 => false,
      C_USE_64BIT                 => true,
      C_AGNOSTIC_MODE             => false,
      C_VENDOR_WIDTH              => 128,
      C_RT_VENDOR_WIDTH           => 256,
      C_ADDR_WIDTH                => 8,
      C_SPEED_SEL_WIDTH           => 15,
      C_IQ_DATA_WIDTH             => 64,
      C_ETH_DATA_WIDTH            => 8,
      C_CDC_IS_EXTENDED           => 0,
      C_IS_MASTER                 => true,
      C_LINE_RATE                 => 6,
      C_REF_CLK_SPEED             => 2,
      C_USE_ETHERNET              => true,
      C_USE_GMII                  => true,
      C_USE_ORI                   => false,
      C_R21_TIMER                 => true,
      C_AXI_IPIF                  => true,
      C_FREE_RUNNING_RX_REFERENCE => false,
      C_BYPASS_BUFFER             => false,
      C_RT_VENDOR_SUPPORT         => false,
      C_GT_TYPE                   => 3,
      C_USE_FEC                   => true,
      C_USE_HARD_FEC              => false,
      C_USE_0_6144G               => false,
      C_USE_1_2288G               => false,
      C_USE_2_4576G               => false,
      C_USE_3_072G                => false,
      C_USE_4_9152G               => false,
      C_USE_6_144G                => false,
      C_USE_8_11008G              => false,
      C_USE_9_8304G               => false,
      C_USE_10_1376G              => true,
      C_USE_12_16512G             => false,
      C_USE_24_33024G             => true,
      C_MAJOR_VERSION             => 8,
      C_MINOR_VERSION             => 11,
      C_REVISION                  => 14
      )
    port map (
      iq_tx_enable                     => iq_tx_enable,
      basic_frame_first_word           => basic_frame_first_word,
      iq_tx                            => iq_tx,
      iq_rx                            => iq_rx,
      tx_axis_agn_tdata                => (others => '0'),
      rx_axis_agn_tdata                => open,
      tx_axis_agn_tlast                => '0',
      tx_axis_agn_tready               => open,
      tx_axis_agn_tvalid               => '0',
      rx_axis_agn_tlast                => open,
      rx_axis_agn_tready               => '0',
      rx_axis_agn_tvalid               => open,
      agn_line_speed                   => (others => '0'),
      vendor_tx_data                   => vendor_tx_data,
      rt_vendor_tx_data                => (others => '0'),
      vendor_tx_xs                     => vendor_tx_xs,
      vendor_tx_ns                     => vendor_tx_ns,
      vendor_rx_data                   => vendor_rx_data,
      rt_vendor_rx_data                => open,
      vendor_rx_xs                     => vendor_rx_xs,
      vendor_rx_ns                     => vendor_rx_ns,
      nodebfn_tx_strobe                => nodebfn_tx_strobe,
      nodebfn_tx_nr                    => nodebfn_tx_nr,
      nodebfn_rx_strobe                => nodebfn_rx_strobe,
      nodebfn_rx_nr                    => nodebfn_rx_nr,
      eth_txd                          => eth_txd,
      eth_tx_er                        => eth_tx_er,
      eth_tx_en                        => eth_tx_en,
      eth_col                          => eth_col,
      eth_crs                          => eth_crs,
      eth_rxd                          => eth_rxd,
      eth_rx_er                        => eth_rx_er,
      eth_rx_dv                        => eth_rx_dv,
      eth_rx_avail                     => eth_rx_avail,
      eth_rx_ready                     => eth_rx_ready,
      rx_fifo_almost_full              => rx_fifo_almost_full,
      rx_fifo_full                     => rx_fifo_full,
      eth_tx_clk                       => eth_tx_clk,
      eth_rx_clk                       => eth_rx_clk,
      eth_ref_clk                      => '0',
      tx_axis_eth_tdata                => x"00",
      tx_axis_eth_tvalid               => '0',
      tx_axis_eth_tuser                => '0',
      tx_axis_eth_tlast                => '0',
      tx_axis_eth_tready               => open,
      rx_axis_eth_tdata                => open,
      rx_axis_eth_tvalid               => open,
      rx_axis_eth_tuser                => open,
      rx_axis_eth_tlast                => open,
      hdlc_rx_data                     => hdlc_rx_data,
      hdlc_tx_data                     => hdlc_tx_data,
      hdlc_rx_data_valid               => hdlc_rx_data_valid,
      hdlc_tx_enable                   => hdlc_tx_enable,
      stat_alarm                       => stat_alarm,
      stat_code                        => stat_code_i,
      ser_txd                          => txdata,
      ser_tx_k                         => txcharisk,
      ser_txheader                     => txheader,
      ser_txsequence                   => txsequence,
      ser_rxd                          => rxdata,
      ser_rx_err                       => rxcharerr,
      ser_rx_iscomma                   => rxchariscomma,
      ser_rxdval                       => rxdatavalid,
      ser_rxheader                     => rxheader,
      ser_rxhval                       => rxheadervalid,
      ser_rx_realign_en                => encommaalign,
      ser_tx_inhibit                   => txinhibit_i,
      ser_lol                          => lossoflight_i,
      loopback                         => loopback,
      hfnsync                          => hfnsync,
      fec_alignment_en                 => fec_alignment_en_i,
      mgmnt_addr                       => mgmnt_addr,
      mgmnt_wr_data                    => mgmnt_wr_data,
      mgmnt_req                        => mgmnt_req,
      mgmnt_rnw                        => mgmnt_rnw,
      mgmnt_rd_data                    => mgmnt_rd_data,
      mgmnt_ack                        => mgmnt_ack,
      l1_timer_expired                 => l1_timer_expired,
      vs_negotiation_complete          => vs_negotiation_complete,
      reset_request_in                 => reset_request_in,
      reset_acknowledge_in             => '0',
      sdi_request_in                   => sdi_request_in,
      reset_request_out                => open,
      reset_acknowledge_out            => reset_acknowledge_out,
      sdi_request_out                  => sdi_request_out,
      local_los                        => local_los,
      local_lof                        => local_lof,
      local_rai                        => local_rai,
      remote_los                       => remote_los,
      remote_lof                       => remote_lof,
      remote_rai                       => remote_rai,
      fifo_transit_time                => fifo_transit_time_int,
      fifo_transit_time_tx             => open,
      coarse_timer_value               => coarse_timer_value,
      barrel_shift_value               => barrel_shift_value,
      tx_gb_latency_value              => tx_gb_latency_value,
      rx_gb_latency_value              => rx_gb_latency_value,
      stat_rx_delay_value              => stat_rx_delay_value,
      hfec_fifo_latency_value          => open,
      hyperframe_number                => hyperframe_number,
      drp_arb_req                      => core_drp_arb_req,
      drp_arb_gnt                      => core_drp_arb_gnt,
      drp_daddr                        => core_drp_daddr,
      drp_dout                         => core_drp_dout,
      drp_dwe                          => core_drp_dwe,
      gt_den                           => core_gt_den,
      gt_din                           => core_gt_din,
      gt_drdy                          => core_gt_drdy,
      pll_den                          => open,
      pll_din                          => x"0000",
      pll_drdy                         => '0',
      datapath_reset_req               => datapath_reset_req,
      speed_select                     => speed_select_full,
      core_is_master                   => core_is_master,

      recovered_clk                    => recclk_in,
      rec_gt_clk                       => recclk_in,
      clk                              => clk_in,
      clk_ok                           => clk_ok_i,
      clk_316                          => '0',
      hires_clk                        => hires_clk,
      aux_clk                          => bus2ip_clk,
      reset_hires_clk                  => reset_hires_clk,
      reset_recclk                     => reset_recclk,
      reset_aux_clk                    => reset_aux_clk,
      reset                            => reset_core,
      blocksync                        => blocksync_i,
      gt_rxresetdone                   => gt_rxresetdone_i,
      watchdog_timeout_value           => watchdog_timeout_value,
      tl_tx_clk                        => tl_tx_clk,
      tl_tx_resetn                     => tl_tx_resetn,
      tl_rx_clk                        => tl_rx_clk,
      tl_rx_resetn                     => tl_rx_resetn,
      tl_tx_mac_cw_start               => tl_tx_mac_cw_start,
      tl_tx_mac_data                   => tl_tx_mac_data,
      tl_rx_mac_data                   => tl_rx_mac_data,
      tl_tx_phy_data                   => tl_tx_phy_data,
      tl_rx_phy_data                   => tl_rx_phy_data,
      tl_ctrl_bypass_indication_enable => tl_ctrl_bypass_indication_enable,
      tl_ctrl_rapid_alignment_mode     => tl_ctrl_rapid_alignment_mode,
      tl_stat_corrected_cw_inc         => tl_stat_corrected_cw_inc,
      tl_stat_uncorrected_cw_inc       => tl_stat_uncorrected_cw_inc,
      tl_stat_cw_inc                   => tl_stat_cw_inc,
      tl_stat_symbol_errors_inc        => tl_stat_symbol_errors_inc,
      tl_stat_rx_delay                 => tl_stat_rx_delay,
      tl_stat_rx_align_status          => tl_stat_rx_align_status,
      -- HFEC unused
      hfec_enable                      => open,
      hfec_cdc_reset                   => open,
      hfec_fifo_fill_level             => open,
      hfec_average                     => (others => '0'),
      hfec_average_rdy                 => '0',
      hfec_average_ack                 => open,
      hfec_fifo_error                  => '0',
      hfec_cdc_rxdata                  => (others => '0'),
      hfec_cdc_rxheader                => "00",
      hfec_fifo_latency                => (others => '0'),
      hfec_fifo_latency_rdy            => '0',
      hfec_fifo_latency_ack            => open);

  cpri_fec_i : xCORE_CPRI_RUn77_REC_fc32_rs_fec
    port map (
      -- Clocks & Resets
      tx_clk                        => tl_tx_clk,
      tx_resetn                     => tl_tx_resetn,
      rx_clk                        => tl_rx_clk,
      rx_resetn                     => tl_rx_resetn,
      tx_mac_cw_start               => tl_tx_mac_cw_start,
      tx_mac_data                   => tl_tx_mac_data,
      rx_mac_data                   => tl_rx_mac_data,
      tx_phy_data                   => tl_tx_phy_data,
      rx_phy_data                   => tl_rx_phy_data,
      ctrl_bypass_indication_enable => tl_ctrl_bypass_indication_enable,
      ctrl_rapid_alignment_mode     => tl_ctrl_rapid_alignment_mode,
      stat_corrected_cw_inc         => tl_stat_corrected_cw_inc,
      stat_uncorrected_cw_inc       => tl_stat_uncorrected_cw_inc,
      stat_cw_inc                   => tl_stat_cw_inc,
      stat_symbol_errors_inc        => tl_stat_symbol_errors_inc,
      stat_rx_delay                 => tl_stat_rx_delay,
      stat_rx_align_status          => tl_stat_rx_align_status);


    -- AND the clk_ok_in signal with the gt_txresetdone o/p signal to allow a
    -- secondary CPRI core to clear its soft reset register bit in mgmnt block.
    process(clk_in)
    begin
      if rising_edge(clk_in) then
        clk_ok_i <= clk_ok_in and gt_txresetdone_i;
      end if;
    end process;

  -- Transceiver block
  gt_and_clocks_i : xCORE_CPRI_RUn77_REC_gt_and_clocks
  port map (
    gt_txresetdone             => gt_txresetdone_i,
    gt_rxresetdone             => gt_rxresetdone_i,
    -- Input clocks & resets
    refclk                     => refclk,
    aux_clk                    => aux_clk,
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
    reset                      => reset,
    watchdog_reset             => watchdog_reset,
    mmcm_reset_req             => datapath_reset_req,

   -- Output clocks & resets
    blocksync                  => blocksync_i,
    rec_clk_rst                => rec_rst_i,
    txoutclk                   => txoutclk,
    txresetdone_o              => txresetdone_out,

    -- GT Common Ports
    qpll0clk                   => qpll0clk_in,
    qpll0refclk                => qpll0refclk_in,
    qpll1clk                   => qpll1clk_in,
    qpll1refclk                => qpll1refclk_in,
    qpll0lock                  => qpll0lock_in,
    qpll0_pd                   => qpll0_pd,
    qpll1lock                  => qpll1lock_in,
    qpll1_pd                   => qpll1_pd,

    -- serial I/O
    txn                        => txn,
    txp                        => txp,
    rxn                        => rxn,
    rxp                        => rxp,

    -- Transmit datapath from core
    txcharisk                  => txcharisk,
    txdata                     => txdata,
    txheader                   => txheader,
    txsequence                 => txsequence,

    -- Receive datapath to core
    rxchariscomma              => rxchariscomma,
    rxcharisk                  => rxcharisk,
    rxdata                     => rxdata,
    rxcharerr                  => rxcharerr,
    rxdatavalid                => rxdatavalid,
    rxheader                   => rxheader,
    rxheadervalid              => rxheadervalid,

    -- FEC alignment control
    fec_alignment_en           => fec_alignment_en_i,

    -- Transceiver control
    loopback                   => loopback_qual,
    txinhibit                  => txinhibit_r,
    encommaalign               => encommaalign,
    qpll_select                => qpll_select,

     -- Core DRP
    core_drp_arb_req           => core_drp_arb_req,
    core_drp_arb_gnt           => core_drp_arb_gnt,
    core_drp_dout              => core_drp_dout,
    core_drp_daddr             => core_drp_daddr,
    core_drp_dwe               => core_drp_dwe,
    core_gt_din                => core_gt_din,
    core_gt_den                => core_gt_den,
    core_gt_drdy               => core_gt_drdy,

    -- User DRP - GT only
    user_drp_dout              => x"0000",
    user_drp_daddr             => "0000000000",
    user_drp_dwe               => '0',
    user_gt_din                => open,
    user_gt_den                => '0',
    user_gt_drdy               => open,

    -- Line rate
    speed_select               => speed_select_i,

    mmcm_rst                   => mmcm_rst_i,
    rxoutclk                   => rxoutclk,
    rxrecclkout                => rxrecclkout,

    txusrclk                   => txusrclk,
    txusrclk2                  => clk_in,
    rxusrclk2                  => recclk_in,
    hires_clk                  => hires_clk,

    gtreset_sm_done            => gtreset_sm_done,
    userclk_tx_reset           => userclk_tx_reset,
    userclk_rx_reset           => userclk_rx_reset,

    txdlyen                    => txdlyen_in,
    txphinit                   => txphinit_in,
    phase_alignment_done       => phase_alignment_done_in,
    txdlysreset                => txdlysreset_in,
    txphalign                  => txphalign_in,
    txphaligndone              => txphaligndone_out,
    txdlysresetdone            => txdlysresetdone_out,
    txphinitdone_o             => txphinitdone_out,
    txsyncdone_o               => txsyncdone_out);


  s_axi_awaddr_i(31 downto 12) <= (OTHERS=>'0');
  s_axi_awaddr_i(11 downto 0) <= s_axi_awaddr;
  s_axi_araddr_i(31 downto 12) <= (OTHERS=>'0');
  s_axi_araddr_i(11 downto 0) <= s_axi_araddr;

   -- instantiate the axi_ipif block
  axi_lite_ipif : xCORE_CPRI_RUn77_REC_axi_lite_ipif_wrapper
  port map (
    -- System signals
    S_AXI_ACLK        => s_axi_aclk,
    S_AXI_ARESETN     => s_axi_aresetn,
    S_AXI_AWADDR      => s_axi_awaddr_i,
    S_AXI_AWVALID     => s_axi_awvalid,
    S_AXI_AWREADY     => s_axi_awready,
    S_AXI_WDATA       => s_axi_wdata,
    S_AXI_WSTRB       => "1111",
    S_AXI_WVALID      => s_axi_wvalid,
    S_AXI_WREADY      => s_axi_wready,
    S_AXI_BRESP       => s_axi_bresp,
    S_AXI_BVALID      => s_axi_bvalid,
    S_AXI_BREADY      => s_axi_bready,
    S_AXI_ARADDR      => s_axi_araddr_i,
    S_AXI_ARVALID     => s_axi_arvalid,
    S_AXI_ARREADY     => s_axi_arready,
    S_AXI_RDATA       => s_axi_rdata,
    S_AXI_RRESP       => s_axi_rresp,
    S_AXI_RVALID      => s_axi_rvalid,
    S_AXI_RREADY      => s_axi_rready,
    -- Controls to the IPIf
    Bus2IP_Clk        => bus2ip_clk,
    Bus2IP_Resetn     => bus2ip_resetn,
    Bus2IP_Addr       => bus2ip_addr,
    Bus2IP_RNW        => bus2ip_rnw,
    Bus2IP_BE         => bus2ip_be,
    Bus2IP_RdCE       => bus2ip_rdce,
    Bus2IP_WrCE       => bus2ip_wrce,
    Bus2IP_Data       => mgmnt_wr_data,
    IP2Bus_Data       => mgmnt_rd_data,
    IP2Bus_WrAck      => ip2bus_wrack,
    IP2Bus_RdAck      => ip2bus_rdack,
    IP2Bus_Error      => ip2bus_error);

  bus2ip_reset  <= not(bus2ip_resetn);

  mgmnt_addr    <= bus2ip_addr(9 downto 2);
  ip2bus_wrack  <= mgmnt_ack and bus2ip_wrce(0);
  ip2bus_rdack  <= mgmnt_ack and bus2ip_rdce(0);
  ip2bus_error  <= '0';
  mgmnt_rnw     <= bus2ip_rdce(0);
  mgmnt_req     <= bus2ip_wrce(0) or bus2ip_rdce(0);
  aux_clk       <= bus2ip_clk;
  aux_clk_out   <= bus2ip_clk;

  tx_clk_ok_i   <= clk_ok_in;
  recclk_ok_i   <= not(rec_rst_i);

  -- Synchronize hfnsync into the aux_clk domain
  ref_hfnsync_s : xCORE_CPRI_RUn77_REC_synchronizer
  port map (
    q     => aux_hfnsync,
    clk   => aux_clk,
    d     => hfnsync);

  watchdog_i : xCORE_CPRI_RUn77_REC_watchdog
  port map(
    -- Inputs
    clk                      => aux_clk,
    hfnsync                  => aux_hfnsync,
    reset                    => datapath_reset_req,
    watchdog_timeout_value   => watchdog_timeout_value,
    -- Outputs
    done                     => watchdog_reset,
    hfnsync_achieved_rising  => open);


  reset_hires_clk <= not hires_clk_ok;
  loopback_qual   <= "0" & loopback;

  -- FEC line rates use abbreviated 11 bit vector
  core_disabled   <= '1' when speed_select_i = "00000000000" else '0';

  -- OR the FEC line rates with the standard line rates to create an
  -- abbreviated 11bit vector for the gt_and_clocks & ori_if modules.
  speed_select_i(10) <= speed_select_full(14) or speed_select_full(10); -- 24G
  speed_select_i(9)  <= speed_select_full(13) or speed_select_full(9);  -- 12G
  speed_select_i(8)  <= speed_select_full(11) or speed_select_full(8);  -- 8G
  speed_select_i(7)  <= speed_select_full(12) or speed_select_full(7);  -- 10G
  speed_select_i(6 downto 0) <= speed_select_full(6 downto 0);

  -- Register on the management clock
  p_txinhibit_reg : process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if reset_aux_clk = '1' then
        txinhibit_tmp <= '0';
      elsif txinhibit_i = '1' or reset_hires_clk = '1' or core_disabled = '1' then
        txinhibit_tmp <= '1';
      else
        txinhibit_tmp <= '0';
      end if;
    end if;
  end process p_txinhibit_reg;

  -- Synchronize txinhibit into the core domain
  tx_inhibit_s : xCORE_CPRI_RUn77_REC_synchronizer
  port map (
    q     => txinhibit_r,
    clk   => clk_in,
    d     => txinhibit_tmp);

  txinhibit      <= txinhibit_r;
  lossoflight_i  <= lossoflight when loopback = "00" else '0';
  reset_core     <= not(tx_clk_ok_i);
  stat_speed     <= speed_select_full;
  stat_code      <= stat_code_i;

  reset_recclk   <= not(recclk_ok_i);

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      recclk_ok  <= recclk_ok_i;
    end if;
  end process;

  reset_aux_clk_sync_i : xCORE_CPRI_RUn77_REC_reset_synchronizer
  port map (
    reset_in  => bus2ip_reset,
    clk       => aux_clk,
    reset_out => reset_aux_clk);

  mmcm_rst       <= mmcm_rst_i;

  fifo_transit_time <= fifo_transit_time_int(13 downto 0);

end rtl;
