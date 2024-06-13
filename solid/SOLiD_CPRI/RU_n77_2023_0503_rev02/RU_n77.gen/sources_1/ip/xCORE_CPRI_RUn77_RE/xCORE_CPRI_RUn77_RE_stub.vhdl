-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
-- Date        : Mon Feb  6 23:18:48 2023
-- Host        : SUPERK2-PC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/K2_Project/UQ_DAS/RU_n77/RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/xCORE_CPRI_RUn77_RE_stub.vhdl
-- Design      : xCORE_CPRI_RUn77_RE
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu11eg-ffvc1760-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xCORE_CPRI_RUn77_RE is
  Port ( 
    reset : in STD_LOGIC;
    iq_tx_enable : out STD_LOGIC;
    basic_frame_first_word : out STD_LOGIC;
    iq_tx : in STD_LOGIC_VECTOR ( 63 downto 0 );
    iq_rx : out STD_LOGIC_VECTOR ( 63 downto 0 );
    qpll0clk_out : out STD_LOGIC;
    qpll0refclk_out : out STD_LOGIC;
    qpll1clk_out : out STD_LOGIC;
    qpll1refclk_out : out STD_LOGIC;
    qpll0lock_out : out STD_LOGIC;
    qpll1lock_out : out STD_LOGIC;
    vendor_tx_data : in STD_LOGIC_VECTOR ( 127 downto 0 );
    vendor_tx_xs : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vendor_tx_ns : out STD_LOGIC_VECTOR ( 5 downto 0 );
    vendor_rx_data : out STD_LOGIC_VECTOR ( 127 downto 0 );
    vendor_rx_xs : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vendor_rx_ns : out STD_LOGIC_VECTOR ( 5 downto 0 );
    vs_negotiation_complete : in STD_LOGIC;
    nodebfn_tx_strobe : in STD_LOGIC;
    nodebfn_tx_nr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    nodebfn_rx_strobe : out STD_LOGIC;
    nodebfn_rx_nr : out STD_LOGIC_VECTOR ( 11 downto 0 );
    eth_txd : in STD_LOGIC_VECTOR ( 7 downto 0 );
    eth_tx_er : in STD_LOGIC;
    eth_tx_en : in STD_LOGIC;
    eth_col : out STD_LOGIC;
    eth_crs : out STD_LOGIC;
    eth_rxd : out STD_LOGIC_VECTOR ( 7 downto 0 );
    eth_rx_er : out STD_LOGIC;
    eth_rx_dv : out STD_LOGIC;
    eth_rx_avail : out STD_LOGIC;
    eth_rx_ready : in STD_LOGIC;
    rx_fifo_almost_full : out STD_LOGIC;
    rx_fifo_full : out STD_LOGIC;
    eth_tx_clk : in STD_LOGIC;
    eth_rx_clk : in STD_LOGIC;
    hdlc_rx_data : out STD_LOGIC;
    hdlc_tx_data : in STD_LOGIC;
    hdlc_rx_data_valid : out STD_LOGIC;
    hdlc_tx_enable : out STD_LOGIC;
    stat_alarm : out STD_LOGIC;
    stat_code : out STD_LOGIC_VECTOR ( 3 downto 0 );
    stat_speed : out STD_LOGIC_VECTOR ( 14 downto 0 );
    reset_acknowledge_in : in STD_LOGIC;
    sdi_request_in : in STD_LOGIC;
    reset_request_out : out STD_LOGIC;
    sdi_request_out : out STD_LOGIC;
    local_los : out STD_LOGIC;
    local_lof : out STD_LOGIC;
    local_rai : out STD_LOGIC;
    remote_los : out STD_LOGIC;
    remote_lof : out STD_LOGIC;
    remote_rai : out STD_LOGIC;
    fifo_transit_time : out STD_LOGIC_VECTOR ( 13 downto 0 );
    coarse_timer_value : out STD_LOGIC_VECTOR ( 17 downto 0 );
    barrel_shift_value : out STD_LOGIC_VECTOR ( 6 downto 0 );
    tx_gb_latency_value : out STD_LOGIC_VECTOR ( 15 downto 0 );
    rx_gb_latency_value : out STD_LOGIC_VECTOR ( 15 downto 0 );
    stat_rx_delay_value : out STD_LOGIC_VECTOR ( 6 downto 0 );
    hyperframe_number : out STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    l1_timer_expired : in STD_LOGIC;
    txp : out STD_LOGIC;
    txn : out STD_LOGIC;
    rxp : in STD_LOGIC;
    rxn : in STD_LOGIC;
    lossoflight : in STD_LOGIC;
    txinhibit : out STD_LOGIC;
    refclk : in STD_LOGIC;
    gtwiz_reset_clk_freerun_in : in STD_LOGIC;
    hires_clk : in STD_LOGIC;
    hires_clk_ok : in STD_LOGIC;
    qpll_select : in STD_LOGIC;
    recclk_ok : out STD_LOGIC;
    recclk : out STD_LOGIC;
    clk_out : out STD_LOGIC;
    clk_ok_out : out STD_LOGIC;
    rxrecclkout : out STD_LOGIC;
    txusrclk_out : out STD_LOGIC;
    txphaligndone_in : in STD_LOGIC_VECTOR ( 2 downto 0 );
    txdlysresetdone_in : in STD_LOGIC_VECTOR ( 2 downto 0 );
    txphinitdone_in : in STD_LOGIC_VECTOR ( 2 downto 0 );
    txphinit_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
    phase_alignment_done_out : out STD_LOGIC;
    txdlysreset_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
    txphalign_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
    txdlyen_out : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end xCORE_CPRI_RUn77_RE;

architecture stub of xCORE_CPRI_RUn77_RE is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "reset,iq_tx_enable,basic_frame_first_word,iq_tx[63:0],iq_rx[63:0],qpll0clk_out,qpll0refclk_out,qpll1clk_out,qpll1refclk_out,qpll0lock_out,qpll1lock_out,vendor_tx_data[127:0],vendor_tx_xs[1:0],vendor_tx_ns[5:0],vendor_rx_data[127:0],vendor_rx_xs[1:0],vendor_rx_ns[5:0],vs_negotiation_complete,nodebfn_tx_strobe,nodebfn_tx_nr[11:0],nodebfn_rx_strobe,nodebfn_rx_nr[11:0],eth_txd[7:0],eth_tx_er,eth_tx_en,eth_col,eth_crs,eth_rxd[7:0],eth_rx_er,eth_rx_dv,eth_rx_avail,eth_rx_ready,rx_fifo_almost_full,rx_fifo_full,eth_tx_clk,eth_rx_clk,hdlc_rx_data,hdlc_tx_data,hdlc_rx_data_valid,hdlc_tx_enable,stat_alarm,stat_code[3:0],stat_speed[14:0],reset_acknowledge_in,sdi_request_in,reset_request_out,sdi_request_out,local_los,local_lof,local_rai,remote_los,remote_lof,remote_rai,fifo_transit_time[13:0],coarse_timer_value[17:0],barrel_shift_value[6:0],tx_gb_latency_value[15:0],rx_gb_latency_value[15:0],stat_rx_delay_value[6:0],hyperframe_number[7:0],s_axi_aclk,s_axi_aresetn,s_axi_awaddr[11:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[11:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,l1_timer_expired,txp,txn,rxp,rxn,lossoflight,txinhibit,refclk,gtwiz_reset_clk_freerun_in,hires_clk,hires_clk_ok,qpll_select,recclk_ok,recclk,clk_out,clk_ok_out,rxrecclkout,txusrclk_out,txphaligndone_in[2:0],txdlysresetdone_in[2:0],txphinitdone_in[2:0],txphinit_out[2:0],phase_alignment_done_out,txdlysreset_out[2:0],txphalign_out[2:0],txdlyen_out[2:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "cpri_v8_11_14,Vivado 2022.2.1";
begin
end;
