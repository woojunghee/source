--------------------------------------------------------------------------
-- Title      : Block level wrapper for CPRI design
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_REC.vhd
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

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_14;
use cpri_v8_11_14.all;

entity xCORE_CPRI_RUn77_REC is
  port (
    reset                    : in  std_logic; -- Asynchronous reset

    -- I/Q interface
    iq_tx_enable             : out std_logic;
    basic_frame_first_word   : out std_logic;
    iq_tx                    : in  std_logic_vector(63 downto 0);
    iq_rx                    : out std_logic_vector(63 downto 0);

    -- GT Common Ports
    qpll0clk_out             : out std_logic;
    qpll0refclk_out          : out std_logic;
    qpll1clk_out             : out std_logic;
    qpll1refclk_out          : out std_logic;
    qpll0lock_out            : out std_logic;
    qpll1lock_out            : out std_logic;

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
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk                : in  std_logic;
    hires_clk_ok             : in  std_logic;
    qpll_select              : in  std_logic;
    core_is_master           : in  std_logic;
    recclk_ok                : out std_logic;
    recclk                   : out std_logic;
    clk_out                  : out std_logic;
    clk_ok_out               : out std_logic;
    rxrecclkout              : out std_logic;
    txusrclk_out             : out std_logic;
    txphaligndone_in         : in  std_logic_vector(2 downto 0);
    txdlysresetdone_in       : in  std_logic_vector(2 downto 0);
    txphinitdone_in          : in  std_logic_vector(2 downto 0);
    txphinit_out             : out std_logic_vector(2 downto 0);
    phase_alignment_done_out : out std_logic;
    txdlysreset_out          : out std_logic_vector(2 downto 0);
    txphalign_out            : out std_logic_vector(2 downto 0);
    txdlyen_out              : out std_logic_vector(2 downto 0));
end xCORE_CPRI_RUn77_REC;


architecture wrapper of xCORE_CPRI_RUn77_REC is

  component xCORE_CPRI_RUn77_REC_support
  port (
    reset                    : in  std_logic; -- Asynchronous reset

    -- I/Q interface
    iq_tx_enable             : out std_logic;
    basic_frame_first_word   : out std_logic;
    iq_tx                    : in  std_logic_vector(63 downto 0);
    iq_rx                    : out std_logic_vector(63 downto 0);

    -- GT Common Ports
    qpll0clk_out             : out std_logic;
    qpll0refclk_out          : out std_logic;
    qpll1clk_out             : out std_logic;
    qpll1refclk_out          : out std_logic;
    qpll0lock_out            : out std_logic;
    qpll1lock_out            : out std_logic;

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
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk                : in  std_logic;
    hires_clk_ok             : in  std_logic;
    qpll_select              : in  std_logic;
    core_is_master           : in  std_logic;
    recclk_ok                : out std_logic;
    recclk                   : out std_logic;
    clk_out                  : out std_logic;
    clk_ok_out               : out std_logic;
    rxrecclkout              : out std_logic;
    txusrclk_out             : out std_logic;
    txphaligndone_in         : in  std_logic_vector(2 downto 0);
    txdlysresetdone_in       : in  std_logic_vector(2 downto 0);
    txphinitdone_in          : in  std_logic_vector(2 downto 0);
    txphinit_out             : out std_logic_vector(2 downto 0);
    phase_alignment_done_out : out std_logic;
    txdlysreset_out          : out std_logic_vector(2 downto 0);
    txphalign_out            : out std_logic_vector(2 downto 0);
    txdlyen_out              : out std_logic_vector(2 downto 0));
  end component;

  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF wrapper : ARCHITECTURE IS "xCORE_CPRI_RUn77_REC,cpri_v8_11_14,{x_ipProduct=Vivado 2022.2.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=cpri,x_ipVersion=8.11,x_ipCoreRevision=14,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,c_elaboration_transient_dir=0,c_component_name=xCORE_CPRI_RUn77_REC,c_transceiver_type=6,c_datapath_bytes=8,c_vendor_width=128,c_rt_vendor_width=256,c_addr_width=8,c_speed_sel_width=15,c_iq_data_width=64,c_use_32bit=false,c_use_64bit=true,c_aux_clk_rate=125.0,c_eth_data_width=8,c_is_master=true,c_line_rate=6,c_ref_clk_speed=2,c_ins_loss_nyq0=14,c_ins_loss_nyq1=20,c_ins_loss_nyq2=25,c_eq_mode0=0,c_eq_mode1=0,c_eq_mode2=0,c_cdc_fifo_depth=Standard,c_cdc_is_extended=0,c_use_0_6144g=false,c_use_1_2288g=false,c_use_2_4576g=false,c_use_3_072g=false,c_use_4_9152g=false,c_use_6_144g=false,c_use_8_11008g=false,c_use_9_8304g=false,c_use_10_1376g=true,c_use_12_16512g=false,c_use_24_33024g=true,c_sub_core_name=xCORE_CPRI_RUn77_REC_gt,c_use_ethernet=true,c_bypass_buffer=false,c_use_gmii=true,c_use_ori=false,c_r21_timer=true,c_axi_ipif=true,c_free_running_rx_reference=false,rtl_simulation=false,c_supportlevel=1,c_transceivercontrol=false,c_gth_transceiver=false,c_gt_type=3,c_ver_gt_type=GTYE4,c_silicon_revision=1,c_rt_vendor_support=false,c_gt_loc=X0Y4,c_refclk_loc=clk0,c_qpll_sel=QPLL0,c_cmac_location=CMACE4_X0Y0,c_use_fec=true,c_use_hard_fec=false,c_agnostic_mode=false,c_sim_speed_switching=false,c_hard_fec_wrapper=false,c_freerun_clk_rate=15.36,c_use_cpll_at_9g=true,IP_IS_VERSAL=false,x_ipLicense=cpri@2019.10(bought),x_ipLicense=fc32_rs_fec@2016.10(bought)}";

  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF wrapper: ARCHITECTURE IS "cpri_v8_11_14,Vivado 2022.2.1";


begin  -- cpri_block wrapper
  U0 : xCORE_CPRI_RUn77_REC_support
  port map (
    reset                   => reset,

    -- I/Q interface
    iq_tx_enable            => iq_tx_enable,
    basic_frame_first_word  => basic_frame_first_word,
    iq_tx                   => iq_tx,
    iq_rx                   => iq_rx,

    -- GT Common Ports
    qpll0clk_out            => qpll0clk_out,
    qpll0refclk_out         => qpll0refclk_out,
    qpll1clk_out            => qpll1clk_out,
    qpll1refclk_out         => qpll1refclk_out,
    qpll0lock_out           => qpll0lock_out,
    qpll1lock_out           => qpll1lock_out,

    -- Vendor Specific Data
    vendor_tx_data          => vendor_tx_data,
    vendor_tx_xs            => vendor_tx_xs,
    vendor_tx_ns            => vendor_tx_ns,
    vendor_rx_data          => vendor_rx_data,
    vendor_rx_xs            => vendor_rx_xs,
    vendor_rx_ns            => vendor_rx_ns,
    vs_negotiation_complete => vs_negotiation_complete,

    -- Synchronization
    nodebfn_tx_strobe       => nodebfn_tx_strobe,
    nodebfn_tx_nr           => nodebfn_tx_nr,
    nodebfn_rx_strobe       => nodebfn_rx_strobe,
    nodebfn_rx_nr           => nodebfn_rx_nr,

    -- Ethernet interface
    eth_txd                 => eth_txd,
    eth_tx_er               => eth_tx_er,
    eth_tx_en               => eth_tx_en,
    eth_col                 => eth_col,
    eth_crs                 => eth_crs,
    eth_rxd                 => eth_rxd,
    eth_rx_er               => eth_rx_er,
    eth_rx_dv               => eth_rx_dv,
    eth_rx_avail            => eth_rx_avail,
    eth_rx_ready            => eth_rx_ready,
    rx_fifo_almost_full     => rx_fifo_almost_full,
    rx_fifo_full            => rx_fifo_full,
    eth_tx_clk              => eth_tx_clk,
    eth_rx_clk              => eth_rx_clk,

    -- HDLC interface
    hdlc_rx_data            => hdlc_rx_data,
    hdlc_tx_data            => hdlc_tx_data,
    hdlc_rx_data_valid      => hdlc_rx_data_valid,
    hdlc_tx_enable          => hdlc_tx_enable,

    -- Status interface
    stat_alarm              => stat_alarm,
    stat_code               => stat_code,
    stat_speed              => stat_speed,
    reset_request_in        => reset_request_in,
    sdi_request_in          => sdi_request_in,
    reset_acknowledge_out   => reset_acknowledge_out,
    sdi_request_out         => sdi_request_out,
    local_los               => local_los,
    local_lof               => local_lof,
    local_rai               => local_rai,
    remote_los              => remote_los,
    remote_lof              => remote_lof,
    remote_rai              => remote_rai,
    fifo_transit_time       => fifo_transit_time,
    coarse_timer_value      => coarse_timer_value,
    barrel_shift_value      => barrel_shift_value,
    tx_gb_latency_value     => tx_gb_latency_value,
    rx_gb_latency_value     => rx_gb_latency_value,
    stat_rx_delay_value     => stat_rx_delay_value,
    hyperframe_number       => hyperframe_number,

    -- AXI-Lite Interface
    -----------------
    s_axi_aclk              => s_axi_aclk,
    s_axi_aresetn           => s_axi_aresetn,
    s_axi_awaddr            => s_axi_awaddr,
    s_axi_awvalid           => s_axi_awvalid,
    s_axi_awready           => s_axi_awready,
    s_axi_wdata             => s_axi_wdata,
    s_axi_wvalid            => s_axi_wvalid,
    s_axi_wready            => s_axi_wready,
    s_axi_bresp             => s_axi_bresp,
    s_axi_bvalid            => s_axi_bvalid,
    s_axi_bready            => s_axi_bready,
    s_axi_araddr            => s_axi_araddr,
    s_axi_arvalid           => s_axi_arvalid,
    s_axi_arready           => s_axi_arready,
    s_axi_rdata             => s_axi_rdata,
    s_axi_rresp             => s_axi_rresp,
    s_axi_rvalid            => s_axi_rvalid,
    s_axi_rready            => s_axi_rready,
    l1_timer_expired        => l1_timer_expired,

    -- Transceiver interface
    txp                     => txp,
    txn                     => txn,
    rxp                     => rxp,
    rxn                     => rxn,
    lossoflight             => lossoflight,
    txinhibit               => txinhibit,

    -- Clocks
    refclk                  => refclk,
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
    hires_clk               => hires_clk,
    hires_clk_ok            => hires_clk_ok,
    qpll_select             => qpll_select,
    core_is_master          => core_is_master,
    recclk_ok               => recclk_ok,
    recclk                  => recclk,
    clk_out                 => clk_out,
    clk_ok_out              => clk_ok_out,
    rxrecclkout             => rxrecclkout,
    txusrclk_out            => txusrclk_out,
    txphaligndone_in        => txphaligndone_in,
    txdlysresetdone_in      => txdlysresetdone_in,
    txphinitdone_in         => txphinitdone_in,
    txphinit_out            => txphinit_out,
    phase_alignment_done_out => phase_alignment_done_out,
    txdlysreset_out         => txdlysreset_out,
    txphalign_out           => txphalign_out,
    txdlyen_out             => txdlyen_out);

end wrapper;
