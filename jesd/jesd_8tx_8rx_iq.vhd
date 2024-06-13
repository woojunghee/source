----------------------------------------------------------------------------------
-- company:
-- engineer:
--
-- create date: 2017/06/09 11:44:47
-- design name:
-- module name: jesd_2tx_2rx - behavioral
-- project name:
-- target devices:
-- tool versions:
-- description:
--
-- dependencies:
--
-- revision:
-- revision 0.01 - file created
-- additional comments:
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library xpm;
use xpm.vcomponents.all;
Library UNISIM;
use UNISIM.vcomponents.all;
use work.my_package.all;

entity jesd_8tx_8rx_iq is port (
    axi_aresetn     : in  std_logic;
    reset_n         : in  std_logic;
    gt_powergood    : out std_logic;
    ref_clk         : in  std_logic;
    tx_core_clk     : in  std_logic; --245.76Mhz
    rx_core_clk     : in  std_logic; --245.76Mhz
    clk_491p52      : in  std_logic; --491.52Mhz
    drpclk          : in  std_logic;
    tx_sysref       : in  std_logic;
    rx_sysref       : in  std_logic;
    meta_mode       : in  std_logic_vector(1 downto 0);
    jesd_qpll_lock  : out std_logic;
    jesd_irq        : out std_logic_vector(1 downto 0);

    adc0_i          : out std_logic_vector( 15 downto 0);
    adc0_q          : out std_logic_vector( 15 downto 0);
    adc1_i          : out std_logic_vector( 15 downto 0);
    adc1_q          : out std_logic_vector( 15 downto 0);
    adc2_i          : out std_logic_vector( 15 downto 0);
    adc2_q          : out std_logic_vector( 15 downto 0);
    adc3_i          : out std_logic_vector( 15 downto 0);
    adc3_q          : out std_logic_vector( 15 downto 0);

    fb0_i_s0        : out std_logic_vector( 15 downto 0);
    fb0_q_s0        : out std_logic_vector( 15 downto 0);
    fb0_i_s1        : out std_logic_vector( 15 downto 0);
    fb0_q_s1        : out std_logic_vector( 15 downto 0);
    fb1_i_s0        : out std_logic_vector( 15 downto 0);
    fb1_q_s0        : out std_logic_vector( 15 downto 0);
    fb1_i_s1        : out std_logic_vector( 15 downto 0);
    fb1_q_s1        : out std_logic_vector( 15 downto 0);

    dac_i_s0        : in  arr_4_16_stdlogic;
    dac_q_s0        : in  arr_4_16_stdlogic;
    dac_i_s1        : in  arr_4_16_stdlogic;
    dac_q_s1        : in  arr_4_16_stdlogic;

    txp             : out std_logic_vector( 7 downto 0);
    txn             : out std_logic_vector( 7 downto 0);

    rxp             : in  std_logic_vector( 7 downto 0);
    rxn             : in  std_logic_vector( 7 downto 0);

    axi_clk         : in  std_logic;
    rx_axi_awaddr   : in  std_logic_vector( 11 downto 0);
    rx_axi_wdata    : in  std_logic_vector( 31 downto 0);
    rx_axi_araddr   : in  std_logic_vector( 11 downto 0);
    rx_axi_awvalid  : in  std_logic;
    rx_axi_awready  : out std_logic;
    rx_axi_wvalid   : in  std_logic;
    rx_axi_wready   : out std_logic;
    rx_axi_bready   : in  std_logic;
    rx_axi_bresp    : out std_logic_vector( 1 downto 0);
    rx_axi_bvalid   : out std_logic;
    rx_axi_arvalid  : in  std_logic;
    rx_axi_arready  : out std_logic;
    rx_axi_rdata    : out std_logic_vector( 31 downto 0);
    rx_axi_rvalid   : out std_logic;
    rx_axi_rready   : in  std_logic;
    rx_axi_rresp    : out std_logic_vector( 1 downto 0);
    tx_axi_awaddr   : in  std_logic_vector( 11 downto 0);
    tx_axi_wdata    : in  std_logic_vector( 31 downto 0);
    tx_axi_araddr   : in  std_logic_vector( 11 downto 0);
    tx_axi_awvalid  : in  std_logic;
    tx_axi_awready  : out std_logic;
    tx_axi_wvalid   : in  std_logic;
    tx_axi_wready   : out std_logic;
    tx_axi_bready   : in  std_logic;
    tx_axi_bresp    : out std_logic_vector( 1 downto 0);
    tx_axi_bvalid   : out std_logic;
    tx_axi_arvalid  : in  std_logic;
    tx_axi_arready  : out std_logic;
    tx_axi_rdata    : out std_logic_vector( 31 downto 0);
    tx_axi_rvalid   : out std_logic;
    tx_axi_rready   : in  std_logic;
    tx_axi_rresp    : out std_logic_vector( 1 downto 0);

    txdiffctrl      : in  std_logic_vector( 4 downto 0);
    cw_data         : in  std_logic_vector(15 downto 0);
    rfic_loop       : in  std_logic_vector( 1 downto 0)
    );
end jesd_8tx_8rx_iq;

architecture behavioral of jesd_8tx_8rx_iq is

  signal rxp_in           : std_logic_vector( 1 downto 0);
  signal rxn_in           : std_logic_vector( 1 downto 0);

  signal txp_out          : std_logic_vector( 1 downto 0);
  signal txn_out          : std_logic_vector( 1 downto 0);

  signal adc0_i_s0        : std_logic_vector( 15 downto 0);
  signal adc1_i_s0        : std_logic_vector( 15 downto 0);
  signal adc2_i_s0        : std_logic_vector( 15 downto 0);
  signal adc3_i_s0        : std_logic_vector( 15 downto 0);
  signal adc0_q_s0        : std_logic_vector( 15 downto 0);
  signal adc1_q_s0        : std_logic_vector( 15 downto 0);
  signal adc2_q_s0        : std_logic_vector( 15 downto 0);
  signal adc3_q_s0        : std_logic_vector( 15 downto 0);
  signal adc0_i_s1        : std_logic_vector( 15 downto 0);
  signal adc1_i_s1        : std_logic_vector( 15 downto 0);
  signal adc2_i_s1        : std_logic_vector( 15 downto 0);
  signal adc3_i_s1        : std_logic_vector( 15 downto 0);
  signal adc0_q_s1        : std_logic_vector( 15 downto 0);
  signal adc1_q_s1        : std_logic_vector( 15 downto 0);
  signal adc2_q_s1        : std_logic_vector( 15 downto 0);
  signal adc3_q_s1        : std_logic_vector( 15 downto 0);

  signal fb0_i_s0_245     : std_logic_vector( 15 downto 0);
  signal fb0_i_s1_245     : std_logic_vector( 15 downto 0);
  signal fb0_i_s2_245     : std_logic_vector( 15 downto 0);
  signal fb0_i_s3_245     : std_logic_vector( 15 downto 0);
  signal fb0_q_s0_245     : std_logic_vector( 15 downto 0);
  signal fb0_q_s1_245     : std_logic_vector( 15 downto 0);
  signal fb0_q_s2_245     : std_logic_vector( 15 downto 0);
  signal fb0_q_s3_245     : std_logic_vector( 15 downto 0);

  signal fb1_i_s0_245     : std_logic_vector( 15 downto 0);
  signal fb1_i_s1_245     : std_logic_vector( 15 downto 0);
  signal fb1_i_s2_245     : std_logic_vector( 15 downto 0);
  signal fb1_i_s3_245     : std_logic_vector( 15 downto 0);
  signal fb1_q_s0_245     : std_logic_vector( 15 downto 0);
  signal fb1_q_s1_245     : std_logic_vector( 15 downto 0);
  signal fb1_q_s2_245     : std_logic_vector( 15 downto 0);
  signal fb1_q_s3_245     : std_logic_vector( 15 downto 0);

  signal tx_sof           : std_logic_vector( 3 downto 0);
  signal tx_somf          : std_logic_vector( 3 downto 0);
  signal tx_tdata         : std_logic_vector(511 downto 0);
  signal tx_tready        : std_logic;
  signal rx_sof           : std_logic_vector( 3 downto 0);
  signal rx_eof           : std_logic_vector( 3 downto 0);
  signal rx_frame_error   : std_logic_vector( 23 downto 0);
  signal gt0_rxdata       : std_logic_vector(63 downto 0);
  signal gt0_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt0_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt0_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt0_rxheader     : std_logic_vector( 1 downto 0);
  signal gt0_rxmisalign   : std_logic;
  signal gt0_rxblock_sync : std_logic;

  signal gt1_rxdata       : std_logic_vector(63 downto 0);
  signal gt1_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt1_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt1_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt1_rxheader     : std_logic_vector( 1 downto 0);
  signal gt1_rxmisalign   : std_logic;
  signal gt1_rxblock_sync : std_logic;

  signal gt2_rxdata       : std_logic_vector(63 downto 0);
  signal gt2_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt2_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt2_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt2_rxheader     : std_logic_vector( 1 downto 0);
  signal gt2_rxmisalign   : std_logic;
  signal gt2_rxblock_sync : std_logic;

  signal gt3_rxdata       : std_logic_vector(63 downto 0);
  signal gt3_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt3_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt3_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt3_rxheader     : std_logic_vector( 1 downto 0);
  signal gt3_rxmisalign   : std_logic;
  signal gt3_rxblock_sync : std_logic;

  signal gt4_rxdata       : std_logic_vector(63 downto 0);
  signal gt4_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt4_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt4_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt4_rxheader     : std_logic_vector( 1 downto 0);
  signal gt4_rxmisalign   : std_logic;
  signal gt4_rxblock_sync : std_logic;

  signal gt5_rxdata       : std_logic_vector(63 downto 0);
  signal gt5_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt5_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt5_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt5_rxheader     : std_logic_vector( 1 downto 0);
  signal gt5_rxmisalign   : std_logic;
  signal gt5_rxblock_sync : std_logic;

  signal gt6_rxdata       : std_logic_vector(63 downto 0);
  signal gt6_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt6_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt6_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt6_rxheader     : std_logic_vector( 1 downto 0);
  signal gt6_rxmisalign   : std_logic;
  signal gt6_rxblock_sync : std_logic;

  signal gt7_rxdata       : std_logic_vector(63 downto 0);
  signal gt7_rxcharisk    : std_logic_vector( 3 downto 0);
  signal gt7_rxdisperr    : std_logic_vector( 3 downto 0);
  signal gt7_rxnotintable : std_logic_vector( 3 downto 0);
  signal gt7_rxheader     : std_logic_vector( 1 downto 0);
  signal gt7_rxmisalign   : std_logic;
  signal gt7_rxblock_sync : std_logic;

  signal gt0_txdata       : std_logic_vector(63 downto 0);
  signal gt0_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt0_txheader     : std_logic_vector( 1 downto 0);
  signal gt1_txdata       : std_logic_vector(63 downto 0);
  signal gt1_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt1_txheader     : std_logic_vector( 1 downto 0);
  signal gt2_txdata       : std_logic_vector(63 downto 0);
  signal gt2_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt2_txheader     : std_logic_vector( 1 downto 0);
  signal gt3_txdata       : std_logic_vector(63 downto 0);
  signal gt3_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt3_txheader     : std_logic_vector( 1 downto 0);
  signal gt4_txdata       : std_logic_vector(63 downto 0);
  signal gt4_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt4_txheader     : std_logic_vector( 1 downto 0);
  signal gt5_txdata       : std_logic_vector(63 downto 0);
  signal gt5_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt5_txheader     : std_logic_vector( 1 downto 0);
  signal gt6_txdata       : std_logic_vector(63 downto 0);
  signal gt6_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt6_txheader     : std_logic_vector( 1 downto 0);
  signal gt7_txdata       : std_logic_vector(63 downto 0);
  signal gt7_txcharisk    : std_logic_vector( 3 downto 0);
  signal gt7_txheader     : std_logic_vector( 1 downto 0);
  signal s_axi_wdata      : std_logic_vector(31 downto 0);
  signal rx_sys_reset     : std_logic;
  signal tx_sys_reset     : std_logic;
  signal txoutclk         : std_logic;
  signal rxoutclk         : std_logic;
  signal rxencommaalign   : std_logic;
  signal tx_reset_gt      : std_logic;
  signal tx_reset_done    : std_logic;
  signal rx_reset_gt      : std_logic;
  signal gt_prbssel_out   : std_logic_vector( 3 downto 0);
  signal rx_reset_done    : std_logic;
  signal axi_sel          : std_logic;
  signal tx_aresetn       : std_logic;
  signal rx_aresetn       : std_logic;

  signal rx_tdata         : std_logic_vector(511 downto 0);
  signal rx_tvalid        : std_logic;

  signal tx_i_s0          : arr_4_16_stdlogic;
  signal tx_q_s0          : arr_4_16_stdlogic;
  signal tx_i_s1          : arr_4_16_stdlogic;
  signal tx_q_s1          : arr_4_16_stdlogic;
  signal tx_i_s2          : arr_4_16_stdlogic;
  signal tx_q_s2          : arr_4_16_stdlogic;
  signal tx_i_s3          : arr_4_16_stdlogic;
  signal tx_q_s3          : arr_4_16_stdlogic;

  signal txdiffctrl_40    : std_logic_vector(39 downto 0);
  signal mod_cnt          : std_logic_vector( 1 downto 0);

  signal r_bit            : std_logic;

  signal rx_sync          : std_logic;
  signal tx_sync          : std_logic;

  signal rx_rst_n         : std_logic;
  signal tx_rst_n         : std_logic;
  signal tx_reset         : std_logic;
  signal rx_reset         : std_logic;

  signal txpostcursor     : std_logic_vector(39 downto 0);
  signal txprecursor      : std_logic_vector(39 downto 0);

  signal rx_irq           : std_logic;
  signal tx_irq           : std_logic;

  signal tx_cmd_tdata     : std_logic_vector(255 downto 0);
  signal tx_cmd_tvalid    : std_logic;
  signal tx_cmd_tready    : std_logic;

  signal rx_cmd_tdata     : std_logic_vector(255 downto 0);
  signal rx_cmd_tvalid    : std_logic;
  signal rx_cmd_tuser     : std_logic_vector(7 downto 0);
  signal rx_cmd_tready    : std_logic := '0';

  signal sample_tic_tx    : std_logic;
  signal sample_tic_rx    : std_logic;
  signal rst_n_491p52     : std_logic;
  signal lane_ena         : std_logic_vector(5 downto 0);

  signal qpll_reset       : std_logic;

  signal qpll0_clk_in     : std_logic;
  signal qpll0_refclk_in  : std_logic;
  signal qpll0_lock_in    : std_logic;
  signal qpll1_clk_in     : std_logic;
  signal qpll1_refclk_in  : std_logic;
  signal qpll1_lock_in    : std_logic;

  signal rx_tvalid_s      : std_logic;
  signal tx_tready_s      : std_logic;

begin

rst_blk_rx: xpm_cdc_async_rst
generic map (
    DEST_SYNC_FF    => 2, -- integer; range: 2-10
    RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
)
port map (
    src_arst  => reset_n,
    dest_clk  => rx_core_clk,
    dest_arst => rx_rst_n
);

rst_blk_tx: xpm_cdc_async_rst
generic map (
    DEST_SYNC_FF    => 2, -- integer; range: 2-10
    RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
)
port map (
    src_arst  => reset_n,
    dest_clk  => tx_core_clk,
    dest_arst => tx_rst_n
);

rst_blk_491 : xpm_cdc_async_rst
generic map (
    DEST_SYNC_FF    => 2, -- integer; range: 2-10
    RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
)
port map (
    src_arst  => reset_n,
    dest_clk  => clk_491p52,
    dest_arst => rst_n_491p52
);

tx_sys_reset       <= not tx_rst_n;
rx_sys_reset       <= not rx_rst_n;

rx_reset           <= not axi_aresetn;
tx_reset           <= not axi_aresetn;

txpostcursor        <= x"0000000000";
txprecursor         <= x"0000000000";

  txdiffctrl_40 <= txdiffctrl & txdiffctrl & txdiffctrl & txdiffctrl & txdiffctrl & txdiffctrl & txdiffctrl & txdiffctrl;

--=======================================================================
--=======================================================================


 jesd204_phy : entity work.jesd204_phy_8t8r
  PORT MAP (
    drpclk                  => drpclk                              , --: IN STD_LOGIC;
    tx_reset_gt             => tx_reset_gt                         , --: IN STD_LOGIC;
    rx_reset_gt             => rx_reset_gt                         , --: IN STD_LOGIC;
    tx_sys_reset            => tx_sys_reset                        , --: IN STD_LOGIC;
    rx_sys_reset            => rx_sys_reset                        , --: IN STD_LOGIC;
    txp_out                 => txp                                 , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    txn_out                 => txn                                 , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxp_in                  => rxp                                 , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxn_in                  => rxn                                 , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    tx_core_clk             => tx_core_clk                         , --: IN STD_LOGIC;
    rx_core_clk             => rx_core_clk                         , --: IN STD_LOGIC;
    txoutclk                => txoutclk                            , --: OUT STD_LOGIC;
    rxoutclk                => rxoutclk                            , --: OUT STD_LOGIC;
    gt0_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt0_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt0_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt0_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt0_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt0_drprdy              => open                                , --: OUT STD_LOGIC;
    gt1_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt1_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt1_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt1_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt1_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt1_drprdy              => open                                , --: OUT STD_LOGIC;
    gt2_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt2_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt2_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt2_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt2_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt2_drprdy              => open                                , --: OUT STD_LOGIC;
    gt3_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt3_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt3_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt3_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt3_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt3_drprdy              => open                                , --: OUT STD_LOGIC;
    gt4_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt4_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt4_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt4_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt4_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt4_drprdy              => open                                , --: OUT STD_LOGIC;
    gt5_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt5_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt5_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt5_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt5_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt5_drprdy              => open                                , --: OUT STD_LOGIC;
    gt6_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt6_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt6_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt6_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt6_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt6_drprdy              => open                                , --: OUT STD_LOGIC;
    gt7_drpaddr             => "0000000000"                        , --: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt7_drpen               => '0'                                 , --: IN STD_LOGIC;
    gt7_drpdi               => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt7_drpdo               => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt7_drpwe               => '0'                                 , --: IN STD_LOGIC;
    gt7_drprdy              => open                                , --: OUT STD_LOGIC;
    gt_loopback             => x"000000"                           , --: IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    gt_cplllock             => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txresetdone          => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxresetdone          => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxprbssel            => x"00000000"                         , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    gt_txprbsforceerr       => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxprbscntreset       => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxprbserr            => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txpostcursor         => txpostcursor                        , --: IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    gt_txprecursor          => txprecursor                         , --: IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    gt_txdiffctrl           => txdiffctrl_40                       , --: IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    gt_txpolarity           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxpolarity           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txinhibit            => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxpd                 => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt_txpd                 => x"0000"                             , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt_eyescantrigger       => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_eyescanreset         => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_eyescandataerror     => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txpmareset           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txpcsreset           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txbufstatus          => open                                , --: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt_rxpmareset           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxpcsreset           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxpmaresetdone       => open                                , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxcdrhold            => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxdfelpmreset        => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxlpmen              => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxbufreset           => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_rxbufstatus          => open                                , --: OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    gt_rxrate               => x"000000"                           , --: IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    gt_dmonitorclk          => x"00"                               , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_dmonitorout          => open                                , --: OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    gt_pcsrsvdin            => x"00000000000000000000000000000000" , --: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    gt0_txdata              => gt0_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt0_txcharisk           => gt0_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_txheader            => gt0_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt1_txdata              => gt1_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt1_txcharisk           => gt1_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_txheader            => gt1_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt2_txdata              => gt2_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt2_txcharisk           => gt2_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_txheader            => gt2_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt3_txdata              => gt3_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt3_txcharisk           => gt3_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_txheader            => gt3_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt4_txdata              => gt4_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt4_txcharisk           => gt4_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_txheader            => gt4_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt5_txdata              => gt5_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt5_txcharisk           => gt5_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_txheader            => gt5_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt6_txdata              => gt6_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt6_txcharisk           => gt6_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_txheader            => gt6_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt7_txdata              => gt7_txdata                          , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt7_txcharisk           => gt7_txcharisk                       , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_txheader            => gt7_txheader                        , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    tx_reset_done           => tx_reset_done                       , --: OUT STD_LOGIC;
    gt_powergood            => gt_powergood                        , --: OUT STD_LOGIC;
    gt0_rxdata              => gt0_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt0_rxcharisk           => gt0_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxdisperr           => gt0_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxnotintable        => gt0_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxheader            => gt0_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt0_rxmisalign          => gt0_rxmisalign                      , --: OUT STD_LOGIC;
    gt0_rxblock_sync        => gt0_rxblock_sync                    , --: OUT STD_LOGIC;
    gt1_rxdata              => gt1_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt1_rxcharisk           => gt1_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxdisperr           => gt1_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxnotintable        => gt1_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxheader            => gt1_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt1_rxmisalign          => gt1_rxmisalign                      , --: OUT STD_LOGIC;
    gt1_rxblock_sync        => gt1_rxblock_sync                    , --: OUT STD_LOGIC;
    gt2_rxdata              => gt2_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt2_rxcharisk           => gt2_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxdisperr           => gt2_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxnotintable        => gt2_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxheader            => gt2_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt2_rxmisalign          => gt2_rxmisalign                      , --: OUT STD_LOGIC;
    gt2_rxblock_sync        => gt2_rxblock_sync                    , --: OUT STD_LOGIC;
    gt3_rxdata              => gt3_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt3_rxcharisk           => gt3_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxdisperr           => gt3_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxnotintable        => gt3_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxheader            => gt3_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt3_rxmisalign          => gt3_rxmisalign                      , --: OUT STD_LOGIC;
    gt3_rxblock_sync        => gt3_rxblock_sync                    , --: OUT STD_LOGIC;
    gt4_rxdata              => gt4_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt4_rxcharisk           => gt4_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxdisperr           => gt4_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxnotintable        => gt4_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxheader            => gt4_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt4_rxmisalign          => gt4_rxmisalign                      , --: OUT STD_LOGIC;
    gt4_rxblock_sync        => gt4_rxblock_sync                    , --: OUT STD_LOGIC;
    gt5_rxdata              => gt5_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt5_rxcharisk           => gt5_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxdisperr           => gt5_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxnotintable        => gt5_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxheader            => gt5_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt5_rxmisalign          => gt5_rxmisalign                      , --: OUT STD_LOGIC;
    gt5_rxblock_sync        => gt5_rxblock_sync                    , --: OUT STD_LOGIC;
    gt6_rxdata              => gt6_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt6_rxcharisk           => gt6_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxdisperr           => gt6_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxnotintable        => gt6_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxheader            => gt6_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt6_rxmisalign          => gt6_rxmisalign                      , --: OUT STD_LOGIC;
    gt6_rxblock_sync        => gt6_rxblock_sync                    , --: OUT STD_LOGIC;
    gt7_rxdata              => gt7_rxdata                          , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt7_rxcharisk           => gt7_rxcharisk                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxdisperr           => gt7_rxdisperr                       , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxnotintable        => gt7_rxnotintable                    , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxheader            => gt7_rxheader                        , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt7_rxmisalign          => gt7_rxmisalign                      , --: OUT STD_LOGIC;
    gt7_rxblock_sync        => gt7_rxblock_sync                    , --: OUT STD_LOGIC;
    rx_reset_done           => rx_reset_done                       , --: OUT STD_LOGIC;
    common0_qpll0_clk_in    => qpll0_clk_in                        , --: IN STD_LOGIC;
    common0_qpll0_refclk_in => qpll0_refclk_in                     , --: IN STD_LOGIC;
    common0_qpll0_lock_in   => qpll0_lock_in                       , --: IN STD_LOGIC;
    common1_qpll0_clk_in    => qpll1_clk_in                        , --: IN STD_LOGIC;
    common1_qpll0_refclk_in => qpll1_refclk_in                     , --: IN STD_LOGIC;
    common1_qpll0_lock_in   => qpll1_lock_in                       , --: IN STD_LOGIC;
    qpll0_reset_out         => qpll_reset                          ); --: OUT STD_LOGIC


--=======================================================================
--=======================================================================


jesd204_rx : entity work.jesd204c_8rx
port map (
    s_axi_aclk       => axi_clk          , --: IN STD_LOGIC;
    s_axi_aresetn    => axi_aresetn      , --: IN STD_LOGIC;
    s_axi_awaddr     => rx_axi_awaddr    , --: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_awvalid    => rx_axi_awvalid   , --: IN STD_LOGIC;
    s_axi_awready    => rx_axi_awready   , --: OUT STD_LOGIC;
    s_axi_wdata      => rx_axi_wdata     , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb      => "1111"           , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid     => rx_axi_wvalid    , --: IN STD_LOGIC;
    s_axi_wready     => rx_axi_wready    , --: OUT STD_LOGIC;
    s_axi_bresp      => rx_axi_bresp     , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid     => rx_axi_bvalid    , --: OUT STD_LOGIC;
    s_axi_bready     => rx_axi_bready    , --: IN STD_LOGIC;
    s_axi_araddr     => rx_axi_araddr    , --: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_arvalid    => rx_axi_arvalid   , --: IN STD_LOGIC;
    s_axi_arready    => rx_axi_arready   , --: OUT STD_LOGIC;
    s_axi_rdata      => rx_axi_rdata     , --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp      => rx_axi_rresp     , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid     => rx_axi_rvalid    , --: OUT STD_LOGIC;
    s_axi_rready     => rx_axi_rready    , --: IN STD_LOGIC;
    rx_core_clk      => rx_core_clk      , --: IN STD_LOGIC;
    rx_core_reset    => rx_reset         , --: IN STD_LOGIC;
    rx_sysref        => rx_sysref        , --: IN STD_LOGIC;
    irq              => rx_irq           , --: OUT STD_LOGIC;
    rx_tdata         => rx_tdata         , --: OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    rx_tvalid        => rx_tvalid        , --: OUT STD_LOGIC;
    rx_aresetn       => rx_aresetn       , --: OUT STD_LOGIC;
    rx_soemb         => open             , --: OUT STD_LOGIC;
    rx_crc_err       => open             , --: OUT STD_LOGIC;
    rx_emb_err       => open             , --: OUT STD_LOGIC;
    rx_cmd_tdata     => rx_cmd_tdata     , --: OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    rx_cmd_tvalid    => rx_cmd_tvalid    , --: OUT STD_LOGIC;
    rx_cmd_tuser     => rx_cmd_tuser     , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rx_cmd_tready    => rx_cmd_tready    , --: IN STD_LOGIC;
    rx_reset_gt      => rx_reset_gt      , --: OUT STD_LOGIC;
    rx_reset_done    => rx_reset_done    , --: IN STD_LOGIC;
    gt0_rxdata       => gt0_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt0_rxcharisk    => gt0_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxdisperr    => gt0_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxnotintable => gt0_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_rxheader     => gt0_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt0_rxmisalign   => gt0_rxmisalign   , --: IN STD_LOGIC;
    gt0_rxblock_sync => gt0_rxblock_sync , --: IN STD_LOGIC;
    gt1_rxdata       => gt1_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt1_rxcharisk    => gt1_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxdisperr    => gt1_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxnotintable => gt1_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_rxheader     => gt1_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt1_rxmisalign   => gt1_rxmisalign   , --: IN STD_LOGIC;
    gt1_rxblock_sync => gt1_rxblock_sync , --: IN STD_LOGIC;
    gt2_rxdata       => gt2_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt2_rxcharisk    => gt2_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxdisperr    => gt2_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxnotintable => gt2_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_rxheader     => gt2_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt2_rxmisalign   => gt2_rxmisalign   , --: IN STD_LOGIC;
    gt2_rxblock_sync => gt2_rxblock_sync , --: IN STD_LOGIC;
    gt3_rxdata       => gt3_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt3_rxcharisk    => gt3_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxdisperr    => gt3_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxnotintable => gt3_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_rxheader     => gt3_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt3_rxmisalign   => gt3_rxmisalign   , --: IN STD_LOGIC;
    gt3_rxblock_sync => gt3_rxblock_sync , --: IN STD_LOGIC;
    gt4_rxdata       => gt4_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt4_rxcharisk    => gt4_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxdisperr    => gt4_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxnotintable => gt4_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_rxheader     => gt4_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt4_rxmisalign   => gt4_rxmisalign   , --: IN STD_LOGIC;
    gt4_rxblock_sync => gt4_rxblock_sync , --: IN STD_LOGIC;
    gt5_rxdata       => gt5_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt5_rxcharisk    => gt5_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxdisperr    => gt5_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxnotintable => gt5_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_rxheader     => gt5_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt5_rxmisalign   => gt5_rxmisalign   , --: IN STD_LOGIC;
    gt5_rxblock_sync => gt5_rxblock_sync , --: IN STD_LOGIC
    gt6_rxdata       => gt6_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt6_rxcharisk    => gt6_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxdisperr    => gt6_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxnotintable => gt6_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_rxheader     => gt6_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt6_rxmisalign   => gt6_rxmisalign   , --: IN STD_LOGIC;
    gt6_rxblock_sync => gt6_rxblock_sync , --: IN STD_LOGIC;
    gt7_rxdata       => gt7_rxdata       , --: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt7_rxcharisk    => gt7_rxcharisk    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxdisperr    => gt7_rxdisperr    , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxnotintable => gt7_rxnotintable , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_rxheader     => gt7_rxheader     , --: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt7_rxmisalign   => gt7_rxmisalign   , --: IN STD_LOGIC;
    gt7_rxblock_sync => gt7_rxblock_sync ); --: IN STD_LOGIC

lane_ena    <= "111111";


process(rx_core_clk)
begin
if rising_edge(rx_core_clk) then
   if (rx_tvalid = '0') then
       adc0_i_s0    <= (others => '0');
       adc0_q_s0    <= (others => '0');
       adc0_i_s1    <= (others => '0');
       adc0_q_s1    <= (others => '0');
       adc1_i_s0    <= (others => '0');
       adc1_q_s0    <= (others => '0');
       adc1_i_s1    <= (others => '0');
       adc1_q_s1    <= (others => '0');
       adc2_i_s0    <= (others => '0');
       adc2_q_s0    <= (others => '0');
       adc2_i_s1    <= (others => '0');
       adc2_q_s1    <= (others => '0');
       adc3_i_s0    <= (others => '0');
       adc3_q_s0    <= (others => '0');
       adc3_i_s1    <= (others => '0');
       adc3_q_s1    <= (others => '0');
       fb0_i_s0_245 <= (others => '0');
       fb0_q_s0_245 <= (others => '0');
       fb0_i_s1_245 <= (others => '0');
       fb0_q_s1_245 <= (others => '0');
       fb0_i_s2_245 <= (others => '0');
       fb0_q_s2_245 <= (others => '0');
       fb0_i_s3_245 <= (others => '0');
       fb0_q_s3_245 <= (others => '0');
       fb1_i_s0_245 <= (others => '0');
       fb1_q_s0_245 <= (others => '0');
       fb1_i_s1_245 <= (others => '0');
       fb1_q_s1_245 <= (others => '0');
       fb1_i_s2_245 <= (others => '0');
       fb1_q_s2_245 <= (others => '0');
       fb1_i_s3_245 <= (others => '0');
       fb1_q_s3_245 <= (others => '0');
   else
		adc2_i_s1    <= rx_tdata( 15 downto   0); --    ADC0 sample 0
        adc2_q_s1    <= rx_tdata( 31 downto  16);
        adc2_i_s0    <= rx_tdata( 47 downto  32); --    ADC0 sample 1
        adc2_q_s0    <= rx_tdata( 63 downto  48);

        adc3_i_s1    <= rx_tdata( 79 downto  64); --    ADC1 sample 0
        adc3_q_s1    <= rx_tdata( 95 downto  80);
        adc3_i_s0    <= rx_tdata(111 downto  96); --    ADC1 sample 1
        adc3_q_s0    <= rx_tdata(127 downto 112);

        adc0_i_s1    <= rx_tdata(143 downto 128); --    ADC2 sample 0
        adc0_q_s1    <= rx_tdata(159 downto 144);
        adc0_i_s0    <= rx_tdata(175 downto 160); --    ADC2 sample 1
        adc0_q_s0    <= rx_tdata(191 downto 176);

        adc1_i_s1    <= rx_tdata(207 downto 192); --    ADC3 sample 0
        adc1_q_s1    <= rx_tdata(223 downto 208);
        adc1_i_s0    <= rx_tdata(239 downto 224); --    ADC3 sample 1
        adc1_q_s0    <= rx_tdata(255 downto 240);

        fb1_i_s3_245 <= rx_tdata(271 downto 256); --    FB0 sample 0
		fb1_i_s2_245 <= rx_tdata(287 downto 272);
		fb1_i_s1_245 <= rx_tdata(303 downto 288); --    FB0 sample 1
		fb1_i_s0_245 <= rx_tdata(319 downto 304);

		fb1_q_s3_245 <= rx_tdata(335 downto 320); --    FB0 sample 2
		fb1_q_s2_245 <= rx_tdata(351 downto 336);
		fb1_q_s1_245 <= rx_tdata(367 downto 352); --    FB0 sample 3
		fb1_q_s0_245 <= rx_tdata(383 downto 368);

		fb0_i_s3_245 <= rx_tdata(399 downto 384); --    FB1 sample 0
		fb0_i_s2_245 <= rx_tdata(415 downto 400);
		fb0_i_s1_245 <= rx_tdata(431 downto 416); --    FB1 sample 1
		fb0_i_s0_245 <= rx_tdata(447 downto 432);

		fb0_q_s3_245 <= rx_tdata(463 downto 448); --    FB1 sample 2
		fb0_q_s2_245 <= rx_tdata(479 downto 464);
		fb0_q_s1_245 <= rx_tdata(495 downto 480); --    FB1 sample 3
		fb0_q_s0_245 <= rx_tdata(511 downto 496);
	end if;
end if;
end process;


process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (sample_tic_rx = '0') then
        adc0_i       <= adc0_i_s0;
        adc0_q       <= adc0_q_s0;
        adc1_i       <= adc1_i_s0;
        adc1_q       <= adc1_q_s0;
        adc2_i       <= adc2_i_s0;
        adc2_q       <= adc2_q_s0;
        adc3_i       <= adc3_i_s0;
        adc3_q       <= adc3_q_s0;

        fb0_i_s0     <= fb0_i_s0_245;
        fb0_q_s0     <= fb0_q_s0_245;
        fb0_i_s1     <= fb0_i_s1_245;
        fb0_q_s1     <= fb0_q_s1_245;
        fb1_i_s0     <= fb1_i_s0_245;
        fb1_q_s0     <= fb1_q_s0_245;
        fb1_i_s1     <= fb1_i_s1_245;
        fb1_q_s1     <= fb1_q_s1_245;
    else
        adc0_i       <= adc0_i_s1;
        adc0_q       <= adc0_q_s1;
        adc1_i       <= adc1_i_s1;
        adc1_q       <= adc1_q_s1;
        adc2_i       <= adc2_i_s1;
        adc2_q       <= adc2_q_s1;
        adc3_i       <= adc3_i_s1;
        adc3_q       <= adc3_q_s1;

        fb0_i_s0     <= fb0_i_s2_245;
        fb0_q_s0     <= fb0_q_s2_245;
        fb0_i_s1     <= fb0_i_s3_245;
        fb0_q_s1     <= fb0_q_s3_245;
        fb1_i_s0     <= fb1_i_s2_245;
        fb1_q_s0     <= fb1_q_s2_245;
        fb1_i_s1     <= fb1_i_s3_245;
        fb1_q_s1     <= fb1_q_s3_245;
    end if;
end if;
end process;

--adc0_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => adc0_i_s0     , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => adc0_q_s0     , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => adc0_i_s1     , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => adc0_q_s1     , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => adc0_i        , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => adc0_q       ); --: out std_logic_vector(15 downto 0)  -- Output Q data
--
--adc1_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => adc1_i_s0     , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => adc1_q_s0     , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => adc1_i_s1     , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => adc1_q_s1     , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => adc1_i        , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => adc1_q       ); --: out std_logic_vector(15 downto 0)  -- Output Q data
--
--adc2_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => adc2_i_s0     , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => adc2_q_s0     , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => adc2_i_s1     , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => adc2_q_s1     , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => adc2_i        , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => adc2_q       ); --: out std_logic_vector(15 downto 0)  -- Output Q data
--
--adc3_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => adc3_i_s0     , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => adc3_q_s0     , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => adc3_i_s1     , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => adc3_q_s1     , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => adc3_i        , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => adc3_q       ); --: out std_logic_vector(15 downto 0)  -- Output Q data
--
--fb0_s0_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => fb0_i_s0_245  , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => fb0_q_s0_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => fb0_i_s2_245  , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => fb0_q_s2_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => fb0_i_s0      , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => fb0_q_s0      ); --: out std_logic_vector(15 downto 0) -- Output Q data
--
--fb0_s1_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => fb0_i_s1_245  , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => fb0_q_s1_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => fb0_i_s3_245  , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => fb0_q_s3_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => fb0_i_s1      , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => fb0_q_s1      ); --: out std_logic_vector(15 downto 0) -- Output Q data
--
--fb1_s0_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => fb1_i_s0_245  , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => fb1_q_s0_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => fb1_i_s2_245  , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => fb1_q_s2_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => fb1_i_s0      , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => fb1_q_s0      ); --: out std_logic_vector(15 downto 0) -- Output Q data
--
--fb1_s1_sc : entity work.sample_rate_conv_1_2
-- port map (
--    clk_i    => rx_core_clk   , --: in  std_logic;                     -- Input clock
--    rst_n    => rst_n_491p52  , --: in  std_logic;
--    ref_tic  => sample_tic_rx , --: in  std_logic;
--    i_in_s0  => fb1_i_s1_245  , --: in  std_logic_vector(15 downto 0); -- Input I data first sample
--    q_in_s0  => fb1_q_s1_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data first sample
--    i_in_s1  => fb1_i_s3_245  , --: in  std_logic_vector(15 downto 0); -- Input I data second sample
--    q_in_s1  => fb1_q_s3_245  , --: in  std_logic_vector(15 downto 0); -- Input Q data second sample
--    clk_o    => clk_491p52    , --: in  std_logic;                     -- Output clock
--    i_out    => fb1_i_s1      , --: out std_logic_vector(15 downto 0); -- Output I data
--    q_out    => fb1_q_s1      ); --: out std_logic_vector(15 downto 0) -- Output Q data

--=======================================================================

--random_blk : entity work.random
--    port map(
--    clk         => tx_core_clk , --: in  std_logic;
--    reset_n     => tx_aresetn  , --: in  std_logic;
--    rbit_out    => r_bit       ); --: out std_logic

 --rx_tvalid_cdc : xpm_cdc_single
 --generic map (
 --   DEST_SYNC_FF   => 2 ,
 --   INIT_SYNC_FF   => 0 ,
 --   SIM_ASSERT_CHK => 0 ,
 --   SRC_INPUT_REG  => 1 )
 --port map (
 --   dest_out       => rx_tvalid_s ,
 --   dest_clk       => clk_491p52  ,
 --   src_clk        => rx_core_clk ,
 --   src_in         => rx_tvalid   );
--
 --tx_tready_cdc : xpm_cdc_single
 --generic map (
 --   DEST_SYNC_FF   => 2 ,
 --   INIT_SYNC_FF   => 0 ,
 --   SIM_ASSERT_CHK => 0 ,
 --   SRC_INPUT_REG  => 1 )
 --port map (
 --   dest_out       => tx_tready_s ,
 --   dest_clk       => clk_491p52  ,
 --   src_clk        => tx_core_clk ,
 --   src_in         => tx_tready   );

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (rst_n_491p52 = '0') then
        sample_tic_rx <= '0';
    elsif (rx_tvalid = '0') then
        sample_tic_rx <= '0';
    else
        sample_tic_rx <= not sample_tic_rx;
    end if;
end if;
end process;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (rst_n_491p52 = '0') then
        sample_tic_tx <= '0';
    elsif (tx_tready = '0') then
        sample_tic_tx <= '0';
    else
        sample_tic_tx <= not sample_tic_tx;
    end if;
end if;
end process;


-- dl rf port 0 -> dac2
-- dl rf port 1 -> dac3
-- dl rf port 2 -> dac0
-- dl rf port 3 -> dac1

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
        if (sample_tic_tx = '0') then
            tx_i_s1(2)  <= dac_i_s0(0);
            tx_i_s0(2)  <= dac_i_s1(0);
            tx_i_s1(3)  <= dac_i_s0(1);
            tx_i_s0(3)  <= dac_i_s1(1);
            tx_i_s1(0)  <= dac_i_s0(2);
            tx_i_s0(0)  <= dac_i_s1(2);
            tx_i_s1(1)  <= dac_i_s0(3);
            tx_i_s0(1)  <= dac_i_s1(3);
            tx_q_s1(2)  <= dac_q_s0(0);
            tx_q_s0(2)  <= dac_q_s1(0);
            tx_q_s1(3)  <= dac_q_s0(1);
            tx_q_s0(3)  <= dac_q_s1(1);
            tx_q_s1(0)  <= dac_q_s0(2);
            tx_q_s0(0)  <= dac_q_s1(2);
            tx_q_s1(1)  <= dac_q_s0(3);
            tx_q_s0(1)  <= dac_q_s1(3);
        else
            tx_i_s3(2)  <= dac_i_s0(0);
            tx_i_s2(2)  <= dac_i_s1(0);
            tx_i_s3(3)  <= dac_i_s0(1);
            tx_i_s2(3)  <= dac_i_s1(1);
            tx_i_s3(0)  <= dac_i_s0(2);
            tx_i_s2(0)  <= dac_i_s1(2);
            tx_i_s3(1)  <= dac_i_s0(3);
            tx_i_s2(1)  <= dac_i_s1(3);
            tx_q_s3(2)  <= dac_q_s0(0);
            tx_q_s2(2)  <= dac_q_s1(0);
            tx_q_s3(3)  <= dac_q_s0(1);
            tx_q_s2(3)  <= dac_q_s1(1);
            tx_q_s3(0)  <= dac_q_s0(2);
            tx_q_s2(0)  <= dac_q_s1(2);
            tx_q_s3(1)  <= dac_q_s0(3);
            tx_q_s2(1)  <= dac_q_s1(3);
        end if;

end if;
end process;


process(tx_core_clk)
begin
if rising_edge(tx_core_clk) then
   if (tx_tready = '0') then
        tx_tdata(511 downto   0) <= (others => '0');
   else
	    tx_tdata( 63 downto   0) <= tx_i_s3(0) & tx_i_s2(0) & tx_i_s1(0) & tx_i_s0(0);
        tx_tdata(127 downto  64) <= tx_q_s3(0) & tx_q_s2(0) & tx_q_s1(0) & tx_q_s0(0);

        --tx_tdata(191 downto 128) <= fb0_i_s0_245 & fb0_i_s1_245 & fb0_i_s2_245 & fb0_i_s3_245;
        --tx_tdata(255 downto 192) <= fb0_q_s0_245 & fb0_q_s1_245 & fb0_q_s2_245 & fb0_q_s3_245;

        tx_tdata(191 downto 128) <= tx_i_s3(1) & tx_i_s2(1) & tx_i_s1(1) & tx_i_s0(1);
        tx_tdata(255 downto 192) <= tx_q_s3(1) & tx_q_s2(1) & tx_q_s1(1) & tx_q_s0(1);

        tx_tdata(319 downto 256) <= tx_i_s3(2) & tx_i_s2(2) & tx_i_s1(2) & tx_i_s0(2);
        tx_tdata(383 downto 320) <= tx_q_s3(2) & tx_q_s2(2) & tx_q_s1(2) & tx_q_s0(2);

        --tx_tdata(447 downto 384) <= fb1_i_s0_245 & fb1_i_s1_245 & fb1_i_s2_245 & fb1_i_s3_245;
        --tx_tdata(511 downto 448) <= fb1_q_s0_245 & fb1_q_s1_245 & fb1_q_s2_245 & fb1_q_s3_245;

        tx_tdata(447 downto 384) <= tx_i_s3(3) & tx_i_s2(3) & tx_i_s1(3) & tx_i_s0(3);
        tx_tdata(511 downto 448) <= tx_q_s3(3) & tx_q_s2(3) & tx_q_s1(3) & tx_q_s0(3);
   end if;
end if;
end process;





jesd204_tx : entity work.jesd204c_8tx
port map(
    s_axi_aclk    => axi_clk        , --: IN STD_LOGIC;
    s_axi_aresetn => axi_aresetn    , --: IN STD_LOGIC;
    s_axi_awaddr  => tx_axi_awaddr  , --: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_awvalid => tx_axi_awvalid , --: IN STD_LOGIC;
    s_axi_awready => tx_axi_awready , --: OUT STD_LOGIC;
    s_axi_wdata   => tx_axi_wdata   , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb   => "1111"         , --: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid  => tx_axi_wvalid  , --: IN STD_LOGIC;
    s_axi_wready  => tx_axi_wready  , --: OUT STD_LOGIC;
    s_axi_bresp   => tx_axi_bresp   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid  => tx_axi_bvalid  , --: OUT STD_LOGIC;
    s_axi_bready  => tx_axi_bready  , --: IN STD_LOGIC;
    s_axi_araddr  => tx_axi_araddr  , --: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_arvalid => tx_axi_arvalid , --: IN STD_LOGIC;
    s_axi_arready => tx_axi_arready , --: OUT STD_LOGIC;
    s_axi_rdata   => tx_axi_rdata   , --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp   => tx_axi_rresp   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid  => tx_axi_rvalid  , --: OUT STD_LOGIC;
    s_axi_rready  => tx_axi_rready  , --: IN STD_LOGIC;
    tx_core_clk   => tx_core_clk    , --: IN STD_LOGIC;
    tx_core_reset => tx_reset       , --: IN STD_LOGIC;
    tx_sysref     => tx_sysref      , --: IN STD_LOGIC;
    irq           => tx_irq         , --: OUT STD_LOGIC;
    tx_tdata      => tx_tdata       , --: IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    tx_tready     => tx_tready      , --: OUT STD_LOGIC;
    tx_aresetn    => tx_aresetn     , --: OUT STD_LOGIC;
    tx_soemb      => open           , --: OUT STD_LOGIC;
    tx_cmd_tdata  => tx_cmd_tdata   , --: IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    tx_cmd_tvalid => tx_cmd_tvalid  , --: IN STD_LOGIC;
    tx_cmd_tready => tx_cmd_tready  , --: OUT STD_LOGIC;
    tx_reset_gt   => tx_reset_gt    , --: OUT STD_LOGIC;
    tx_reset_done => tx_reset_done  , --: IN STD_LOGIC;
    gt0_txdata    => gt0_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt0_txcharisk => gt0_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt0_txheader  => gt0_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt1_txdata    => gt1_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt1_txcharisk => gt1_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt1_txheader  => gt1_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt2_txdata    => gt2_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt2_txcharisk => gt2_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt2_txheader  => gt2_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt3_txdata    => gt3_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt3_txcharisk => gt3_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt3_txheader  => gt3_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt4_txdata    => gt4_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt4_txcharisk => gt4_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt4_txheader  => gt4_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt5_txdata    => gt5_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt5_txcharisk => gt5_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt5_txheader  => gt5_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt6_txdata    => gt6_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt6_txcharisk => gt6_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt6_txheader  => gt6_txheader   , --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    gt7_txdata    => gt7_txdata     , --: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt7_txcharisk => gt7_txcharisk  , --: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt7_txheader  => gt7_txheader   ); --: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)


jesd_irq <= tx_irq & rx_irq;

jesd204_cmd_gen : entity work.jesd204c_cmd_gen
port map(
	clk				=>	axi_clk				, -- :in  std_logic;
	rst_n			=>	axi_aresetn			, -- :in  std_logic;
	tx_clear		=>	'0'					, -- :in  std_logic;
	tx_tready		=>	tx_tready			, -- :in  std_logic;
	tx_cmd_tready	=>	tx_cmd_tready		, -- :in  std_logic;
	meta_mode		=>	"00"				, -- :in  std_logic_vector(1 downto 0);
	tx_cmd_tdata	=>	tx_cmd_tdata 		, -- :out std_logic_vector(255 downto 0);
	tx_cmd_tvalid 	=>	tx_cmd_tvalid	    ); -- :out std_logic;

jesd204_qpll0 : entity work.jesd204_phy_8t8r_gt_common_wrapper
port map(
    common_gtrefclk0       => ref_clk         , --: in  std_logic;
    common_gtrefclk1       => '0'             , --: in  std_logic;
    common_drpclk          => '0'             , --: in  std_logic;
    common_drpaddr         => x"0000"         , --: in  std_logic_vector(15 downto 0);
    common_drpdi           => x"0000"         , --: in  std_logic_vector(15 downto 0);
    common_drpen           => '0'             , --: in  std_logic;
    common_drpwe           => '0'             , --: in  std_logic;
    common_drpdo           => open            , --: out std_logic_vector(15 downto 0);
    common_drprdy          => open            , --: out std_logic;
    common_qpll0_lock      => qpll0_lock_in   , --: out std_logic;
    common_qpll0_outclk    => qpll0_clk_in    , --: out std_logic;
    common_qpll0_outrefclk => qpll0_refclk_in , --: out std_logic;
    common_qpll0_reset     => qpll_reset      , --: in  std_logic;
    common_qpll0_pd        => '0'             , --: in  std_logic;
    common_qpll1_lock      => open            , --: out  std_logic;
    common_qpll1_outclk    => open            , --: out  std_logic;
    common_qpll1_outrefclk => open            , --: out  std_logic;
    common_qpll1_reset     => '0'             , --: in  std_logic;
    common_qpll1_pd        => '1'             ); --: in  std_logic;

jesd204_qpll1 : entity work.jesd204_phy_8t8r_gt_common_wrapper
port map(
    common_gtrefclk0       => ref_clk         , --: in  std_logic;
    common_gtrefclk1       => '0'             , --: in  std_logic;
    common_drpclk          => '0'             , --: in  std_logic;
    common_drpaddr         => x"0000"         , --: in  std_logic_vector(15 downto 0);
    common_drpdi           => x"0000"         , --: in  std_logic_vector(15 downto 0);
    common_drpen           => '0'             , --: in  std_logic;
    common_drpwe           => '0'             , --: in  std_logic;
    common_drpdo           => open            , --: out std_logic_vector(15 downto 0);
    common_drprdy          => open            , --: out std_logic;
    common_qpll0_lock      => qpll1_lock_in   , --: out std_logic;
    common_qpll0_outclk    => qpll1_clk_in    , --: out std_logic;
    common_qpll0_outrefclk => qpll1_refclk_in , --: out std_logic;
    common_qpll0_reset     => qpll_reset      , --: in  std_logic;
    common_qpll0_pd        => '0'             , --: in  std_logic;
    common_qpll1_lock      => open            , --: out  std_logic;
    common_qpll1_outclk    => open            , --: out  std_logic;
    common_qpll1_outrefclk => open            , --: out  std_logic;
    common_qpll1_reset     => '0'             , --: in  std_logic;
    common_qpll1_pd        => '1'             ); --: in  std_logic;


jesd_qpll_lock  <= qpll0_lock_in and qpll1_lock_in;


end behavioral;
