library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
library cpri_v8_11_13;
use cpri_v8_11_13.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;


entity cpri_4path is port (
    reset                      : in  std_logic; -- Asynchronous reset
    iq_tx_enable               : out std_logic_vector(CPRI_NUM downto 0);
    basic_frame_first_word     : out std_logic_vector(CPRI_NUM downto 0);
    iq_tx                      : in  arr_cpri_64_stdlogic;
    iq_rx                      : out arr_cpri_64_stdlogic;
    s_axi_aclk                 : in  std_logic;
    s_axi_aresetn              : in  std_logic;
    s_axi_awaddr               : in  arr_cpri_12_stdlogic;
    s_axi_awvalid              : in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_awready              : out std_logic_vector(CPRI_NUM downto 0);
    s_axi_wdata                : in  arr_cpri_32_stdlogic;
    s_axi_wvalid               : in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_wready               : out std_logic_vector(CPRI_NUM downto 0);
    s_axi_bresp                : out arr_cpri_2_stdlogic;
    s_axi_rresp                : out arr_cpri_2_stdlogic;
    s_axi_bvalid               : out std_logic_vector(CPRI_NUM downto 0);
    s_axi_bready               : in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_araddr               : in  arr_cpri_12_stdlogic;
    s_axi_arvalid              : in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_arready              : out std_logic_vector(CPRI_NUM downto 0);
    s_axi_rdata                : out arr_cpri_32_stdlogic;
    s_axi_rvalid               : out std_logic_vector(CPRI_NUM downto 0);
    s_axi_rready               : in  std_logic_vector(CPRI_NUM downto 0);
    txp                        : out std_logic_vector(CPRI_NUM downto 0);
    txn                        : out std_logic_vector(CPRI_NUM downto 0);
    rxp                        : in  std_logic_vector(CPRI_NUM downto 0);
    rxn                        : in  std_logic_vector(CPRI_NUM downto 0);
    sfp_los                    : in  std_logic_vector(CPRI_NUM downto 0);
    txinhibit                  : out std_logic_vector(CPRI_NUM downto 0);
    clk_368p64                 : in  std_logic;
    clk_294p912                : in  std_logic;
    clk_7p68                   : in  std_logic;
    hires_clk                  : in  std_logic;
    cpri_mmcm_locked           : in  std_logic;
    hires_clk_ok               : in  std_logic;
    refclk                     : in  std_logic;
    clk_100m                   : in  std_logic;
    clk_125m                   : in  std_logic;
    clk_25m                    : in  std_logic;
    clk_12p5m                  : in  std_logic;
    eth_gap                    : in  std_logic_vector(11 downto 0);
    eth_tx_en                  : in  std_logic;
    eth_txd                    : in  std_logic_vector(7 downto 0);
    eth_rx_dv                  : out std_logic;
    eth_rxd                    : out std_logic_vector(7 downto 0);
    mapper_reset               : out std_logic_vector(CPRI_NUM downto 0);
    recclk_out                 : out std_logic;
    qpll_lock_out              : out std_logic;
    cpri_linkup                : out std_logic_vector(CPRI_NUM downto 0);
    local_los                  : out std_logic_vector(CPRI_NUM downto 0);
    local_lof                  : out std_logic_vector(CPRI_NUM downto 0);
    gt_rxpcs_rst               : in  std_logic_vector(CPRI_NUM downto 0);
    gt_txpcs_rst               : in  std_logic_vector(CPRI_NUM downto 0);
    gt_rxpma_rst               : in  std_logic_vector(CPRI_NUM downto 0);
    gt_txpma_rst               : in  std_logic_vector(CPRI_NUM downto 0);
    gt_txresetdone             : out std_logic_vector(CPRI_NUM downto 0);
    gt_rxresetdone             : out std_logic_vector(CPRI_NUM downto 0);
    gt_rxlpmen                 : in  std_logic_vector(CPRI_NUM downto 0);
    gt_txdiffctrl              : in  arr_cpri_5_stdlogic;
    -- vs
    mu_id                      : out arr_2_4_stdlogic;
    mu_port_num                : out arr_2_4_stdlogic;
    hu_port_num                : out arr_2_4_stdlogic;
    cascade_num                : out arr_2_4_stdlogic;
    du_type                    : out std_logic_vector(1 downto 0);
    module_type                : out arr_2_2_stdlogic;
    op_id0                     : out arr_2_2_stdlogic;
    op_id1                     : out arr_2_2_stdlogic;
    band_id                    : out std_logic_vector(1 downto 0);
    dly_ctrl                   : out arr_2_8_stdlogic;
    core_is_master             : in  std_logic_vector(CPRI_NUM downto 0);
    l1_reset                   : out std_logic
    );
end cpri_4path;


architecture rtl of cpri_4path is

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  signal all_clk_locked           : std_logic;

  signal txoutclk_i               : std_logic_vector(CPRI_NUM downto 0);
  signal txresetdone_i            : std_logic_vector(CPRI_NUM downto 0);
  signal clk_ok_i                 : std_logic_vector(CPRI_NUM downto 0);
  signal pll_reset                : std_logic;
  signal mmcm_rst                 : std_logic_vector(CPRI_NUM downto 0);
  signal stat_speed_i             : arr_cpri_15_stdlogic;
  signal rxoutclk_i               : std_logic_vector(CPRI_NUM downto 0);
  signal rec_clk_i                : std_logic_vector(CPRI_NUM downto 0);
  signal gtreset_sm_done          : std_logic_vector(CPRI_NUM downto 0);
  signal reset_phalignment        : std_logic;
  signal phase_alignment_done     : std_logic;
  signal phase_alignment_done_int : std_logic;
  signal userclk_tx_reset         : std_logic_vector(CPRI_NUM downto 0);
  signal userclk_rx_reset         : std_logic_vector(CPRI_NUM downto 0);
  signal vs_tx_0_16_0             : arr_cpri_32_stdlogic;
  signal vs_tx_0_16_1             : arr_cpri_32_stdlogic;
  signal vs_tx_0_16_2             : arr_cpri_32_stdlogic;
  signal vs_tx_0_16_3             : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_0             : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_1             : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_2             : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_3             : arr_cpri_32_stdlogic;

  signal vs_rx_0_16_0_s           : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_1_s           : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_2_s           : arr_cpri_32_stdlogic;
  signal vs_rx_0_16_3_s           : arr_cpri_32_stdlogic;

  signal core_clk_i               : std_logic;
  signal vendor_tx_data           : arr_cpri_128_stdlogic;
  signal vendor_tx_xs             : arr_cpri_2_stdlogic;
  signal vendor_tx_ns             : arr_cpri_6_stdlogic;
  signal vendor_rx_data           : arr_cpri_128_stdlogic;
  signal vendor_rx_xs             : arr_cpri_2_stdlogic;
  signal vendor_rx_ns             : arr_cpri_6_stdlogic;
  signal common_qpll0clk          : std_logic;
  signal common_qpll0refclk       : std_logic;
  signal common_qpll0lock         : std_logic;
  signal common_qpll0_pd          : std_logic_vector(CPRI_NUM downto 0);
  signal common_qpll1clk          : std_logic;
  signal common_qpll1refclk       : std_logic;
  signal common_qpll1lock         : std_logic;
  signal common_qpll1_pd          : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_tx_strobe_t      : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_tx_strobe        : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_tx_nr            : arr_cpri_12_stdlogic;
  signal nodebfn_tx_nr_i          : arr_cpri_12_stdlogic;
  signal nodebfn_rx_nr            : arr_cpri_12_stdlogic;
  signal tx_axis_eth_tdata        : arr_cpri_8_stdlogic;
  signal tx_axis_eth_tvalid       : std_logic_vector(CPRI_NUM downto 0);
  signal tx_axis_eth_tlast        : std_logic_vector(CPRI_NUM downto 0);
  signal tx_axis_eth_tuser        : std_logic_vector(CPRI_NUM downto 0);
  signal tx_axis_eth_tready       : std_logic_vector(CPRI_NUM downto 0);
  signal rx_axis_eth_tdata        : arr_cpri_8_stdlogic;
  signal rx_axis_eth_tvalid       : std_logic_vector(CPRI_NUM downto 0);
  signal rx_axis_eth_tuser        : std_logic_vector(CPRI_NUM downto 0);
  signal rx_axis_eth_tlast        : std_logic_vector(CPRI_NUM downto 0);
  signal stat_code                : arr_cpri_4_stdlogic;
  signal txphaligndone_in         : std_logic_vector(2 downto 0);
  signal txdlysresetdone_in       : std_logic_vector(2 downto 0);
  signal txphinitdone_in          : std_logic_vector(2 downto 0);
  signal txphalign_out            : std_logic_vector(2 downto 0);
  signal txdlysreset_out          : std_logic_vector(2 downto 0);
  signal txphinit_out             : std_logic_vector(2 downto 0);
  signal txdlysresetdone          : std_logic_vector(CPRI_NUM downto 0);
  signal txphaligndone_vec        : std_logic_vector(3 downto 0);
  signal txdlysresetdone_vec      : std_logic_vector(3 downto 0);
  signal txphinit_vec             : std_logic_vector(3 downto 0);
  signal txdlysreset_vec          : std_logic_vector(3 downto 0);
  signal txphalign_vec            : std_logic_vector(3 downto 0);
  signal txphinitdone_vec         : std_logic_vector(3 downto 0);
  signal txphaligndone            : std_logic_vector(CPRI_NUM downto 0);
  signal txphinitdone_out         : std_logic_vector(CPRI_NUM downto 0);
  signal txdlyen_vec              : std_logic_vector(3 downto 0);
  signal resetn                   : std_logic_vector(CPRI_NUM downto 0);
  signal ru_id_flag_1d            : std_logic_vector(CPRI_NUM downto 0);
  signal dl_m0_dc_cancel_on_1d    : arr_cpri_5_stdlogic;
  signal dl_m1_dc_cancel_on_1d    : arr_cpri_5_stdlogic;
  signal recclk_ok                : std_logic_vector(CPRI_NUM downto 0);
  signal rxrecclkout              : std_logic_vector(CPRI_NUM downto 0);
  signal hyperframe_number        : arr_cpri_8_stdlogic;

  signal reset_s                  : std_logic;
  signal reset_n                  : std_logic;

  signal txusrclk                 : std_logic_vector(CPRI_NUM downto 0);
--  signal core_is_master           : std_logic_vector(CPRI_NUM downto 0);

  signal eth_rx_dv_t              : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_rx_strobe        : std_logic_vector(CPRI_NUM downto 0);


  signal tx_axis_eth_tdata_i      : arr_cpri_8_stdlogic;
  signal tx_axis_eth_tvalid_i     : std_logic_vector(CPRI_NUM downto 0);
  signal tx_axis_eth_tlast_i      : std_logic_vector(CPRI_NUM downto 0);
  signal tx_axis_eth_tuser_i      : std_logic_vector(CPRI_NUM downto 0);

  signal bfn_strobe0              : std_logic_vector(192 downto 0);
  signal bfn_strobe1              : std_logic_vector(192 downto 0);

  signal local_los_buf            : std_logic_vector(CPRI_NUM downto 0);
  signal local_lof_buf            : std_logic_vector(CPRI_NUM downto 0);
  signal gt_reset                 : std_logic_vector(CPRI_NUM downto 0);

  signal bffw                     : std_logic_vector(CPRI_NUM downto 0);
  signal iq_tx_en                 : std_logic_vector(CPRI_NUM downto 0);

  signal ru_l1_rst_s0             : std_logic_vector(15 downto 0);
  signal ru_l1_rst_s1             : std_logic_vector(15 downto 0);

  signal cpri_rst                 : std_logic_vector(CPRI_NUM downto 0);

  signal rx_rsfec_enable          : std_logic_vector(CPRI_NUM downto 0);
  signal rx_rec_clk               : std_logic_vector(CPRI_NUM downto 0);
  signal rx_serdes_data           : arr_cpri_64_stdlogic;
  signal rx_serdes_head           : arr_cpri_2_stdlogic;
  signal rx_gbx_slip              : std_logic_vector(CPRI_NUM downto 0);
  signal cdc_reset                : std_logic_vector(CPRI_NUM downto 0);
  signal fifo_fill_level          : arr_cpri_9_stdlogic;
  signal average                  : arr_cpri_17_stdlogic;
  signal average_rdy              : std_logic_vector(CPRI_NUM downto 0);
  signal average_ack              : std_logic_vector(CPRI_NUM downto 0);
  signal fifo_error               : std_logic_vector(CPRI_NUM downto 0);
  signal cdc_rxdata               : arr_cpri_64_stdlogic;
  signal cdc_rxheader             : arr_cpri_2_stdlogic;
  signal pcs_rxdata               : arr_cpri_64_stdlogic;
  signal pcs_rxheader             : arr_cpri_2_stdlogic;
  signal pcs_rxheadervalid        : std_logic_vector(CPRI_NUM downto 0);
  signal stat_rx_align_status     : std_logic_vector(CPRI_NUM downto 0);
  signal stat_cw_inc              : std_logic_vector(CPRI_NUM downto 0);
  signal stat_corrected_cw_inc    : std_logic_vector(CPRI_NUM downto 0);
  signal stat_uncorrected_cw_inc  : std_logic_vector(CPRI_NUM downto 0);
  signal hfec_fifo_latency        : arr_cpri_16_stdlogic;
  signal hfec_fifo_latency_rdy    : std_logic_vector(CPRI_NUM downto 0);
  signal hfec_fifo_latency_ack    : std_logic_vector(CPRI_NUM downto 0);

  signal link_up                  : std_logic_vector(CPRI_NUM downto 0);
  signal link_up_s0               : std_logic_vector(CPRI_NUM downto 0);
  signal link_up_core             : std_logic_vector(CPRI_NUM downto 0);

  signal stat_alarm               : std_logic_vector(CPRI_NUM downto 0);

  signal tx_cpu_eth_tready        : std_logic;
  signal tx_cpu_eth_tdata         : std_logic_vector(7 downto 0);
  signal tx_cpu_eth_tvalid        : std_logic;
  signal tx_cpu_eth_tlast         : std_logic;

  signal rx_cpu_eth_tready        : std_logic;
  signal rx_cpu_eth_tdata         : std_logic_vector(7 downto 0);
  signal rx_cpu_eth_tvalid        : std_logic;
  signal rx_cpu_eth_tlast         : std_logic;

  signal tx_cas_eth_tdata         : std_logic_vector(7 downto 0);
  signal tx_cas_eth_tvalid        : std_logic;
  signal tx_cas_eth_tlast         : std_logic;
  signal tx_cas_eth_tready        : std_logic;

  signal rx_cas_eth_tready        : std_logic;
  signal rx_cas_eth_tdata         : std_logic_vector(7 downto 0);
  signal rx_cas_eth_tvalid        : std_logic;
  signal rx_cas_eth_tlast         : std_logic;

  signal tx_mux_eth_tdata         : std_logic_vector(7 downto 0);
  signal tx_mux_eth_tvalid        : std_logic;
  signal tx_mux_eth_tlast         : std_logic;
  signal tx_mux_eth_tready        : std_logic;

  signal rx_mux_eth_tdata         : std_logic_vector(7 downto 0);
  signal rx_mux_eth_tvalid        : std_logic;
  signal rx_mux_eth_tlast         : std_logic;
  signal rx_mux_eth_tready        : std_logic;

  signal eth_resetn               : std_logic_vector(CPRI_NUM downto 0);

  signal cnt_lock                 : arr_cpri_2_stdlogic;

  signal rx0_packet_cnt           : std_logic_vector(15 downto 0);
  signal rx1_packet_cnt           : std_logic_vector(15 downto 0);
  signal rx2_packet_cnt           : std_logic_vector(15 downto 0);
  signal tx0_packet_cnt           : std_logic_vector(15 downto 0);
  signal tx1_packet_cnt           : std_logic_vector(15 downto 0);
  signal tx2_packet_cnt           : std_logic_vector(15 downto 0);

  signal hu_br1                   : std_logic_vector(3 downto 0);
  signal hu_br2                   : std_logic_vector(3 downto 0);

  signal ru_br1                   : std_logic_vector(3 downto 0);
  signal ru_br2                   : std_logic_vector(3 downto 0);

  signal stat_speed               : std_logic_vector(14 downto 0);
  signal stat_speed_i_rec         : std_logic_vector(14 downto 0);
  signal src_send_clk             : std_logic;
  signal src_rcv_clk              : std_logic;
  signal src_send_rec             : std_logic;
  signal src_rcv_rec              : std_logic;
  signal recclkout_i              : std_logic;
  signal recclk                   : std_logic;
  signal count                    : integer range 0 to 31 := 0;
  signal master_lane              : std_logic;
  signal master_lane_s0           : std_logic;
  signal master_lane_cas          : std_logic;
  signal master_lane_cas_s0       : std_logic;
  signal reset_i                  : std_logic;

  signal eth_cnt_lock             : arr_cpri_2_stdlogic;
  signal eth_main_rst_n           : std_logic;
  signal eth_cas_rst_n            : std_logic;


  signal vs_rst                   : std_logic_vector(CPRI_NUM downto 0);

  signal g0_mu_id                 : std_logic_vector(3 downto 0);
  signal g0_mu_port_num           : std_logic_vector(3 downto 0);
  signal g0_hu_port_num           : std_logic_vector(3 downto 0);
  signal g0_cascade_num           : std_logic_vector(3 downto 0);
  signal g0_du_type               : std_logic;
  signal g0_module_type           : std_logic_vector(1 downto 0);
  signal g0_op_id0                : std_logic_vector(1 downto 0);
  signal g0_op_id1                : std_logic_vector(1 downto 0);
  signal g0_band_id               : std_logic;
  signal g0_dly_ctrl              : std_logic_vector(7 downto 0);
  signal g0_l1_reset              : std_logic;
  signal g1_mu_id                 : std_logic_vector(3 downto 0);
  signal g1_mu_port_num           : std_logic_vector(3 downto 0);
  signal g1_hu_port_num           : std_logic_vector(3 downto 0);
  signal g1_cascade_num           : std_logic_vector(3 downto 0);
  signal g1_du_type               : std_logic;
  signal g1_module_type           : std_logic_vector(1 downto 0);
  signal g1_op_id0                : std_logic_vector(1 downto 0);
  signal g1_op_id1                : std_logic_vector(1 downto 0);
  signal g1_band_id               : std_logic;
  signal g1_dly_ctrl              : std_logic_vector(7 downto 0);
  signal g1_l1_reset              : std_logic;

  signal ru_band_id               : std_logic := '1';
  signal ru_module_type           : std_logic_vector(1 downto 0) := "10";
  signal ru_cascade_num           : std_logic_vector(3 downto 0) := "0001";

  signal basic_frame_first_word_r : std_logic_vector(CPRI_NUM downto 0);
  signal bfn_tx_nr_slv            : arr_cpri_12_stdlogic;
  signal bfn_tx_strobe_slv        : std_logic_vector(CPRI_NUM downto 0);


begin


--core_is_master <= "1100";

reset_sync : entity work.cpri_24g_reset_synchronizer
  port map (
    reset_in  => reset,
    clk       => s_axi_aclk,
    reset_out => reset_s);

reset_n <= not reset_s;

local_los   <= local_los_buf;
local_lof   <= local_lof_buf;


-- CPRI_CORE_bank : for n IN 0 to CPRI_NUM generate
cpri_blk_0 : entity work.cpri_24g_0
    port map (
        -- Additional Debug Ports
        -- DRP Access
        gt_drpdaddr                => "00" & x"00"                , --: in  std_logic_vector(9 downto 0);
        gt_drpdi                   => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        gt_drpen                   => '0'                         , --: in  std_logic;
        gt_drpwe                   => '0'                         , --: in  std_logic;
        gt_drpdo                   => open                        , --: out std_logic_vector(15 downto 0);
        gt_drprdy                  => open                        , --: out std_logic;
        -- TX Reset and Initialization
        gt_txpmareset              => gt_txpma_rst(0)             , --: in  std_logic;
        gt_txpcsreset              => gt_txpcs_rst(0)             , --: in  std_logic;
        gt_txresetdone             => gt_txresetdone(0)           , --: out std_logic;
        -- RX Reset and Initialization
        gt_rxpmareset              => gt_rxpma_rst(0)             , --: in  std_logic;
        gt_rxpcsreset              => gt_rxpcs_rst(0)             , --: in  std_logic;
        gt_rxpmaresetdone          => open                        , --: out std_logic;
        gt_rxresetdone             => gt_rxresetdone(0)           , --: out std_logic;
        -- Clocking
        gt_txphaligndone           => open                        , --: out std_logic;
        gt_txphinitdone            => open                        , --: out std_logic;
        gt_txdlysresetdone         => open                        , --: out std_logic;
        gt_rxphaligndone           => open                        , --: out std_logic;
        gt_rxdlysresetdone         => open                        , --: out std_logic;
        gt_rxsyncdone              => open                        , --: out std_logic;
        gt_cplllock                => open                        , --: out std_logic;
        -- Signal Integrity and Functionality
        gt_rxrate                  => "000"                       , --: in  std_logic_vector(2 downto 0);
        gt_eyescantrigger          => '0'                         , --: in  std_logic;
        gt_eyescanreset            => '0'                         , --: in  std_logic;
        gt_eyescandataerror        => open                        , --: out std_logic;
        gt_rxpolarity              => '0'                         , --: in  std_logic;
        gt_txpolarity              => '0'                         , --: in  std_logic;
        gt_rxdfelpmreset           => '0'                         , --: in  std_logic;
        gt_rxlpmen                 => gt_rxlpmen(0)               , --: in  std_logic;
        gt_txprecursor             => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txpostcursor            => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txdiffctrl              => gt_txdiffctrl(0)            , --: in  std_logic_vector(4 downto 0);
        gt_txprbsforceerr          => '0'                         , --: in  std_logic;
        gt_txprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbserr               => open                        , --: out std_logic;
        gt_rxprbscntreset          => '0'                         , --: in  std_logic;
        gt_rxcdrhold               => '0'                         , --: in  std_logic;
        gt_dmonitorout             => open                        , --: out std_logic_vector(15 downto 0);
        gt_rxheader                => open                        , --: out std_logic_vector(1 downto 0);
        gt_rxheadervalid           => open                        , --: out std_logic;

        gt_rxdisperr               => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxnotintable            => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxcommadet              => open                        , --: out std_logic;
        gt_pcsrsvdin               => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        ----------------- END OF DEBUG PORTS -----------------

        -- Transceiver monitor interface
        txdata                     => open                        , --: out std_logic_vector(63 downto 0);
        txcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        txheader                   => open                        , --: out std_logic_vector(1 downto 0);
        txsequence                 => open                        , --: out std_logic_vector(6 downto 0);
        rxdata                     => open                        , --: out std_logic_vector(63 downto 0);
        rxchariscomma              => open                        , --: out std_logic_vector(7 downto 0);
        rxcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        rxdisperr                  => open                        , --: out std_logic_vector(7 downto 0);
        rxnotintable               => open                        , --: out std_logic_vector(7 downto 0);
        rxdatavalid                => open                        , --: out std_logic;
        rxheader                   => open                        , --: out std_logic_vector(1 downto 0);
        rxheadervalid              => open                        , --: out std_logic;
        rxgearboxslip              => open                        , --: out std_logic;
        reset                      => reset_s                     , --: in  std_logic;

        -- I/Q interface
        iq_tx_enable               => iq_tx_en(0)                 , --: out std_logic;
        basic_frame_first_word     => bffw(0)                     , --: out std_logic;
        iq_tx                      => iq_tx(0)                    , --: in  std_logic_vector(63 downto 0);
        iq_rx                      => iq_rx(0)                    , --: out std_logic_vector(63 downto 0);

        -- GT Common Ports
        qpll0clk_in                => common_qpll0clk             , --: in  std_logic;
        qpll0refclk_in             => common_qpll0refclk          , --: in  std_logic;
        qpll1clk_in                => common_qpll1clk             , --: in  std_logic;
        qpll1refclk_in             => common_qpll1refclk          , --: in  std_logic;
        qpll0lock_in               => common_qpll0lock            , --: in  std_logic;
        qpll0_pd                   => common_qpll0_pd(0)          , --: out std_logic;
        qpll1lock_in               => common_qpll1lock            , --: in  std_logic;
        qpll1_pd                   => common_qpll1_pd(0)          , --: out std_logic;

        -- Vendor Specific Data
        vendor_tx_data             => vendor_tx_data(0)           , --: in  std_logic_vector(127 downto 0);
        vendor_tx_xs               => vendor_tx_xs(0)             , --: out std_logic_vector(1 downto 0);
        vendor_tx_ns               => vendor_tx_ns(0)             , --: out std_logic_vector(5 downto 0);
        vendor_rx_data             => vendor_rx_data(0)           , --: out std_logic_vector(127 downto 0);
        vendor_rx_xs               => vendor_rx_xs(0)             , --: out std_logic_vector(1 downto 0);
        vendor_rx_ns               => vendor_rx_ns(0)             , --: out std_logic_vector(5 downto 0);
        vs_negotiation_complete    => '1'                         , --: in  std_logic;

        -- Synchronization
        nodebfn_tx_strobe          => nodebfn_tx_strobe(0)        , --: in  std_logic;
        nodebfn_tx_nr              => nodebfn_tx_nr(0)            , --: in  std_logic_vector(11 downto 0);
        nodebfn_rx_strobe          => nodebfn_rx_strobe(0)        , --: out std_logic;
        nodebfn_rx_nr              => nodebfn_rx_nr(0)            , --: out std_logic_vector(11 downto 0);

        -- Ethernet interface
        tx_axis_eth_tdata          => tx_axis_eth_tdata(0)        , --: in  std_logic_vector(7 downto 0);
        tx_axis_eth_tvalid         => tx_axis_eth_tvalid(0)       , --: in  std_logic;
        tx_axis_eth_tuser          => tx_axis_eth_tuser(0)        , --: in  std_logic;
        tx_axis_eth_tlast          => tx_axis_eth_tlast(0)        , --: in  std_logic;
        tx_axis_eth_tready         => tx_axis_eth_tready(0)       , --: out std_logic;

        rx_axis_eth_tdata          => rx_axis_eth_tdata(0)        , --: out std_logic_vector(7 downto 0);
        rx_axis_eth_tvalid         => rx_axis_eth_tvalid(0)       , --: out std_logic;
        rx_axis_eth_tuser          => rx_axis_eth_tuser(0)        , --: out std_logic;
        rx_axis_eth_tlast          => rx_axis_eth_tlast(0)        , --: out std_logic;

        -- HDLC interface
        hdlc_rx_data               => open                        , --: out std_logic;
        hdlc_tx_data               => '0'                         , --: in  std_logic;
        hdlc_rx_data_valid         => open                        , --: out std_logic;
        hdlc_tx_enable             => open                        , --: out std_logic;

        -- Status interface
        stat_alarm                 => stat_alarm(0)               , --: out std_logic;
        stat_code                  => stat_code(0)                , --: out std_logic_vector(3 downto 0);
        stat_speed                 => stat_speed_i(0)             , --: out std_logic_vector(10 downto 0);
        reset_request_in           => '0'                         , --: in  std_logic;
        sdi_request_in             => '0'                         , --: in  std_logic;
        reset_acknowledge_out      => open                        , --: out std_logic;
        sdi_request_out            => open                        , --: out std_logic;
        local_los                  => local_los_buf(0)            , --: out std_logic;
        local_lof                  => local_lof_buf(0)            , --: out std_logic;
        local_rai                  => open                        , --: out std_logic;
        remote_los                 => open                        , --: out std_logic;
        remote_lof                 => open                        , --: out std_logic;
        remote_rai                 => open                        , --: out std_logic;
        fifo_transit_time          => open                        , --: out std_logic_vector(13 downto 0);
        coarse_timer_value         => open                        , --: out std_logic_vector(CPRI_NUM downto 0);
        barrel_shift_value         => open                        , --: out std_logic_vector(6 downto 0);
        tx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        rx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        hyperframe_number          => hyperframe_number(0)        , --: out std_logic_vector(7 downto 0);

        -- AXI-Lite Interface
        -----------------
        s_axi_aclk                 => s_axi_aclk                  , --: in  std_logic;
        s_axi_aresetn              => s_axi_aresetn               , --: in  std_logic;
        s_axi_awaddr               => s_axi_awaddr(0)             , --: in  std_logic_vector(11 downto 0);
        s_axi_awvalid              => s_axi_awvalid(0)            , --: in  std_logic;
        s_axi_awready              => s_axi_awready(0)            , --: out std_logic;
        s_axi_wdata                => s_axi_wdata(0)              , --: in  std_logic_vector(31 downto 0);
        s_axi_wvalid               => s_axi_wvalid(0)             , --: in  std_logic;
        s_axi_wready               => s_axi_wready(0)             , --: out std_logic;
        s_axi_bresp                => s_axi_bresp(0)              , --: out std_logic_vector(1 downto 0);
        s_axi_bvalid               => s_axi_bvalid(0)             , --: out std_logic;
        s_axi_bready               => s_axi_bready(0)             , --: in  std_logic;
        s_axi_araddr               => s_axi_araddr(0)             , --: in  std_logic_vector(11 downto 0);
        s_axi_arvalid              => s_axi_arvalid(0)            , --: in  std_logic;
        s_axi_arready              => s_axi_arready(0)            , --: out std_logic;
        s_axi_rdata                => s_axi_rdata(0)              , --: out std_logic_vector(31 downto 0);
        s_axi_rresp                => s_axi_rresp(0)              , --: out std_logic_vector(1 downto 0);
        s_axi_rvalid               => s_axi_rvalid(0)             , --: out std_logic;
        s_axi_rready               => s_axi_rready(0)             , --: in  std_logic;
        l1_timer_expired           => '0'                         , --: in  std_logic;

        -- Transceiver signals
        txp                        => txp(0)                      , --: out std_logic;
        txn                        => txn(0)                      , --: out std_logic;
        rxp                        => rxp(0)                      , --: in  std_logic;
        rxn                        => rxn(0)                      , --: in  std_logic;
        lossoflight                => sfp_los(0)                  , --: in  std_logic;
        txinhibit                  => txinhibit(0)                , --: out std_logic;

        -- Clocks
        refclk                     => refclk                      , --: in  std_logic;
        clk_in                     => clk_368p64                  , --: in  std_logic;
        clk_ok_in                  => cpri_mmcm_locked            , --: in  std_logic;
        txusrclk                   => clk_368p64                  , --: in  std_logic;
        recclk_in                  => rec_clk_i(0)                , --: in  std_logic;
        gtreset_sm_done            => gtreset_sm_done(0)          , --: out std_logic;
        userclk_tx_reset           => userclk_tx_reset(0)         , --: out std_logic;
        userclk_rx_reset           => userclk_rx_reset(0)         , --: out std_logic;
        aux_clk_out                => open                        , --: out std_logic;
        gtwiz_reset_clk_freerun_in => clk_7p68                    , --: in std_logic;
        hires_clk                  => hires_clk                   , --: in  std_logic;
        hires_clk_ok               => hires_clk_ok                , --: in  std_logic;
        qpll_select                => '0'                         , --: in  std_logic;
        core_is_master             => core_is_master(0)           , --: in  std_logic;
        recclk_ok                  => recclk_ok(0)                , --: out std_logic;
        txoutclk                   => txoutclk_i(0)               , --: out std_logic;
        mmcm_rst                   => mmcm_rst(0)                 , --: out std_logic;  --Signal to reset mmcm in clocking module
        rxoutclk                   => rxoutclk_i(0)               , --: out std_logic;
        rxrecclkout                => rxrecclkout(0)              , --: out std_logic;
        txresetdone_out            => txresetdone_i(0)            , --: out std_logic;

        --Ports for phase_alignment module
        txdlyen_in                 => txdlyen_vec(0)              , --: in  std_logic;
        txphinit_in                => txphinit_vec(0)             , --: in  std_logic;
        phase_alignment_done_in    => '1'                         , --: in  std_logic;
        txdlysreset_in             => txdlysreset_vec(0)          , --: in  std_logic;
        txphalign_in               => txphalign_vec(0)            , --: in  std_logic;
        txphaligndone_out          => txphaligndone(0)            , --: out std_logic;
        txdlysresetdone_out        => txdlysresetdone(0)          , --: out std_logic;
        txsyncdone_out             => open                        , --: out std_logic;
        txphinitdone_out           => txphinitdone_out(0)         , --: out std_logic);
        rx_rsfec_enable_ch         => rx_rsfec_enable(0)          , --: out std_logic;
        rx_rec_clk_ch              => rx_rec_clk(0)               , --: out std_logic;
        rx_serdes_data_ch          => rx_serdes_data(0)           , --: out std_logic_vector(63 downto 0);
        rx_serdes_head_ch          => rx_serdes_head(0)           , --: out std_logic_vector( 1 downto 0);
        rx_gbx_slip_ch             => rx_gbx_slip(0)              , --: in  std_logic;
        cdc_reset_ch               => cdc_reset(0)                , --: out std_logic;
        fifo_fill_level_ch         => fifo_fill_level(0)          , --: out std_logic_vector( 8 downto 0);
        average_ch                 => average(0)                  , --: in  std_logic_vector(16 downto 0);
        average_rdy_ch             => average_rdy(0)              , --: in  std_logic;
        average_ack_ch             => average_ack(0)              , --: out std_logic;
        fifo_error_ch              => fifo_error(0)               , --: in  std_logic;
        cdc_rxdata_ch              => cdc_rxdata(0)               , --: in  std_logic_vector(63 downto 0);
        cdc_rxheader_ch            => cdc_rxheader(0)             , --: in  std_logic_vector( 1 downto 0);
        pcs_txclk_ch               => clk_368p64                  , --: in  std_logic;
        pcs_txclk_ok_ch            => cpri_mmcm_locked            , --: in  std_logic;
        pcs_rxdata_ch              => pcs_rxdata(0)               , --: in  std_logic_vector(63 downto 0);
        pcs_rxheader_ch            => pcs_rxheader(0)             , --: in  std_logic_vector( 1 downto 0);
        pcs_rxheadervalid_ch       => pcs_rxheadervalid(0)        , --: in  std_logic;
        stat_rx_align_status_ch    => stat_rx_align_status(0)     , --: in  std_logic;
        stat_cw_inc_ch             => stat_cw_inc(0)              , --: in  std_logic;
        stat_corrected_cw_inc_ch   => stat_corrected_cw_inc(0)    , --: in  std_logic;
        stat_uncorrected_cw_inc_ch => stat_uncorrected_cw_inc(0)  , --: in  std_logic;
        hfec_fifo_latency_ch       => hfec_fifo_latency(0)        , --: in  std_logic_vector(15 downto 0);
        hfec_fifo_latency_rdy_ch   => hfec_fifo_latency_rdy(0)    , --: in  std_logic;
        hfec_fifo_latency_ack_ch   => hfec_fifo_latency_ack(0)   ); --: out std_logic);
		
cpri_blk_1 : entity work.cpri_24g_1
    port map (
        -- Additional Debug Ports
        -- DRP Access
        gt_drpdaddr                => "00" & x"00"                , --: in  std_logic_vector(9 downto 0);
        gt_drpdi                   => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        gt_drpen                   => '0'                         , --: in  std_logic;
        gt_drpwe                   => '0'                         , --: in  std_logic;
        gt_drpdo                   => open                        , --: out std_logic_vector(15 downto 0);
        gt_drprdy                  => open                        , --: out std_logic;
        -- TX Reset and Initialization
        gt_txpmareset              => gt_txpma_rst(1)             , --: in  std_logic;
        gt_txpcsreset              => gt_txpcs_rst(1)             , --: in  std_logic;
        gt_txresetdone             => gt_txresetdone(1)           , --: out std_logic;
        -- RX Reset and Initialization
        gt_rxpmareset              => gt_rxpma_rst(1)             , --: in  std_logic;
        gt_rxpcsreset              => gt_rxpcs_rst(1)             , --: in  std_logic;
        gt_rxpmaresetdone          => open                        , --: out std_logic;
        gt_rxresetdone             => gt_rxresetdone(1)           , --: out std_logic;
        -- Clocking
        gt_txphaligndone           => open                        , --: out std_logic;
        gt_txphinitdone            => open                        , --: out std_logic;
        gt_txdlysresetdone         => open                        , --: out std_logic;
        gt_rxphaligndone           => open                        , --: out std_logic;
        gt_rxdlysresetdone         => open                        , --: out std_logic;
        gt_rxsyncdone              => open                        , --: out std_logic;
        gt_cplllock                => open                        , --: out std_logic;
        -- Signal Integrity and Functionality
        gt_rxrate                  => "000"                       , --: in  std_logic_vector(2 downto 0);
        gt_eyescantrigger          => '0'                         , --: in  std_logic;
        gt_eyescanreset            => '0'                         , --: in  std_logic;
        gt_eyescandataerror        => open                        , --: out std_logic;
        gt_rxpolarity              => '0'                         , --: in  std_logic;
        gt_txpolarity              => '0'                         , --: in  std_logic;
        gt_rxdfelpmreset           => '0'                         , --: in  std_logic;
        gt_rxlpmen                 => gt_rxlpmen(1)               , --: in  std_logic;
        gt_txprecursor             => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txpostcursor            => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txdiffctrl              => gt_txdiffctrl(1)            , --: in  std_logic_vector(4 downto 0);
        gt_txprbsforceerr          => '0'                         , --: in  std_logic;
        gt_txprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbserr               => open                        , --: out std_logic;
        gt_rxprbscntreset          => '0'                         , --: in  std_logic;
        gt_rxcdrhold               => '0'                         , --: in  std_logic;
        gt_dmonitorout             => open                        , --: out std_logic_vector(15 downto 0);
        gt_rxheader                => open                        , --: out std_logic_vector(1 downto 0);
        gt_rxheadervalid           => open                        , --: out std_logic;

        gt_rxdisperr               => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxnotintable            => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxcommadet              => open                        , --: out std_logic;
        gt_pcsrsvdin               => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        ----------------- END OF DEBUG PORTS -----------------

        -- Transceiver monitor interface
        txdata                     => open                        , --: out std_logic_vector(63 downto 0);
        txcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        txheader                   => open                        , --: out std_logic_vector(1 downto 0);
        txsequence                 => open                        , --: out std_logic_vector(6 downto 0);
        rxdata                     => open                        , --: out std_logic_vector(63 downto 0);
        rxchariscomma              => open                        , --: out std_logic_vector(7 downto 0);
        rxcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        rxdisperr                  => open                        , --: out std_logic_vector(7 downto 0);
        rxnotintable               => open                        , --: out std_logic_vector(7 downto 0);
        rxdatavalid                => open                        , --: out std_logic;
        rxheader                   => open                        , --: out std_logic_vector(1 downto 0);
        rxheadervalid              => open                        , --: out std_logic;
        rxgearboxslip              => open                        , --: out std_logic;
        reset                      => reset_s                     , --: in  std_logic;

        -- I/Q interface
        iq_tx_enable               => iq_tx_en(1)                 , --: out std_logic;
        basic_frame_first_word     => bffw(1)                     , --: out std_logic;
        iq_tx                      => iq_tx(1)                    , --: in  std_logic_vector(63 downto 0);
        iq_rx                      => iq_rx(1)                    , --: out std_logic_vector(63 downto 0);

        -- GT Common Ports
        qpll0clk_in                => common_qpll0clk             , --: in  std_logic;
        qpll0refclk_in             => common_qpll0refclk          , --: in  std_logic;
        qpll1clk_in                => common_qpll1clk             , --: in  std_logic;
        qpll1refclk_in             => common_qpll1refclk          , --: in  std_logic;
        qpll0lock_in               => common_qpll0lock            , --: in  std_logic;
        qpll0_pd                   => common_qpll0_pd(1)          , --: out std_logic;
        qpll1lock_in               => common_qpll1lock            , --: in  std_logic;
        qpll1_pd                   => common_qpll1_pd(1)          , --: out std_logic;

        -- Vendor Specific Data
        vendor_tx_data             => vendor_tx_data(1)           , --: in  std_logic_vector(127 downto 0);
        vendor_tx_xs               => vendor_tx_xs(1)             , --: out std_logic_vector(1 downto 0);
        vendor_tx_ns               => vendor_tx_ns(1)             , --: out std_logic_vector(5 downto 0);
        vendor_rx_data             => vendor_rx_data(1)           , --: out std_logic_vector(127 downto 0);
        vendor_rx_xs               => vendor_rx_xs(1)             , --: out std_logic_vector(1 downto 0);
        vendor_rx_ns               => vendor_rx_ns(1)             , --: out std_logic_vector(5 downto 0);
        vs_negotiation_complete    => '1'                         , --: in  std_logic;

        -- Synchronization
        nodebfn_tx_strobe          => nodebfn_tx_strobe(1)        , --: in  std_logic;
        nodebfn_tx_nr              => nodebfn_tx_nr(1)            , --: in  std_logic_vector(11 downto 0);
        nodebfn_rx_strobe          => nodebfn_rx_strobe(1)        , --: out std_logic;
        nodebfn_rx_nr              => nodebfn_rx_nr(1)            , --: out std_logic_vector(11 downto 0);

        -- Ethernet interface
        tx_axis_eth_tdata          => tx_axis_eth_tdata(1)        , --: in  std_logic_vector(7 downto 0);
        tx_axis_eth_tvalid         => tx_axis_eth_tvalid(1)       , --: in  std_logic;
        tx_axis_eth_tuser          => tx_axis_eth_tuser(1)        , --: in  std_logic;
        tx_axis_eth_tlast          => tx_axis_eth_tlast(1)        , --: in  std_logic;
        tx_axis_eth_tready         => tx_axis_eth_tready(1)       , --: out std_logic;

        rx_axis_eth_tdata          => rx_axis_eth_tdata(1)        , --: out std_logic_vector(7 downto 0);
        rx_axis_eth_tvalid         => rx_axis_eth_tvalid(1)       , --: out std_logic;
        rx_axis_eth_tuser          => rx_axis_eth_tuser(1)        , --: out std_logic;
        rx_axis_eth_tlast          => rx_axis_eth_tlast(1)        , --: out std_logic;

        -- HDLC interface
        hdlc_rx_data               => open                        , --: out std_logic;
        hdlc_tx_data               => '0'                         , --: in  std_logic;
        hdlc_rx_data_valid         => open                        , --: out std_logic;
        hdlc_tx_enable             => open                        , --: out std_logic;

        -- Status interface
        stat_alarm                 => stat_alarm(1)               , --: out std_logic;
        stat_code                  => stat_code(1)                , --: out std_logic_vector(3 downto 0);
        stat_speed                 => stat_speed_i(1)             , --: out std_logic_vector(10 downto 0);
        reset_request_in           => '0'                         , --: in  std_logic;
        sdi_request_in             => '0'                         , --: in  std_logic;
        reset_acknowledge_out      => open                        , --: out std_logic;
        sdi_request_out            => open                        , --: out std_logic;
        local_los                  => local_los_buf(1)            , --: out std_logic;
        local_lof                  => local_lof_buf(1)            , --: out std_logic;
        local_rai                  => open                        , --: out std_logic;
        remote_los                 => open                        , --: out std_logic;
        remote_lof                 => open                        , --: out std_logic;
        remote_rai                 => open                        , --: out std_logic;
        fifo_transit_time          => open                        , --: out std_logic_vector(13 downto 0);
        coarse_timer_value         => open                        , --: out std_logic_vector(CPRI_NUM downto 0);
        barrel_shift_value         => open                        , --: out std_logic_vector(6 downto 0);
        tx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        rx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        hyperframe_number          => hyperframe_number(1)        , --: out std_logic_vector(7 downto 0);

        -- AXI-Lite Interface
        -----------------
        s_axi_aclk                 => s_axi_aclk                  , --: in  std_logic;
        s_axi_aresetn              => s_axi_aresetn               , --: in  std_logic;
        s_axi_awaddr               => s_axi_awaddr(1)             , --: in  std_logic_vector(11 downto 0);
        s_axi_awvalid              => s_axi_awvalid(1)            , --: in  std_logic;
        s_axi_awready              => s_axi_awready(1)            , --: out std_logic;
        s_axi_wdata                => s_axi_wdata(1)              , --: in  std_logic_vector(31 downto 0);
        s_axi_wvalid               => s_axi_wvalid(1)             , --: in  std_logic;
        s_axi_wready               => s_axi_wready(1)             , --: out std_logic;
        s_axi_bresp                => s_axi_bresp(1)              , --: out std_logic_vector(1 downto 0);
        s_axi_bvalid               => s_axi_bvalid(1)             , --: out std_logic;
        s_axi_bready               => s_axi_bready(1)             , --: in  std_logic;
        s_axi_araddr               => s_axi_araddr(1)             , --: in  std_logic_vector(11 downto 0);
        s_axi_arvalid              => s_axi_arvalid(1)            , --: in  std_logic;
        s_axi_arready              => s_axi_arready(1)            , --: out std_logic;
        s_axi_rdata                => s_axi_rdata(1)              , --: out std_logic_vector(31 downto 0);
        s_axi_rresp                => s_axi_rresp(1)              , --: out std_logic_vector(1 downto 0);
        s_axi_rvalid               => s_axi_rvalid(1)             , --: out std_logic;
        s_axi_rready               => s_axi_rready(1)             , --: in  std_logic;
        l1_timer_expired           => '0'                         , --: in  std_logic;

        -- Transceiver signals
        txp                        => txp(1)                      , --: out std_logic;
        txn                        => txn(1)                      , --: out std_logic;
        rxp                        => rxp(1)                      , --: in  std_logic;
        rxn                        => rxn(1)                      , --: in  std_logic;
        lossoflight                => sfp_los(1)                  , --: in  std_logic;
        txinhibit                  => txinhibit(1)                , --: out std_logic;

        -- Clocks
        refclk                     => refclk                      , --: in  std_logic;
        clk_in                     => clk_368p64                  , --: in  std_logic;
        clk_ok_in                  => cpri_mmcm_locked            , --: in  std_logic;
        txusrclk                   => clk_368p64                  , --: in  std_logic;
        recclk_in                  => rec_clk_i(1)                , --: in  std_logic;
        gtreset_sm_done            => gtreset_sm_done(1)          , --: out std_logic;
        userclk_tx_reset           => userclk_tx_reset(1)         , --: out std_logic;
        userclk_rx_reset           => userclk_rx_reset(1)         , --: out std_logic;
        aux_clk_out                => open                        , --: out std_logic;
        gtwiz_reset_clk_freerun_in => clk_7p68                    , --: in std_logic;
        hires_clk                  => hires_clk                   , --: in  std_logic;
        hires_clk_ok               => hires_clk_ok                , --: in  std_logic;
        qpll_select                => '0'                         , --: in  std_logic;
        core_is_master             => core_is_master(1)           , --: in  std_logic;
        recclk_ok                  => recclk_ok(1)                , --: out std_logic;
        txoutclk                   => txoutclk_i(1)               , --: out std_logic;
        mmcm_rst                   => mmcm_rst(1)                 , --: out std_logic;  --Signal to reset mmcm in clocking module
        rxoutclk                   => rxoutclk_i(1)               , --: out std_logic;
        rxrecclkout                => rxrecclkout(1)              , --: out std_logic;
        txresetdone_out            => txresetdone_i(1)            , --: out std_logic;

        --Ports for phase_alignment module
        txdlyen_in                 => txdlyen_vec(0)              , --: in  std_logic;
        txphinit_in                => txphinit_vec(0)             , --: in  std_logic;
        phase_alignment_done_in    => '1'                         , --: in  std_logic;
        txdlysreset_in             => txdlysreset_vec(0)          , --: in  std_logic;
        txphalign_in               => txphalign_vec(0)            , --: in  std_logic;
        txphaligndone_out          => txphaligndone(1)            , --: out std_logic;
        txdlysresetdone_out        => txdlysresetdone(1)          , --: out std_logic;
        txsyncdone_out             => open                        , --: out std_logic;
        txphinitdone_out           => txphinitdone_out(1)         , --: out std_logic);
        rx_rsfec_enable_ch         => rx_rsfec_enable(1)          , --: out std_logic;
        rx_rec_clk_ch              => rx_rec_clk(1)               , --: out std_logic;
        rx_serdes_data_ch          => rx_serdes_data(1)           , --: out std_logic_vector(63 downto 0);
        rx_serdes_head_ch          => rx_serdes_head(1)           , --: out std_logic_vector( 1 downto 0);
        rx_gbx_slip_ch             => rx_gbx_slip(1)              , --: in  std_logic;
        cdc_reset_ch               => cdc_reset(1)                , --: out std_logic;
        fifo_fill_level_ch         => fifo_fill_level(1)          , --: out std_logic_vector( 8 downto 0);
        average_ch                 => average(1)                  , --: in  std_logic_vector(16 downto 0);
        average_rdy_ch             => average_rdy(1)              , --: in  std_logic;
        average_ack_ch             => average_ack(1)              , --: out std_logic;
        fifo_error_ch              => fifo_error(1)               , --: in  std_logic;
        cdc_rxdata_ch              => cdc_rxdata(1)               , --: in  std_logic_vector(63 downto 0);
        cdc_rxheader_ch            => cdc_rxheader(1)             , --: in  std_logic_vector( 1 downto 0);
        pcs_txclk_ch               => clk_368p64                  , --: in  std_logic;
        pcs_txclk_ok_ch            => cpri_mmcm_locked            , --: in  std_logic;
        pcs_rxdata_ch              => pcs_rxdata(1)               , --: in  std_logic_vector(63 downto 0);
        pcs_rxheader_ch            => pcs_rxheader(1)             , --: in  std_logic_vector( 1 downto 0);
        pcs_rxheadervalid_ch       => pcs_rxheadervalid(1)        , --: in  std_logic;
        stat_rx_align_status_ch    => stat_rx_align_status(1)     , --: in  std_logic;
        stat_cw_inc_ch             => stat_cw_inc(1)              , --: in  std_logic;
        stat_corrected_cw_inc_ch   => stat_corrected_cw_inc(1)    , --: in  std_logic;
        stat_uncorrected_cw_inc_ch => stat_uncorrected_cw_inc(1)  , --: in  std_logic;
        hfec_fifo_latency_ch       => hfec_fifo_latency(1)        , --: in  std_logic_vector(15 downto 0);
        hfec_fifo_latency_rdy_ch   => hfec_fifo_latency_rdy(1)    , --: in  std_logic;
        hfec_fifo_latency_ack_ch   => hfec_fifo_latency_ack(1)   ); --: out std_logic);
		
cpri_blk_2 : entity work.cpri_24g_2
    port map (
        -- Additional Debug Ports
        -- DRP Access
        gt_drpdaddr                => "00" & x"00"                , --: in  std_logic_vector(9 downto 0);
        gt_drpdi                   => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        gt_drpen                   => '0'                         , --: in  std_logic;
        gt_drpwe                   => '0'                         , --: in  std_logic;
        gt_drpdo                   => open                        , --: out std_logic_vector(15 downto 0);
        gt_drprdy                  => open                        , --: out std_logic;
        -- TX Reset and Initialization
        gt_txpmareset              => gt_txpma_rst(2)             , --: in  std_logic;
        gt_txpcsreset              => gt_txpcs_rst(2)             , --: in  std_logic;
        gt_txresetdone             => gt_txresetdone(2)           , --: out std_logic;
        -- RX Reset and Initialization
        gt_rxpmareset              => gt_rxpma_rst(2)             , --: in  std_logic;
        gt_rxpcsreset              => gt_rxpcs_rst(2)             , --: in  std_logic;
        gt_rxpmaresetdone          => open                        , --: out std_logic;
        gt_rxresetdone             => gt_rxresetdone(2)           , --: out std_logic;
        -- Clocking
        gt_txphaligndone           => open                        , --: out std_logic;
        gt_txphinitdone            => open                        , --: out std_logic;
        gt_txdlysresetdone         => open                        , --: out std_logic;
        gt_rxphaligndone           => open                        , --: out std_logic;
        gt_rxdlysresetdone         => open                        , --: out std_logic;
        gt_rxsyncdone              => open                        , --: out std_logic;
        gt_cplllock                => open                        , --: out std_logic;
        -- Signal Integrity and Functionality
        gt_rxrate                  => "000"                       , --: in  std_logic_vector(2 downto 0);
        gt_eyescantrigger          => '0'                         , --: in  std_logic;
        gt_eyescanreset            => '0'                         , --: in  std_logic;
        gt_eyescandataerror        => open                        , --: out std_logic;
        gt_rxpolarity              => '0'                         , --: in  std_logic;
        gt_txpolarity              => '0'                         , --: in  std_logic;
        gt_rxdfelpmreset           => '0'                         , --: in  std_logic;
        gt_rxlpmen                 => gt_rxlpmen(2)               , --: in  std_logic;
        gt_txprecursor             => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txpostcursor            => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txdiffctrl              => gt_txdiffctrl(2)            , --: in  std_logic_vector(4 downto 0);
        gt_txprbsforceerr          => '0'                         , --: in  std_logic;
        gt_txprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbserr               => open                        , --: out std_logic;
        gt_rxprbscntreset          => '0'                         , --: in  std_logic;
        gt_rxcdrhold               => '0'                         , --: in  std_logic;
        gt_dmonitorout             => open                        , --: out std_logic_vector(15 downto 0);
        gt_rxheader                => open                        , --: out std_logic_vector(1 downto 0);
        gt_rxheadervalid           => open                        , --: out std_logic;

        gt_rxdisperr               => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxnotintable            => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxcommadet              => open                        , --: out std_logic;
        gt_pcsrsvdin               => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        ----------------- END OF DEBUG PORTS -----------------

        -- Transceiver monitor interface
        txdata                     => open                        , --: out std_logic_vector(63 downto 0);
        txcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        txheader                   => open                        , --: out std_logic_vector(1 downto 0);
        txsequence                 => open                        , --: out std_logic_vector(6 downto 0);
        rxdata                     => open                        , --: out std_logic_vector(63 downto 0);
        rxchariscomma              => open                        , --: out std_logic_vector(7 downto 0);
        rxcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        rxdisperr                  => open                        , --: out std_logic_vector(7 downto 0);
        rxnotintable               => open                        , --: out std_logic_vector(7 downto 0);
        rxdatavalid                => open                        , --: out std_logic;
        rxheader                   => open                        , --: out std_logic_vector(1 downto 0);
        rxheadervalid              => open                        , --: out std_logic;
        rxgearboxslip              => open                        , --: out std_logic;
        reset                      => reset_s                     , --: in  std_logic;

        -- I/Q interface
        iq_tx_enable               => iq_tx_en(2)                 , --: out std_logic;
        basic_frame_first_word     => bffw(2)                     , --: out std_logic;
        iq_tx                      => iq_tx(2)                    , --: in  std_logic_vector(63 downto 0);
        iq_rx                      => iq_rx(2)                    , --: out std_logic_vector(63 downto 0);

        -- GT Common Ports
        qpll0clk_in                => common_qpll0clk             , --: in  std_logic;
        qpll0refclk_in             => common_qpll0refclk          , --: in  std_logic;
        qpll1clk_in                => common_qpll1clk             , --: in  std_logic;
        qpll1refclk_in             => common_qpll1refclk          , --: in  std_logic;
        qpll0lock_in               => common_qpll0lock            , --: in  std_logic;
        qpll0_pd                   => common_qpll0_pd(2)          , --: out std_logic;
        qpll1lock_in               => common_qpll1lock            , --: in  std_logic;
        qpll1_pd                   => common_qpll1_pd(2)          , --: out std_logic;

        -- Vendor Specific Data
        vendor_tx_data             => vendor_tx_data(2)           , --: in  std_logic_vector(127 downto 0);
        vendor_tx_xs               => vendor_tx_xs(2)             , --: out std_logic_vector(1 downto 0);
        vendor_tx_ns               => vendor_tx_ns(2)             , --: out std_logic_vector(5 downto 0);
        vendor_rx_data             => vendor_rx_data(2)           , --: out std_logic_vector(127 downto 0);
        vendor_rx_xs               => vendor_rx_xs(2)             , --: out std_logic_vector(1 downto 0);
        vendor_rx_ns               => vendor_rx_ns(2)             , --: out std_logic_vector(5 downto 0);
        vs_negotiation_complete    => '1'                         , --: in  std_logic;

        -- Synchronization
        nodebfn_tx_strobe          => nodebfn_tx_strobe(2)        , --: in  std_logic;
        nodebfn_tx_nr              => nodebfn_tx_nr(2)            , --: in  std_logic_vector(11 downto 0);
        nodebfn_rx_strobe          => nodebfn_rx_strobe(2)        , --: out std_logic;
        nodebfn_rx_nr              => nodebfn_rx_nr(2)            , --: out std_logic_vector(11 downto 0);

        -- Ethernet interface
        tx_axis_eth_tdata          => tx_axis_eth_tdata(2)        , --: in  std_logic_vector(7 downto 0);
        tx_axis_eth_tvalid         => tx_axis_eth_tvalid(2)       , --: in  std_logic;
        tx_axis_eth_tuser          => tx_axis_eth_tuser(2)        , --: in  std_logic;
        tx_axis_eth_tlast          => tx_axis_eth_tlast(2)        , --: in  std_logic;
        tx_axis_eth_tready         => tx_axis_eth_tready(2)       , --: out std_logic;

        rx_axis_eth_tdata          => rx_axis_eth_tdata(2)        , --: out std_logic_vector(7 downto 0);
        rx_axis_eth_tvalid         => rx_axis_eth_tvalid(2)       , --: out std_logic;
        rx_axis_eth_tuser          => rx_axis_eth_tuser(2)        , --: out std_logic;
        rx_axis_eth_tlast          => rx_axis_eth_tlast(2)        , --: out std_logic;

        -- HDLC interface
        hdlc_rx_data               => open                        , --: out std_logic;
        hdlc_tx_data               => '0'                         , --: in  std_logic;
        hdlc_rx_data_valid         => open                        , --: out std_logic;
        hdlc_tx_enable             => open                        , --: out std_logic;

        -- Status interface
        stat_alarm                 => stat_alarm(2)               , --: out std_logic;
        stat_code                  => stat_code(2)                , --: out std_logic_vector(3 downto 0);
        stat_speed                 => stat_speed_i(2)             , --: out std_logic_vector(10 downto 0);
        reset_request_in           => '0'                         , --: in  std_logic;
        sdi_request_in             => '0'                         , --: in  std_logic;
        reset_acknowledge_out      => open                        , --: out std_logic;
        sdi_request_out            => open                        , --: out std_logic;
        local_los                  => local_los_buf(2)            , --: out std_logic;
        local_lof                  => local_lof_buf(2)            , --: out std_logic;
        local_rai                  => open                        , --: out std_logic;
        remote_los                 => open                        , --: out std_logic;
        remote_lof                 => open                        , --: out std_logic;
        remote_rai                 => open                        , --: out std_logic;
        fifo_transit_time          => open                        , --: out std_logic_vector(13 downto 0);
        coarse_timer_value         => open                        , --: out std_logic_vector(CPRI_NUM downto 0);
        barrel_shift_value         => open                        , --: out std_logic_vector(6 downto 0);
        tx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        rx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        hyperframe_number          => hyperframe_number(2)        , --: out std_logic_vector(7 downto 0);

        -- AXI-Lite Interface
        -----------------
        s_axi_aclk                 => s_axi_aclk                  , --: in  std_logic;
        s_axi_aresetn              => s_axi_aresetn               , --: in  std_logic;
        s_axi_awaddr               => s_axi_awaddr(2)             , --: in  std_logic_vector(11 downto 0);
        s_axi_awvalid              => s_axi_awvalid(2)            , --: in  std_logic;
        s_axi_awready              => s_axi_awready(2)            , --: out std_logic;
        s_axi_wdata                => s_axi_wdata(2)              , --: in  std_logic_vector(31 downto 0);
        s_axi_wvalid               => s_axi_wvalid(2)             , --: in  std_logic;
        s_axi_wready               => s_axi_wready(2)             , --: out std_logic;
        s_axi_bresp                => s_axi_bresp(2)              , --: out std_logic_vector(1 downto 0);
        s_axi_bvalid               => s_axi_bvalid(2)             , --: out std_logic;
        s_axi_bready               => s_axi_bready(2)             , --: in  std_logic;
        s_axi_araddr               => s_axi_araddr(2)             , --: in  std_logic_vector(11 downto 0);
        s_axi_arvalid              => s_axi_arvalid(2)            , --: in  std_logic;
        s_axi_arready              => s_axi_arready(2)            , --: out std_logic;
        s_axi_rdata                => s_axi_rdata(2)              , --: out std_logic_vector(31 downto 0);
        s_axi_rresp                => s_axi_rresp(2)              , --: out std_logic_vector(1 downto 0);
        s_axi_rvalid               => s_axi_rvalid(2)             , --: out std_logic;
        s_axi_rready               => s_axi_rready(2)             , --: in  std_logic;
        l1_timer_expired           => '0'                         , --: in  std_logic;

        -- Transceiver signals
        txp                        => txp(2)                      , --: out std_logic;
        txn                        => txn(2)                      , --: out std_logic;
        rxp                        => rxp(2)                      , --: in  std_logic;
        rxn                        => rxn(2)                      , --: in  std_logic;
        lossoflight                => sfp_los(2)                  , --: in  std_logic;
        txinhibit                  => txinhibit(2)                , --: out std_logic;

        -- Clocks
        refclk                     => refclk                      , --: in  std_logic;
        clk_in                     => clk_368p64                  , --: in  std_logic;
        clk_ok_in                  => cpri_mmcm_locked            , --: in  std_logic;
        txusrclk                   => clk_368p64                  , --: in  std_logic;
        recclk_in                  => rec_clk_i(2)                , --: in  std_logic;
        gtreset_sm_done            => gtreset_sm_done(2)          , --: out std_logic;
        userclk_tx_reset           => userclk_tx_reset(2)         , --: out std_logic;
        userclk_rx_reset           => userclk_rx_reset(2)         , --: out std_logic;
        aux_clk_out                => open                        , --: out std_logic;
        gtwiz_reset_clk_freerun_in => clk_7p68                    , --: in std_logic;
        hires_clk                  => hires_clk                   , --: in  std_logic;
        hires_clk_ok               => hires_clk_ok                , --: in  std_logic;
        qpll_select                => '0'                         , --: in  std_logic;
        core_is_master             => core_is_master(2)           , --: in  std_logic;
        recclk_ok                  => recclk_ok(2)                , --: out std_logic;
        txoutclk                   => txoutclk_i(2)               , --: out std_logic;
        mmcm_rst                   => mmcm_rst(2)                 , --: out std_logic;  --Signal to reset mmcm in clocking module
        rxoutclk                   => rxoutclk_i(2)               , --: out std_logic;
        rxrecclkout                => rxrecclkout(2)              , --: out std_logic;
        txresetdone_out            => txresetdone_i(2)            , --: out std_logic;

        --Ports for phase_alignment module
        txdlyen_in                 => txdlyen_vec(0)              , --: in  std_logic;
        txphinit_in                => txphinit_vec(0)             , --: in  std_logic;
        phase_alignment_done_in    => '1'                         , --: in  std_logic;
        txdlysreset_in             => txdlysreset_vec(0)          , --: in  std_logic;
        txphalign_in               => txphalign_vec(0)            , --: in  std_logic;
        txphaligndone_out          => txphaligndone(2)            , --: out std_logic;
        txdlysresetdone_out        => txdlysresetdone(2)          , --: out std_logic;
        txsyncdone_out             => open                        , --: out std_logic;
        txphinitdone_out           => txphinitdone_out(2)         , --: out std_logic);
        rx_rsfec_enable_ch         => rx_rsfec_enable(2)          , --: out std_logic;
        rx_rec_clk_ch              => rx_rec_clk(2)               , --: out std_logic;
        rx_serdes_data_ch          => rx_serdes_data(2)           , --: out std_logic_vector(63 downto 0);
        rx_serdes_head_ch          => rx_serdes_head(2)           , --: out std_logic_vector( 1 downto 0);
        rx_gbx_slip_ch             => rx_gbx_slip(2)              , --: in  std_logic;
        cdc_reset_ch               => cdc_reset(2)                , --: out std_logic;
        fifo_fill_level_ch         => fifo_fill_level(2)          , --: out std_logic_vector( 8 downto 0);
        average_ch                 => average(2)                  , --: in  std_logic_vector(16 downto 0);
        average_rdy_ch             => average_rdy(2)              , --: in  std_logic;
        average_ack_ch             => average_ack(2)              , --: out std_logic;
        fifo_error_ch              => fifo_error(2)               , --: in  std_logic;
        cdc_rxdata_ch              => cdc_rxdata(2)               , --: in  std_logic_vector(63 downto 0);
        cdc_rxheader_ch            => cdc_rxheader(2)             , --: in  std_logic_vector( 1 downto 0);
        pcs_txclk_ch               => clk_368p64                  , --: in  std_logic;
        pcs_txclk_ok_ch            => cpri_mmcm_locked            , --: in  std_logic;
        pcs_rxdata_ch              => pcs_rxdata(2)               , --: in  std_logic_vector(63 downto 0);
        pcs_rxheader_ch            => pcs_rxheader(2)             , --: in  std_logic_vector( 1 downto 0);
        pcs_rxheadervalid_ch       => pcs_rxheadervalid(2)        , --: in  std_logic;
        stat_rx_align_status_ch    => stat_rx_align_status(2)     , --: in  std_logic;
        stat_cw_inc_ch             => stat_cw_inc(2)              , --: in  std_logic;
        stat_corrected_cw_inc_ch   => stat_corrected_cw_inc(2)    , --: in  std_logic;
        stat_uncorrected_cw_inc_ch => stat_uncorrected_cw_inc(2)  , --: in  std_logic;
        hfec_fifo_latency_ch       => hfec_fifo_latency(2)        , --: in  std_logic_vector(15 downto 0);
        hfec_fifo_latency_rdy_ch   => hfec_fifo_latency_rdy(2)    , --: in  std_logic;
        hfec_fifo_latency_ack_ch   => hfec_fifo_latency_ack(2)   ); --: out std_logic);
		
cpri_blk_3 : entity work.cpri_24g_3
    port map (
        -- Additional Debug Ports
        -- DRP Access
        gt_drpdaddr                => "00" & x"00"                , --: in  std_logic_vector(9 downto 0);
        gt_drpdi                   => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        gt_drpen                   => '0'                         , --: in  std_logic;
        gt_drpwe                   => '0'                         , --: in  std_logic;
        gt_drpdo                   => open                        , --: out std_logic_vector(15 downto 0);
        gt_drprdy                  => open                        , --: out std_logic;
        -- TX Reset and Initialization
        gt_txpmareset              => gt_txpma_rst(3)             , --: in  std_logic;
        gt_txpcsreset              => gt_txpcs_rst(3)             , --: in  std_logic;
        gt_txresetdone             => gt_txresetdone(3)           , --: out std_logic;
        -- RX Reset and Initialization
        gt_rxpmareset              => gt_rxpma_rst(3)             , --: in  std_logic;
        gt_rxpcsreset              => gt_rxpcs_rst(3)             , --: in  std_logic;
        gt_rxpmaresetdone          => open                        , --: out std_logic;
        gt_rxresetdone             => gt_rxresetdone(3)           , --: out std_logic;
        -- Clocking
        gt_txphaligndone           => open                        , --: out std_logic;
        gt_txphinitdone            => open                        , --: out std_logic;
        gt_txdlysresetdone         => open                        , --: out std_logic;
        gt_rxphaligndone           => open                        , --: out std_logic;
        gt_rxdlysresetdone         => open                        , --: out std_logic;
        gt_rxsyncdone              => open                        , --: out std_logic;
        gt_cplllock                => open                        , --: out std_logic;
        -- Signal Integrity and Functionality
        gt_rxrate                  => "000"                       , --: in  std_logic_vector(2 downto 0);
        gt_eyescantrigger          => '0'                         , --: in  std_logic;
        gt_eyescanreset            => '0'                         , --: in  std_logic;
        gt_eyescandataerror        => open                        , --: out std_logic;
        gt_rxpolarity              => '0'                         , --: in  std_logic;
        gt_txpolarity              => '0'                         , --: in  std_logic;
        gt_rxdfelpmreset           => '0'                         , --: in  std_logic;
        gt_rxlpmen                 => gt_rxlpmen(3)               , --: in  std_logic;
        gt_txprecursor             => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txpostcursor            => "00000"                     , --: in  std_logic_vector(4 downto 0);
        gt_txdiffctrl              => gt_txdiffctrl(3)            , --: in  std_logic_vector(4 downto 0);
        gt_txprbsforceerr          => '0'                         , --: in  std_logic;
        gt_txprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbssel               => "0000"                      , --: in  std_logic_vector(3 downto 0);
        gt_rxprbserr               => open                        , --: out std_logic;
        gt_rxprbscntreset          => '0'                         , --: in  std_logic;
        gt_rxcdrhold               => '0'                         , --: in  std_logic;
        gt_dmonitorout             => open                        , --: out std_logic_vector(15 downto 0);
        gt_rxheader                => open                        , --: out std_logic_vector(1 downto 0);
        gt_rxheadervalid           => open                        , --: out std_logic;

        gt_rxdisperr               => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxnotintable            => open                        , --: out std_logic_vector(7 downto 0);
        gt_rxcommadet              => open                        , --: out std_logic;
        gt_pcsrsvdin               => x"0000"                     , --: in  std_logic_vector(15 downto 0);
        ----------------- END OF DEBUG PORTS -----------------

        -- Transceiver monitor interface
        txdata                     => open                        , --: out std_logic_vector(63 downto 0);
        txcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        txheader                   => open                        , --: out std_logic_vector(1 downto 0);
        txsequence                 => open                        , --: out std_logic_vector(6 downto 0);
        rxdata                     => open                        , --: out std_logic_vector(63 downto 0);
        rxchariscomma              => open                        , --: out std_logic_vector(7 downto 0);
        rxcharisk                  => open                        , --: out std_logic_vector(7 downto 0);
        rxdisperr                  => open                        , --: out std_logic_vector(7 downto 0);
        rxnotintable               => open                        , --: out std_logic_vector(7 downto 0);
        rxdatavalid                => open                        , --: out std_logic;
        rxheader                   => open                        , --: out std_logic_vector(1 downto 0);
        rxheadervalid              => open                        , --: out std_logic;
        rxgearboxslip              => open                        , --: out std_logic;
        reset                      => reset_s                     , --: in  std_logic;

        -- I/Q interface
        iq_tx_enable               => iq_tx_en(3)                 , --: out std_logic;
        basic_frame_first_word     => bffw(3)                     , --: out std_logic;
        iq_tx                      => iq_tx(3)                    , --: in  std_logic_vector(63 downto 0);
        iq_rx                      => iq_rx(3)                    , --: out std_logic_vector(63 downto 0);

        -- GT Common Ports
        qpll0clk_in                => common_qpll0clk             , --: in  std_logic;
        qpll0refclk_in             => common_qpll0refclk          , --: in  std_logic;
        qpll1clk_in                => common_qpll1clk             , --: in  std_logic;
        qpll1refclk_in             => common_qpll1refclk          , --: in  std_logic;
        qpll0lock_in               => common_qpll0lock            , --: in  std_logic;
        qpll0_pd                   => common_qpll0_pd(3)          , --: out std_logic;
        qpll1lock_in               => common_qpll1lock            , --: in  std_logic;
        qpll1_pd                   => common_qpll1_pd(3)          , --: out std_logic;

        -- Vendor Specific Data
        vendor_tx_data             => vendor_tx_data(3)           , --: in  std_logic_vector(127 downto 0);
        vendor_tx_xs               => vendor_tx_xs(3)             , --: out std_logic_vector(1 downto 0);
        vendor_tx_ns               => vendor_tx_ns(3)             , --: out std_logic_vector(5 downto 0);
        vendor_rx_data             => vendor_rx_data(3)           , --: out std_logic_vector(127 downto 0);
        vendor_rx_xs               => vendor_rx_xs(3)             , --: out std_logic_vector(1 downto 0);
        vendor_rx_ns               => vendor_rx_ns(3)             , --: out std_logic_vector(5 downto 0);
        vs_negotiation_complete    => '1'                         , --: in  std_logic;

        -- Synchronization
        nodebfn_tx_strobe          => nodebfn_tx_strobe(3)        , --: in  std_logic;
        nodebfn_tx_nr              => nodebfn_tx_nr(3)            , --: in  std_logic_vector(11 downto 0);
        nodebfn_rx_strobe          => nodebfn_rx_strobe(3)        , --: out std_logic;
        nodebfn_rx_nr              => nodebfn_rx_nr(3)            , --: out std_logic_vector(11 downto 0);

        -- Ethernet interface
        tx_axis_eth_tdata          => tx_axis_eth_tdata(3)        , --: in  std_logic_vector(7 downto 0);
        tx_axis_eth_tvalid         => tx_axis_eth_tvalid(3)       , --: in  std_logic;
        tx_axis_eth_tuser          => tx_axis_eth_tuser(3)        , --: in  std_logic;
        tx_axis_eth_tlast          => tx_axis_eth_tlast(3)        , --: in  std_logic;
        tx_axis_eth_tready         => tx_axis_eth_tready(3)       , --: out std_logic;

        rx_axis_eth_tdata          => rx_axis_eth_tdata(3)        , --: out std_logic_vector(7 downto 0);
        rx_axis_eth_tvalid         => rx_axis_eth_tvalid(3)       , --: out std_logic;
        rx_axis_eth_tuser          => rx_axis_eth_tuser(3)        , --: out std_logic;
        rx_axis_eth_tlast          => rx_axis_eth_tlast(3)        , --: out std_logic;

        -- HDLC interface
        hdlc_rx_data               => open                        , --: out std_logic;
        hdlc_tx_data               => '0'                         , --: in  std_logic;
        hdlc_rx_data_valid         => open                        , --: out std_logic;
        hdlc_tx_enable             => open                        , --: out std_logic;

        -- Status interface
        stat_alarm                 => stat_alarm(3)               , --: out std_logic;
        stat_code                  => stat_code(3)                , --: out std_logic_vector(3 downto 0);
        stat_speed                 => stat_speed_i(3)             , --: out std_logic_vector(10 downto 0);
        reset_request_in           => '0'                         , --: in  std_logic;
        sdi_request_in             => '0'                         , --: in  std_logic;
        reset_acknowledge_out      => open                        , --: out std_logic;
        sdi_request_out            => open                        , --: out std_logic;
        local_los                  => local_los_buf(3)            , --: out std_logic;
        local_lof                  => local_lof_buf(3)            , --: out std_logic;
        local_rai                  => open                        , --: out std_logic;
        remote_los                 => open                        , --: out std_logic;
        remote_lof                 => open                        , --: out std_logic;
        remote_rai                 => open                        , --: out std_logic;
        fifo_transit_time          => open                        , --: out std_logic_vector(13 downto 0);
        coarse_timer_value         => open                        , --: out std_logic_vector(CPRI_NUM downto 0);
        barrel_shift_value         => open                        , --: out std_logic_vector(6 downto 0);
        tx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        rx_gb_latency_value        => open                        , --: out std_logic_vector(15 downto 0);
        hyperframe_number          => hyperframe_number(3)        , --: out std_logic_vector(7 downto 0);

        -- AXI-Lite Interface
        -----------------
        s_axi_aclk                 => s_axi_aclk                  , --: in  std_logic;
        s_axi_aresetn              => s_axi_aresetn               , --: in  std_logic;
        s_axi_awaddr               => s_axi_awaddr(3)             , --: in  std_logic_vector(11 downto 0);
        s_axi_awvalid              => s_axi_awvalid(3)            , --: in  std_logic;
        s_axi_awready              => s_axi_awready(3)            , --: out std_logic;
        s_axi_wdata                => s_axi_wdata(3)              , --: in  std_logic_vector(31 downto 0);
        s_axi_wvalid               => s_axi_wvalid(3)             , --: in  std_logic;
        s_axi_wready               => s_axi_wready(3)             , --: out std_logic;
        s_axi_bresp                => s_axi_bresp(3)              , --: out std_logic_vector(1 downto 0);
        s_axi_bvalid               => s_axi_bvalid(3)             , --: out std_logic;
        s_axi_bready               => s_axi_bready(3)             , --: in  std_logic;
        s_axi_araddr               => s_axi_araddr(3)             , --: in  std_logic_vector(11 downto 0);
        s_axi_arvalid              => s_axi_arvalid(3)            , --: in  std_logic;
        s_axi_arready              => s_axi_arready(3)            , --: out std_logic;
        s_axi_rdata                => s_axi_rdata(3)              , --: out std_logic_vector(31 downto 0);
        s_axi_rresp                => s_axi_rresp(3)              , --: out std_logic_vector(1 downto 0);
        s_axi_rvalid               => s_axi_rvalid(3)             , --: out std_logic;
        s_axi_rready               => s_axi_rready(3)             , --: in  std_logic;
        l1_timer_expired           => '0'                         , --: in  std_logic;

        -- Transceiver signals
        txp                        => txp(3)                      , --: out std_logic;
        txn                        => txn(3)                      , --: out std_logic;
        rxp                        => rxp(3)                      , --: in  std_logic;
        rxn                        => rxn(3)                      , --: in  std_logic;
        lossoflight                => sfp_los(3)                  , --: in  std_logic;
        txinhibit                  => txinhibit(3)                , --: out std_logic;

        -- Clocks
        refclk                     => refclk                      , --: in  std_logic;
        clk_in                     => clk_368p64                  , --: in  std_logic;
        clk_ok_in                  => cpri_mmcm_locked            , --: in  std_logic;
        txusrclk                   => clk_368p64                  , --: in  std_logic;
        recclk_in                  => rec_clk_i(3)                , --: in  std_logic;
        gtreset_sm_done            => gtreset_sm_done(3)          , --: out std_logic;
        userclk_tx_reset           => userclk_tx_reset(3)         , --: out std_logic;
        userclk_rx_reset           => userclk_rx_reset(3)         , --: out std_logic;
        aux_clk_out                => open                        , --: out std_logic;
        gtwiz_reset_clk_freerun_in => clk_7p68                    , --: in std_logic;
        hires_clk                  => hires_clk                   , --: in  std_logic;
        hires_clk_ok               => hires_clk_ok                , --: in  std_logic;
        qpll_select                => '0'                         , --: in  std_logic;
        core_is_master             => core_is_master(3)           , --: in  std_logic;
        recclk_ok                  => recclk_ok(3)                , --: out std_logic;
        txoutclk                   => txoutclk_i(3)               , --: out std_logic;
        mmcm_rst                   => mmcm_rst(3)                 , --: out std_logic;  --Signal to reset mmcm in clocking module
        rxoutclk                   => rxoutclk_i(3)               , --: out std_logic;
        rxrecclkout                => rxrecclkout(3)              , --: out std_logic;
        txresetdone_out            => txresetdone_i(3)            , --: out std_logic;

        --Ports for phase_alignment module
        txdlyen_in                 => txdlyen_vec(0)              , --: in  std_logic;
        txphinit_in                => txphinit_vec(0)             , --: in  std_logic;
        phase_alignment_done_in    => '1'                         , --: in  std_logic;
        txdlysreset_in             => txdlysreset_vec(0)          , --: in  std_logic;
        txphalign_in               => txphalign_vec(0)            , --: in  std_logic;
        txphaligndone_out          => txphaligndone(3)            , --: out std_logic;
        txdlysresetdone_out        => txdlysresetdone(3)          , --: out std_logic;
        txsyncdone_out             => open                        , --: out std_logic;
        txphinitdone_out           => txphinitdone_out(3)         , --: out std_logic);
        rx_rsfec_enable_ch         => rx_rsfec_enable(3)          , --: out std_logic;
        rx_rec_clk_ch              => rx_rec_clk(3)               , --: out std_logic;
        rx_serdes_data_ch          => rx_serdes_data(3)           , --: out std_logic_vector(63 downto 0);
        rx_serdes_head_ch          => rx_serdes_head(3)           , --: out std_logic_vector( 1 downto 0);
        rx_gbx_slip_ch             => rx_gbx_slip(3)              , --: in  std_logic;
        cdc_reset_ch               => cdc_reset(3)                , --: out std_logic;
        fifo_fill_level_ch         => fifo_fill_level(3)          , --: out std_logic_vector( 8 downto 0);
        average_ch                 => average(3)                  , --: in  std_logic_vector(16 downto 0);
        average_rdy_ch             => average_rdy(3)              , --: in  std_logic;
        average_ack_ch             => average_ack(3)              , --: out std_logic;
        fifo_error_ch              => fifo_error(3)               , --: in  std_logic;
        cdc_rxdata_ch              => cdc_rxdata(3)               , --: in  std_logic_vector(63 downto 0);
        cdc_rxheader_ch            => cdc_rxheader(3)             , --: in  std_logic_vector( 1 downto 0);
        pcs_txclk_ch               => clk_368p64                  , --: in  std_logic;
        pcs_txclk_ok_ch            => cpri_mmcm_locked            , --: in  std_logic;
        pcs_rxdata_ch              => pcs_rxdata(3)               , --: in  std_logic_vector(63 downto 0);
        pcs_rxheader_ch            => pcs_rxheader(3)             , --: in  std_logic_vector( 1 downto 0);
        pcs_rxheadervalid_ch       => pcs_rxheadervalid(3)        , --: in  std_logic;
        stat_rx_align_status_ch    => stat_rx_align_status(3)     , --: in  std_logic;
        stat_cw_inc_ch             => stat_cw_inc(3)              , --: in  std_logic;
        stat_corrected_cw_inc_ch   => stat_corrected_cw_inc(3)    , --: in  std_logic;
        stat_uncorrected_cw_inc_ch => stat_uncorrected_cw_inc(3)  , --: in  std_logic;
        hfec_fifo_latency_ch       => hfec_fifo_latency(3)        , --: in  std_logic_vector(15 downto 0);
        hfec_fifo_latency_rdy_ch   => hfec_fifo_latency_rdy(3)    , --: in  std_logic;
        hfec_fifo_latency_ack_ch   => hfec_fifo_latency_ack(3)   ); --: out std_logic);
-- end generate;


all_clk_locked  <= cpri_mmcm_locked and hires_clk_ok;

  cpri_hard_fec_blk : entity work.cpri_hard_fec_wrapper
    port map (
      -- Control
      rx_fast_clk                    => clk_368p64                , --: IN STD_LOGIC;
      rsfec_clk                      => clk_294p912               , --: IN STD_LOGIC;
      hires_clk                      => hires_clk                 , --: IN STD_LOGIC;
      all_clk_locked                 => all_clk_locked            , --: IN STD_LOGIC;
      rx_fast_reset                  => reset                     , --: IN STD_LOGIC;
      rx_rsfec_enable_ch0            => rx_rsfec_enable(0)        , --: IN STD_LOGIC;
      rx_rsfec_enable_ch1            => rx_rsfec_enable(1)        , --: IN STD_LOGIC;
      rx_rsfec_enable_ch2            => rx_rsfec_enable(2)        , --: IN STD_LOGIC;
      rx_rsfec_enable_ch3            => rx_rsfec_enable(3)        , --: IN STD_LOGIC;
      rsfec_enable_correction        => '1'                       , --: IN STD_LOGIC;
      rsfec_enable_indication        => '1'                       , --: IN STD_LOGIC;

      -- Data Ingress --
      rx_rec_clk_ch0                 => rx_rec_clk(0)             , --: IN STD_LOGIC;
      rx_serdes_data_ch0             => rx_serdes_data(0)         , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      rx_serdes_head_ch0             => rx_serdes_head(0)         , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rx_gbx_slip_ch0                => rx_gbx_slip(0)            , --: OUT STD_LOGIC;

      rx_rec_clk_ch1                 => rx_rec_clk(1)             , --: IN STD_LOGIC;
      rx_serdes_data_ch1             => rx_serdes_data(1)         , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      rx_serdes_head_ch1             => rx_serdes_head(1)         , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rx_gbx_slip_ch1                => rx_gbx_slip(1)            , --: OUT STD_LOGIC;

      rx_rec_clk_ch2                 => rx_rec_clk(2)             , --: IN STD_LOGIC;
      rx_serdes_data_ch2             => rx_serdes_data(2)         , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      rx_serdes_head_ch2             => rx_serdes_head(2)         , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rx_gbx_slip_ch2                => rx_gbx_slip(2)            , --: OUT STD_LOGIC;

      rx_rec_clk_ch3                 => rx_rec_clk(3)             , --: IN STD_LOGIC;
      rx_serdes_data_ch3             => rx_serdes_data(3)         , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      rx_serdes_head_ch3             => rx_serdes_head(3)         , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rx_gbx_slip_ch3                => rx_gbx_slip(3)            , --: OUT STD_LOGIC;

      -- CDC FIFO control and status --
      cdc_reset_ch0                  => cdc_reset(0)              , --: IN STD_LOGIC;
      cdc_reset_ch1                  => cdc_reset(1)              , --: IN STD_LOGIC;
      cdc_reset_ch2                  => cdc_reset(2)              , --: IN STD_LOGIC;
      cdc_reset_ch3                  => cdc_reset(3)              , --: IN STD_LOGIC;
      fifo_fill_level_ch0            => fifo_fill_level(0)        , --: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      fifo_fill_level_ch1            => fifo_fill_level(1)        , --: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      fifo_fill_level_ch2            => fifo_fill_level(2)        , --: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      fifo_fill_level_ch3            => fifo_fill_level(3)        , --: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      average_ch0                    => average(0)                , --: OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      average_ch1                    => average(1)                , --: OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      average_ch2                    => average(2)                , --: OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      average_ch3                    => average(3)                , --: OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      average_rdy_ch0                => average_rdy(0)            , --: OUT STD_LOGIC;
      average_rdy_ch1                => average_rdy(1)            , --: OUT STD_LOGIC;
      average_rdy_ch2                => average_rdy(2)            , --: OUT STD_LOGIC;
      average_rdy_ch3                => average_rdy(3)            , --: OUT STD_LOGIC;
      average_ack_ch0                => average_ack(0)            , --: IN STD_LOGIC;
      average_ack_ch1                => average_ack(1)            , --: IN STD_LOGIC;
      average_ack_ch2                => average_ack(2)            , --: IN STD_LOGIC;
      average_ack_ch3                => average_ack(3)            , --: IN STD_LOGIC;
      fifo_error_ch0                 => fifo_error(0)             , --: OUT STD_LOGIC;
      fifo_error_ch1                 => fifo_error(1)             , --: OUT STD_LOGIC;
      fifo_error_ch2                 => fifo_error(2)             , --: OUT STD_LOGIC;
      fifo_error_ch3                 => fifo_error(3)             , --: OUT STD_LOGIC;

      -- CDC FIFO output (no FEC decode) --
      cdc_rxdata_ch0                 => cdc_rxdata(0)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      cdc_rxheader_ch0               => cdc_rxheader(0)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      cdc_rxdata_ch1                 => cdc_rxdata(1)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      cdc_rxheader_ch1               => cdc_rxheader(1)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      cdc_rxdata_ch2                 => cdc_rxdata(2)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      cdc_rxheader_ch2               => cdc_rxheader(2)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      cdc_rxdata_ch3                 => cdc_rxdata(3)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      cdc_rxheader_ch3               => cdc_rxheader(3)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

      -- Data and status Egress --
      pcs_rxdata_ch0                 => pcs_rxdata(0)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      pcs_rxheader_ch0               => pcs_rxheader(0)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pcs_rxheadervalid_ch0          => pcs_rxheadervalid(0)      , --: OUT STD_LOGIC;
      stat_rx_align_status_ch0       => stat_rx_align_status(0)   , --: OUT STD_LOGIC;
      stat_cw_inc_ch0                => stat_cw_inc(0)            , --: OUT STD_LOGIC;
      stat_corrected_cw_inc_ch0      => stat_corrected_cw_inc(0)  , --: OUT STD_LOGIC;
      stat_uncorrected_cw_inc_ch0    => stat_uncorrected_cw_inc(0), --: OUT STD_LOGIC;
      hfec_fifo_latency_ch0          => hfec_fifo_latency(0)      , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      hfec_fifo_latency_rdy_ch0      => hfec_fifo_latency_rdy(0)  , --: OUT STD_LOGIC;
      hfec_fifo_latency_ack_ch0      => hfec_fifo_latency_ack(0)  , --: IN STD_LOGIC;

      pcs_rxdata_ch1                 => pcs_rxdata(1)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      pcs_rxheader_ch1               => pcs_rxheader(1)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pcs_rxheadervalid_ch1          => pcs_rxheadervalid(1)      , --: OUT STD_LOGIC;
      stat_rx_align_status_ch1       => stat_rx_align_status(1)   , --: OUT STD_LOGIC;
      stat_cw_inc_ch1                => stat_cw_inc(1)            , --: OUT STD_LOGIC;
      stat_corrected_cw_inc_ch1      => stat_corrected_cw_inc(1)  , --: OUT STD_LOGIC;
      stat_uncorrected_cw_inc_ch1    => stat_uncorrected_cw_inc(1), --: OUT STD_LOGIC;
      hfec_fifo_latency_ch1          => hfec_fifo_latency(1)      , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      hfec_fifo_latency_rdy_ch1      => hfec_fifo_latency_rdy(1)  , --: OUT STD_LOGIC;
      hfec_fifo_latency_ack_ch1      => hfec_fifo_latency_ack(1)  , --: IN STD_LOGIC;

      pcs_rxdata_ch2                 => pcs_rxdata(2)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      pcs_rxheader_ch2               => pcs_rxheader(2)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pcs_rxheadervalid_ch2          => pcs_rxheadervalid(2)      , --: OUT STD_LOGIC;
      stat_rx_align_status_ch2       => stat_rx_align_status(2)   , --: OUT STD_LOGIC;
      stat_cw_inc_ch2                => stat_cw_inc(2)            , --: OUT STD_LOGIC;
      stat_corrected_cw_inc_ch2      => stat_corrected_cw_inc(2)  , --: OUT STD_LOGIC;
      stat_uncorrected_cw_inc_ch2    => stat_uncorrected_cw_inc(2), --: OUT STD_LOGIC;
      hfec_fifo_latency_ch2          => hfec_fifo_latency(2)      , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      hfec_fifo_latency_rdy_ch2      => hfec_fifo_latency_rdy(2)  , --: OUT STD_LOGIC;
      hfec_fifo_latency_ack_ch2      => hfec_fifo_latency_ack(2)  , --: IN STD_LOGIC;

      pcs_rxdata_ch3                 => pcs_rxdata(3)             , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      pcs_rxheader_ch3               => pcs_rxheader(3)           , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pcs_rxheadervalid_ch3          => pcs_rxheadervalid(3)      , --: OUT STD_LOGIC;
      stat_rx_align_status_ch3       => stat_rx_align_status(3)   , --: OUT STD_LOGIC;
      stat_cw_inc_ch3                => stat_cw_inc(3)            , --: OUT STD_LOGIC;
      stat_corrected_cw_inc_ch3      => stat_corrected_cw_inc(3)  , --: OUT STD_LOGIC;
      stat_uncorrected_cw_inc_ch3    => stat_uncorrected_cw_inc(3), --: OUT STD_LOGIC;
      hfec_fifo_latency_ch3          => hfec_fifo_latency(3)      , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      hfec_fifo_latency_rdy_ch3      => hfec_fifo_latency_rdy(3)  , --: OUT STD_LOGIC;
      hfec_fifo_latency_ack_ch3      => hfec_fifo_latency_ack(3)  ); --: IN STD_LOGIC;


---------------------------------------------------------------------
-- Instantiate Shared Clocking Module
-- Clocks from this module can be used to share with other CL modules
---------------------------------------------------------------------

  cpri_shared_clocks_i : entity work.cpri_24g_clocking
  port map (
    reset                 => reset_s          ,  --: in  std_logic;
    stable_clk            => s_axi_aclk       ,  --: in  std_logic;
    txresetdone_in        => txresetdone_i(0) ,  --: in  std_logic;
    speed_select          => stat_speed       ,  --: in  std_logic_vector(14 downto 0);
    reset_phalignment_out => reset_phalignment); --: out std_logic;


CPRI_RX_CLOCKING_BANK : for n IN 0 to CPRI_NUM generate
rxusrclk_bufg0 : BUFG_GT
port map (
    I               => rxoutclk_i(n),
    CE              => '1',
    CEMASK          => '0',
    CLR             => userclk_rx_reset(n),
    CLRMASK         => '0',
    DIV             => "000",
    O               => rec_clk_i(n));
end generate;

core_clk_i <= clk_368p64;


cpri_shared_resets_i : entity work.cpri_24g_resets port map (
    aux_clk    => s_axi_aclk ,  --: in  std_logic;
    reset      => reset_s    ,  --: in  std_logic;
    qpll_reset => pll_reset  ); --: out std_logic);

---------------------------------------------------------------------
-- Instantiate Common Phase Alignment Module
---------------------------------------------------------------------

cpri_shared_alignment_i : entity work.cpri_24g_tx_alignment
  generic map (
    MASTER_LANE_ID => 0)
port map (
    stable_clk              => s_axi_aclk               , --: in  std_logic;
    reset_phalignment       => reset_phalignment        , --: in  std_logic;
    txphaligndone_vec       => txphaligndone_vec        , --: in  std_logic_vector(3 downto 0);
    txphinitdone_vec        => txphinitdone_vec         , --: in  std_logic_vector(3 downto 0);
    txdlysresetdone_vec     => txdlysresetdone_vec      , --: in  std_logic_vector(3 downto 0);
    txphinit_vec            => txphinit_vec             , --: out std_logic_vector(3 downto 0);
    phase_alignment_done    => phase_alignment_done_int , --: out std_logic := '0';
    txdlysreset_vec         => txdlysreset_vec          , --: out std_logic_vector(3 downto 0);
    txphalign_vec           => txphalign_vec            , --: out std_logic_vector(3 downto 0);
    txdlyen_vec             => txdlyen_vec              );--: out std_logic_vector(3 downto 0));


    txphaligndone_in                <= txphalign_out;
    txdlysresetdone_in              <= txdlysreset_out;
    txphinitdone_in                 <= txphinit_out;
    txdlysresetdone_vec(0)          <= txdlysresetdone(0);
    txphaligndone_vec(0)            <= txphaligndone(0);
    txphinitdone_vec(0)             <= txphinitdone_out(0);
    txdlysresetdone_vec(3 downto 1) <= txdlysresetdone_in;
    txphaligndone_vec(3 downto 1)   <= txphaligndone_in;
    txphinitdone_vec(3 downto 1)    <= txphinitdone_in;
    txphinit_out                    <= txphinit_vec(3 downto 1);
    txdlysreset_out                 <= txdlysreset_vec(3 downto 1);
    txphalign_out                   <= txphalign_vec(3 downto 1);

    txdlyen_vec          <= txdlyen_vec;
    txphinit_vec         <= txphinit_vec;
    txdlysreset_vec      <= txdlysreset_vec;
    txphalign_vec        <= txphalign_vec;
    phase_alignment_done <= phase_alignment_done;


---------------------------------------------------------------------
-- Instantiate Common GT Module
---------------------------------------------------------------------
cpri_gt_common : entity work.cpri_24g_gt_gtye4_common_wrapper
generic map (SIM_VERSION => "4.0")
port map (
    GTREFCLK0_IN       => refclk              , --: in  std_logic;
    QPLL0RESET_IN      => pll_reset           , --: in  std_logic;
    QPLL0LOCKDETCLK_IN => s_axi_aclk          , --: in  std_logic;
    QPLL1RESET_IN      => pll_reset           , --: in  std_logic;
    QPLL1LOCKDETCLK_IN => s_axi_aclk          , --: in  std_logic;
    QPLL0PD_IN         => common_qpll0_pd(0)  , --: in  std_logic;
    QPLL1PD_IN         => common_qpll1_pd(0)  , --: in  std_logic;
    QPLL0LOCK_OUT      => common_qpll0lock    , --: out std_logic;
    QPLL0OUTCLK_OUT    => common_qpll0clk     , --: out std_logic;
    QPLL0OUTREFCLK_OUT => common_qpll0refclk  , --: out std_logic;
    QPLL1LOCK_OUT      => common_qpll1lock    , --: out std_logic;
    QPLL1OUTCLK_OUT    => common_qpll1clk     , --: out std_logic;
    QPLL1OUTREFCLK_OUT => common_qpll1refclk  , --: out std_logic;
    speed_select       => stat_speed          ); --: in std_logic_vector(14 downto 0)


qpll_lock_out    <= common_qpll0lock;




-----------------------------------------------------------------------------------------------------

vendor_stim_bank : for n IN 0 to CPRI_NUM generate
vendor_stim_blk : entity work.vendor_stim
port map(
    clk            => core_clk_i        , --: in std_logic;
    rst            => vs_rst(n)         , --: in std_logic;
    iq_tx_enable   => iq_tx_en(n)       , --: in std_logic;
    bffw           => bffw(n)           , --: in std_logic;
    vs_tx_0_16_0   => vs_tx_0_16_0(n)   , --: in std_logic_vector( 31 downto 0);
    vs_tx_0_16_1   => vs_tx_0_16_1(n)   , --: in std_logic_vector( 31 downto 0); --mu port number
    vs_tx_0_16_2   => vs_tx_0_16_2(n)   , --: in std_logic_vector( 31 downto 0); --hu port number
    vs_tx_0_16_3   => vs_tx_0_16_3(n)   , --: in std_logic_vector( 31 downto 0); --mu l1 reset
    vendor_tx_data => vendor_tx_data(n) , --: out std_logic_vector(127 downto 0);
    vendor_tx_xs   => vendor_tx_xs(n)   , --: in std_logic_vector(  1 downto 0);
    vendor_tx_ns   => vendor_tx_ns(n)   , --: in std_logic_vector(  5 downto 0);
    vendor_rx_data => vendor_rx_data(n) , --: in std_logic_vector(127 downto 0);
    vendor_rx_xs   => vendor_rx_xs(n)   , --: in std_logic_vector(  1 downto 0);
    vendor_rx_ns   => vendor_rx_ns(n)   , --: in std_logic_vector(  5 downto 0);
    vs_rx_0_16_0   => vs_rx_0_16_0(n)   , --: out std_logic_vector( 31 downto 0);
    vs_rx_0_16_1   => vs_rx_0_16_1(n)   , --: out std_logic_vector( 31 downto 0);
    vs_rx_0_16_2   => open              , --: out std_logic_vector( 31 downto 0);
    vs_rx_0_16_3   => open              );--: out std_logic_vector( 31 downto 0));
end generate;

process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    -- ip offset
    g0_mu_id       <= vs_rx_0_16_0(0)( 3 downto  0);
    g0_mu_port_num <= vs_rx_0_16_0(0)( 7 downto  4);
    g0_hu_port_num <= vs_rx_0_16_0(0)(11 downto  8);
    g0_cascade_num <= vs_rx_0_16_0(0)(15 downto 12);

    g1_mu_id       <= vs_rx_0_16_0(1)( 3 downto  0);
    g1_mu_port_num <= vs_rx_0_16_0(1)( 7 downto  4);
    g1_hu_port_num <= vs_rx_0_16_0(1)(11 downto  8);
    g1_cascade_num <= vs_rx_0_16_0(1)(15 downto 12);

    -- cc group
    g0_du_type     <= vs_rx_0_16_1(0)(0);
    g0_module_type <= vs_rx_0_16_1(0)(2 downto 1);
    g0_op_id0      <= vs_rx_0_16_1(0)(4 downto 3);
    g0_op_id1      <= vs_rx_0_16_1(0)(6 downto 5);
    g0_band_id     <= vs_rx_0_16_1(0)(7);

    g1_du_type     <= vs_rx_0_16_1(1)(0);
    g1_module_type <= vs_rx_0_16_1(1)(2 downto 1);
    g1_op_id0      <= vs_rx_0_16_1(1)(4 downto 3);
    g1_op_id1      <= vs_rx_0_16_1(1)(6 downto 5);
    g1_band_id     <= vs_rx_0_16_1(1)(7);

    -- delay ctrl
    g0_dly_ctrl    <= vs_rx_0_16_2(0)( 7 downto  0);
    g0_l1_reset    <= vs_rx_0_16_2(0)(8);

    g1_dly_ctrl    <= vs_rx_0_16_2(1)( 7 downto  0);
    g1_l1_reset    <= vs_rx_0_16_2(1)(8);

    l1_reset       <= g0_l1_reset or g1_l1_reset;
end if;
end process;

g0_vs0_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_0(0)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_0_s(0) ); --: out std_logic_vector(bits-1 downto 0)

g0_vs1_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_1(0)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_1_s(0) ); --: out std_logic_vector(bits-1 downto 0)

g0_vs2_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_2(0)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_2_s(0) ); --: out std_logic_vector(bits-1 downto 0)


g1_vs0_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_0(1)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_0_s(1) ); --: out std_logic_vector(bits-1 downto 0)

g1_vs1_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_1(1)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_1_s(1) ); --: out std_logic_vector(bits-1 downto 0)

g1_vs2_sync_blk : entity work.d_sync
generic map(
    bits            => 32                ) --: natural := 16; -- number of bit.
port map(
    in_clk          => core_clk_i        , --: in   std_logic;
    out_clk         => clk_100m          , --: in   std_logic;
    d_in            => vs_rx_0_16_2(1)   , --: in   std_logic_vector(bits-1 downto 0);
    d_out           => vs_rx_0_16_2_s(1) ); --: out std_logic_vector(bits-1 downto 0)


process(clk_100m)
begin
if rising_edge(clk_100m) then
    -- ip offset
    mu_id(0)       <= vs_rx_0_16_0_s(0)( 3 downto  0);
    mu_port_num(0) <= vs_rx_0_16_0_s(0)( 7 downto  4);
    hu_port_num(0) <= vs_rx_0_16_0_s(0)(11 downto  8);
    cascade_num(0) <= vs_rx_0_16_0_s(0)(15 downto 12);

    mu_id(1)       <= vs_rx_0_16_0_s(1)( 3 downto  0);
    mu_port_num(1) <= vs_rx_0_16_0_s(1)( 7 downto  4);
    hu_port_num(1) <= vs_rx_0_16_0_s(1)(11 downto  8);
    cascade_num(1) <= vs_rx_0_16_0_s(1)(15 downto 12);

    -- cc group
    du_type(0)     <= vs_rx_0_16_1_s(0)(0);
    module_type(0) <= vs_rx_0_16_1_s(0)( 2 downto  1);
    op_id0(0)      <= vs_rx_0_16_1_s(0)( 4 downto  3);
    op_id1(0)      <= vs_rx_0_16_1_s(0)( 6 downto  5);
    band_id(0)     <= vs_rx_0_16_1_s(0)(7);

    du_type(1)     <= vs_rx_0_16_1_s(1)(0);
    module_type(1) <= vs_rx_0_16_1_s(1)( 2 downto  1);
    op_id0(1)      <= vs_rx_0_16_1_s(1)( 4 downto  3);
    op_id1(1)      <= vs_rx_0_16_1_s(1)( 6 downto  5);
    band_id(1)     <= vs_rx_0_16_1_s(1)(7);

    -- delay ctrl
    dly_ctrl(0)    <= vs_rx_0_16_2_s(0)( 7 downto  0);
    dly_ctrl(1)    <= vs_rx_0_16_2_s(1)( 7 downto  0);

end if;
end process;


-- ru_band_id <= '1';
-- 0 : n41
-- 1 : n77

-- ru_module_type <= "10";
-- 00 : MU
-- 01 : HU
-- 10 : LRU
-- 11 : HRU

process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    vs_tx_0_16_0(0)    <= x"0000" & g0_cascade_num & g0_hu_port_num & g0_mu_port_num & g0_mu_id;
    vs_tx_0_16_0(1)    <= x"0000" & g1_cascade_num & g1_hu_port_num & g1_mu_port_num & g1_mu_id;
    vs_tx_0_16_0(2)    <= x"0000" & ru_cascade_num & g0_hu_port_num & g0_mu_port_num & g0_mu_id;
    vs_tx_0_16_0(3)    <= x"0000" & ru_cascade_num & g1_hu_port_num & g1_mu_port_num & g1_mu_id;

    vs_tx_0_16_1(0)    <= x"000000" & ru_band_id & g0_op_id1 & g0_op_id0 & ru_module_type & g0_du_type;
    vs_tx_0_16_1(1)    <= x"000000" & ru_band_id & g1_op_id1 & g1_op_id0 & ru_module_type & g1_du_type;
    vs_tx_0_16_1(2)    <= x"000000" & ru_band_id & g0_op_id1 & g0_op_id0 & ru_module_type & g0_du_type;
    vs_tx_0_16_1(3)    <= x"000000" & ru_band_id & g1_op_id1 & g1_op_id0 & ru_module_type & g1_du_type;

    vs_tx_0_16_2(0)    <= x"00000000";
    vs_tx_0_16_2(1)    <= x"00000000";
    vs_tx_0_16_2(2)    <= x"00000" & "000" & g0_l1_reset & g0_dly_ctrl;
    vs_tx_0_16_2(3)    <= x"00000" & "000" & g1_l1_reset & g1_dly_ctrl;
end if;
end process;


-------------------------------------------------------------------------------------------------------------

STAT_CODE_BANK : for n in 0 to CPRI_NUM generate
process(s_axi_aclk)
begin
if rising_edge(s_axi_aclk) then
    if (stat_alarm(n) = '0' and stat_code(n) = "1111") then
        link_up(n) <= '1';
    else
        link_up(n) <= '0';
    end if;
end if;
end process;
end generate;

--peak_sync_blk : entity work.d_sync
--generic map(
--    bits            => 4            ) --: natural := 16; -- number of bit.
--port map(
--    in_clk          => s_axi_aclk   , --: in   std_logic;
--    out_clk         => core_clk_i   , --: in   std_logic;
--    d_in            => link_up      , --: in   std_logic_vector(bits-1 downto 0);
--    d_out           => link_up_core ); --: out std_logic_vector(bits-1 downto 0)


link_up_core    <= link_up;



MAPPER_RESET_BANK : for n in 0 to CPRI_NUM generate
process(s_axi_aclk)
begin
if rising_edge(s_axi_aclk) then
    if (link_up(n) = '0') then
        cnt_lock(n)     <= (others =>'0');
        mapper_reset(n) <= '1';
        vs_rst(n)       <= '1';
    else
        if (cnt_lock(n) = "11") then
            cnt_lock(n)     <= "11";
            mapper_reset(n) <= '0';
            vs_rst(n)       <= '0';
        elsif (cnt_lock(n) = "10") then
            mapper_reset(n) <= '1';
            vs_rst(n)       <= '0';
            if (nodebfn_rx_strobe(n) = '1' and bffw(n) = '1') then
                cnt_lock(n) <= cnt_lock(n) + 1;
            end if;
        else
            mapper_reset(n) <= '1';
            if (nodebfn_rx_strobe(n) = '1' and bffw(n) = '1') then
                cnt_lock(n) <= cnt_lock(n) + 1;
            end if;
        end if;
    end if;
end if;
end process;
end generate;



 cpri_linkup <= link_up;

reset_sync_i : xpm_cdc_async_rst
  generic map (
    RST_ACTIVE_HIGH => 1)
  port map (
    src_arst  => reset,
    dest_clk  => core_clk_i,
    dest_arst => reset_i);

process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    if (reset_i = '1') then
        master_lane <= '0';
    else
        if (link_up_core(0) = '1' and link_up_core(1) = '1') then
            master_lane <= '0';
        elsif (link_up_core(0) = '1' and link_up_core(1) = '0') then
            master_lane <= '0';
        elsif (link_up_core(0) = '0' and link_up_core(1) = '1') then
            master_lane <= '1';
        else
            master_lane <= '0';
        end if;
    end if;
end if;
end process;

process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    if (reset_i = '1') then
        master_lane_cas <= '0';
    else
        if (link_up_core(2) = '1' and link_up_core(3) = '1') then
            master_lane_cas <= '0';
        elsif (link_up_core(2) = '1' and link_up_core(3) = '0') then
            master_lane_cas <= '0';
        elsif (link_up_core(2) = '0' and link_up_core(3) = '1') then
            master_lane_cas <= '1';
        else
            master_lane_cas <= '0';
        end if;
    end if;
end if;
end process;

process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    master_lane_s0 <= master_lane;
    if ((master_lane_s0 /= master_lane) or (link_up_core(1 downto 0) = "00")) then
        eth_main_rst_n   <= '0';
        eth_cnt_lock(0)  <= "00";
        eth_cnt_lock(1)  <= "00";
    else
        if (eth_cnt_lock(0) = "11") then
            eth_cnt_lock(0)   <= eth_cnt_lock(0);
        else
            if (nodebfn_rx_strobe(0) = '1' and bffw(0) = '1') then
                eth_cnt_lock(0) <= eth_cnt_lock(0) + 1;
            end if;
        end if;

        if (eth_cnt_lock(1) = "11") then
            eth_cnt_lock(1)   <= eth_cnt_lock(1);
        else
            if (nodebfn_rx_strobe(1) = '1' and bffw(1) = '1') then
                eth_cnt_lock(1) <= eth_cnt_lock(1) + 1;
            end if;
        end if;

        if (eth_cnt_lock(0) = "11" or eth_cnt_lock(1) = "11") then
            eth_main_rst_n  <= '1';
        else
            eth_main_rst_n  <= '0';
        end if;
    end if;
end if;
end process;


process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    master_lane_cas_s0 <= master_lane_cas;
    if ((master_lane_cas_s0 /= master_lane_cas) or (link_up_core(3 downto 2) = "00")) then
        eth_cas_rst_n    <= '0';
        eth_cnt_lock(2)  <= "00";
        eth_cnt_lock(3)  <= "00";
    else
        if (eth_cnt_lock(2) = "11") then
            eth_cnt_lock(2)   <= eth_cnt_lock(2);
        else
            if (nodebfn_rx_strobe(2) = '1' and bffw(2) = '1') then
                eth_cnt_lock(2) <= eth_cnt_lock(2) + 1;
            end if;
        end if;

        if (eth_cnt_lock(3) = "11") then
            eth_cnt_lock(3)   <= eth_cnt_lock(3);
        else
            if (nodebfn_rx_strobe(3) = '1' and bffw(3) = '1') then
                eth_cnt_lock(3) <= eth_cnt_lock(3) + 1;
            end if;
        end if;

        if (eth_cnt_lock(2) = "11" or eth_cnt_lock(3) = "11") then
            eth_cas_rst_n  <= '1';
        else
            eth_cas_rst_n  <= '0';
        end if;
    end if;
end if;
end process;


--eth_ctrl_to_cpu : entity work.eth_ctrl_gmii
--port map(
--    clk_125m           => clk_125m          , --: in  std_logic;
--    clk                => core_clk_i        , --: in  std_logic;
--    reset_n            => eth_main_rst_n    , --: in  std_logic;
--    gap_value          => eth_gap           , --: in  std_logic_vector(11 downto 0);
--    tx_axis_eth_tready => tx_cpu_eth_tready , --: in  std_logic;
--    tx_axis_eth_tdata  => tx_cpu_eth_tdata  , --: out std_logic_vector(7 downto 0);
--    tx_axis_eth_tvalid => tx_cpu_eth_tvalid , --: out std_logic;
--    tx_axis_eth_tlast  => tx_cpu_eth_tlast  , --: out std_logic;
--    rx_axis_eth_tready => rx_cpu_eth_tready , --: out std_logic;
--    rx_axis_eth_tdata  => rx_cpu_eth_tdata  , --: in  std_logic_vector(7 downto 0);
--    rx_axis_eth_tvalid => rx_cpu_eth_tvalid , --: in  std_logic;
--    rx_axis_eth_tlast  => rx_cpu_eth_tlast  , --: in  std_logic;
--    eth_tx_en          => eth_tx_en         , --: in  std_logic;
--    eth_txd            => eth_txd           , --: in  std_logic_vector(7 downto 0);
--    eth_rx_dv          => eth_rx_dv         , --: out std_logic;
--    eth_rxd            => eth_rxd           ); --: out std_logic_vector(7 downto 0)


eth_ctrl_to_cpu : entity work.eth_ctrl
port map(
    clk_12p5m          => clk_12p5m         , --: in  std_logic;
    clk_25m            => clk_25m           , --: in  std_logic;
    clk                => core_clk_i        , --: in  std_logic;
    reset_n            => eth_main_rst_n    , --: in  std_logic;
    gap_value          => eth_gap           , --: in  std_logic_vector( 11 downto 0);
    tx_axis_eth_tready => tx_cpu_eth_tready , --: in  std_logic;
    tx_axis_eth_tdata  => tx_cpu_eth_tdata  , --: out std_logic_vector(  7 downto  0);
    tx_axis_eth_tvalid => tx_cpu_eth_tvalid , --: out std_logic;
    tx_axis_eth_tlast  => tx_cpu_eth_tlast  , --: out std_logic;
    rx_axis_eth_tready => rx_cpu_eth_tready , --: out std_logic;
    rx_axis_eth_tdata  => rx_cpu_eth_tdata  , --: in  std_logic_vector(  7 downto  0);
    rx_axis_eth_tvalid => rx_cpu_eth_tvalid , --: in  std_logic;
    rx_axis_eth_tlast  => rx_cpu_eth_tlast  , --: in  std_logic;
    eth_tx_en          => eth_tx_en         , --: in  std_logic;
    eth_txd            => eth_txd           , --: in  std_logic_vector(  7 downto  0);
    eth_rx_dv          => eth_rx_dv         , --: out std_logic;
    eth_rxd            => eth_rxd           ); --: out std_logic_vector(  7 downto  0)




process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    if (master_lane = '0') then
        rx_mux_eth_tdata      <= rx_axis_eth_tdata(0);
        rx_mux_eth_tvalid     <= rx_axis_eth_tvalid(0);
        rx_mux_eth_tlast      <= rx_axis_eth_tlast(0);
        tx_mux_eth_tready     <= tx_axis_eth_tready(0);
        tx_axis_eth_tdata(0)  <= tx_mux_eth_tdata;
        tx_axis_eth_tvalid(0) <= tx_mux_eth_tvalid;
        tx_axis_eth_tlast(0)  <= tx_mux_eth_tlast;
    else
        rx_mux_eth_tdata      <= rx_axis_eth_tdata(1);
        rx_mux_eth_tvalid     <= rx_axis_eth_tvalid(1);
        rx_mux_eth_tlast      <= rx_axis_eth_tlast(1);
        tx_mux_eth_tready     <= tx_axis_eth_tready(1);
        tx_axis_eth_tdata(1)  <= tx_mux_eth_tdata;
        tx_axis_eth_tvalid(1) <= tx_mux_eth_tvalid;
        tx_axis_eth_tlast(1)  <= tx_mux_eth_tlast;
    end if;
end if;
end process;


process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    if (master_lane_cas = '0') then
        rx_cas_eth_tdata      <= rx_axis_eth_tdata(2);
        rx_cas_eth_tvalid     <= rx_axis_eth_tvalid(2);
        rx_cas_eth_tlast      <= rx_axis_eth_tlast(2);
        tx_cas_eth_tready     <= tx_axis_eth_tready(2);
        tx_axis_eth_tdata(2)  <= tx_cas_eth_tdata;
        tx_axis_eth_tvalid(2) <= tx_cas_eth_tvalid;
        tx_axis_eth_tlast(2)  <= tx_cas_eth_tlast;
    else
        rx_cas_eth_tdata      <= rx_axis_eth_tdata(3);
        rx_cas_eth_tvalid     <= rx_axis_eth_tvalid(3);
        rx_cas_eth_tlast      <= rx_axis_eth_tlast(3);
        tx_cas_eth_tready     <= tx_axis_eth_tready(3);
        tx_axis_eth_tdata(3)  <= tx_cas_eth_tdata;
        tx_axis_eth_tvalid(3) <= tx_cas_eth_tvalid;
        tx_axis_eth_tlast(3)  <= tx_cas_eth_tlast;
    end if;
end if;
end process;



eth_sw0 : entity work.eth_sw
generic map(
      port0_table_num       => 15                    ,
      port1_table_num       => 1                     ,
      port2_table_num       => 1                     )
port map(
    clk                     => core_clk_i            , --: in  std_logic;
    port0_rst_n             => eth_main_rst_n        , --: in  std_logic;
    port1_rst_n             => eth_main_rst_n        , --: in  std_logic;
    port2_rst_n             => eth_cas_rst_n         , --: in  std_logic;
    rx0_axis_eth_tready     => open                  , --: out std_logic;
    rx0_axis_eth_tdata      => rx_mux_eth_tdata      , --: in  std_logic_vector(7 downto 0);
    rx0_axis_eth_tvalid     => rx_mux_eth_tvalid     , --: in  std_logic;
    rx0_axis_eth_tlast      => rx_mux_eth_tlast      , --: in  std_logic;
    rx0_packet_cnt          => rx0_packet_cnt        , --: out std_logic_vector(15 downto 0);
    rx1_axis_eth_tready     => tx_cpu_eth_tready     , --: out std_logic;
    rx1_axis_eth_tdata      => tx_cpu_eth_tdata      , --: in  std_logic_vector(7 downto 0);
    rx1_axis_eth_tvalid     => tx_cpu_eth_tvalid     , --: in  std_logic;
    rx1_axis_eth_tlast      => tx_cpu_eth_tlast      , --: in  std_logic;
    rx1_packet_cnt          => rx1_packet_cnt        , --: out std_logic_vector(15 downto 0);
    rx2_axis_eth_tready     => open                  , --: out std_logic;
    rx2_axis_eth_tdata      => rx_cas_eth_tdata      , --: in  std_logic_vector(7 downto 0);
    rx2_axis_eth_tvalid     => rx_cas_eth_tvalid     , --: in  std_logic;
    rx2_axis_eth_tlast      => rx_cas_eth_tlast      , --: in  std_logic;
    rx2_packet_cnt          => rx2_packet_cnt        , --: out std_logic_vector(15 downto 0);
    tx0_axis_eth_tready     => tx_mux_eth_tready     , --: in  std_logic;
    tx0_axis_eth_tdata      => tx_mux_eth_tdata      , --: out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid     => tx_mux_eth_tvalid     , --: out std_logic;
    tx0_axis_eth_tlast      => tx_mux_eth_tlast      , --: out std_logic;
    tx0_packet_cnt          => tx0_packet_cnt        , --: out std_logic_vector(15 downto 0);
    tx1_axis_eth_tready     => rx_cpu_eth_tready     , --: in  std_logic;
    tx1_axis_eth_tdata      => rx_cpu_eth_tdata      , --: out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid     => rx_cpu_eth_tvalid     , --: out std_logic;
    tx1_axis_eth_tlast      => rx_cpu_eth_tlast      , --: out std_logic;
    tx1_packet_cnt          => tx1_packet_cnt        , --: out std_logic_vector(15 downto 0);
    tx2_axis_eth_tready     => tx_cas_eth_tready     , --: in  std_logic;
    tx2_axis_eth_tdata      => tx_cas_eth_tdata      , --: out std_logic_vector(7 downto 0);
    tx2_axis_eth_tvalid     => tx_cas_eth_tvalid     , --: out std_logic;
    tx2_axis_eth_tlast      => tx_cas_eth_tlast      , --: out std_logic;
    tx2_packet_cnt          => tx2_packet_cnt        ); --: out std_logic_vector(15 downto 0)


    tx_axis_eth_tuser(0)  <= '0';
    tx_axis_eth_tuser(1)  <= '0';
    tx_axis_eth_tuser(2)  <= '0';
    tx_axis_eth_tuser(3)  <= '0';


--bfn_strobe0(0) <= nodebfn_rx_strobe(0);
--bfn_strobe1(0) <= nodebfn_rx_strobe(1);
--
--
--NODEBFN0_DELAY : for n IN 0 to 191 generate
--process(core_clk_i)
--begin
--if rising_edge(core_clk_i) then
--    bfn_strobe0(n+1) <= bfn_strobe0(n);
--end if;
--end process;
--end generate;
--
--NODEBFN1_DELAY : for n IN 0 to 191 generate
--process(core_clk_i)
--begin
--if rising_edge(core_clk_i) then
--    bfn_strobe1(n+1) <= bfn_strobe1(n);
--end if;
--end process;
--end generate;
--
--nodebfn_tx_strobe_i(0) <= bfn_strobe0(192);
--nodebfn_tx_strobe_i(2) <= bfn_strobe0(192);
--
--nodebfn_tx_strobe_i(1) <= bfn_strobe1(192);
--nodebfn_tx_strobe_i(3) <= bfn_strobe1(192);
--
--nodebfn_tx_nr(0)       <= nodebfn_rx_nr(0);
--nodebfn_tx_nr(1)       <= nodebfn_rx_nr(1);
--nodebfn_tx_nr(2)       <= nodebfn_rx_nr(0);
--nodebfn_tx_nr(3)       <= nodebfn_rx_nr(1);

strobe_gen_bank : for n in 2 to 3 generate
strobe_gen : entity work.iq_tx_gen
  port map(
    clk                 => core_clk_i           , --: in  std_logic;
    iq_tx_enable        => iq_tx_en(n)          , --: in  std_logic;
    speed               => stat_speed_i(n)      , --: in  std_logic_vector(14 downto 0);
    nodebfn_tx_strobe   => nodebfn_tx_strobe(n) , --: out std_logic;
    nodebfn_tx_nr       => nodebfn_tx_nr(n)     ); --: out std_logic_vector(11 downto 0));

end generate;


strobe_slv_bank : for n in 0 to 1 generate
process(core_clk_i)
begin
if rising_edge(core_clk_i) then
    bfn_tx_strobe_slv(n) <= nodebfn_rx_strobe(n);
    basic_frame_first_word_r(n) <= bffw(n);
    if(bfn_tx_strobe_slv(n) = '1' and basic_frame_first_word_r(n) = '1' ) then
        bfn_tx_nr_slv(n) <= std_logic_vector(nodebfn_rx_nr(n) + 1);
    end if;
end if;
end process;

  nodebfn_tx_strobe(n) <= bfn_tx_strobe_slv(n);
  nodebfn_tx_nr(n)     <= bfn_tx_nr_slv(n);

end generate;

basic_frame_first_word <= bffw;

iq_tx_enable           <= iq_tx_en;





process(s_axi_aclk)
begin
if rising_edge(s_axi_aclk) then
    if (master_lane = '0') then
        stat_speed <= stat_speed_i(0);
    else
        stat_speed <= stat_speed_i(1);
    end if;
end if;
end process;


--   REC_CLK_MUX : BUFGMUX_CTRL
--   port map (
--      O  => recclk      ,  -- 1-bit output: Clock output
--      I0 => rec_clk_i(0),  -- 1-bit input: Clock input (S=0)
--      I1 => rec_clk_i(1),  -- 1-bit input: Clock input (S=1)
--      S  => master_lane ); -- 1-bit input: Clock select

--   xpm_cdc_single_inst : xpm_cdc_single
--   generic map (
--      DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
--      INIT_SYNC_FF => 0,   -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
--      SIM_ASSERT_CHK => 0, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
--      SRC_INPUT_REG => 1   -- DECIMAL; 0=do not register input, 1=register input
--   )
--   port map (
--      dest_out => dest_out, -- 1-bit output: src_in synchronized to the destination clock domain. This output
--                            -- is registered.
--      dest_clk => dest_clk, -- 1-bit input: Clock signal for the destination clock domain.
--      src_clk => src_clk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
--      src_in => src_in      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
--   );



   BUFGMUX_inst : BUFGMUX
   generic map (
      CLK_SEL_TYPE => "SYNC"  -- ASYNC, SYNC
   )
   port map (
      O  => recclk      ,  -- 1-bit output: Clock output
      I0 => rec_clk_i(0),  -- 1-bit input: Clock input (S=0)
      I1 => rec_clk_i(1),  -- 1-bit input: Clock input (S=1)
      S  => master_lane ); -- 1-bit input: Clock select


  stat_speed_recclk_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 15)
    port map (
      src_clk        => s_axi_aclk,
      src_in         => stat_speed,
      src_send       => src_send_rec,
      src_rcv        => src_rcv_rec,
      dest_clk       => recclk,
      dest_out       => stat_speed_i_rec,
      dest_req       => open,
      dest_ack       => '0');

  process(s_axi_aclk)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
        src_send_rec <= '1';
      elsif src_rcv_rec = '1' then
        src_send_rec <= '0';
      else
        src_send_rec <= '1';
      end if;
    end if;
  end process;

  -- Now create the divided clock to the outside world - 7.68MHz
  process(recclk)
  begin
    if rising_edge(recclk) then
      case stat_speed_i_rec is
        when "100000000000000" | "000010000000000" => -- 24.3G
          if count = 23 then    -- refclk: 7.68MHz
            recclkout_i <= not recclkout_i;
            count <= 0;
          else
            count <= count + 1;
          end if;
        when others =>                                -- 0.6G
          recclkout_i <= not recclkout_i;
      end case;
    end if;
  end process;

  -- Output 7.68MHz
  recclkout_gen : FDCE
  port map (D   => recclkout_i,
            CE  => '1',
            C   => recclk,
            CLR => '0',
            Q   => recclk_out);


end rtl;