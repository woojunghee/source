-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
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
-- 
-- DO NOT MODIFY THIS FILE.
-- IP VLNV: xilinx.com:ip:cpri:8.11
-- IP Revision: 14

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT xCORE_CPRI_RUn77_RE
  PORT (
    iq_tx_enable : OUT STD_LOGIC;
    iq_tx : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    iq_rx : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    basic_frame_first_word : OUT STD_LOGIC;
    vendor_tx_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    vendor_tx_xs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vendor_tx_ns : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    vendor_rx_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    vendor_rx_xs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vendor_rx_ns : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    nodebfn_tx_strobe : IN STD_LOGIC;
    nodebfn_tx_nr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    nodebfn_rx_strobe : OUT STD_LOGIC;
    nodebfn_rx_nr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    eth_tx_clk : IN STD_LOGIC;
    eth_txd : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    eth_tx_er : IN STD_LOGIC;
    eth_tx_en : IN STD_LOGIC;
    eth_col : OUT STD_LOGIC;
    eth_crs : OUT STD_LOGIC;
    eth_rx_clk : IN STD_LOGIC;
    eth_rxd : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    eth_rx_er : OUT STD_LOGIC;
    eth_rx_dv : OUT STD_LOGIC;
    eth_rx_avail : OUT STD_LOGIC;
    eth_rx_ready : IN STD_LOGIC;
    rx_fifo_almost_full : OUT STD_LOGIC;
    rx_fifo_full : OUT STD_LOGIC;
    hdlc_rx_data : OUT STD_LOGIC;
    hdlc_tx_data : IN STD_LOGIC;
    hdlc_rx_data_valid : OUT STD_LOGIC;
    hdlc_tx_enable : OUT STD_LOGIC;
    stat_alarm : OUT STD_LOGIC;
    stat_code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    txp : OUT STD_LOGIC;
    txn : OUT STD_LOGIC;
    rxp : IN STD_LOGIC;
    rxn : IN STD_LOGIC;
    lossoflight : IN STD_LOGIC;
    txinhibit : OUT STD_LOGIC;
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    l1_timer_expired : IN STD_LOGIC;
    vs_negotiation_complete : IN STD_LOGIC;
    reset_acknowledge_in : IN STD_LOGIC;
    sdi_request_in : IN STD_LOGIC;
    reset_request_out : OUT STD_LOGIC;
    sdi_request_out : OUT STD_LOGIC;
    local_los : OUT STD_LOGIC;
    local_lof : OUT STD_LOGIC;
    local_rai : OUT STD_LOGIC;
    remote_los : OUT STD_LOGIC;
    remote_lof : OUT STD_LOGIC;
    remote_rai : OUT STD_LOGIC;
    fifo_transit_time : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
    coarse_timer_value : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    barrel_shift_value : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    tx_gb_latency_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rx_gb_latency_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    stat_rx_delay_value : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    hyperframe_number : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    txusrclk_out : OUT STD_LOGIC;
    stat_speed : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    qpll_select : IN STD_LOGIC;
    recclk : OUT STD_LOGIC;
    recclk_ok : OUT STD_LOGIC;
    clk_out : OUT STD_LOGIC;
    clk_ok_out : OUT STD_LOGIC;
    hires_clk : IN STD_LOGIC;
    hires_clk_ok : IN STD_LOGIC;
    gtwiz_reset_clk_freerun_in : IN STD_LOGIC;
    refclk : IN STD_LOGIC;
    qpll0clk_out : OUT STD_LOGIC;
    qpll0refclk_out : OUT STD_LOGIC;
    qpll0lock_out : OUT STD_LOGIC;
    qpll1clk_out : OUT STD_LOGIC;
    qpll1refclk_out : OUT STD_LOGIC;
    qpll1lock_out : OUT STD_LOGIC;
    rxrecclkout : OUT STD_LOGIC;
    txphinit_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    phase_alignment_done_out : OUT STD_LOGIC;
    txdlysreset_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    txphalign_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    txdlyen_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    txphaligndone_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    txdlysresetdone_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    txphinitdone_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    reset : IN STD_LOGIC 
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : xCORE_CPRI_RUn77_RE
  PORT MAP (
    iq_tx_enable => iq_tx_enable,
    iq_tx => iq_tx,
    iq_rx => iq_rx,
    basic_frame_first_word => basic_frame_first_word,
    vendor_tx_data => vendor_tx_data,
    vendor_tx_xs => vendor_tx_xs,
    vendor_tx_ns => vendor_tx_ns,
    vendor_rx_data => vendor_rx_data,
    vendor_rx_xs => vendor_rx_xs,
    vendor_rx_ns => vendor_rx_ns,
    nodebfn_tx_strobe => nodebfn_tx_strobe,
    nodebfn_tx_nr => nodebfn_tx_nr,
    nodebfn_rx_strobe => nodebfn_rx_strobe,
    nodebfn_rx_nr => nodebfn_rx_nr,
    eth_tx_clk => eth_tx_clk,
    eth_txd => eth_txd,
    eth_tx_er => eth_tx_er,
    eth_tx_en => eth_tx_en,
    eth_col => eth_col,
    eth_crs => eth_crs,
    eth_rx_clk => eth_rx_clk,
    eth_rxd => eth_rxd,
    eth_rx_er => eth_rx_er,
    eth_rx_dv => eth_rx_dv,
    eth_rx_avail => eth_rx_avail,
    eth_rx_ready => eth_rx_ready,
    rx_fifo_almost_full => rx_fifo_almost_full,
    rx_fifo_full => rx_fifo_full,
    hdlc_rx_data => hdlc_rx_data,
    hdlc_tx_data => hdlc_tx_data,
    hdlc_rx_data_valid => hdlc_rx_data_valid,
    hdlc_tx_enable => hdlc_tx_enable,
    stat_alarm => stat_alarm,
    stat_code => stat_code,
    txp => txp,
    txn => txn,
    rxp => rxp,
    rxn => rxn,
    lossoflight => lossoflight,
    txinhibit => txinhibit,
    s_axi_aclk => s_axi_aclk,
    s_axi_aresetn => s_axi_aresetn,
    s_axi_awaddr => s_axi_awaddr,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awready => s_axi_awready,
    s_axi_wdata => s_axi_wdata,
    s_axi_wvalid => s_axi_wvalid,
    s_axi_wready => s_axi_wready,
    s_axi_bresp => s_axi_bresp,
    s_axi_bvalid => s_axi_bvalid,
    s_axi_bready => s_axi_bready,
    s_axi_araddr => s_axi_araddr,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arready => s_axi_arready,
    s_axi_rdata => s_axi_rdata,
    s_axi_rresp => s_axi_rresp,
    s_axi_rvalid => s_axi_rvalid,
    s_axi_rready => s_axi_rready,
    l1_timer_expired => l1_timer_expired,
    vs_negotiation_complete => vs_negotiation_complete,
    reset_acknowledge_in => reset_acknowledge_in,
    sdi_request_in => sdi_request_in,
    reset_request_out => reset_request_out,
    sdi_request_out => sdi_request_out,
    local_los => local_los,
    local_lof => local_lof,
    local_rai => local_rai,
    remote_los => remote_los,
    remote_lof => remote_lof,
    remote_rai => remote_rai,
    fifo_transit_time => fifo_transit_time,
    coarse_timer_value => coarse_timer_value,
    barrel_shift_value => barrel_shift_value,
    tx_gb_latency_value => tx_gb_latency_value,
    rx_gb_latency_value => rx_gb_latency_value,
    stat_rx_delay_value => stat_rx_delay_value,
    hyperframe_number => hyperframe_number,
    txusrclk_out => txusrclk_out,
    stat_speed => stat_speed,
    qpll_select => qpll_select,
    recclk => recclk,
    recclk_ok => recclk_ok,
    clk_out => clk_out,
    clk_ok_out => clk_ok_out,
    hires_clk => hires_clk,
    hires_clk_ok => hires_clk_ok,
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
    refclk => refclk,
    qpll0clk_out => qpll0clk_out,
    qpll0refclk_out => qpll0refclk_out,
    qpll0lock_out => qpll0lock_out,
    qpll1clk_out => qpll1clk_out,
    qpll1refclk_out => qpll1refclk_out,
    qpll1lock_out => qpll1lock_out,
    rxrecclkout => rxrecclkout,
    txphinit_out => txphinit_out,
    phase_alignment_done_out => phase_alignment_done_out,
    txdlysreset_out => txdlysreset_out,
    txphalign_out => txphalign_out,
    txdlyen_out => txdlyen_out,
    txphaligndone_in => txphaligndone_in,
    txdlysresetdone_in => txdlysresetdone_in,
    txphinitdone_in => txphinitdone_in,
    reset => reset
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file xCORE_CPRI_RUn77_RE.vhd when simulating
-- the core, xCORE_CPRI_RUn77_RE. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.



