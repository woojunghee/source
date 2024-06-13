
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.ALL;
use UNISIM.VComponents.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

--gui_ver[23:20] : 0 is Xilinx, 1 is Maxlin
--gui_ver[15:12] : 0 is G, 1 is H
--gui_ver[11:8] : 0 is samji, 1 is solid

entity N77_RU_TOP is
generic(
    ver             : std_logic_vector( 31 downto  0)    := x"23120700";
    gui_ver         : std_logic_vector( 31 downto  0)    := x"77000116"
);
  port (

    FPGA_25MHZ      : in  std_logic;
    -- PLL
    PLL_LOCK        : in  std_logic_vector( 2 downto 0);
    ONE_PPS         : in  std_logic;

    -- SFP
    CPRI_REF_CLK_P  : in  std_logic; -- 245.76MHz
    CPRI_REF_CLK_N  : in  std_logic;
    CPRI_REC_CLK_P  : out std_logic; -- 7.68MHz
    CPRI_REC_CLK_N  : out std_logic;

    SFP_RX_P        : in  std_logic_vector(3 downto 0);
    SFP_RX_N        : in  std_logic_vector(3 downto 0);
    SFP_TX_P        : out std_logic_vector(3 downto 0);
    SFP_TX_N        : out std_logic_vector(3 downto 0);

    SFP_INSERT      : in  std_logic_vector(3 downto 0);
    SFP_LOS         : in  std_logic_vector(3 downto 0);
    SFP_DIS         : out std_logic_vector(3 downto 0);

    SFP_SCL         : inout std_logic_vector(3 downto 0);
    SFP_SDA         : inout std_logic_vector(3 downto 0);

    -- JESD
    JESD_REF_CLK_P  : in  std_logic; -- 245.76MHz
    JESD_REF_CLK_N  : in  std_logic;
    JESD_SYS_REF_P  : in  std_logic;
    JESD_SYS_REF_N  : in  std_logic;

    JESD_TX_P       : out std_logic_vector(7 downto 0);
    JESD_TX_N       : out std_logic_vector(7 downto 0);
    JESD_RX_P       : in  std_logic_vector(7 downto 0);
    JESD_RX_N       : in  std_logic_vector(7 downto 0);

    -- RFU
    RFU_INSERT      : in  std_logic;
    RFU_TX_EN       : out std_logic_vector(3 downto 0);
    RFU_RX_EN       : out std_logic_vector(3 downto 0);
    RFU_DL_TDD_SYNC : out std_logic;
    RFU_UL_TDD_SYNC : out std_logic;

    RFU_ORX         : out std_logic_vector(1 downto 0);
    RFU_FRS         : out std_logic;
    RFU_TEMP_SCL    : inout std_logic;
    RFU_TEMP_SDA    : inout std_logic;

    RFU_ATT_DATA    : out std_logic;
    RFU_ATT_CLK     : out std_logic;
    RFU_ATT_LE      : out std_logic_vector(3 downto 0);

    -- RFIC
    MXL_RST_N       : out std_logic;
    MXL_CHIP_MODE   : out std_logic_vector(1 downto 0);
    MXL_CLK_SEL     : out std_logic_vector(2 downto 0);
    MXL_TX_EN       : out std_logic_vector(3 downto 0);
    MXL_RX_EN       : out std_logic_vector(3 downto 0);
    MXL_FB_EN       : out std_logic_vector(1 downto 0);

    MXL_RXFB0_ID0   : out std_logic;
    MXL_RXFB1_ID0   : out std_logic;

    MXL_FBRX_CAL    : out std_logic;
    MXL_PAP         : out std_logic;

    MXL_MGAIN_CLK   : out std_logic;
    MXL_MGAIN_STB   : out std_logic;
    MXL_MGAIN_DATA  : out std_logic_vector(1 downto 0);

    MXL_RSSI_CLK    : in  std_logic;
    MXL_RSSI_STB    : in  std_logic;
    MXL_RSSI_DATA   : in  std_logic;

    MXL_TX_FAULT    : in  std_logic;
    MXL_INTR        : in  std_logic;
    MXL_IO1         : out std_logic;

    -- ETC

    LED_G           : out std_logic_vector(2 downto 0);
    LED_R           : out std_logic_vector(2 downto 0);

    LED             : out std_logic_vector(7 downto 0);

    OPTIC_SW        : out std_logic;
    L1_RESET        : out std_logic;
    ONE_PPS_MON     : out std_logic;
    TDD_MON         : out std_logic
  );
end entity;

architecture beh of N77_RU_TOP is

constant GND                    : std_logic := '0';

  signal sub_type               : std_logic;

 -- Clock

  signal cpri_ref_clk           : std_logic;
  signal jesd_ref_clk           : std_logic;
  signal jesd_core_clk          : std_logic;

  signal jesd_sysref            : std_logic;

  signal clk_491p52             : std_logic;
  signal clk_245p76             : std_logic;
  signal clk_122p88             : std_logic;
  signal clk_61p44              : std_logic;
  signal clk_7p68               : std_logic;

  signal clk_368p64             : std_logic;
  signal dspclk_368p64             : std_logic;
  signal clk_294p912            : std_logic;

  signal clk_25                 : std_logic;
  signal clk_12p5               : std_logic;
  signal clk_100                : std_logic;
  signal clk_125                : std_logic;
  signal clk_400                : std_logic;

  signal rec_clk                : std_logic;

  signal axi_rst_n              : std_logic := '0';
  signal loc_rst_n              : std_logic := '0';
  signal mmcm_cpri_locked       : std_logic;
  signal mmcm_jesd_locked       : std_logic;
  signal loc_locked             : std_logic;

  signal cpu_add                : std_logic_vector(23 downto 0);
  signal cpu_data               : std_logic_vector(31 downto 0);
  signal fpga_data_g            : std_logic_vector(31 downto 0);

  -- dsp

  signal adc0_i                 : std_logic_vector(15 downto 0);
  signal adc0_q                 : std_logic_vector(15 downto 0);
  signal adc1_i                 : std_logic_vector(15 downto 0);
  signal adc1_q                 : std_logic_vector(15 downto 0);
  signal adc2_i                 : std_logic_vector(15 downto 0);
  signal adc2_q                 : std_logic_vector(15 downto 0);
  signal adc3_i                 : std_logic_vector(15 downto 0);
  signal adc3_q                 : std_logic_vector(15 downto 0);
  signal fb0_i_s0               : std_logic_vector(15 downto 0);
  signal fb0_q_s0               : std_logic_vector(15 downto 0);
  signal fb0_i_s1               : std_logic_vector(15 downto 0);
  signal fb0_q_s1               : std_logic_vector(15 downto 0);
  signal fb1_i_s0               : std_logic_vector(15 downto 0);
  signal fb1_q_s0               : std_logic_vector(15 downto 0);
  signal fb1_i_s1               : std_logic_vector(15 downto 0);
  signal fb1_q_s1               : std_logic_vector(15 downto 0);
  signal dac0_i_s0              : std_logic_vector(15 downto 0);
  signal dac0_q_s0              : std_logic_vector(15 downto 0);
  signal dac0_i_s1              : std_logic_vector(15 downto 0);
  signal dac0_q_s1              : std_logic_vector(15 downto 0);
  signal dac1_i_s0              : std_logic_vector(15 downto 0);
  signal dac1_q_s0              : std_logic_vector(15 downto 0);
  signal dac1_i_s1              : std_logic_vector(15 downto 0);
  signal dac1_q_s1              : std_logic_vector(15 downto 0);
  signal dac2_i_s0              : std_logic_vector(15 downto 0);
  signal dac2_q_s0              : std_logic_vector(15 downto 0);
  signal dac2_i_s1              : std_logic_vector(15 downto 0);
  signal dac2_q_s1              : std_logic_vector(15 downto 0);
  signal dac3_i_s0              : std_logic_vector(15 downto 0);
  signal dac3_q_s0              : std_logic_vector(15 downto 0);
  signal dac3_i_s1              : std_logic_vector(15 downto 0);
  signal dac3_q_s1              : std_logic_vector(15 downto 0);

  signal tdd_sync               : std_logic_vector(1 downto 0);
  signal tdd_sync_dly           : std_logic_vector(1 downto 0);
  signal tdd_sync_lock          : std_logic_vector(1 downto 0);
  signal tdd_sync_in            : std_logic;
  signal dl_det_tsync           : std_logic;
  signal ul_det_tsync           : std_logic;

  signal dl_out_s0_i            : arr_4_16_stdlogic;
  signal dl_out_s0_q            : arr_4_16_stdlogic;
  signal dl_out_s1_i            : arr_4_16_stdlogic;
  signal dl_out_s1_q            : arr_4_16_stdlogic;

  signal ul_in_i                : arr_4_16_stdlogic;
  signal ul_in_q                : arr_4_16_stdlogic;

  signal ul_in_gain             : arr_4_16_stdlogic;
  signal dl_out_gain            : arr_4_16_stdlogic;

  signal dcm_dl_i               : arr_4_16_stdlogic;
  signal dcm_dl_q               : arr_4_16_stdlogic;
  signal dcm_dl_i_s             : arr_4_16_stdlogic;
  signal dcm_dl_q_s             : arr_4_16_stdlogic;
  signal dcm_dl_pow             : arr_4_32_stdlogic;
  signal dcm_dl_peak            : arr_4_32_stdlogic;
  signal dcm_ul_pow             : arr_4_32_stdlogic;
  signal dcm_ul_peak            : arr_4_32_stdlogic;
  signal dcm_dl_path_en         : std_logic_vector(3 downto 0);
  signal dcm_ul_path_en         : std_logic_vector(3 downto 0);
  signal dcm_input_gain         : arr_4_16_stdlogic;
  signal dcm_dl_slope           : arr_4_16_stdlogic;
  signal dcm_dl_curve           : arr_4_16_stdlogic;
  signal dcm_ul_slope           : arr_4_16_stdlogic;
  signal dcm_ul_curve           : arr_4_16_stdlogic;
  signal kddi_dl_i              : arr_4_16_stdlogic;
  signal kddi_dl_q              : arr_4_16_stdlogic;
  signal kddi_dl_i_s              : arr_4_16_stdlogic;
  signal kddi_dl_q_s              : arr_4_16_stdlogic;
  signal kddi_dl_pow            : arr_4_32_stdlogic;
  signal kddi_dl_peak           : arr_4_32_stdlogic;
  signal kddi_ul_pow            : arr_4_32_stdlogic;
  signal kddi_ul_peak           : arr_4_32_stdlogic;
  signal kddi_dl_path_en        : std_logic_vector(3 downto 0);
  signal kddi_ul_path_en        : std_logic_vector(3 downto 0);
  signal kddi_input_gain        : arr_4_16_stdlogic;
  signal kddi_dl_slope          : arr_4_16_stdlogic;
  signal kddi_dl_curve          : arr_4_16_stdlogic;
  signal kddi_ul_slope          : arr_4_16_stdlogic;
  signal kddi_ul_curve          : arr_4_16_stdlogic;
  signal rm_dl_i                : arr_4_16_stdlogic;
  signal rm_dl_q                : arr_4_16_stdlogic;
  signal rm_dl_i_s                : arr_4_16_stdlogic;
  signal rm_dl_q_s                : arr_4_16_stdlogic;
  signal rm_dl_pow              : arr_4_32_stdlogic;
  signal rm_dl_peak             : arr_4_32_stdlogic;
  signal rm_ul_pow              : arr_4_32_stdlogic;
  signal rm_ul_peak             : arr_4_32_stdlogic;
  signal rm_dl_path_en          : std_logic_vector(3 downto 0);
  signal rm_ul_path_en          : std_logic_vector(3 downto 0);
  signal rm_input_gain          : arr_4_16_stdlogic;
  signal rm_dl_slope            : arr_4_16_stdlogic;
  signal rm_dl_curve            : arr_4_16_stdlogic;
  signal rm_ul_slope            : arr_4_16_stdlogic;
  signal rm_ul_curve            : arr_4_16_stdlogic;
  signal sb_dl_i                : arr_4_16_stdlogic;
  signal sb_dl_q                : arr_4_16_stdlogic;
  signal sb_dl_i_s                : arr_4_16_stdlogic;
  signal sb_dl_q_s                : arr_4_16_stdlogic;
  signal sb_dl_pow              : arr_4_32_stdlogic;
  signal sb_dl_peak             : arr_4_32_stdlogic;
  signal sb_ul_pow              : arr_4_32_stdlogic;
  signal sb_ul_peak             : arr_4_32_stdlogic;
  signal sb_dl_path_en          : std_logic_vector(3 downto 0);
  signal sb_ul_path_en          : std_logic_vector(3 downto 0);
  signal sb_input_gain          : arr_4_16_stdlogic;
  signal sb_dl_slope            : arr_4_16_stdlogic;
  signal sb_dl_curve            : arr_4_16_stdlogic;
  signal sb_ul_slope            : arr_4_16_stdlogic;
  signal sb_ul_curve            : arr_4_16_stdlogic;

  signal dl_sum_pow             : arr_4_32_stdlogic;
  signal dl_sum_peak            : arr_4_32_stdlogic;

  signal dpd_gain               : arr_4_16_stdlogic;

  signal dl_out_pow             : arr_4_32_stdlogic;
  signal dl_out_peak            : arr_4_32_stdlogic;

  signal ul_in_pow              : arr_4_32_stdlogic;
  signal ul_in_peak             : arr_4_32_stdlogic;


  signal dl_i0                  : arr_4_16_stdlogic;
  signal dl_i1                  : arr_4_16_stdlogic;
  signal dl_i2                  : arr_4_16_stdlogic;
  signal dl_i3                  : arr_4_16_stdlogic;
  signal dl_q0                  : arr_4_16_stdlogic;
  signal dl_q1                  : arr_4_16_stdlogic;
  signal dl_q2                  : arr_4_16_stdlogic;
  signal dl_q3                  : arr_4_16_stdlogic;

  signal cas_i0                 : arr_4_16_stdlogic;
  signal cas_i1                 : arr_4_16_stdlogic;
  signal cas_i2                 : arr_4_16_stdlogic;
  signal cas_i3                 : arr_4_16_stdlogic;

  signal cas_q0                 : arr_4_16_stdlogic;
  signal cas_q1                 : arr_4_16_stdlogic;
  signal cas_q2                 : arr_4_16_stdlogic;
  signal cas_q3                 : arr_4_16_stdlogic;

  signal ul_i0                  : arr_4_16_stdlogic;
  signal ul_i1                  : arr_4_16_stdlogic;
  signal ul_i2                  : arr_4_16_stdlogic;
  signal ul_i3                  : arr_4_16_stdlogic;
  signal ul_q0                  : arr_4_16_stdlogic;
  signal ul_q1                  : arr_4_16_stdlogic;
  signal ul_q2                  : arr_4_16_stdlogic;
  signal ul_q3                  : arr_4_16_stdlogic;


  signal dcm_output_gain        : arr_4_16_stdlogic;
  signal dc_dout_i             : arr_4_16_stdlogic;
  signal dc_dout_q             : arr_4_16_stdlogic;
  signal dcm_cas_i              : arr_4_16_stdlogic;
  signal dcm_cas_q              : arr_4_16_stdlogic;
  signal dcm_sum_i              : arr_4_16_stdlogic;
  signal dcm_sum_q              : arr_4_16_stdlogic;
  signal kddi_slope_ul          : std_logic_vector(15 downto 0);
  signal kddi_curve_ul          : std_logic_vector(15 downto 0);
  signal kddi_output_gain       : arr_4_16_stdlogic;
  signal kd_dout_i            : arr_4_16_stdlogic;
  signal kd_dout_q            : arr_4_16_stdlogic;
  signal kddi_cas_i             : arr_4_16_stdlogic;
  signal kddi_cas_q             : arr_4_16_stdlogic;
  signal kddi_sum_i             : arr_4_16_stdlogic;
  signal kddi_sum_q             : arr_4_16_stdlogic;
  signal rm_slope_ul            : std_logic_vector(15 downto 0);
  signal rm_curve_ul            : std_logic_vector(15 downto 0);
  signal rm_output_gain         : arr_4_16_stdlogic;
  signal rm_dout_i              : arr_4_16_stdlogic;
  signal rm_dout_q              : arr_4_16_stdlogic;
  signal rm_cas_i               : arr_4_16_stdlogic;
  signal rm_cas_q               : arr_4_16_stdlogic;
  signal rm_sum_i               : arr_4_16_stdlogic;
  signal rm_sum_q               : arr_4_16_stdlogic;
  signal sb_slope_ul            : std_logic_vector(15 downto 0);
  signal sb_curve_ul            : std_logic_vector(15 downto 0);
  signal sb_output_gain         : arr_4_16_stdlogic;
  signal sb_dout_i              : arr_4_16_stdlogic;
  signal sb_dout_q              : arr_4_16_stdlogic;
  signal sb_cas_i               : arr_4_16_stdlogic;
  signal sb_cas_q               : arr_4_16_stdlogic;
  signal sb_sum_i               : arr_4_16_stdlogic;
  signal sb_sum_q               : arr_4_16_stdlogic;

  signal dl_dly_dcm_01          : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_dcm_23          : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_kddi_01         : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_kddi_23         : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_rm_01           : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_rm_23           : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_sb_01           : std_logic_vector(13 downto 0) := (others=>'0');
  signal dl_dly_sb_23           : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_dcm_01          : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_dcm_23          : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_kddi_01         : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_kddi_23         : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_rm_01           : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_rm_23           : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_sb_01           : std_logic_vector(13 downto 0) := (others=>'0');
  signal ul_dly_sb_23           : std_logic_vector(13 downto 0) := (others=>'0');

    -- CPRI
  signal cpri_rst_reg           : std_logic                           := '1';
  signal cpri_rst               : std_logic                           := '1';
  signal cpri_linkup            : std_logic_vector(CPRI_NUM downto 0);
  signal rst_n                  : std_logic                           := '0';

  signal l1_reset_reg           : std_logic;
  signal l1_reset_out           : std_logic;

  signal mapper_reset           : std_logic_vector(CPRI_NUM downto 0);

  signal basic_frame_first_word : std_logic_vector(CPRI_NUM downto 0);
  signal iq_tx_enable           : std_logic_vector(CPRI_NUM downto 0);
  signal iq_tx                  : arr_cpri_64_stdlogic;
  signal iq_rx                  : arr_cpri_64_stdlogic;

  signal cpri_qpll_lock         : std_logic;

  signal sfp_disable_reg        : std_logic_vector(3 downto 0);
  signal txinhibit              : std_logic_vector(3 downto 0);


  -- Zynq
  signal axi_clk                : std_logic;
  signal lock_100MHz            : std_logic;
  signal avalon_address         : std_logic_vector(23 downto 0);
  signal avalon_rd              : std_logic;
  signal avalon_rddata          : std_logic_vector(31 downto 0);
  signal avalon_rddatavalid     : std_logic;
  signal avalon_waitrequest     : std_logic;
  signal avalon_wr              : std_logic;
  signal avalon_wrdata          : std_logic_vector(31 downto 0);
  signal eth_gmii_txd           : std_logic_vector(7 downto 0);
  signal eth_gmii_rxd           : std_logic_vector(7 downto 0);
  signal eth_txd                : std_logic_vector(7 downto 0);
  signal eth_rxd                : std_logic_vector(7 downto 0);
  signal eth_speed_mode         : std_logic_vector(2 downto 0);
  signal eth_tx_en              : std_logic;
  signal eth_tx_er              : std_logic;
  signal eth_rx_dv              : std_logic;
  signal eth_rx_er              : std_logic;
  signal zynq_25MHz             : std_logic;

  signal eth_resetn             : std_logic;

  -- JESD

  signal jesd_tx_diff_ctrl      : std_logic_vector(4 downto 0)        := "11111";

  signal rfic_loop              : std_logic_vector(1 downto 0);
  --signal path_loop            : std_logic_vector(5 downto 0);

  signal cpri_core_reset        : std_logic;


  signal pow_cnt                : std_logic_vector(  7 downto  0)     := x"16";
  signal pow_sel                : std_logic_vector(  3 downto  0)     := x"0";


  signal CFR_AXI_RST_N          : std_logic_vector ( 0 to 0 );
  signal CFR_AXI_araddr         : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_araddr_s         : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_arprot         : std_logic_vector ( 2 downto 0 );
  signal CFR_AXI_arready        : std_logic;
  signal CFR_AXI_arvalid        : std_logic;
  signal CFR_AXI_awaddr         : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_awaddr_s         : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_awprot         : std_logic_vector ( 2 downto 0 );
  signal CFR_AXI_awready        : std_logic;
  signal CFR_AXI_awvalid        : std_logic;
  signal CFR_AXI_bready         : std_logic;
  signal CFR_AXI_bresp          : std_logic_vector ( 1 downto 0 );
  signal CFR_AXI_bvalid         : std_logic;
  signal CFR_AXI_rdata          : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_rready         : std_logic;
  signal CFR_AXI_rresp          : std_logic_vector ( 1 downto 0 );
  signal CFR_AXI_rvalid         : std_logic;
  signal CFR_AXI_wdata          : std_logic_vector ( 31 downto 0 );
  signal CFR_AXI_wready         : std_logic;
  signal CFR_AXI_wstrb          : std_logic_vector ( 3 downto 0 );
  signal CFR_AXI_wvalid         : std_logic;

  signal CPRI_AXI_RST_N         : std_logic_vector ( 0 to 0 );
  signal CPRI_AXI_araddr        : arr_cpri_32_stdlogic;
  signal CPRI_AXI_araddr_12     : arr_cpri_12_stdlogic;
  signal CPRI_AXI_arprot        : arr_cpri_3_stdlogic;
  signal CPRI_AXI_arready       : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_arvalid       : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_awaddr        : arr_cpri_32_stdlogic;
  signal CPRI_AXI_awaddr_12     : arr_cpri_12_stdlogic;
  signal CPRI_AXI_awprot        : arr_cpri_3_stdlogic;
  signal CPRI_AXI_awready       : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_awvalid       : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_bready        : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_bresp         : arr_cpri_2_stdlogic;
  signal CPRI_AXI_bvalid        : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_rdata         : arr_cpri_32_stdlogic;
  signal CPRI_AXI_rready        : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_rresp         : arr_cpri_2_stdlogic;
  signal CPRI_AXI_rvalid        : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_wdata         : arr_cpri_32_stdlogic;
  signal CPRI_AXI_wready        : std_logic_vector(CPRI_NUM downto 0);
  signal CPRI_AXI_wstrb         : arr_cpri_4_stdlogic;
  signal CPRI_AXI_wvalid        : std_logic_vector(CPRI_NUM downto 0);

  signal JESD_RX_AXI_araddr     : std_logic_vector ( 31 downto 0 );
  signal JESD_RX_AXI_arprot     : std_logic_vector ( 2 downto 0 );
  signal JESD_RX_AXI_arready    : std_logic;
  signal JESD_RX_AXI_arvalid    : std_logic;
  signal JESD_RX_AXI_awaddr     : std_logic_vector ( 31 downto 0 );
  signal JESD_RX_AXI_awprot     : std_logic_vector ( 2 downto 0 );
  signal JESD_RX_AXI_awready    : std_logic;
  signal JESD_RX_AXI_awvalid    : std_logic;
  signal JESD_RX_AXI_bready     : std_logic;
  signal JESD_RX_AXI_bresp      : std_logic_vector ( 1 downto 0 );
  signal JESD_RX_AXI_bvalid     : std_logic;
  signal JESD_RX_AXI_rdata      : std_logic_vector ( 31 downto 0 );
  signal JESD_RX_AXI_rready     : std_logic;
  signal JESD_RX_AXI_rresp      : std_logic_vector ( 1 downto 0 );
  signal JESD_RX_AXI_rvalid     : std_logic;
  signal JESD_RX_AXI_wdata      : std_logic_vector ( 31 downto 0 );
  signal JESD_RX_AXI_wready     : std_logic;
  signal JESD_RX_AXI_wstrb      : std_logic_vector ( 3 downto 0 );
  signal JESD_RX_AXI_wvalid     : std_logic;

  signal JESD_TX_AXI_araddr     : std_logic_vector ( 31 downto 0 );
  signal JESD_TX_AXI_arprot     : std_logic_vector ( 2 downto 0 );
  signal JESD_TX_AXI_arready    : std_logic;
  signal JESD_TX_AXI_arvalid    : std_logic;
  signal JESD_TX_AXI_awaddr     : std_logic_vector ( 31 downto 0 );
  signal JESD_TX_AXI_awprot     : std_logic_vector ( 2 downto 0 );
  signal JESD_TX_AXI_awready    : std_logic;
  signal JESD_TX_AXI_awvalid    : std_logic;
  signal JESD_TX_AXI_bready     : std_logic;
  signal JESD_TX_AXI_bresp      : std_logic_vector ( 1 downto 0 );
  signal JESD_TX_AXI_bvalid     : std_logic;
  signal JESD_TX_AXI_rdata      : std_logic_vector ( 31 downto 0 );
  signal JESD_TX_AXI_rready     : std_logic;
  signal JESD_TX_AXI_rresp      : std_logic_vector ( 1 downto 0 );
  signal JESD_TX_AXI_rvalid     : std_logic;
  signal JESD_TX_AXI_wdata      : std_logic_vector ( 31 downto 0 );
  signal JESD_TX_AXI_wready     : std_logic;
  signal JESD_TX_AXI_wstrb      : std_logic_vector ( 3 downto 0 );
  signal JESD_TX_AXI_wvalid     : std_logic;


  signal jesd_qpll_lock         : std_logic;
  signal gt_powergood           : std_logic;

  signal dpd_in_tdata           : std_logic_vector ( 255 downto 0 );
  signal dpd_in_tlast           : std_logic;
  signal dpd_in_tready          : std_logic;
  signal dpd_in_tuser           : std_logic_vector ( 31 downto 0 )    := x"00000000";
  signal dpd_in_tvalid          : std_logic;
  signal dpd_out_tdata          : std_logic_vector ( 255 downto 0 );
  signal dpd_out_tlast          : std_logic;
  signal dpd_out_tready         : std_logic;
  signal dpd_out_tuser          : std_logic_vector ( 31 downto 0 );
  signal dpd_out_tvalid         : std_logic;
  signal fb_in_tdata            : std_logic_vector ( 63 downto 0 );
  signal fb_in_tready           : std_logic;
  signal fb_in_tuser            : std_logic_vector ( 7 downto 0 )     := x"00";
  signal fb_in_tvalid           : std_logic;

  signal srx_ctrl_tdata         : std_logic_vector ( 7 downto 0 );
  signal srx_ctrl_tready        : std_logic;
  signal srx_ctrl_tvalid        : std_logic;

  signal avalon_rd_s0           : std_logic;
  signal avalon_rd_s1           : std_logic;
  signal avalon_rd_s2           : std_logic;

  signal fir_loop               : std_logic                           := '0';
  signal comp_loop              : std_logic                           := '0';

  signal coe_sel                : std_logic_vector( 2 downto  0)      := "000";
  signal ram_sel                : std_logic                           := '0';
  signal ant_sel                : std_logic_vector( 2 downto  0)      := "000";


  signal rd_enable              : std_logic;
  signal rd_en_delay            : std_logic_vector( 2 downto 0);
  signal mod_cnt                : std_logic_vector( 1 downto 0)       := "00";
  signal test_data              : std_logic_vector(15 downto 0)       := x"0200";
  signal test_data_s0           : std_logic_vector(15 downto 0);
  signal test_data_s1           : std_logic_vector(15 downto 0);
  signal test_i                 : std_logic_vector(15 downto 0);
  signal test_q                 : std_logic_vector(15 downto 0);

  signal tdd_ctrl               : std_logic;

  signal FB_IN_buf              : std_logic_vector(63 downto 0);

  signal dpd_bypass             : std_logic                           :='0';

  signal fb_pow                 : arr_4_32_stdlogic;
  signal fb_peak                : arr_4_32_stdlogic;

  signal dpd_rst_reg            : std_logic                           := '1';
  signal dpd_rst                : std_logic                           := '1';
  signal dpd_rst_n              : std_logic                           := '0';

  signal g_led_reg              : std_logic_vector(2 downto 0);
  signal r_led_reg              : std_logic_vector(2 downto 0);

  signal path_sel               : std_logic_vector( 1 downto 0);
  signal cw_data                : std_logic_vector(15 downto 0);
  signal cw_start               : std_logic;
  signal signal_on              : std_logic_vector( 5 downto 0);

  signal t_offset               : std_logic_vector(31 downto 0);

  signal fb_port                : std_logic_vector(7 downto 0);

  signal eth_gap                : std_logic_vector(11 downto 0);

  signal test_reg               : std_logic_vector(31 downto 0);

  signal gt_rxpcs_rst           : std_logic_vector(CPRI_NUM downto 0);
  signal gt_txpcs_rst           : std_logic_vector(CPRI_NUM downto 0);
  signal gt_rxpma_rst           : std_logic_vector(CPRI_NUM downto 0);
  signal gt_txpma_rst           : std_logic_vector(CPRI_NUM downto 0);
  signal gt_txresetdone         : std_logic_vector(CPRI_NUM downto 0);
  signal gt_rxresetdone         : std_logic_vector(CPRI_NUM downto 0);
  signal gt_rxlpmen             : std_logic_vector(CPRI_NUM downto 0);
  signal gt_txdiffctrl          : arr_cpri_5_stdlogic;
  signal add_rst                : std_logic;

  signal tdd_mode               : std_logic_vector(1 downto 0);
  signal cal_mode               : std_logic_vector(1 downto 0);
  signal fbsel_mode             : std_logic_vector(1 downto 0);
  signal mxl_fb_sw              : std_logic_vector(1 downto 0);

  signal r_pull_dl              : std_logic_vector(16 downto 0);
  signal r_push_dl              : std_logic_vector(16 downto 0);
  signal f_pull_dl              : std_logic_vector(16 downto 0);
  signal f_push_dl              : std_logic_vector(16 downto 0);
  signal r_pull_ul              : std_logic_vector(16 downto 0);
  signal r_push_ul              : std_logic_vector(16 downto 0);
  signal f_pull_ul              : std_logic_vector(16 downto 0);
  signal f_push_ul              : std_logic_vector(16 downto 0);

  signal r_pull_dl_rf           : std_logic_vector(16 downto 0);
  signal r_push_dl_rf           : std_logic_vector(16 downto 0);
  signal f_pull_dl_rf           : std_logic_vector(16 downto 0);
  signal f_push_dl_rf           : std_logic_vector(16 downto 0);
  signal r_pull_ul_rf           : std_logic_vector(16 downto 0);
  signal r_push_ul_rf           : std_logic_vector(16 downto 0);
  signal f_pull_ul_rf           : std_logic_vector(16 downto 0);
  signal f_push_ul_rf           : std_logic_vector(16 downto 0);
  signal r_pull_ul_rssi         : std_logic_vector(16 downto 0);
  signal r_push_ul_rssi         : std_logic_vector(16 downto 0);
  signal f_pull_ul_rssi         : std_logic_vector(16 downto 0);
  signal f_push_ul_rssi         : std_logic_vector(16 downto 0);

  signal scl_in                 : std_logic_vector(4 downto 0);
  signal scl_out                : std_logic_vector(4 downto 0);
  signal scl_t                  : std_logic_vector(4 downto 0);
  signal sda_in                 : std_logic_vector(4 downto 0);
  signal sda_out                : std_logic_vector(4 downto 0);
  signal sda_t                  : std_logic_vector(4 downto 0);

  signal mxl_rst_reg            : std_logic := '1';
  signal pl_rst_n               : std_logic;

  signal mxl_gain               : arr_4_5_stdlogic;

  signal mxl_peak               : std_logic_vector(3 downto 0);
  signal mxl_hi                 : std_logic_vector(3 downto 0);
  signal mxl_lo                 : std_logic_vector(3 downto 0);


  signal rfu_rx_en_reg          : std_logic_vector(3 downto 0);
  signal rfu_tx_en_reg          : std_logic_vector(3 downto 0);

  signal fb_sw                  : std_logic_vector(1 downto 0);
  signal fb_ona                 : std_logic;
  signal fb_sw_dly              : std_logic_vector(10 downto 0);

  signal tdd_sync_dl            : std_logic;
  signal tdd_sync_ul            : std_logic;
  signal tdd_mon_sel			: std_logic_vector(3 downto 0);


  signal mxl_tx_en_reg          : std_logic_vector(3 downto 0);
  signal mxl_tx_en_reg_s          : std_logic_vector(3 downto 0);
  signal mxl_rx_en_reg          : std_logic_vector(3 downto 0);

  signal rfu_io_test_mode       : std_logic_vector(1 downto 0);

  signal led_cnt                : std_logic_vector(23 downto 0);

  signal working_led            : std_logic;

  -- signal mu_id                  : arr_2_4_stdlogic;
  -- signal mu_port_num            : arr_2_4_stdlogic;
  -- signal hu_port_num            : arr_2_4_stdlogic;
  -- signal cascade_num            : arr_2_4_stdlogic;
  -- signal du_type                : arr_2_2_stdlogic;
  -- signal module_type            : arr_2_6_stdlogic;
   signal op_id0                 : arr_2_6_stdlogic;
   signal op_id1                 : arr_2_6_stdlogic;
  -- signal band_id0                : arr_2_2_stdlogic;
  -- signal band_id1                : arr_2_2_stdlogic;
  -- signal dl_dly_ctrl0           : arr_2_24_stdlogic;
  -- signal ul_dly_ctrl0           : arr_2_24_stdlogic;
  -- signal dl_dly_ctrl1           : arr_2_24_stdlogic;
  -- signal ul_dly_ctrl1           : arr_2_24_stdlogic;
  signal cpri_t_offset          : arr_2_32_stdlogic;
  signal cas_delay          	: arr_2_32_stdlogic;
  -- signal ip_offset          	: arr_2_32_stdlogic;
  -- signal cnm_prime				: std_logic_vector(1 downto 0);

	signal vs_rx_0_80_0				: arr_2_32_stdlogic;
	signal vs_rx_0_80_1				: arr_cpri_32_stdlogic;
	signal vs_rx_0_144_0			: arr_cpri_32_stdlogic;
	signal vs_rx_0_144_1			: arr_2_32_stdlogic;
	signal vs_rx_0_144_2			: arr_2_32_stdlogic;
	signal vs_rx_0_144_3			: arr_2_32_stdlogic;
	signal vs_tx_0_80             :arr_4_128_stdlogic;
	signal vs_tx_0_144            :arr_4_128_stdlogic;
  signal vs_rx_0_80             :arr_4_128_stdlogic;
  signal vs_rx_0_144            :arr_4_128_stdlogic;
	signal cnm_prime_in				: std_logic;
	signal ip_offset_fb				: arr_2_32_stdlogic;
	signal ip_offset_cas			: arr_2_32_stdlogic;

  signal optic_sw_reg           : std_logic;

  signal mxl_chip_mode_reg      : std_logic_vector(1 downto 0);
  signal mxl_clk_sel_reg        : std_logic_vector(2 downto 0);
  signal mxl_pap_reg            : std_logic;
  signal mxl_io1_reg			: std_logic;
  signal mxl_init_reg			: std_logic := '0';

  signal jesd_irq               : std_logic_vector(1 downto 0);
  signal rfic_irq               : std_logic_vector(2 downto 0);
  signal mxl_fbrx_cal_s         : std_logic;
  signal mxl_fb_en_s         : std_logic_vector(1 downto 0);

  signal core_is_master       : std_logic_vector(CPRI_NUM downto 0);
  signal rec_clk_clr : std_logic;
  signal dpd_rst_reg_s  : std_logic;
  signal fb_in_gain				: std_logic_vector(15 downto 0);
  signal fb_sw_cnt_out			: std_logic_vector(23 downto 0);
  signal peak_sel				: std_logic := '0';
  signal l1_reset_out_s		: std_logic;
  signal l1_reset_ctrl_reg		: std_logic := '0';
  signal fpga_temp          : std_logic_vector(9 downto 0);
  signal tdd_sync_rssi      : std_logic;
  signal bg_cal_duration       : std_logic_vector(31 downto 0);
  -- signal adc_assign_value : std_logic_vector( 7 downto 0);
  -- signal fb_assign_value : std_logic_vector(31 downto 0);
  signal vs_tx_0_80_0				: arr_2_32_stdlogic;
  signal vs_tx_0_144_0				: arr_2_32_stdlogic;
  signal vs_tx_0_144_1				: arr_2_32_stdlogic;
  signal vs_tx_0_144_2				: arr_2_32_stdlogic;
  signal vs_tx_0_144_3				: arr_2_32_stdlogic;
  signal cpri_hyperframe_number : arr_cpri_8_stdlogic;
  signal stat_speed             : arr_cpri_15_stdlogic;
  signal nodebfn_rx_strobe      : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_rx_nr          : arr_cpri_12_stdlogic;
  signal nodebfn_tx_strobe      : std_logic_vector(CPRI_NUM downto 0);
  signal nodebfn_tx_nr          : arr_cpri_12_stdlogic;
  signal vendor_rx_xs           : arr_cpri_2_stdlogic;
  signal vendor_rx_ns           : arr_cpri_6_stdlogic;
  signal vendor_tx_xs           : arr_cpri_2_stdlogic;
  signal vendor_tx_ns           : arr_cpri_6_stdlogic;
  signal vendor_tx_data         : arr_cpri_128_stdlogic;
  signal vendor_rx_data         : arr_cpri_128_stdlogic;
  signal tdd_valid_s            : std_logic_vector(1 downto 0);
  signal map_loop_mode          : arr_2_2_stdlogic;
  signal map_test_mode          : std_logic;
  signal combine_bypass_mode    : std_logic;
  signal ul_ref_10m             :arr_2_1_stdlogic;
  signal dl_iq_sync             : std_logic_vector(3 downto 0);
  signal ul_iq_sync             : std_logic;
  signal dcm_dout_iq            : arr_4_32_stdlogic;
  signal kddi_dout_iq           : arr_4_32_stdlogic;
  signal rm_dout_iq             : arr_4_32_stdlogic;
  signal sb_dout_iq             : arr_4_32_stdlogic;
  signal dl_ref_10m_s           : std_logic_vector(1 downto 0);
  signal dl_iq0                 : arr_4_32_stdlogic;
  signal dl_iq1                 : arr_4_32_stdlogic;
  signal dl_iq2                 : arr_4_32_stdlogic;
  signal dl_iq3                 : arr_4_32_stdlogic;
  signal dl_ref_10m             : std_logic;
  signal tdd_valid              : std_logic;
  signal dl_slt_num1            : std_logic_vector(5 downto 0)        :="000011";
  signal dl_sym_num1            : std_logic_vector(3 downto 0)        :="0110";
  signal ul_slt_num1            : std_logic_vector(5 downto 0)        :="000000";
  signal ul_sym_num1            : std_logic_vector(3 downto 0)        :="0000";
  signal dl_slt_num2            : std_logic_vector(5 downto 0)        :="000100";
  signal dl_sym_num2            : std_logic_vector(3 downto 0)        :="0000";
  signal ul_slt_num2            : std_logic_vector(5 downto 0)        :="000000";
  signal ul_sym_num2            : std_logic_vector(3 downto 0)        :="0000";
  signal trx_periodicity1       : std_logic_vector(6 downto 0)        :="0011110";
  signal trx_periodicity2       : std_logic_vector(6 downto 0)        :="0010100";
  signal patt2_onoff            : std_logic                           :='0';
  signal ul_ref_10m_dly_val     : arr_2_10_stdlogic;
  signal ul_ref_10m_dly         : arr_2_1_stdlogic;
  signal ul_ref             : std_logic_vector(1 downto 0);
  signal tsync_chk_clr      : std_logic;
  signal mapper_rst_n       : std_logic;
  signal dpd_in_tuser_ant            : arr_4_8_stdlogic;
  signal mxl_tx_en_s : std_logic_vector(3 downto 0);
  signal tdd_sync_dl_sync : std_logic;
  signal fb_valid : std_logic;
  signal xdpd_rfs : std_logic;
  signal frame_marker : std_logic;
  signal dl_ul_marker : std_logic;
  signal capture_sync : std_logic;
  signal pow_en_fb	: std_logic_vector(3 downto 0);
  signal fa_det_threshold	: std_logic_vector(31 downto 0);
  signal fa_detect            : arr_4_4_stdlogic;
  signal pow_en_sync	: std_logic_vector(3 downto 0);
  signal eth_blk_rst    : std_logic := '0';
  signal link_chg_rst_n : std_logic;
  signal data_sync_dl       : std_logic;
  signal mapper_rst_p       : std_logic_vector(1 downto 0);
  signal master_lane_ind        : std_logic;

  begin


--cpu_add          <= "00" & avalon_address(19 downto 2);


cpu_add          <= avalon_address(23 downto 0);
avalon_rddata <= fpga_data_g;

process(clk_100)
begin
if rising_edge(clk_100) then
    if (loc_rst_n='0') then
        rd_enable             <= '0';
        avalon_rddatavalid    <= '0';
    else
        rd_enable            <= avalon_rd;
        avalon_rddatavalid    <= rd_enable;
    end if;
end if;
end process;

process(clk_100)
begin
if rising_edge(clk_100) then
    if (loc_rst_n='0') then
        fpga_data_g       <= (others => '0');

        pow_cnt           <= x"16";

        rfic_loop         <= "00";

        jesd_tx_diff_ctrl <= "11111";

        tdd_ctrl          <= '0';
        pow_sel           <= x"0";
        dpd_rst_reg       <= '1';

        sfp_disable_reg   <= x"0";
        path_sel          <= "00";
        cw_data           <= x"0400";

        t_offset          <= x"00000000";

        eth_gap           <= x"010";
        eth_rx_er         <= '0';

        ul_in_gain(0)     <= x"0800";
        ul_in_gain(1)     <= x"0800";
        ul_in_gain(2)     <= x"0800";
        ul_in_gain(3)     <= x"0800";

        dl_out_gain(0)    <= x"0800";
        dl_out_gain(1)    <= x"0800";
        dl_out_gain(2)    <= x"0800";
        dl_out_gain(3)    <= x"0800";

        dpd_gain(0)       <= x"0800";
        dpd_gain(1)       <= x"0800";
        dpd_gain(2)       <= x"0800";
        dpd_gain(3)       <= x"0800";

        dl_dly_dcm_01     <= "00000000000000";
        dl_dly_dcm_23     <= "00000000000000";
        dl_dly_kddi_01    <= "00000000000000";
        dl_dly_kddi_23    <= "00000000000000";
        dl_dly_rm_01      <= "00000000000000";
        dl_dly_rm_23      <= "00000000000000";
        dl_dly_sb_01      <= "00000000000000";
        dl_dly_sb_23      <= "00000000000000";

        ul_dly_dcm_01     <= "00000000000000";
        ul_dly_dcm_23     <= "00000000000000";
        ul_dly_kddi_01    <= "00000000000000";
        ul_dly_kddi_23    <= "00000000000000";
        ul_dly_rm_01      <= "00000000000000";
        ul_dly_rm_23      <= "00000000000000";
        ul_dly_sb_01      <= "00000000000000";
        ul_dly_sb_23      <= "00000000000000";

        gt_rxpcs_rst      <= "0000";
        gt_txpcs_rst      <= "0000";
        --gt_rxpma_rst      <= "0000";
        --gt_txpma_rst      <= "0000";
        gt_rxlpmen        <= "1111";
        gt_txdiffctrl(0)  <= "00100";
        gt_txdiffctrl(1)  <= "00100";
        gt_txdiffctrl(2)  <= "00100";
        gt_txdiffctrl(3)  <= "00100";
        eth_blk_rst <= '0';

        r_pull_dl         <= (others => '0');
        r_push_dl         <= (others => '0');
        f_pull_dl         <= (others => '0');
        f_push_dl         <= (others => '0');

        r_pull_ul         <= (others => '0');
        r_push_ul         <= (others => '0');
        f_pull_ul         <= (others => '0');
        f_push_ul         <= (others => '0');

        r_pull_dl_rf      <= (others => '0');
        r_push_dl_rf      <= (others => '0');
        f_pull_dl_rf      <= (others => '0');
        f_push_dl_rf      <= (others => '0');

        r_pull_ul_rf      <= (others => '0');
        r_push_ul_rf      <= (others => '0');
        f_pull_ul_rf      <= (others => '0');
        f_push_ul_rf      <= (others => '0');

		r_pull_ul_rssi    <= (others => '0');
        r_push_ul_rssi    <= "0" & x"1000";
        f_pull_ul_rssi    <= "1" & x"ffff";
        f_push_ul_rssi    <= (others => '0');

        bg_cal_duration   <= x"0000ea60";--60000

        mxl_rst_reg       <= '1';
        mxl_init_reg      <= '0';
        mxl_chip_mode_reg <= "ZZ";
        mxl_io1_reg <= 'Z';
        mxl_clk_sel_reg   <= "001";
        mxl_pap_reg       <= '0';

        mxl_gain(0)       <= "00000";
        mxl_gain(1)       <= "00000";
        mxl_gain(2)       <= "00000";
        mxl_gain(3)       <= "00000";
        rfu_tx_en_reg     <= "0000";
        rfu_rx_en_reg     <= "1111";
        mxl_tx_en_reg     <= "0000";
        mxl_rx_en_reg     <= "0000";

        tdd_mode          <= "11";
        cal_mode          <= "11";
        fbsel_mode        <= "11";
        rfu_io_test_mode  <= "00";

        fb_sw_dly         <= "00000000000";
		fb_in_gain		  <= x"0800";

		tdd_mon_sel		  <= x"0";
		l1_reset_ctrl_reg <= '0';

        optic_sw_reg      <= '0';
        map_loop_mode(0) <= "00";
        map_loop_mode(1) <= "00";
        map_test_mode <= '0';
        combine_bypass_mode <= '0';
		tsync_chk_clr <= '1';	
    else
        -- write general
        if(avalon_wr = '1') then
            case(cpu_add(19 downto 0)) is
                when x"00003"   => sfp_disable_reg     <= cpu_data(3 downto 0);
				when x"00004"   => tsync_chk_clr <= cpu_data(31);

                when x"00008"   => optic_sw_reg        <= cpu_data(0);

                when x"0000a"   => tdd_mode            <= cpu_data(9 downto 8);
                                   fbsel_mode          <= cpu_data(5 downto 4);
                                   cal_mode            <= cpu_data(1 downto 0);
                when x"0000b"   => bg_cal_duration     <= cpu_data(31 downto 0);
                when x"0000c"   => jesd_tx_diff_ctrl   <= cpu_data(4 downto 0);

                -- when x"0000f"   => core_is_master     <= cpu_data(3 downto 0);

                when x"00010"   => r_led_reg(0)        <= cpu_data(0);
                                   g_led_reg(0)        <= cpu_data(1);
                when x"00011"   => r_led_reg(1)        <= cpu_data(0);
                                   g_led_reg(1)        <= cpu_data(1);
                when x"00012"   => r_led_reg(2)        <= cpu_data(0);
                                   g_led_reg(2)        <= cpu_data(1);

				when x"00030"   => cnm_prime_in        <= cpu_data(0);
				when x"00031"   => cpri_t_offset(0)    <= cpu_data(31 downto 0);
				when x"00032"   => cas_delay(0)    	   <= cpu_data(31 downto 0);
				when x"00033"   => cpri_t_offset(1)    <= cpu_data(31 downto 0);
				when x"00034"   => cas_delay(1)    	   <= cpu_data(31 downto 0);
				when x"00035"   => ip_offset_fb(0)    	   <= cpu_data(31 downto 0);
				when x"00036"   => ip_offset_cas(0)       <= cpu_data(31 downto 0);
				when x"0003b"   => ip_offset_fb(1)    	   <= cpu_data(31 downto 0);
				when x"0003c"   => ip_offset_cas(1)       <= cpu_data(31 downto 0);
                when x"0003d"   => vs_tx_0_80_0(0)       <= cpu_data(31 downto 0);
				when x"0003e"   => vs_tx_0_80_0(1)       <= cpu_data(31 downto 0);
				
				when x"00040"   => vs_tx_0_144_0(0)       <= cpu_data(31 downto 0);
				when x"00041"   => vs_tx_0_144_0(1)       <= cpu_data(31 downto 0);
				when x"00042"   => vs_tx_0_144_1(0)       <= cpu_data(31 downto 0);
				when x"00043"   => vs_tx_0_144_1(1)       <= cpu_data(31 downto 0);
				when x"00044"   => vs_tx_0_144_2(0)       <= cpu_data(31 downto 0);
				when x"00045"   => vs_tx_0_144_2(1)       <= cpu_data(31 downto 0);
				when x"00046"   => vs_tx_0_144_3(0)       <= cpu_data(31 downto 0);
				when x"00047"   => vs_tx_0_144_3(1)       <= cpu_data(31 downto 0);

				when x"00052"   => l1_reset_ctrl_reg   <= cpu_data(0);
                when x"00055"   => mxl_rst_reg         <= cpu_data(0);

                when x"00060"   => cpri_rst_reg        <= cpu_data(0);
                when x"00061"   => gt_rxpcs_rst        <= cpu_data(3 downto 0);
                when x"00062"   => gt_txpcs_rst        <= cpu_data(3 downto 0);
                --when x"00063"   => gt_rxpma_rst        <= cpu_data(3 downto 0);
                --when x"00064"   => gt_txpma_rst        <= cpu_data(3 downto 0);
                when x"00067"   => gt_rxlpmen          <= cpu_data(3 downto 0);
                when x"00068"   => gt_txdiffctrl(0)    <= cpu_data(4 downto 0);
                when x"00069"   => gt_txdiffctrl(1)    <= cpu_data(4 downto 0);
                when x"0006a"   => gt_txdiffctrl(2)    <= cpu_data(4 downto 0);
                when x"0006b"   => gt_txdiffctrl(3)    <= cpu_data(4 downto 0);
				when x"0006c"   => map_loop_mode(0)        <= cpu_data(1 downto 0);
                                   map_loop_mode(1)        <= cpu_data(3 downto 2);
                                   map_test_mode        <= cpu_data(4);
                                   combine_bypass_mode        <= cpu_data(8);
                when x"0006d"   => eth_blk_rst		<= cpu_data(0);

                when x"00073"   => pow_cnt             <= cpu_data( 7 downto 0);
                when x"00075"   => eth_gap             <= cpu_data(11 downto 0);

                when x"00080"   => mxl_chip_mode_reg   <= cpu_data(1 downto 0);
                when x"00081"   => mxl_clk_sel_reg     <= cpu_data(2 downto 0);
                when x"00083"   => mxl_pap_reg         <= cpu_data(0);
                when x"00084"   => mxl_init_reg         <= cpu_data(0);

                when x"00090"   => r_pull_dl           <= cpu_data(16 downto 0);
                when x"00091"   => r_push_dl           <= cpu_data(16 downto 0);
                when x"00092"   => f_pull_dl           <= cpu_data(16 downto 0);
                when x"00093"   => f_push_dl           <= cpu_data(16 downto 0);
                when x"00094"   => r_pull_ul           <= cpu_data(16 downto 0);
                when x"00095"   => r_push_ul           <= cpu_data(16 downto 0);
                when x"00096"   => f_pull_ul           <= cpu_data(16 downto 0);
                when x"00097"   => f_push_ul           <= cpu_data(16 downto 0);
                when x"00098"   => r_pull_dl_rf        <= cpu_data(16 downto 0);
                when x"00099"   => r_push_dl_rf        <= cpu_data(16 downto 0);
                when x"0009a"   => f_pull_dl_rf        <= cpu_data(16 downto 0);
                when x"0009b"   => f_push_dl_rf        <= cpu_data(16 downto 0);
                when x"0009c"   => r_pull_ul_rf        <= cpu_data(16 downto 0);
                when x"0009d"   => r_push_ul_rf        <= cpu_data(16 downto 0);
                when x"0009e"   => f_pull_ul_rf        <= cpu_data(16 downto 0);
                when x"0009f"   => f_push_ul_rf        <= cpu_data(16 downto 0);
				
				when x"000a0"   => dl_sym_num1         <= cpu_data(11 downto 8);
                                   dl_slt_num1         <= cpu_data(5 downto 0);
                when x"000a1"   => ul_sym_num1         <= cpu_data(11 downto 8);
                                   ul_slt_num1         <= cpu_data(5 downto 0);
                when x"000a2"   => trx_periodicity1    <= cpu_data(6 downto 0);
                when x"000a3"   => patt2_onoff         <= cpu_data(0);
                when x"000a4"   => dl_sym_num2         <= cpu_data(11 downto 8);
                                   dl_slt_num2         <= cpu_data(5 downto 0);
                when x"000a5"   => ul_sym_num2         <= cpu_data(11 downto 8);
                                   ul_slt_num2         <= cpu_data(5 downto 0);
                when x"000a6"   => trx_periodicity2    <= cpu_data(6 downto 0);

				when x"000b0"   => r_pull_ul_rssi      <= cpu_data(16 downto 0);
                when x"000b1"   => r_push_ul_rssi      <= cpu_data(16 downto 0);
                when x"000b2"   => f_pull_ul_rssi      <= cpu_data(16 downto 0);
                when x"000b3"   => f_push_ul_rssi      <= cpu_data(16 downto 0);
				
				when x"000c0"   => ul_ref_10m_dly_val(0)    <= cpu_data(9 downto 0);
                when x"000c1"   => ul_ref_10m_dly_val(1)    <= cpu_data(9 downto 0);

                when x"000d0"   => dpd_rst_reg         <= cpu_data(0);
                when x"000d1"   => fb_sw_dly           <= cpu_data(10 downto 0);
				when x"000d2"	=> fb_in_gain			<= cpu_data(15 downto 0);

                --when x"000e0"   => t_offset            <= cpu_data;

                when x"000f0"   => rfic_loop           <= cpu_data(1 downto 0);
                when x"000f1"   => path_sel            <= cpu_data(1 downto 0);
                when x"000f2"   => cw_start            <= cpu_data(0);
                when x"000f6"   => pow_sel             <= cpu_data(3 downto 0);
				when x"000f7"   => peak_sel            <= cpu_data(0);
                when x"000f9"   => cw_data             <= cpu_data(15 downto 0);
				-- when x"000fa"   => adc_assign_value    <= cpu_data(7 downto 0);
				when x"000fb"   => tdd_mon_sel         <= cpu_data(3 downto 0);
				
				when x"00100"   => fa_det_threshold         <= cpu_data(31 downto 0);

                -- DL PATH
                when x"10100"   => dl_dly_dcm_01       <= cpu_data(13 downto 0);
                when x"10300"   => dl_dly_dcm_23       <= cpu_data(13 downto 0);
                when x"20100"   => dl_dly_kddi_01      <= cpu_data(13 downto 0);
                when x"20300"   => dl_dly_kddi_23      <= cpu_data(13 downto 0);
                when x"30100"   => dl_dly_rm_01        <= cpu_data(13 downto 0);
                when x"30300"   => dl_dly_rm_23        <= cpu_data(13 downto 0);
                when x"40100"   => dl_dly_sb_01        <= cpu_data(13 downto 0);
                when x"40300"   => dl_dly_sb_23        <= cpu_data(13 downto 0);

                when x"1010c"   => dcm_dl_path_en(0)   <= cpu_data(0);
                when x"1020c"   => dcm_dl_path_en(1)   <= cpu_data(0);
                when x"1030c"   => dcm_dl_path_en(2)   <= cpu_data(0);
                when x"1040c"   => dcm_dl_path_en(3)   <= cpu_data(0);

                when x"2010c"   => kddi_dl_path_en(0)  <= cpu_data(0);
                when x"2020c"   => kddi_dl_path_en(1)  <= cpu_data(0);
                when x"2030c"   => kddi_dl_path_en(2)  <= cpu_data(0);
                when x"2040c"   => kddi_dl_path_en(3)  <= cpu_data(0);

                when x"3010c"   => rm_dl_path_en(0)    <= cpu_data(0);
                when x"3020c"   => rm_dl_path_en(1)    <= cpu_data(0);
                when x"3030c"   => rm_dl_path_en(2)    <= cpu_data(0);
                when x"3040c"   => rm_dl_path_en(3)    <= cpu_data(0);

                when x"4010c"   => sb_dl_path_en(0)    <= cpu_data(0);
                when x"4020c"   => sb_dl_path_en(1)    <= cpu_data(0);
                when x"4030c"   => sb_dl_path_en(2)    <= cpu_data(0);
                when x"4040c"   => sb_dl_path_en(3)    <= cpu_data(0);

                when x"10110"   => dcm_dl_slope(0)     <= cpu_data(15 downto 0);
                when x"10210"   => dcm_dl_slope(1)     <= cpu_data(15 downto 0);
                when x"10310"   => dcm_dl_slope(2)     <= cpu_data(15 downto 0);
                when x"10410"   => dcm_dl_slope(3)     <= cpu_data(15 downto 0);

                when x"20110"   => kddi_dl_slope(0)    <= cpu_data(15 downto 0);
                when x"20210"   => kddi_dl_slope(1)    <= cpu_data(15 downto 0);
                when x"20310"   => kddi_dl_slope(2)    <= cpu_data(15 downto 0);
                when x"20410"   => kddi_dl_slope(3)    <= cpu_data(15 downto 0);

                when x"30110"   => rm_dl_slope(0)      <= cpu_data(15 downto 0);
                when x"30210"   => rm_dl_slope(1)      <= cpu_data(15 downto 0);
                when x"30310"   => rm_dl_slope(2)      <= cpu_data(15 downto 0);
                when x"30410"   => rm_dl_slope(3)      <= cpu_data(15 downto 0);

                when x"40110"   => sb_dl_slope(0)      <= cpu_data(15 downto 0);
                when x"40210"   => sb_dl_slope(1)      <= cpu_data(15 downto 0);
                when x"40310"   => sb_dl_slope(2)      <= cpu_data(15 downto 0);
                when x"40410"   => sb_dl_slope(3)      <= cpu_data(15 downto 0);

                when x"10114"   => dcm_dl_curve(0)     <= cpu_data(15 downto 0);
                when x"10214"   => dcm_dl_curve(1)     <= cpu_data(15 downto 0);
                when x"10314"   => dcm_dl_curve(2)     <= cpu_data(15 downto 0);
                when x"10414"   => dcm_dl_curve(3)     <= cpu_data(15 downto 0);

                when x"20114"   => kddi_dl_curve(0)    <= cpu_data(15 downto 0);
                when x"20214"   => kddi_dl_curve(1)    <= cpu_data(15 downto 0);
                when x"20314"   => kddi_dl_curve(2)    <= cpu_data(15 downto 0);
                when x"20414"   => kddi_dl_curve(3)    <= cpu_data(15 downto 0);

                when x"30114"   => rm_dl_curve(0)      <= cpu_data(15 downto 0);
                when x"30214"   => rm_dl_curve(1)      <= cpu_data(15 downto 0);
                when x"30314"   => rm_dl_curve(2)      <= cpu_data(15 downto 0);
                when x"30414"   => rm_dl_curve(3)      <= cpu_data(15 downto 0);

                when x"40114"   => sb_dl_curve(0)      <= cpu_data(15 downto 0);
                when x"40214"   => sb_dl_curve(1)      <= cpu_data(15 downto 0);
                when x"40314"   => sb_dl_curve(2)      <= cpu_data(15 downto 0);
                when x"40414"   => sb_dl_curve(3)      <= cpu_data(15 downto 0);

                when x"10118"   => dcm_input_gain(0)   <= cpu_data(15 downto 0);
                when x"10218"   => dcm_input_gain(1)   <= cpu_data(15 downto 0);
                when x"10318"   => dcm_input_gain(2)   <= cpu_data(15 downto 0);
                when x"10418"   => dcm_input_gain(3)   <= cpu_data(15 downto 0);

                when x"20118"   => kddi_input_gain(0)  <= cpu_data(15 downto 0);
                when x"20218"   => kddi_input_gain(1)  <= cpu_data(15 downto 0);
                when x"20318"   => kddi_input_gain(2)  <= cpu_data(15 downto 0);
                when x"20418"   => kddi_input_gain(3)  <= cpu_data(15 downto 0);

                when x"30118"   => rm_input_gain(0)    <= cpu_data(15 downto 0);
                when x"30218"   => rm_input_gain(1)    <= cpu_data(15 downto 0);
                when x"30318"   => rm_input_gain(2)    <= cpu_data(15 downto 0);
                when x"30418"   => rm_input_gain(3)    <= cpu_data(15 downto 0);

                when x"40118"   => sb_input_gain(0)    <= cpu_data(15 downto 0);
                when x"40218"   => sb_input_gain(1)    <= cpu_data(15 downto 0);
                when x"40318"   => sb_input_gain(2)    <= cpu_data(15 downto 0);
                when x"40418"   => sb_input_gain(3)    <= cpu_data(15 downto 0);

                when x"00124"   => dpd_gain(0)         <= cpu_data(15 downto 0);
                when x"00224"   => dpd_gain(1)         <= cpu_data(15 downto 0);
                when x"00324"   => dpd_gain(2)         <= cpu_data(15 downto 0);
                when x"00424"   => dpd_gain(3)         <= cpu_data(15 downto 0);

                when x"00128"   => dl_out_gain(0)      <= cpu_data(15 downto 0);
                when x"00228"   => dl_out_gain(1)      <= cpu_data(15 downto 0);
                when x"00328"   => dl_out_gain(2)      <= cpu_data(15 downto 0);
                when x"00428"   => dl_out_gain(3)      <= cpu_data(15 downto 0);

                when x"00134"   => rfu_tx_en_reg(0)    <= cpu_data(0);
								    mxl_tx_en_reg(0)    <= cpu_data(4);

                when x"00234"   => rfu_tx_en_reg(1)    <= cpu_data(0);
									mxl_tx_en_reg(1)    <= cpu_data(4);

                when x"00334"   => rfu_tx_en_reg(2)    <= cpu_data(0);
									mxl_tx_en_reg(2)    <= cpu_data(4);

                when x"00434"   => rfu_tx_en_reg(3)    <= cpu_data(0);
								    mxl_tx_en_reg(3)    <= cpu_data(4);

                -- UL PATH
                when x"00180"    => rfu_rx_en_reg(0)  <= cpu_data(0);
                                    mxl_rx_en_reg(0)  <= cpu_data(4);
                when x"00280"    => rfu_rx_en_reg(1)  <= cpu_data(0);
                                    mxl_rx_en_reg(1)  <= cpu_data(4);
                when x"00380"    => rfu_rx_en_reg(2)  <= cpu_data(0);
                                    mxl_rx_en_reg(2)  <= cpu_data(4);
                when x"00480"    => rfu_rx_en_reg(3)  <= cpu_data(0);
                                    mxl_rx_en_reg(3)  <= cpu_data(4);


                when x"00184"   => mxl_gain(0)         <= cpu_data(4 downto 0);
                when x"00284"   => mxl_gain(1)         <= cpu_data(4 downto 0);
                when x"00384"   => mxl_gain(2)         <= cpu_data(4 downto 0);
                when x"00484"   => mxl_gain(3)         <= cpu_data(4 downto 0);

                when x"00194"   => ul_in_gain(0)       <= cpu_data(15 downto 0);
                when x"00294"   => ul_in_gain(1)       <= cpu_data(15 downto 0);
                when x"00394"   => ul_in_gain(2)       <= cpu_data(15 downto 0);
                when x"00494"   => ul_in_gain(3)       <= cpu_data(15 downto 0);

                when x"10198"   => dcm_ul_path_en(0)   <= cpu_data(0);
                when x"10298"   => dcm_ul_path_en(1)   <= cpu_data(0);
                when x"10398"   => dcm_ul_path_en(2)   <= cpu_data(0);
                when x"10498"   => dcm_ul_path_en(3)   <= cpu_data(0);

                when x"20198"   => kddi_ul_path_en(0)  <= cpu_data(0);
                when x"20298"   => kddi_ul_path_en(1)  <= cpu_data(0);
                when x"20398"   => kddi_ul_path_en(2)  <= cpu_data(0);
                when x"20498"   => kddi_ul_path_en(3)  <= cpu_data(0);

                when x"30198"   => rm_ul_path_en(0)    <= cpu_data(0);
                when x"30298"   => rm_ul_path_en(1)    <= cpu_data(0);
                when x"30398"   => rm_ul_path_en(2)    <= cpu_data(0);
                when x"30498"   => rm_ul_path_en(3)    <= cpu_data(0);

                when x"40198"   => sb_ul_path_en(0)    <= cpu_data(0);
                when x"40298"   => sb_ul_path_en(1)    <= cpu_data(0);
                when x"40398"   => sb_ul_path_en(2)    <= cpu_data(0);
                when x"40498"   => sb_ul_path_en(3)    <= cpu_data(0);

                when x"1019c"   => dcm_ul_slope(0)     <= cpu_data(15 downto 0);
                when x"1029c"   => dcm_ul_slope(1)     <= cpu_data(15 downto 0);
                when x"1039c"   => dcm_ul_slope(2)     <= cpu_data(15 downto 0);
                when x"1049c"   => dcm_ul_slope(3)     <= cpu_data(15 downto 0);

                when x"2019c"   => kddi_ul_slope(0)    <= cpu_data(15 downto 0);
                when x"2029c"   => kddi_ul_slope(1)    <= cpu_data(15 downto 0);
                when x"2039c"   => kddi_ul_slope(2)    <= cpu_data(15 downto 0);
                when x"2049c"   => kddi_ul_slope(3)    <= cpu_data(15 downto 0);

                when x"3019c"   => rm_ul_slope(0)      <= cpu_data(15 downto 0);
                when x"3029c"   => rm_ul_slope(1)      <= cpu_data(15 downto 0);
                when x"3039c"   => rm_ul_slope(2)      <= cpu_data(15 downto 0);
                when x"3049c"   => rm_ul_slope(3)      <= cpu_data(15 downto 0);

                when x"4019c"   => sb_ul_slope(0)      <= cpu_data(15 downto 0);
                when x"4029c"   => sb_ul_slope(1)      <= cpu_data(15 downto 0);
                when x"4039c"   => sb_ul_slope(2)      <= cpu_data(15 downto 0);
                when x"4049c"   => sb_ul_slope(3)      <= cpu_data(15 downto 0);

                when x"101a0"   => dcm_ul_curve(0)     <= cpu_data(15 downto 0);
                when x"102a0"   => dcm_ul_curve(1)     <= cpu_data(15 downto 0);
                when x"103a0"   => dcm_ul_curve(2)     <= cpu_data(15 downto 0);
                when x"104a0"   => dcm_ul_curve(3)     <= cpu_data(15 downto 0);

                when x"201a0"   => kddi_ul_curve(0)    <= cpu_data(15 downto 0);
                when x"202a0"   => kddi_ul_curve(1)    <= cpu_data(15 downto 0);
                when x"203a0"   => kddi_ul_curve(2)    <= cpu_data(15 downto 0);
                when x"204a0"   => kddi_ul_curve(3)    <= cpu_data(15 downto 0);

                when x"301a0"   => rm_ul_curve(0)      <= cpu_data(15 downto 0);
                when x"302a0"   => rm_ul_curve(1)      <= cpu_data(15 downto 0);
                when x"303a0"   => rm_ul_curve(2)      <= cpu_data(15 downto 0);
                when x"304a0"   => rm_ul_curve(3)      <= cpu_data(15 downto 0);

                when x"401a0"   => sb_ul_curve(0)      <= cpu_data(15 downto 0);
                when x"402a0"   => sb_ul_curve(1)      <= cpu_data(15 downto 0);
                when x"403a0"   => sb_ul_curve(2)      <= cpu_data(15 downto 0);
                when x"404a0"   => sb_ul_curve(3)      <= cpu_data(15 downto 0);

                when x"101a4"   => dcm_output_gain(0)  <= cpu_data(15 downto 0);
                when x"102a4"   => dcm_output_gain(1)  <= cpu_data(15 downto 0);
                when x"103a4"   => dcm_output_gain(2)  <= cpu_data(15 downto 0);
                when x"104a4"   => dcm_output_gain(3)  <= cpu_data(15 downto 0);

                when x"201a4"   => kddi_output_gain(0) <= cpu_data(15 downto 0);
                when x"202a4"   => kddi_output_gain(1) <= cpu_data(15 downto 0);
                when x"203a4"   => kddi_output_gain(2) <= cpu_data(15 downto 0);
                when x"204a4"   => kddi_output_gain(3) <= cpu_data(15 downto 0);

                when x"301a4"   => rm_output_gain(0)   <= cpu_data(15 downto 0);
                when x"302a4"   => rm_output_gain(1)   <= cpu_data(15 downto 0);
                when x"303a4"   => rm_output_gain(2)   <= cpu_data(15 downto 0);
                when x"304a4"   => rm_output_gain(3)   <= cpu_data(15 downto 0);

                when x"401a4"   => sb_output_gain(0)   <= cpu_data(15 downto 0);
                when x"402a4"   => sb_output_gain(1)   <= cpu_data(15 downto 0);
                when x"403a4"   => sb_output_gain(2)   <= cpu_data(15 downto 0);
                when x"404a4"   => sb_output_gain(3)   <= cpu_data(15 downto 0);

                when x"101b0"   => ul_dly_dcm_01       <= cpu_data(13 downto 0);
                when x"103b0"   => ul_dly_dcm_23       <= cpu_data(13 downto 0);
                when x"201b0"   => ul_dly_kddi_01      <= cpu_data(13 downto 0);
                when x"203b0"   => ul_dly_kddi_23      <= cpu_data(13 downto 0);
                when x"301b0"   => ul_dly_rm_01        <= cpu_data(13 downto 0);
                when x"303b0"   => ul_dly_rm_23        <= cpu_data(13 downto 0);
                when x"401b0"   => ul_dly_sb_01        <= cpu_data(13 downto 0);
                when x"403b0"   => ul_dly_sb_23        <= cpu_data(13 downto 0);

                -- TEST REG
                when x"50000"   => rfu_io_test_mode    <= cpu_data(1 downto 0);
                when x"5d5d5"   => test_reg            <= cpu_data(31 downto  0);

                when others     => null;

            end case;

        -- read general
        elsif (rd_enable = '1') then
            case(cpu_add(19 downto 0)) is
                when x"00000"   => fpga_data_g <= gui_ver;
--                when x"00001"   => fpga_data_g <= mu_id(1) & mu_port_num(1) & hu_port_num(1) & cascade_num(1) & mu_id(0) & mu_port_num(0) & hu_port_num(0) & cascade_num(0);
                when x"00002"   => fpga_data_g <= ver;
                when x"00003"   => fpga_data_g <= x"0000000" & sfp_disable_reg;
				-- module_type : 6b
				-- op_id0/op_id1 : 6b
				-- band_id : 2b
--                when x"00004"   => fpga_data_g <= x"0" & "000" & du_type(1) & module_type(1) & op_id0(1) & op_id1(1) & band_id(1) & x"0" & "000" & du_type(0) & module_type(0) & op_id0(0) & op_id1(0) & band_id0(0) & band_id1(0);
                -- dl_dly_ctrl0 : 24b
				-- ul_dly_ctrl0 : 24b
				-- dl_dly_ctrl1 : 24b
				-- ul_dly_ctrl1 : 24b
				when x"00004"   => fpga_data_g <= tsync_chk_clr & "000" & x"000000" & "000" & tdd_valid;
--				when x"00005"   => fpga_data_g <= x"00" & dly_ctrl(1) & x"00" & dly_ctrl(0);

                when x"00006"   => fpga_data_g <= x"000000" & '0' & mmcm_jesd_locked & mmcm_cpri_locked & jesd_qpll_lock & cpri_qpll_lock & pll_lock;
                when x"00007"   => fpga_data_g <= "00000000" & sfp_insert & "000000" & sfp_los &"000000" & "0000";
                when x"00008"   => fpga_data_g <= x"0000000" & "000" & optic_sw_reg;
                when x"00009"   => fpga_data_g <= x"00000" & "00" & fpga_temp;

                when x"0000a"   => fpga_data_g <= x"00000" & "00" & tdd_mode & "00" & fbsel_mode & "00" & cal_mode;
                when x"0000b"   => fpga_data_g <= bg_cal_duration;
                when x"0000c"   => fpga_data_g <= x"000000" & "000" & jesd_tx_diff_ctrl;
				when x"0000f"   => fpga_data_g <= x"0000000" & "000" & RFU_INSERT;

                when x"00010"   => fpga_data_g <= x"0000000" & "00" & g_led_reg(0) & r_led_reg(0);
                when x"00011"   => fpga_data_g <= x"0000000" & "00" & g_led_reg(1) & r_led_reg(1);
                when x"00012"   => fpga_data_g <= x"0000000" & "00" & g_led_reg(2) & r_led_reg(2);

				when x"00020"   => fpga_data_g <= vs_rx_0_80_0(0);
				when x"00021"   => fpga_data_g <= vs_rx_0_80_1(0);
				when x"00022"   => fpga_data_g <= vs_rx_0_144_0(0);
				when x"00023"   => fpga_data_g <= vs_rx_0_144_1(0);
				when x"00024"   => fpga_data_g <= vs_rx_0_144_2(0);
				when x"00025"   => fpga_data_g <= vs_rx_0_144_3(0);
				when x"00026"   => fpga_data_g <= vs_rx_0_80_0(1);
				when x"00027"   => fpga_data_g <= vs_rx_0_80_1(1);
				when x"00028"   => fpga_data_g <= vs_rx_0_144_0(1);
				when x"00029"   => fpga_data_g <= vs_rx_0_144_1(1);
				when x"0002a"   => fpga_data_g <= vs_rx_0_144_2(1);
				when x"0002b"   => fpga_data_g <= vs_rx_0_144_3(1);

				when x"00030"   => fpga_data_g <= x"0000000" & "000" & cnm_prime_in;
				when x"00031"   => fpga_data_g <= cpri_t_offset(0);
				when x"00032"   => fpga_data_g <= cas_delay(0);
				when x"00033"   => fpga_data_g <= cpri_t_offset(1);
				when x"00034"   => fpga_data_g <= cas_delay(1);
				when x"00035"   => fpga_data_g <= ip_offset_fb(0);
				when x"00036"   => fpga_data_g <= ip_offset_cas(0);
				when x"00037"   => fpga_data_g <= vs_rx_0_80_1(2);
				when x"00038"   => fpga_data_g <= vs_rx_0_80_1(3);
				when x"00039"   => fpga_data_g <= vs_rx_0_144_0(2);
				when x"0003a"   => fpga_data_g <= vs_rx_0_144_0(3);
				when x"0003b"   => fpga_data_g <= ip_offset_fb(1);
				when x"0003c"   => fpga_data_g <= ip_offset_cas(1);
                when x"0003d"   => fpga_data_g <= vs_tx_0_80_0(0);
				when x"0003e"   => fpga_data_g <= vs_tx_0_80_0(1);
				
				when x"00040"   => fpga_data_g <= vs_tx_0_144_0(0);
				when x"00041"   => fpga_data_g <= vs_tx_0_144_0(1);
				when x"00042"   => fpga_data_g <= vs_tx_0_144_1(0);
				when x"00043"   => fpga_data_g <= vs_tx_0_144_1(1);
				when x"00044"   => fpga_data_g <= vs_tx_0_144_2(0);
				when x"00045"   => fpga_data_g <= vs_tx_0_144_2(1);
				when x"00046"   => fpga_data_g <= vs_tx_0_144_3(0);
				when x"00047"   => fpga_data_g <= vs_tx_0_144_3(1);
				

                when x"00051"   => fpga_data_g <= x"0000000" & "000" & l1_reset_reg;
				when x"00052"   => fpga_data_g <= x"0000000" & "000" & l1_reset_ctrl_reg;
                when x"00055"   => fpga_data_g <= x"0000000" & "000" & mxl_rst_reg;

                when x"00060"   => fpga_data_g <= x"0000000" & "000" & cpri_rst_reg;
                when x"00061"   => fpga_data_g <= x"0000000" & gt_rxpcs_rst;
                when x"00062"   => fpga_data_g <= x"0000000" & gt_txpcs_rst;
                --when x"00063"   => fpga_data_g <= x"0000000" & gt_rxpma_rst;
                --when x"00064"   => fpga_data_g <= x"0000000" & gt_txpma_rst;
                when x"00065"   => fpga_data_g <= x"0000000" & gt_txresetdone;
                when x"00066"   => fpga_data_g <= x"0000000" & gt_rxresetdone;
                when x"00067"   => fpga_data_g <= x"0000000" & gt_rxlpmen;
                when x"00068"   => fpga_data_g <= x"000000" & "000" & gt_txdiffctrl(0);
                when x"00069"   => fpga_data_g <= x"000000" & "000" & gt_txdiffctrl(1);
                when x"0006a"   => fpga_data_g <= x"000000" & "000" & gt_txdiffctrl(2);
                when x"0006b"   => fpga_data_g <= x"000000" & "000" & gt_txdiffctrl(3);
				when x"0006c"   => fpga_data_g <= x"00000" & "000" & combine_bypass_mode & "000" & map_test_mode & map_loop_mode(1) & map_loop_mode(0);
                when x"0006d"   => fpga_data_g <= x"0000000" & "000" & eth_blk_rst;

                when x"00073"   => fpga_data_g <= x"000000" & pow_cnt;
                when x"00075"   => fpga_data_g <= x"00000" & eth_gap;

                when x"00080"   => fpga_data_g <= x"0000000" & "00" & mxl_chip_mode_reg;
                when x"00081"   => fpga_data_g <= x"0000000" & '0' & mxl_clk_sel_reg;
                when x"00082"   => fpga_data_g <= x"0000000" & "000" & MXL_TX_FAULT;
                when x"00083"   => fpga_data_g <= x"0000000" & "000" & mxl_pap_reg;
                when x"00084"   => fpga_data_g <= x"0000000" & "000" & mxl_init_reg;

                when x"00090"   => fpga_data_g <= x"000" & "000" & r_pull_dl;
                when x"00091"   => fpga_data_g <= x"000" & "000" & r_push_dl;
                when x"00092"   => fpga_data_g <= x"000" & "000" & f_pull_dl;
                when x"00093"   => fpga_data_g <= x"000" & "000" & f_push_dl;
                when x"00094"   => fpga_data_g <= x"000" & "000" & r_pull_ul;
                when x"00095"   => fpga_data_g <= x"000" & "000" & r_push_ul;
                when x"00096"   => fpga_data_g <= x"000" & "000" & f_pull_ul;
                when x"00097"   => fpga_data_g <= x"000" & "000" & f_push_ul;
                when x"00098"   => fpga_data_g <= x"000" & "000" & r_pull_dl_rf;
                when x"00099"   => fpga_data_g <= x"000" & "000" & r_push_dl_rf;
                when x"0009a"   => fpga_data_g <= x"000" & "000" & f_pull_dl_rf;
                when x"0009b"   => fpga_data_g <= x"000" & "000" & f_push_dl_rf;
                when x"0009c"   => fpga_data_g <= x"000" & "000" & r_pull_ul_rf;
                when x"0009d"   => fpga_data_g <= x"000" & "000" & r_push_ul_rf;
                when x"0009e"   => fpga_data_g <= x"000" & "000" & f_pull_ul_rf;
                when x"0009f"   => fpga_data_g <= x"000" & "000" & f_push_ul_rf;
				
				when x"000a0"   => fpga_data_g <= x"00000" & dl_sym_num1 & "00" & dl_slt_num1;
                when x"000a1"   => fpga_data_g <= x"00000" & ul_sym_num1 & "00" & ul_slt_num1;
                when x"000a2"   => fpga_data_g <= x"000000" & '0' & trx_periodicity1;
                when x"000a3"   => fpga_data_g <= x"0000000" & "000" & patt2_onoff;
                when x"000a4"   => fpga_data_g <= x"00000" & dl_sym_num2 & "00" & dl_slt_num2;
                when x"000a5"   => fpga_data_g <= x"00000" & ul_sym_num2 & "00" & ul_slt_num2;
                when x"000a6"   => fpga_data_g <= x"000000" & '0' & trx_periodicity2;
				
				when x"000b0"   => fpga_data_g <= x"000" & "000" & r_pull_ul_rssi;
                when x"000b1"   => fpga_data_g <= x"000" & "000" & r_push_ul_rssi;
                when x"000b2"   => fpga_data_g <= x"000" & "000" & f_pull_ul_rssi;
                when x"000b3"   => fpga_data_g <= x"000" & "000" & f_push_ul_rssi;
				
				when x"000c0"   => fpga_data_g <= x"00000" & "00" & ul_ref_10m_dly_val(0);
                when x"000c1"   => fpga_data_g <= x"00000" & "00" & ul_ref_10m_dly_val(1);

                when x"000d0"   => fpga_data_g <= x"0000000" & "000" & dpd_rst_reg;
                when x"000d1"   => fpga_data_g <= x"00000" & '0' & fb_sw_dly;
				when x"000d2"   => fpga_data_g <= x"0000" & fb_in_gain;
                when x"000d3"   => fpga_data_g <= x"00" & fb_sw_cnt_out;

                when x"000f0"   => fpga_data_g <= x"0000000" & "00" & rfic_loop;
                when x"000f1"   => fpga_data_g <= x"0000000" & "00" & path_sel;
                --when x"000f2"   => fpga_data_g <= x"0000000" & "000" & cw_start;
                when x"000f6"   => fpga_data_g <= x"0000000" & pow_sel;
				when x"000f7"   => fpga_data_g <= x"0000000" & "000" & peak_sel;
                when x"000f9"   => fpga_data_g <= x"0000" & cw_data;
				-- when x"000fa"   => fpga_data_g <= x"000000" & adc_assign_value;
				when x"000fb"   => fpga_data_g <= x"0000000" & tdd_mon_sel;
				
				when x"00100"   => fpga_data_g <= fa_det_threshold;
				when x"00101"   => fpga_data_g <= x"0000" & fa_detect(3) & fa_detect(2) & fa_detect(1) & fa_detect(0);

                when x"10100"   => fpga_data_g <= x"0000" & "00" & dl_dly_dcm_01;
                when x"10200"   => fpga_data_g <= x"0000" & "00" & dl_dly_dcm_01;
                when x"10300"   => fpga_data_g <= x"0000" & "00" & dl_dly_dcm_23;
                when x"10400"   => fpga_data_g <= x"0000" & "00" & dl_dly_dcm_23;
                when x"20100"   => fpga_data_g <= x"0000" & "00" & dl_dly_kddi_01;
                when x"20200"   => fpga_data_g <= x"0000" & "00" & dl_dly_kddi_01;
                when x"20300"   => fpga_data_g <= x"0000" & "00" & dl_dly_kddi_23;
                when x"20400"   => fpga_data_g <= x"0000" & "00" & dl_dly_kddi_23;
                when x"30100"   => fpga_data_g <= x"0000" & "00" & dl_dly_rm_01;
                when x"30200"   => fpga_data_g <= x"0000" & "00" & dl_dly_rm_01;
                when x"30300"   => fpga_data_g <= x"0000" & "00" & dl_dly_rm_23;
                when x"30400"   => fpga_data_g <= x"0000" & "00" & dl_dly_rm_23;
                when x"40100"   => fpga_data_g <= x"0000" & "00" & dl_dly_sb_01;
                when x"40200"   => fpga_data_g <= x"0000" & "00" & dl_dly_sb_01;
                when x"40300"   => fpga_data_g <= x"0000" & "00" & dl_dly_sb_23;
                when x"40400"   => fpga_data_g <= x"0000" & "00" & dl_dly_sb_23;

                when x"10104"   => fpga_data_g <= dcm_dl_pow(0);
                when x"10204"   => fpga_data_g <= dcm_dl_pow(1);
                when x"10304"   => fpga_data_g <= dcm_dl_pow(2);
                when x"10404"   => fpga_data_g <= dcm_dl_pow(3);

                when x"20104"   => fpga_data_g <= kddi_dl_pow(0);
                when x"20204"   => fpga_data_g <= kddi_dl_pow(1);
                when x"20304"   => fpga_data_g <= kddi_dl_pow(2);
                when x"20404"   => fpga_data_g <= kddi_dl_pow(3);

                when x"30104"   => fpga_data_g <= rm_dl_pow(0);
                when x"30204"   => fpga_data_g <= rm_dl_pow(1);
                when x"30304"   => fpga_data_g <= rm_dl_pow(2);
                when x"30404"   => fpga_data_g <= rm_dl_pow(3);

                when x"40104"   => fpga_data_g <= sb_dl_pow(0);
                when x"40204"   => fpga_data_g <= sb_dl_pow(1);
                when x"40304"   => fpga_data_g <= sb_dl_pow(2);
                when x"40404"   => fpga_data_g <= sb_dl_pow(3);

                when x"10108"   => fpga_data_g <= dcm_dl_peak(0);
                when x"10208"   => fpga_data_g <= dcm_dl_peak(1);
                when x"10308"   => fpga_data_g <= dcm_dl_peak(2);
                when x"10408"   => fpga_data_g <= dcm_dl_peak(3);

                when x"20108"   => fpga_data_g <= kddi_dl_peak(0);
                when x"20208"   => fpga_data_g <= kddi_dl_peak(1);
                when x"20308"   => fpga_data_g <= kddi_dl_peak(2);
                when x"20408"   => fpga_data_g <= kddi_dl_peak(3);

                when x"30108"   => fpga_data_g <= rm_dl_peak(0);
                when x"30208"   => fpga_data_g <= rm_dl_peak(1);
                when x"30308"   => fpga_data_g <= rm_dl_peak(2);
                when x"30408"   => fpga_data_g <= rm_dl_peak(3);

                when x"40108"   => fpga_data_g <= sb_dl_peak(0);
                when x"40208"   => fpga_data_g <= sb_dl_peak(1);
                when x"40308"   => fpga_data_g <= sb_dl_peak(2);
                when x"40408"   => fpga_data_g <= sb_dl_peak(3);

                when x"1010c"   => fpga_data_g <= x"0000000" & "000" & dcm_dl_path_en(0);
                when x"1020c"   => fpga_data_g <= x"0000000" & "000" & dcm_dl_path_en(1);
                when x"1030c"   => fpga_data_g <= x"0000000" & "000" & dcm_dl_path_en(2);
                when x"1040c"   => fpga_data_g <= x"0000000" & "000" & dcm_dl_path_en(3);

                when x"2010c"   => fpga_data_g <= x"0000000" & "000" & kddi_dl_path_en(0);
                when x"2020c"   => fpga_data_g <= x"0000000" & "000" & kddi_dl_path_en(1);
                when x"2030c"   => fpga_data_g <= x"0000000" & "000" & kddi_dl_path_en(2);
                when x"2040c"   => fpga_data_g <= x"0000000" & "000" & kddi_dl_path_en(3);

                when x"3010c"   => fpga_data_g <= x"0000000" & "000" & rm_dl_path_en(0);
                when x"3020c"   => fpga_data_g <= x"0000000" & "000" & rm_dl_path_en(1);
                when x"3030c"   => fpga_data_g <= x"0000000" & "000" & rm_dl_path_en(2);
                when x"3040c"   => fpga_data_g <= x"0000000" & "000" & rm_dl_path_en(3);

                when x"4010c"   => fpga_data_g <= x"0000000" & "000" & sb_dl_path_en(0);
                when x"4020c"   => fpga_data_g <= x"0000000" & "000" & sb_dl_path_en(1);
                when x"4030c"   => fpga_data_g <= x"0000000" & "000" & sb_dl_path_en(2);
                when x"4040c"   => fpga_data_g <= x"0000000" & "000" & sb_dl_path_en(3);

                when x"10110"   => fpga_data_g <= x"0000" & dcm_dl_slope(0);
                when x"10210"   => fpga_data_g <= x"0000" & dcm_dl_slope(1);
                when x"10310"   => fpga_data_g <= x"0000" & dcm_dl_slope(2);
                when x"10410"   => fpga_data_g <= x"0000" & dcm_dl_slope(3);

                when x"20110"   => fpga_data_g <= x"0000" & kddi_dl_slope(0);
                when x"20210"   => fpga_data_g <= x"0000" & kddi_dl_slope(1);
                when x"20310"   => fpga_data_g <= x"0000" & kddi_dl_slope(2);
                when x"20410"   => fpga_data_g <= x"0000" & kddi_dl_slope(3);

                when x"30110"   => fpga_data_g <= x"0000" & rm_dl_slope(0);
                when x"30210"   => fpga_data_g <= x"0000" & rm_dl_slope(1);
                when x"30310"   => fpga_data_g <= x"0000" & rm_dl_slope(2);
                when x"30410"   => fpga_data_g <= x"0000" & rm_dl_slope(3);

                when x"40110"   => fpga_data_g <= x"0000" & sb_dl_slope(0);
                when x"40210"   => fpga_data_g <= x"0000" & sb_dl_slope(1);
                when x"40310"   => fpga_data_g <= x"0000" & sb_dl_slope(2);
                when x"40410"   => fpga_data_g <= x"0000" & sb_dl_slope(3);

                when x"10114"   => fpga_data_g <= x"0000" & dcm_dl_curve(0);
                when x"10214"   => fpga_data_g <= x"0000" & dcm_dl_curve(1);
                when x"10314"   => fpga_data_g <= x"0000" & dcm_dl_curve(2);
                when x"10414"   => fpga_data_g <= x"0000" & dcm_dl_curve(3);

                when x"20114"   => fpga_data_g <= x"0000" & kddi_dl_curve(0);
                when x"20214"   => fpga_data_g <= x"0000" & kddi_dl_curve(1);
                when x"20314"   => fpga_data_g <= x"0000" & kddi_dl_curve(2);
                when x"20414"   => fpga_data_g <= x"0000" & kddi_dl_curve(3);

                when x"30114"   => fpga_data_g <= x"0000" & rm_dl_curve(0);
                when x"30214"   => fpga_data_g <= x"0000" & rm_dl_curve(1);
                when x"30314"   => fpga_data_g <= x"0000" & rm_dl_curve(2);
                when x"30414"   => fpga_data_g <= x"0000" & rm_dl_curve(3);

                when x"40114"   => fpga_data_g <= x"0000" & sb_dl_curve(0);
                when x"40214"   => fpga_data_g <= x"0000" & sb_dl_curve(1);
                when x"40314"   => fpga_data_g <= x"0000" & sb_dl_curve(2);
                when x"40414"   => fpga_data_g <= x"0000" & sb_dl_curve(3);

                when x"10118"   => fpga_data_g <= x"0000" & dcm_input_gain(0);
                when x"10218"   => fpga_data_g <= x"0000" & dcm_input_gain(1);
                when x"10318"   => fpga_data_g <= x"0000" & dcm_input_gain(2);
                when x"10418"   => fpga_data_g <= x"0000" & dcm_input_gain(3);

                when x"20118"   => fpga_data_g <= x"0000" & kddi_input_gain(0);
                when x"20218"   => fpga_data_g <= x"0000" & kddi_input_gain(1);
                when x"20318"   => fpga_data_g <= x"0000" & kddi_input_gain(2);
                when x"20418"   => fpga_data_g <= x"0000" & kddi_input_gain(3);

                when x"30118"   => fpga_data_g <= x"0000" & rm_input_gain(0);
                when x"30218"   => fpga_data_g <= x"0000" & rm_input_gain(1);
                when x"30318"   => fpga_data_g <= x"0000" & rm_input_gain(2);
                when x"30418"   => fpga_data_g <= x"0000" & rm_input_gain(3);

                when x"40118"   => fpga_data_g <= x"0000" & sb_input_gain(0);
                when x"40218"   => fpga_data_g <= x"0000" & sb_input_gain(1);
                when x"40318"   => fpga_data_g <= x"0000" & sb_input_gain(2);
                when x"40418"   => fpga_data_g <= x"0000" & sb_input_gain(3);

                when x"0011c"   => fpga_data_g <= dl_sum_pow(0);
                when x"0021c"   => fpga_data_g <= dl_sum_pow(1);
                when x"0031c"   => fpga_data_g <= dl_sum_pow(2);
                when x"0041c"   => fpga_data_g <= dl_sum_pow(3);

                when x"00120"   => fpga_data_g <= dl_sum_peak(0);
                when x"00220"   => fpga_data_g <= dl_sum_peak(1);
                when x"00320"   => fpga_data_g <= dl_sum_peak(2);
                when x"00420"   => fpga_data_g <= dl_sum_peak(3);

                when x"00124"   => fpga_data_g <= x"0000" & dpd_gain(0);
                when x"00224"   => fpga_data_g <= x"0000" & dpd_gain(1);
                when x"00324"   => fpga_data_g <= x"0000" & dpd_gain(2);
                when x"00424"   => fpga_data_g <= x"0000" & dpd_gain(3);

                when x"00128"   => fpga_data_g <= x"0000" & dl_out_gain(0);
                when x"00228"   => fpga_data_g <= x"0000" & dl_out_gain(1);
                when x"00328"   => fpga_data_g <= x"0000" & dl_out_gain(2);
                when x"00428"   => fpga_data_g <= x"0000" & dl_out_gain(3);

                when x"0012c"   => fpga_data_g <= dl_out_pow(0);
                when x"0022c"   => fpga_data_g <= dl_out_pow(1);
                when x"0032c"   => fpga_data_g <= dl_out_pow(2);
                when x"0042c"   => fpga_data_g <= dl_out_pow(3);

                when x"00130"   => fpga_data_g <= dl_out_peak(0);
                when x"00230"   => fpga_data_g <= dl_out_peak(1);
                when x"00330"   => fpga_data_g <= dl_out_peak(2);
                when x"00430"   => fpga_data_g <= dl_out_peak(3);

                when x"00134"   => fpga_data_g <= x"000000" & "000" & mxl_tx_en_reg(0) & "000" & rfu_tx_en_reg(0);
                when x"00234"   => fpga_data_g <= x"000000" & "000" & mxl_tx_en_reg(1) & "000" & rfu_tx_en_reg(1);
                when x"00334"   => fpga_data_g <= x"000000" & "000" & mxl_tx_en_reg(2) & "000" & rfu_tx_en_reg(2);
                when x"00434"   => fpga_data_g <= x"000000" & "000" & mxl_tx_en_reg(3) & "000" & rfu_tx_en_reg(3);

                when x"00138"   => fpga_data_g <= fb_pow(0);
                when x"00238"   => fpga_data_g <= fb_pow(1);
                when x"00338"   => fpga_data_g <= fb_pow(2);
                when x"00438"   => fpga_data_g <= fb_pow(3);

                when x"0013c"   => fpga_data_g <= fb_peak(0);
                when x"0023c"   => fpga_data_g <= fb_peak(1);
                when x"0033c"   => fpga_data_g <= fb_peak(2);
                when x"0043c"   => fpga_data_g <= fb_peak(3);


                when x"00180"   => fpga_data_g <= x"000000" & "000" & mxl_rx_en_reg(0) & "000" & rfu_rx_en_reg(0);
                when x"00280"   => fpga_data_g <= x"000000" & "000" & mxl_rx_en_reg(1) & "000" & rfu_rx_en_reg(1);
                when x"00380"   => fpga_data_g <= x"000000" & "000" & mxl_rx_en_reg(2) & "000" & rfu_rx_en_reg(2);
                when x"00480"   => fpga_data_g <= x"000000" & "000" & mxl_rx_en_reg(3) & "000" & rfu_rx_en_reg(3);

                when x"00184"   => fpga_data_g <= x"000000" & "000" & mxl_gain(0);
                when x"00284"   => fpga_data_g <= x"000000" & "000" & mxl_gain(1);
                when x"00384"   => fpga_data_g <= x"000000" & "000" & mxl_gain(2);
                when x"00484"   => fpga_data_g <= x"000000" & "000" & mxl_gain(3);

                when x"00188"   => fpga_data_g <= x"0000000" & '0' & mxl_peak(0) & mxl_hi(0) & mxl_lo(0);
                when x"00288"   => fpga_data_g <= x"0000000" & '0' & mxl_peak(1) & mxl_hi(1) & mxl_lo(1);
                when x"00388"   => fpga_data_g <= x"0000000" & '0' & mxl_peak(2) & mxl_hi(2) & mxl_lo(2);
                when x"00488"   => fpga_data_g <= x"0000000" & '0' & mxl_peak(3) & mxl_hi(3) & mxl_lo(3);

                when x"0018c"   => fpga_data_g <= ul_in_pow(0);
                when x"0028c"   => fpga_data_g <= ul_in_pow(1);
                when x"0038c"   => fpga_data_g <= ul_in_pow(2);
                when x"0048c"   => fpga_data_g <= ul_in_pow(3);

                when x"00190"   => fpga_data_g <= ul_in_peak(0);
                when x"00290"   => fpga_data_g <= ul_in_peak(1);
                when x"00390"   => fpga_data_g <= ul_in_peak(2);
                when x"00490"   => fpga_data_g <= ul_in_peak(3);

                when x"00194"   => fpga_data_g <= x"0000" & ul_in_gain(0);
                when x"00294"   => fpga_data_g <= x"0000" & ul_in_gain(1);
                when x"00394"   => fpga_data_g <= x"0000" & ul_in_gain(2);
                when x"00494"   => fpga_data_g <= x"0000" & ul_in_gain(3);

                when x"10198"   => fpga_data_g <= x"0000000" & "000" & dcm_ul_path_en(0);
                when x"10298"   => fpga_data_g <= x"0000000" & "000" & dcm_ul_path_en(1);
                when x"10398"   => fpga_data_g <= x"0000000" & "000" & dcm_ul_path_en(2);
                when x"10498"   => fpga_data_g <= x"0000000" & "000" & dcm_ul_path_en(3);

                when x"20198"   => fpga_data_g <= x"0000000" & "000" & kddi_ul_path_en(0);
                when x"20298"   => fpga_data_g <= x"0000000" & "000" & kddi_ul_path_en(1);
                when x"20398"   => fpga_data_g <= x"0000000" & "000" & kddi_ul_path_en(2);
                when x"20498"   => fpga_data_g <= x"0000000" & "000" & kddi_ul_path_en(3);

                when x"30198"   => fpga_data_g <= x"0000000" & "000" & rm_ul_path_en(0);
                when x"30298"   => fpga_data_g <= x"0000000" & "000" & rm_ul_path_en(1);
                when x"30398"   => fpga_data_g <= x"0000000" & "000" & rm_ul_path_en(2);
                when x"30498"   => fpga_data_g <= x"0000000" & "000" & rm_ul_path_en(3);

                when x"40198"   => fpga_data_g <= x"0000000" & "000" & sb_ul_path_en(0);
                when x"40298"   => fpga_data_g <= x"0000000" & "000" & sb_ul_path_en(1);
                when x"40398"   => fpga_data_g <= x"0000000" & "000" & sb_ul_path_en(2);
                when x"40498"   => fpga_data_g <= x"0000000" & "000" & sb_ul_path_en(3);

                when x"1019c"   => fpga_data_g <= x"0000" & dcm_ul_slope(0);
                when x"1029c"   => fpga_data_g <= x"0000" & dcm_ul_slope(1);
                when x"1039c"   => fpga_data_g <= x"0000" & dcm_ul_slope(2);
                when x"1049c"   => fpga_data_g <= x"0000" & dcm_ul_slope(3);

                when x"2019c"   => fpga_data_g <= x"0000" & kddi_ul_slope(0);
                when x"2029c"   => fpga_data_g <= x"0000" & kddi_ul_slope(1);
                when x"2039c"   => fpga_data_g <= x"0000" & kddi_ul_slope(2);
                when x"2049c"   => fpga_data_g <= x"0000" & kddi_ul_slope(3);

                when x"3019c"   => fpga_data_g <= x"0000" & rm_ul_slope(0);
                when x"3029c"   => fpga_data_g <= x"0000" & rm_ul_slope(1);
                when x"3039c"   => fpga_data_g <= x"0000" & rm_ul_slope(2);
                when x"3049c"   => fpga_data_g <= x"0000" & rm_ul_slope(3);

                when x"4019c"   => fpga_data_g <= x"0000" & sb_ul_slope(0);
                when x"4029c"   => fpga_data_g <= x"0000" & sb_ul_slope(1);
                when x"4039c"   => fpga_data_g <= x"0000" & sb_ul_slope(2);
                when x"4049c"   => fpga_data_g <= x"0000" & sb_ul_slope(3);

                when x"101a0"   => fpga_data_g <= x"0000" & dcm_ul_curve(0);
                when x"102a0"   => fpga_data_g <= x"0000" & dcm_ul_curve(1);
                when x"103a0"   => fpga_data_g <= x"0000" & dcm_ul_curve(2);
                when x"104a0"   => fpga_data_g <= x"0000" & dcm_ul_curve(3);

                when x"201a0"   => fpga_data_g <= x"0000" & kddi_ul_curve(0);
                when x"202a0"   => fpga_data_g <= x"0000" & kddi_ul_curve(1);
                when x"203a0"   => fpga_data_g <= x"0000" & kddi_ul_curve(2);
                when x"204a0"   => fpga_data_g <= x"0000" & kddi_ul_curve(3);

                when x"301a0"   => fpga_data_g <= x"0000" & rm_ul_curve(0);
                when x"302a0"   => fpga_data_g <= x"0000" & rm_ul_curve(1);
                when x"303a0"   => fpga_data_g <= x"0000" & rm_ul_curve(2);
                when x"304a0"   => fpga_data_g <= x"0000" & rm_ul_curve(3);

                when x"401a0"   => fpga_data_g <= x"0000" & sb_ul_curve(0);
                when x"402a0"   => fpga_data_g <= x"0000" & sb_ul_curve(1);
                when x"403a0"   => fpga_data_g <= x"0000" & sb_ul_curve(2);
                when x"404a0"   => fpga_data_g <= x"0000" & sb_ul_curve(3);

                when x"101a4"   => fpga_data_g  <= x"0000" & dcm_output_gain(0);
                when x"102a4"   => fpga_data_g  <= x"0000" & dcm_output_gain(1);
                when x"103a4"   => fpga_data_g  <= x"0000" & dcm_output_gain(2);
                when x"104a4"   => fpga_data_g  <= x"0000" & dcm_output_gain(3);

                when x"201a4"   => fpga_data_g  <= x"0000" & kddi_output_gain(0);
                when x"202a4"   => fpga_data_g  <= x"0000" & kddi_output_gain(1);
                when x"203a4"   => fpga_data_g  <= x"0000" & kddi_output_gain(2);
                when x"204a4"   => fpga_data_g  <= x"0000" & kddi_output_gain(3);

                when x"301a4"   => fpga_data_g  <= x"0000" & rm_output_gain(0);
                when x"302a4"   => fpga_data_g  <= x"0000" & rm_output_gain(1);
                when x"303a4"   => fpga_data_g  <= x"0000" & rm_output_gain(2);
                when x"304a4"   => fpga_data_g  <= x"0000" & rm_output_gain(3);

                when x"401a4"   => fpga_data_g  <= x"0000" & sb_output_gain(0);
                when x"402a4"   => fpga_data_g  <= x"0000" & sb_output_gain(1);
                when x"403a4"   => fpga_data_g  <= x"0000" & sb_output_gain(2);
                when x"404a4"   => fpga_data_g  <= x"0000" & sb_output_gain(3);

                when x"101a8"   => fpga_data_g <= dcm_ul_pow(0);
                when x"102a8"   => fpga_data_g <= dcm_ul_pow(1);
                when x"103a8"   => fpga_data_g <= dcm_ul_pow(2);
                when x"104a8"   => fpga_data_g <= dcm_ul_pow(3);

                when x"201a8"   => fpga_data_g <= kddi_ul_pow(0);
                when x"202a8"   => fpga_data_g <= kddi_ul_pow(1);
                when x"203a8"   => fpga_data_g <= kddi_ul_pow(2);
                when x"204a8"   => fpga_data_g <= kddi_ul_pow(3);

                when x"301a8"   => fpga_data_g <= rm_ul_pow(0);
                when x"302a8"   => fpga_data_g <= rm_ul_pow(1);
                when x"303a8"   => fpga_data_g <= rm_ul_pow(2);
                when x"304a8"   => fpga_data_g <= rm_ul_pow(3);

                when x"401a8"   => fpga_data_g <= sb_ul_pow(0);
                when x"402a8"   => fpga_data_g <= sb_ul_pow(1);
                when x"403a8"   => fpga_data_g <= sb_ul_pow(2);
                when x"404a8"   => fpga_data_g <= sb_ul_pow(3);

                when x"101ac"   => fpga_data_g <= dcm_ul_peak(0);
                when x"102ac"   => fpga_data_g <= dcm_ul_peak(1);
                when x"103ac"   => fpga_data_g <= dcm_ul_peak(2);
                when x"104ac"   => fpga_data_g <= dcm_ul_peak(3);

                when x"201ac"   => fpga_data_g <= kddi_ul_peak(0);
                when x"202ac"   => fpga_data_g <= kddi_ul_peak(1);
                when x"203ac"   => fpga_data_g <= kddi_ul_peak(2);
                when x"204ac"   => fpga_data_g <= kddi_ul_peak(3);

                when x"301ac"   => fpga_data_g <= rm_ul_peak(0);
                when x"302ac"   => fpga_data_g <= rm_ul_peak(1);
                when x"303ac"   => fpga_data_g <= rm_ul_peak(2);
                when x"304ac"   => fpga_data_g <= rm_ul_peak(3);

                when x"401ac"   => fpga_data_g <= sb_ul_peak(0);
                when x"402ac"   => fpga_data_g <= sb_ul_peak(1);
                when x"403ac"   => fpga_data_g <= sb_ul_peak(2);
                when x"404ac"   => fpga_data_g <= sb_ul_peak(3);

                when x"101b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_dcm_01;
                when x"102b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_dcm_01;
                when x"103b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_dcm_23;
                when x"104b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_dcm_23;
                when x"201b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_kddi_01;
                when x"202b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_kddi_01;
                when x"203b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_kddi_23;
                when x"204b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_kddi_23;
                when x"301b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_rm_01;
                when x"302b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_rm_01;
                when x"303b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_rm_23;
                when x"304b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_rm_23;
                when x"401b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_sb_01;
                when x"402b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_sb_01;
                when x"403b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_sb_23;
                when x"404b0"   => fpga_data_g <= x"0000" & "00" & ul_dly_sb_23;


                when x"50000"   => fpga_data_g <= x"0000000" & "00" & rfu_io_test_mode;
                when x"5d5d5"   => fpga_data_g <= test_reg;

                when others     => fpga_data_g <= (others => '0');
            end case;
        end if;
    end if;
end if;
end process;

--dpd_rst_reg_s <= dpd_rst_reg or cpri_rst;

rst_blk_dpd: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 4, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => dpd_rst_reg,
     dest_clk  => clk_491p52,
     dest_arst => dpd_rst
  );

dpd_rst_n   <= not dpd_rst;-- and rst_n;

rfic_irq <= jesd_irq & MXL_INTR;

inst_zynq_ps_wrapper : entity work.zynq_ps
port map (
    dpd_rst_n              => dpd_rst_n           , --: in  STD_LOGIC;
    pl_rst_n               => pl_rst_n            , --: out STD_LOGIC;
    rfic_irq               => rfic_irq            , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    LOC_RST_N(0)           => loc_rst_n           , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_araddr         => CFR_AXI_araddr      , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    CFR_AXI_arprot         => CFR_AXI_arprot      , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CFR_AXI_arready        => CFR_AXI_arready     , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_arvalid        => CFR_AXI_arvalid     , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_awaddr         => CFR_AXI_awaddr      , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    CFR_AXI_awprot         => CFR_AXI_awprot      , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CFR_AXI_awready        => CFR_AXI_awready     , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_awvalid        => CFR_AXI_awvalid     , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_bready         => CFR_AXI_bready      , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_bresp          => CFR_AXI_bresp       , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    CFR_AXI_bvalid         => CFR_AXI_bvalid      , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_rdata          => CFR_AXI_rdata       , --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    CFR_AXI_rready         => CFR_AXI_rready      , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_rresp          => CFR_AXI_rresp       , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    CFR_AXI_rvalid         => CFR_AXI_rvalid      , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_wdata          => CFR_AXI_wdata       , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CFR_AXI_wready         => CFR_AXI_wready      , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    CFR_AXI_wstrb          => CFR_AXI_wstrb       , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    CFR_AXI_wvalid         => CFR_AXI_wvalid      , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    AXI_RST_N(0)           => AXI_RST_N           , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    CPRI0_AXI_araddr       => CPRI_AXI_araddr(0)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI0_AXI_arprot       => CPRI_AXI_arprot(0)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI0_AXI_arready      => CPRI_AXI_arready(0) , --: in STD_LOGIC;
    CPRI0_AXI_arvalid      => CPRI_AXI_arvalid(0) , --: out STD_LOGIC;
    CPRI0_AXI_awaddr       => CPRI_AXI_awaddr(0)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI0_AXI_awprot       => CPRI_AXI_awprot(0)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI0_AXI_awready      => CPRI_AXI_awready(0) , --: in STD_LOGIC;
    CPRI0_AXI_awvalid      => CPRI_AXI_awvalid(0) , --: out STD_LOGIC;
    CPRI0_AXI_bready       => CPRI_AXI_bready(0)  , --: out STD_LOGIC;
    CPRI0_AXI_bresp        => CPRI_AXI_bresp(0)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI0_AXI_bvalid       => CPRI_AXI_bvalid(0)  , --: in STD_LOGIC;
    CPRI0_AXI_rdata        => CPRI_AXI_rdata(0)   , --: in STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI0_AXI_rready       => CPRI_AXI_rready(0)  , --: out STD_LOGIC;
    CPRI0_AXI_rresp        => CPRI_AXI_rresp(0)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI0_AXI_rvalid       => CPRI_AXI_rvalid(0)  , --: in STD_LOGIC;
    CPRI0_AXI_wdata        => CPRI_AXI_wdata(0)   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI0_AXI_wready       => CPRI_AXI_wready(0)  , --: in STD_LOGIC;
    CPRI0_AXI_wstrb        => CPRI_AXI_wstrb(0)   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    CPRI0_AXI_wvalid       => CPRI_AXI_wvalid(0)  , --: out STD_LOGIC;
    CPRI1_AXI_araddr       => CPRI_AXI_araddr(1)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI1_AXI_arprot       => CPRI_AXI_arprot(1)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI1_AXI_arready      => CPRI_AXI_arready(1) , --: in STD_LOGIC;
    CPRI1_AXI_arvalid      => CPRI_AXI_arvalid(1) , --: out STD_LOGIC;
    CPRI1_AXI_awaddr       => CPRI_AXI_awaddr(1)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI1_AXI_awprot       => CPRI_AXI_awprot(1)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI1_AXI_awready      => CPRI_AXI_awready(1) , --: in STD_LOGIC;
    CPRI1_AXI_awvalid      => CPRI_AXI_awvalid(1) , --: out STD_LOGIC;
    CPRI1_AXI_bready       => CPRI_AXI_bready(1)  , --: out STD_LOGIC;
    CPRI1_AXI_bresp        => CPRI_AXI_bresp(1)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI1_AXI_bvalid       => CPRI_AXI_bvalid(1)  , --: in STD_LOGIC;
    CPRI1_AXI_rdata        => CPRI_AXI_rdata(1)   , --: in STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI1_AXI_rready       => CPRI_AXI_rready(1)  , --: out STD_LOGIC;
    CPRI1_AXI_rresp        => CPRI_AXI_rresp(1)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI1_AXI_rvalid       => CPRI_AXI_rvalid(1)  , --: in STD_LOGIC;
    CPRI1_AXI_wdata        => CPRI_AXI_wdata(1)   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI1_AXI_wready       => CPRI_AXI_wready(1)  , --: in STD_LOGIC;
    CPRI1_AXI_wstrb        => CPRI_AXI_wstrb(1)   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    CPRI1_AXI_wvalid       => CPRI_AXI_wvalid(1)  , --: out STD_LOGIC;
    CPRI2_AXI_araddr       => CPRI_AXI_araddr(2)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI2_AXI_arprot       => CPRI_AXI_arprot(2)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI2_AXI_arready      => CPRI_AXI_arready(2) , --: in STD_LOGIC;
    CPRI2_AXI_arvalid      => CPRI_AXI_arvalid(2) , --: out STD_LOGIC;
    CPRI2_AXI_awaddr       => CPRI_AXI_awaddr(2)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI2_AXI_awprot       => CPRI_AXI_awprot(2)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI2_AXI_awready      => CPRI_AXI_awready(2) , --: in STD_LOGIC;
    CPRI2_AXI_awvalid      => CPRI_AXI_awvalid(2) , --: out STD_LOGIC;
    CPRI2_AXI_bready       => CPRI_AXI_bready(2)  , --: out STD_LOGIC;
    CPRI2_AXI_bresp        => CPRI_AXI_bresp(2)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI2_AXI_bvalid       => CPRI_AXI_bvalid(2)  , --: in STD_LOGIC;
    CPRI2_AXI_rdata        => CPRI_AXI_rdata(2)   , --: in STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI2_AXI_rready       => CPRI_AXI_rready(2)  , --: out STD_LOGIC;
    CPRI2_AXI_rresp        => CPRI_AXI_rresp(2)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI2_AXI_rvalid       => CPRI_AXI_rvalid(2)  , --: in STD_LOGIC;
    CPRI2_AXI_wdata        => CPRI_AXI_wdata(2)   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI2_AXI_wready       => CPRI_AXI_wready(2)  , --: in STD_LOGIC;
    CPRI2_AXI_wstrb        => CPRI_AXI_wstrb(2)   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    CPRI2_AXI_wvalid       => CPRI_AXI_wvalid(2)  , --: out STD_LOGIC;
    CPRI3_AXI_araddr       => CPRI_AXI_araddr(3)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI3_AXI_arprot       => CPRI_AXI_arprot(3)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI3_AXI_arready      => CPRI_AXI_arready(3) , --: in STD_LOGIC;
    CPRI3_AXI_arvalid      => CPRI_AXI_arvalid(3) , --: out STD_LOGIC;
    CPRI3_AXI_awaddr       => CPRI_AXI_awaddr(3)  , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI3_AXI_awprot       => CPRI_AXI_awprot(3)  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    CPRI3_AXI_awready      => CPRI_AXI_awready(3) , --: in STD_LOGIC;
    CPRI3_AXI_awvalid      => CPRI_AXI_awvalid(3) , --: out STD_LOGIC;
    CPRI3_AXI_bready       => CPRI_AXI_bready(3)  , --: out STD_LOGIC;
    CPRI3_AXI_bresp        => CPRI_AXI_bresp(3)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI3_AXI_bvalid       => CPRI_AXI_bvalid(3)  , --: in STD_LOGIC;
    CPRI3_AXI_rdata        => CPRI_AXI_rdata(3)   , --: in STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI3_AXI_rready       => CPRI_AXI_rready(3)  , --: out STD_LOGIC;
    CPRI3_AXI_rresp        => CPRI_AXI_rresp(3)   , --: in STD_LOGIC_VECTOR ( 1 downto 0 );
    CPRI3_AXI_rvalid       => CPRI_AXI_rvalid(3)  , --: in STD_LOGIC;
    CPRI3_AXI_wdata        => CPRI_AXI_wdata(3)   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CPRI3_AXI_wready       => CPRI_AXI_wready(3)  , --: in STD_LOGIC;
    CPRI3_AXI_wstrb        => CPRI_AXI_wstrb(3)   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    CPRI3_AXI_wvalid       => CPRI_AXI_wvalid(3)  , --: out STD_LOGIC;
    DPD_IN_tdata           => DPD_IN_tdata        , --: in STD_LOGIC_VECTOR ( 255 downto 0 );
    DPD_IN_tlast           => DPD_IN_tlast        , --: in STD_LOGIC;
    DPD_IN_tready          => DPD_IN_tready       , --: out STD_LOGIC;
    DPD_IN_tuser           => DPD_IN_tuser        , --: in STD_LOGIC_VECTOR ( 31 downto 0 );
    DPD_IN_tvalid          => DPD_IN_tvalid       , --: in STD_LOGIC;
    DPD_OUT_tdata          => DPD_OUT_tdata       , --: out STD_LOGIC_VECTOR ( 255 downto 0 );
    DPD_OUT_tlast          => DPD_OUT_tlast       , --: out STD_LOGIC;
    DPD_OUT_tready         => DPD_OUT_tready      , --: in STD_LOGIC;
    DPD_OUT_tuser          => DPD_OUT_tuser       , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    DPD_OUT_tvalid         => DPD_OUT_tvalid      , --: out STD_LOGIC;
    FB_IN_tdata            => FB_IN_tdata         , --: in STD_LOGIC_VECTOR ( 63 downto 0 );
    FB_IN_tready           => FB_IN_tready        , --: out STD_LOGIC;
    FB_IN_tuser            => FB_IN_tuser         , --: in STD_LOGIC_VECTOR ( 7 downto 0 );
    FB_IN_tvalid           => FB_IN_tvalid        , --: in STD_LOGIC;
    GMII_ENET2_col         => GND                 , --: in  STD_LOGIC;
    GMII_ENET2_crs         => GND                 , --: in  STD_LOGIC;
    GMII_ENET2_rx_clk      => clk_25              , --: in  STD_LOGIC;
    GMII_ENET2_rx_dv       => eth_rx_dv           , --: in  STD_LOGIC;
    GMII_ENET2_rx_er       => eth_rx_er           , --: in  STD_LOGIC;
    GMII_ENET2_rxd         => eth_gmii_rxd        , --: in  STD_LOGIC_VECTOR ( 7 downto 0 );
    GMII_ENET2_speed_mode  => eth_speed_mode      , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    GMII_ENET2_tx_clk      => clk_25              , --: in  STD_LOGIC;
    GMII_ENET2_tx_en       => eth_tx_en           , --: out STD_LOGIC;
    GMII_ENET2_tx_er       => eth_tx_er           , --: out STD_LOGIC;
    GMII_ENET2_txd         => eth_gmii_txd        , --: out STD_LOGIC_VECTOR ( 7 downto 0 );
    JESD_RX_AXI_araddr     => JESD_RX_AXI_araddr  , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    JESD_RX_AXI_arprot     => JESD_RX_AXI_arprot  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    JESD_RX_AXI_arready    => JESD_RX_AXI_arready , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_arvalid    => JESD_RX_AXI_arvalid , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_awaddr     => JESD_RX_AXI_awaddr  , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    JESD_RX_AXI_awprot     => JESD_RX_AXI_awprot  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    JESD_RX_AXI_awready    => JESD_RX_AXI_awready , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_awvalid    => JESD_RX_AXI_awvalid , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_bready     => JESD_RX_AXI_bready  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_bresp      => JESD_RX_AXI_bresp   , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    JESD_RX_AXI_bvalid     => JESD_RX_AXI_bvalid  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_rdata      => JESD_RX_AXI_rdata   , --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    JESD_RX_AXI_rready     => JESD_RX_AXI_rready  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_rresp      => JESD_RX_AXI_rresp   , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    JESD_RX_AXI_rvalid     => JESD_RX_AXI_rvalid  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_wdata      => JESD_RX_AXI_wdata   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    JESD_RX_AXI_wready     => JESD_RX_AXI_wready  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_RX_AXI_wstrb      => JESD_RX_AXI_wstrb   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    JESD_RX_AXI_wvalid     => JESD_RX_AXI_wvalid  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_araddr     => JESD_TX_AXI_araddr  , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    JESD_TX_AXI_arprot     => JESD_TX_AXI_arprot  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    JESD_TX_AXI_arready    => JESD_TX_AXI_arready , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_arvalid    => JESD_TX_AXI_arvalid , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_awaddr     => JESD_TX_AXI_awaddr  , --: out STD_LOGIC_VECTOR ( 39 downto 0 );
    JESD_TX_AXI_awprot     => JESD_TX_AXI_awprot  , --: out STD_LOGIC_VECTOR ( 2 downto 0 );
    JESD_TX_AXI_awready    => JESD_TX_AXI_awready , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_awvalid    => JESD_TX_AXI_awvalid , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_bready     => JESD_TX_AXI_bready  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_bresp      => JESD_TX_AXI_bresp   , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    JESD_TX_AXI_bvalid     => JESD_TX_AXI_bvalid  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_rdata      => JESD_TX_AXI_rdata   , --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    JESD_TX_AXI_rready     => JESD_TX_AXI_rready  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_rresp      => JESD_TX_AXI_rresp   , --: in  STD_LOGIC_VECTOR ( 1 downto 0 );
    JESD_TX_AXI_rvalid     => JESD_TX_AXI_rvalid  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_wdata      => JESD_TX_AXI_wdata   , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    JESD_TX_AXI_wready     => JESD_TX_AXI_wready  , --: in  STD_LOGIC_VECTOR ( 0 to 0 );
    JESD_TX_AXI_wstrb      => JESD_TX_AXI_wstrb   , --: out STD_LOGIC_VECTOR ( 3 downto 0 );
    JESD_TX_AXI_wvalid     => JESD_TX_AXI_wvalid  , --: out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AVALON_address       => avalon_address      , --: out STD_LOGIC_VECTOR ( 23 downto 0 );
    M_AVALON_read          => avalon_rd           , --: out STD_LOGIC;
    M_AVALON_readdata      => avalon_rddata       , --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AVALON_readdatavalid => avalon_rddatavalid  , --: in  STD_LOGIC;
    M_AVALON_waitrequest   => '0'                 , --: in  STD_LOGIC;
    M_AVALON_write         => avalon_wr           , --: out STD_LOGIC;
    M_AVALON_writedata     => cpu_data            , --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    SRX_CTRL_tdata         => SRX_CTRL_tdata      , --: out STD_LOGIC_VECTOR ( 7 downto 0 );
    SRX_CTRL_tready        => SRX_CTRL_tready     , --: in STD_LOGIC;
    SRX_CTRL_tvalid        => SRX_CTRL_tvalid     , --: out STD_LOGIC;
    clk_61p44              => clk_61p44           , --: in  STD_LOGIC;
    clk_491p52             => clk_491p52          , --: in  STD_LOGIC;
    clk_400                => clk_400             , --: out STD_LOGIC;
    clk_125                => clk_125             , --: out STD_LOGIC;
    clk_100                => clk_100             , --: out STD_LOGIC;
    clk_25                 => clk_25              , --: out STD_LOGIC;
    clk_12p5               => clk_12p5            , --: out STD_LOGIC;
    loc_locked             => loc_locked          , --: out STD_LOGIC;
    mmcm_jesd_lock         => mmcm_jesd_locked    , --: in  STD_LOGIC
    temp_out                => fpga_temp           ,--: out STD_LOGIC_VECTOR ( 9 downto 0 )
    scl_in                 => scl_in              , --: in STD_LOGIC_VECTOR ( 4 downto 0 );
    scl_out                => scl_out             , --: out STD_LOGIC_VECTOR ( 4 downto 0 );
    scl_t                  => scl_t               , --: out STD_LOGIC_VECTOR ( 4 downto 0 );
    sda_in                 => sda_in              , --: in STD_LOGIC_VECTOR ( 4 downto 0 );
    sda_out                => sda_out             , --: out STD_LOGIC_VECTOR ( 4 downto 0 );
    sda_t                  => sda_t               ); --: out STD_LOGIC_VECTOR ( 4 downto 0 )

-- DPD_IN_tuser <= dpd_in_tuser_ant(3) & dpd_in_tuser_ant(2) & dpd_in_tuser_ant(1) & dpd_in_tuser_ant(0);
-- frame_marker <= xdpd_rfs;
-- dl_ul_marker <= tdd_sync_dl_sync;
-- capture_sync <= xdpd_rfs;
-- dpd_in_tuser_ant(0) <= "000" & mxl_tx_en_s(0)	& capture_sync & dl_ul_marker & frame_marker & '0';
-- dpd_in_tuser_ant(1) <= "000" & mxl_tx_en_s(1)	& capture_sync & dl_ul_marker & frame_marker & '0';
-- dpd_in_tuser_ant(2) <= "000" & mxl_tx_en_s(2)	& capture_sync & dl_ul_marker & frame_marker & '0';
-- dpd_in_tuser_ant(3) <= "000" & mxl_tx_en_s(3)	& capture_sync & dl_ul_marker & frame_marker & '0';

CLK_BLK0 : entity work.clk_blk
port map (
    loc_reset_n      => pl_rst_n         , --: in  std_logic;
    ext_pll_lock     => PLL_LOCK(1)      , --: in  std_logic;
    clk_100          => clk_100          , --: in  std_logic;

    cpri_ref_clk_p   => cpri_ref_clk_p   , --: in  std_logic; -- 307.2mhz
    cpri_ref_clk_n   => cpri_ref_clk_n   , --: in  std_logic;

    cpri_rec_clk     => rec_clk          , --: in  std_logic;
    cpri_rec_clk_p   => cpri_rec_clk_p   , --: out std_logic;
    cpri_rec_clk_n   => cpri_rec_clk_n   , --: out std_logic;

    jesd_ref_clk_p   => jesd_ref_clk_p   , --: in  std_logic; -- 245.76mhz
    jesd_ref_clk_n   => jesd_ref_clk_n   , --: in  std_logic;
    gt_powergood     => gt_powergood     , --: in  std_logic;

    jesd_sysref_p    => jesd_sys_ref_p   , --: in  std_logic;
    jesd_sysref_n    => jesd_sys_ref_n   , --: in  std_logic;

    cpri_ref_clk     => cpri_ref_clk     , --: out std_logic;
    jesd_ref_clk     => jesd_ref_clk     , --: out std_logic;

    jesd_sysref      => jesd_sysref      , --: out std_logic; -- 1.92mhz

    clk_491p52       => clk_491p52       , --: out std_logic;
    clk_245p76       => clk_245p76       , --: out std_logic;
    clk_122p88       => clk_122p88       , --: out std_logic;
    clk_61p44        => clk_61p44        , --: out std_logic;
    --clk_7p68         => clk_7p68         , --: out std_logic;
    clk_368p64       => clk_368p64       , --: out std_logic;
	dspclk_368p64    => dspclk_368p64       , --: out std_logic;
    clk_294p912      => clk_294p912      , --: out std_logic;

    mmcm_jesd_locked => mmcm_jesd_locked , --: out std_logic;
    mmcm_cpri_locked => mmcm_cpri_locked ); --: out std_logic;


RST_BLK0 : entity work.reset_blk
port map(
    clk         => clk_61p44        , --: in std_logic;
    mmcm_locked => mmcm_jesd_locked , --: in std_logic;
    rst_n       => rst_n            );    --: out std_logic

cpri_rst    <= not rst_n;

cpri_axi_addr_bank : for n IN 0 to CPRI_NUM generate
    cpri_axi_awaddr_12(n)  <= cpri_axi_awaddr(n)(11 downto 0);
    cpri_axi_araddr_12(n)  <= cpri_axi_araddr(n)(11 downto 0);
end generate;


CPRI_BLOCK : entity work.cpri_4path
port map (
    reset                  => cpri_rst            , --: in  std_logic; -- Asynchronous reset
    eth_blk_rst            => eth_blk_rst,
    link_chg_rst_n          => link_chg_rst_n,
    master_lane_ind         => master_lane_ind,
    iq_tx_enable           => iq_tx_enable           , --: out std_logic_vector(CPRI_NUM downto 0);
    basic_frame_first_word => basic_frame_first_word , --: out std_logic_vector(CPRI_NUM downto 0);
    iq_tx                  => iq_tx                  , --: in  arr_cpri_64_stdlogic;
    iq_rx                  => iq_rx                  , --: out arr_cpri_64_stdlogic;
    sync_hyperframe_number    => open        , --: out arr_cpri_8_stdlogic;
    cpri_hyperframe_number    => cpri_hyperframe_number        , --: out arr_cpri_8_stdlogic;
    o_stat_speed              => stat_speed                , --: out arr_cpri_15_stdlogic;
    o_nodebfn_rx_strobe          => nodebfn_rx_strobe        ,
    o_nodebfn_rx_nr           => nodebfn_rx_nr, --: out arr_cpri_12_stdlogic;
    o_nodebfn_tx_strobe          => nodebfn_tx_strobe        ,
    o_nodebfn_tx_nr           => nodebfn_tx_nr, --: out arr_cpri_12_stdlogic;
    o_vendor_rx_xs            => vendor_rx_xs            , --: out arr_cpri_2_stdlogic;
    o_vendor_rx_ns            => vendor_rx_ns            , --: out arr_cpri_6_stdlogic;
    o_vendor_tx_xs            => vendor_tx_xs            , --: out arr_cpri_2_stdlogic;
    o_vendor_tx_ns            => vendor_tx_ns            , --: out arr_cpri_6_stdlogic;
    vendor_tx_data            => vendor_tx_data, --: in arr_cpri_128_stdlogic;
    vendor_rx_data            => vendor_rx_data, --: out arr_cpri_128_stdlogic;
    s_axi_aclk             => clk_61p44              , --: in  std_logic;
    s_axi_aresetn          => axi_rst_n              , --: in  std_logic;
    s_axi_awaddr           => cpri_axi_awaddr_12     , --: in  arr_cpri_12_stdlogic;
    s_axi_awvalid          => cpri_axi_awvalid       , --: in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_awready          => cpri_axi_awready       , --: out std_logic_vector(CPRI_NUM downto 0);
    s_axi_wdata            => cpri_axi_wdata         , --: in  arr_cpri_32_stdlogic;
    s_axi_wvalid           => cpri_axi_wvalid        , --: in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_wready           => cpri_axi_wready        , --: out std_logic_vector(CPRI_NUM downto 0);
    s_axi_bresp            => cpri_axi_bresp         , --: out arr_cpri_2_stdlogic;
    s_axi_rresp            => cpri_axi_rresp         , --: out arr_cpri_2_stdlogic;
    s_axi_bvalid           => cpri_axi_bvalid        , --: out std_logic_vector(CPRI_NUM downto 0);
    s_axi_bready           => cpri_axi_bready        , --: in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_araddr           => cpri_axi_araddr_12     , --: in  arr_cpri_12_stdlogic;
    s_axi_arvalid          => cpri_axi_arvalid       , --: in  std_logic_vector(CPRI_NUM downto 0);
    s_axi_arready          => cpri_axi_arready       , --: out std_logic_vector(CPRI_NUM downto 0);
    s_axi_rdata            => cpri_axi_rdata         , --: out arr_cpri_32_stdlogic;
    s_axi_rvalid           => cpri_axi_rvalid        , --: out std_logic_vector(CPRI_NUM downto 0);
    s_axi_rready           => cpri_axi_rready        , --: in  std_logic_vector(CPRI_NUM downto 0);
    txp                    => sfp_tx_p               , --: out std_logic_vector(CPRI_NUM downto 0);
    txn                    => sfp_tx_n               , --: out std_logic_vector(CPRI_NUM downto 0);
    rxp                    => sfp_rx_p               , --: in  std_logic_vector(CPRI_NUM downto 0);
    rxn                    => sfp_rx_n               , --: in  std_logic_vector(CPRI_NUM downto 0);
    sfp_los                => sfp_los                , --: in  std_logic_vector(CPRI_NUM downto 0);
    txinhibit              => txinhibit              , --: out std_logic_vector(CPRI_NUM downto 0);
    clk_368p64             => clk_368p64             , --: in  std_logic;
    clk_294p912            => clk_294p912            , --: in  std_logic;
																			   
    hires_clk              => clk_400                , --: in  std_logic;
    cpri_mmcm_locked       => mmcm_cpri_locked       , --: in  std_logic;
    hires_clk_ok           => loc_locked      , --: in  std_logic;
    refclk                 => cpri_ref_clk           , --: in  std_logic;
																			   
    clk_125m               => clk_125                , --: in  std_logic;
    clk_25m                => clk_25                 , --: in  std_logic;
    clk_12p5m              => clk_12p5               , --: in  std_logic;
    eth_gap                => eth_gap                , --: in  std_logic_vector(11 downto 0);
    eth_tx_en              => eth_tx_en              , --: in  std_logic;
    eth_txd                => eth_txd                , --: in  std_logic_vector(7 downto 0);
    eth_rx_dv              => eth_rx_dv              , --: out std_logic;
    eth_rxd                => eth_rxd                , --: out std_logic_vector(7 downto 0);
    mapper_reset           => mapper_reset           , --: out std_logic_vector(CPRI_NUM downto 0);
    recclk_out             => rec_clk                , --: out std_logic;
    qpll_lock_out          => cpri_qpll_lock         , --: out std_logic;
    cpri_linkup            => cpri_linkup            , --: out std_logic_vector(CPRI_NUM downto 0);
    local_los              => open                   , --: out std_logic_vector(CPRI_NUM downto 0);
    local_lof              => open                   , --: out std_logic_vector(CPRI_NUM downto 0);
    gt_rxpcs_rst           => gt_rxpcs_rst           , --: in  std_logic_vector(CPRI_NUM downto 0);
    gt_txpcs_rst           => gt_txpcs_rst           , --: in  std_logic_vector(CPRI_NUM downto 0);
    gt_rxpma_rst           => gt_rxpma_rst           , --: in  std_logic_vector(CPRI_NUM downto 0);
    gt_txpma_rst           => gt_txpma_rst           , --: in  std_logic_vector(CPRI_NUM downto 0);
    gt_txresetdone         => gt_txresetdone         , --: out std_logic_vector(CPRI_NUM downto 0);
    gt_rxresetdone         => gt_rxresetdone         , --: out std_logic_vector(CPRI_NUM downto 0);
    gt_rxlpmen             => gt_rxlpmen             , --: in  std_logic_vector(CPRI_NUM downto 0);
    gt_txdiffctrl          => gt_txdiffctrl          , --: in  arr_cpri_5_stdlogic;
    vs_rx_0_80_0           => vs_rx_0_80_0           ,--: out arr_2_32_stdlogic;
    vs_rx_0_80_1           => vs_rx_0_80_1           ,--: out arr_4_32_stdlogic;
    vs_rx_0_144_0          => vs_rx_0_144_0          ,--: out arr_4_32_stdlogic;
    vs_rx_0_144_1          => vs_rx_0_144_1          ,--: out arr_2_32_stdlogic;
    vs_rx_0_144_2          => vs_rx_0_144_2          ,--: out arr_2_32_stdlogic;
    vs_rx_0_144_3          => vs_rx_0_144_3          ,--: out arr_2_32_stdlogic;
    vs_tx_0_80_0_wr                => vs_tx_0_80_0,--: in std_logic_vector(31 downto 0);
    o_vs_tx_0_80                => vs_tx_0_80, --: out arr_4_128_stdlogic;
    o_vs_tx_0_144                => vs_tx_0_144, --: out arr_4_128_stdlogic;
    i_vs_rx_0_80                => vs_rx_0_80, --: in arr_4_128_stdlogic;
    i_vs_rx_0_144                => vs_rx_0_144, --: in arr_4_128_stdlogic;
    vs_tx_0_144_0_wr       => vs_tx_0_144_0,
    vs_tx_0_144_1_wr       => vs_tx_0_144_1,
    vs_tx_0_144_2_wr       => vs_tx_0_144_2,
    vs_tx_0_144_3_wr       => vs_tx_0_144_3,
    tdd_valid              => tdd_valid_s                   ,
    cnm_prime_in           => cnm_prime_in           ,--: in std_logic;
    ip_offset_fb           => ip_offset_fb           ,--: in std_logic_vector(31 downto 0);
    ip_offset_cas          => ip_offset_cas          ,--: in std_logic_vector(31 downto 0);
    cpri_t_offset          => cpri_t_offset          ,--: in arr_2_32_stdlogic;
    cas_delay              => cas_delay              ,--: in arr_2_32_stdlogic;
--    core_is_master       => core_is_master         ,
				
    l1_reset               => l1_reset_out           ); -- : out std_logic


 eth_txd           <= eth_gmii_txd;
 eth_gmii_rxd      <= eth_rxd;
 
 mapper_rst_p(0) <= mapper_reset(0) or (not link_chg_rst_n);
 mapper_rst_p(1) <= mapper_reset(1) or (not link_chg_rst_n);

CPRI_SOLID_mapper_main:entity work.CPRI_SOLID_frame_cacade_RU_n77_ver02
port map(
    i_sys_clk                                              => dspclk_368p64,
    i_rst_p                                                => mapper_rst_p(0),
    -- main cpri interface
    i_tx_clk                                               => clk_368p64,
    --i_speed                                             => '1',
    i_rx_link_up_ok                                        => cpri_linkup(0),
    i_bypass_combine									=> combine_bypass_mode,
    --i_ul_tsync  => ul_det_tsync,
    i_loop_mode                                            => map_loop_mode(0),
    i_test_mode                                            => map_test_mode,

    i_nodebfn_rx_strobe                                   => nodebfn_rx_strobe(0),
    --i_nodebfn_rx_nr                                       => nodebfn_rx_nr(0),
    --i_hyperframe_rx_nr                                    => cpri_hyperframe_number(0),
    --o_nodebfn_tx_strobe                                 => nodebfn_tx_strobe(0),
    --o_nodebfn_tx_nr                                     => nodebfn_tx_nr(0),

    -- iq data
    i_iq_tx_enable                                        => iq_tx_enable(0),
    o_tx_iq_data                                        => iq_tx(0),
    i_basic_frame_first_word                            => basic_frame_first_word(0),
    i_rx_iq_data                                        => iq_rx(0),
    -- vss
    o_vendor_tx_data                                    => vendor_tx_data(0),
    i_vendor_tx_xs                                      => vendor_tx_xs(0),
    i_vendor_tx_ns                                      => vendor_tx_ns(0),
    i_vendor_rx_data                                    => vendor_rx_data(0),
    i_vendor_rx_xs                                      => vendor_rx_xs(0),
    i_vendor_rx_ns                                      => vendor_rx_ns(0),

    -- mapper/demapper
    i_ul_10msec_ref                                        => ul_ref_10m(0)(0),

    -- iq data
    i_sync_g0                                            => ul_iq_sync,    -- ul block?��?�� ?��?�� ?��?��
    i_data_g0_1T                                        => dcm_dout_iq(0),
    i_data_g0_2T                                        => dcm_dout_iq(1),
    i_data_g0_3T                                        => dcm_dout_iq(2),
    i_data_g0_4T                                        => dcm_dout_iq(3),

    i_sync_g1                                            => ul_iq_sync,
    i_data_g1_1T                                        => kddi_dout_iq(0),
    i_data_g1_2T                                        => kddi_dout_iq(1),
    i_data_g1_3T                                        => kddi_dout_iq(2),
    i_data_g1_4T                                        => kddi_dout_iq(3),

    -- tx vss
    i_vss_enable                                        => '1',
    i_vss_080                                            => vs_tx_0_80(0),
    i_vss_144                                            => vs_tx_0_144(0),
    i_vss_208                                            => (others => '0'),
    -- rx iq data
    o_dl_ref_10m                                        => dl_ref_10m_s(0),

    o_sync_g0                                            => dl_iq_sync(0),
    o_data_g0_1T                                        => dl_iq0(0),
    o_data_g0_2T                                        => dl_iq0(1),
    o_data_g0_3T                                        => dl_iq0(2),
    o_data_g0_4T                                        => dl_iq0(3),

    o_sync_g1                                            => dl_iq_sync(1),
    o_data_g1_1T                                        => dl_iq1(0),
    o_data_g1_2T                                        => dl_iq1(1),
    o_data_g1_3T                                        => dl_iq1(2),
    o_data_g1_4T                                        => dl_iq1(3),
	
    -- rx vss                                            => -- rx vss
    o_vss_080                                            => vs_rx_0_80(0),
    o_vss_144                                            => vs_rx_0_144(0),
    o_vss_208                                            => open,
    -- cascade cpri interface
    i_tx_clk_1                                             => clk_368p64,
    --i_speed_1                                           => '1',
    i_rx_link_up_ok_1                                    => cpri_linkup(2),

    --i_nodebfn_rx_strobe_1                                 => nodebfn_rx_strobe(2),
    --i_nodebfn_rx_nr_1                                     => nodebfn_rx_nr(2),
    --i_hyperframe_rx_nr_1                                => cpri_hyperframe_number(2),
    --o_nodebfn_tx_strobe_1                                => nodebfn_tx_strobe(2),
    --o_nodebfn_tx_nr_1                                   => nodebfn_tx_nr(2),
    -- iq data
    i_iq_tx_enable_1                                    => iq_tx_enable(2),
    o_tx_iq_data_1                                        => iq_tx(2),
    i_basic_frame_first_word_1                            => basic_frame_first_word(2),
    i_rx_iq_data_1                                        => iq_rx(2),
    -- vss
    o_vendor_tx_data_1                                  => vendor_tx_data(2),
    i_vendor_tx_xs_1                                       => vendor_tx_xs(2),
    i_vendor_tx_ns_1                                    => vendor_tx_ns(2),
    i_vendor_rx_data_1                                  => vendor_rx_data(2),
    i_vendor_rx_xs_1                                    => vendor_rx_xs(2),
    i_vendor_rx_ns_1                                    => vendor_rx_ns(2),

    i_vss_enable_1                                        => '1',
    i_vss_080_1                                            => vs_tx_0_80(2),
    i_vss_144_1                                            => vs_tx_0_144(2),
    o_vss_080_1                                            => vs_rx_0_80(2),
    o_vss_144_1                                            => vs_rx_0_144(2),
    o_vss_208_1                                            => open
);
CPRI_SOLID_mapper_sub:entity work.CPRI_SOLID_frame_cacade_RU_n77_ver02
port map(
    i_sys_clk                                              => dspclk_368p64,
    i_rst_p                                                => mapper_rst_p(1),
    -- main cpri interface
    i_tx_clk                                               => clk_368p64,
    --i_speed                                             => '1',
    i_rx_link_up_ok                                        => cpri_linkup(1),
    i_bypass_combine									=> combine_bypass_mode,
    --i_ul_tsync  => ul_det_tsync,
    i_loop_mode                                            => map_loop_mode(1),
    i_test_mode                                            => map_test_mode,

    i_nodebfn_rx_strobe                                   => nodebfn_rx_strobe(1),
    --i_nodebfn_rx_nr                                       => nodebfn_rx_nr(1),
    --i_hyperframe_rx_nr                                    => cpri_hyperframe_number(1),
    --o_nodebfn_tx_strobe                                 => nodebfn_tx_strobe(1),
    --o_nodebfn_tx_nr                                     => nodebfn_tx_nr(1),

    -- iq data
    i_iq_tx_enable                                        => iq_tx_enable(1),
    o_tx_iq_data                                        => iq_tx(1),
    i_basic_frame_first_word                            => basic_frame_first_word(1),
    i_rx_iq_data                                        => iq_rx(1),
    -- vss
    o_vendor_tx_data                                    => vendor_tx_data(1),
    i_vendor_tx_xs                                      => vendor_tx_xs(1),
    i_vendor_tx_ns                                      => vendor_tx_ns(1),
    i_vendor_rx_data                                    => vendor_rx_data(1),
    i_vendor_rx_xs                                      => vendor_rx_xs(1),
    i_vendor_rx_ns                                      => vendor_rx_ns(1),

    -- mapper/demapper
    i_ul_10msec_ref                                        => ul_ref_10m(1)(0),

    -- iq data
    i_sync_g0                                            => ul_iq_sync,    -- ul block?��?�� ?��?�� ?��?��
    i_data_g0_1T                                        => rm_dout_iq(0),
    i_data_g0_2T                                        => rm_dout_iq(1),
    i_data_g0_3T                                        => rm_dout_iq(2),
    i_data_g0_4T                                        => rm_dout_iq(3),

    i_sync_g1                                            => ul_iq_sync,
    i_data_g1_1T                                        => sb_dout_iq(0),
    i_data_g1_2T                                        => sb_dout_iq(1),
    i_data_g1_3T                                        => sb_dout_iq(2),
    i_data_g1_4T                                        => sb_dout_iq(3),

    -- tx vss
    i_vss_enable                                        => '1',
    i_vss_080                                            => vs_tx_0_80(1),
    i_vss_144                                            => vs_tx_0_144(1),
    i_vss_208                                            => (others => '0'),
    -- rx iq data
    o_dl_ref_10m                                        => dl_ref_10m_s(1),

    o_sync_g0                                            => dl_iq_sync(2),
    o_data_g0_1T                                        => dl_iq2(0),
    o_data_g0_2T                                        => dl_iq2(1),
    o_data_g0_3T                                        => dl_iq2(2),
    o_data_g0_4T                                        => dl_iq2(3),

    o_sync_g1                                            => dl_iq_sync(3),
    o_data_g1_1T                                        => dl_iq3(0),
    o_data_g1_2T                                        => dl_iq3(1),
    o_data_g1_3T                                        => dl_iq3(2),
    o_data_g1_4T                                        => dl_iq3(3),
    -- rx vss                                            => -- rx vss
    o_vss_080                                            => vs_rx_0_80(1),
    o_vss_144                                            => vs_rx_0_144(1),
    o_vss_208                                            => open,
    -- cascade cpri interface
    i_tx_clk_1                                             => clk_368p64,
    --i_speed_1                                           => '1',
    i_rx_link_up_ok_1                                    => cpri_linkup(3),

    --i_nodebfn_rx_strobe_1                                 => nodebfn_rx_strobe(3),
    --i_nodebfn_rx_nr_1                                     => nodebfn_rx_nr(3),
    --i_hyperframe_rx_nr_1                                => cpri_hyperframe_number(3),
    --o_nodebfn_tx_strobe_1                                => nodebfn_tx_strobe(3),
    --o_nodebfn_tx_nr_1                                   => nodebfn_tx_nr(3),
    -- iq data
    i_iq_tx_enable_1                                    => iq_tx_enable(3),
    o_tx_iq_data_1                                        => iq_tx(3),
    i_basic_frame_first_word_1                            => basic_frame_first_word(3),
    i_rx_iq_data_1                                        => iq_rx(3),
    -- vss
    o_vendor_tx_data_1                                  => vendor_tx_data(3),
    i_vendor_tx_xs_1                                       => vendor_tx_xs(3),
    i_vendor_tx_ns_1                                    => vendor_tx_ns(3),
    i_vendor_rx_data_1                                  => vendor_rx_data(3),
    i_vendor_rx_xs_1                                    => vendor_rx_xs(3),
    i_vendor_rx_ns_1                                    => vendor_rx_ns(3),

    i_vss_enable_1                                        => '1',
	i_vss_080_1                                            => vs_tx_0_80(3),
    i_vss_144_1                                            => vs_tx_0_144(3),
    o_vss_080_1                                            => vs_rx_0_80(3),
    o_vss_144_1                                            => vs_rx_0_144(3),
    o_vss_208_1                                            => open
);

--inst_ila:entity work.ila_1
--port map(
--	clk => dspclk_368p64,
--	probe0 => op_id0(0),	-- 6
--	probe1 => op_id1(0),	-- 6
--	probe2 => op_id0(1),	-- 6
--	probe3 => op_id1(1),	-- 6
--	probe4 => dl_iq0(0),	-- 32
--	probe5 => dl_iq1(0),	-- 32
--	probe6 => dl_iq2(0),	-- 32
--	probe7 => dl_iq3(0),	-- 32
--    probe8(0) => tdd_sync_in
--);

op_id0(0) <= vs_rx_0_80_0(0)(23 downto 18);--1
op_id0(1) <= vs_rx_0_80_0(1)(23 downto 18);--8
op_id1(0) <= vs_rx_0_80_0(0)(31 downto 26);--2
op_id1(1) <= vs_rx_0_80_0(1)(31 downto 26);--4	

dl_i0(0) <= dl_iq0(0)(15 downto 0);
dl_q0(0) <= dl_iq0(0)(31 downto 16);
dl_i0(1) <= dl_iq0(1)(15 downto 0);
dl_q0(1) <= dl_iq0(1)(31 downto 16);
dl_i0(2) <= dl_iq0(2)(15 downto 0);
dl_q0(2) <= dl_iq0(2)(31 downto 16);
dl_i0(3) <= dl_iq0(3)(15 downto 0);
dl_q0(3) <= dl_iq0(3)(31 downto 16);

dl_i1(0) <= dl_iq1(0)(15 downto 0);
dl_q1(0) <= dl_iq1(0)(31 downto 16);
dl_i1(1) <= dl_iq1(1)(15 downto 0);
dl_q1(1) <= dl_iq1(1)(31 downto 16);
dl_i1(2) <= dl_iq1(2)(15 downto 0);
dl_q1(2) <= dl_iq1(2)(31 downto 16);
dl_i1(3) <= dl_iq1(3)(15 downto 0);
dl_q1(3) <= dl_iq1(3)(31 downto 16);

dl_i2(0) <= dl_iq2(0)(15 downto 0);
dl_q2(0) <= dl_iq2(0)(31 downto 16);
dl_i2(1) <= dl_iq2(1)(15 downto 0);
dl_q2(1) <= dl_iq2(1)(31 downto 16);
dl_i2(2) <= dl_iq2(2)(15 downto 0);
dl_q2(2) <= dl_iq2(2)(31 downto 16);
dl_i2(3) <= dl_iq2(3)(15 downto 0);
dl_q2(3) <= dl_iq2(3)(31 downto 16);

dl_i3(0) <= dl_iq3(0)(15 downto 0);
dl_q3(0) <= dl_iq3(0)(31 downto 16);
dl_i3(1) <= dl_iq3(1)(15 downto 0);
dl_q3(1) <= dl_iq3(1)(31 downto 16);
dl_i3(2) <= dl_iq3(2)(15 downto 0);
dl_q3(2) <= dl_iq3(2)(31 downto 16);
dl_i3(3) <= dl_iq3(3)(15 downto 0);
dl_q3(3) <= dl_iq3(3)(31 downto 16);

-- dc_dl_i(0) <= dl_iq0(0)(15 downto 0);
-- dc_dl_q(0) <= dl_iq0(0)(31 downto 16);
-- dc_dl_i(1) <= dl_iq0(1)(15 downto 0);
-- dc_dl_q(1) <= dl_iq0(1)(31 downto 16);
-- dc_dl_i(2) <= dl_iq0(2)(15 downto 0);
-- dc_dl_q(2) <= dl_iq0(2)(31 downto 16);
-- dc_dl_i(3) <= dl_iq0(3)(15 downto 0);
-- dc_dl_q(3) <= dl_iq0(3)(31 downto 16);

-- kd_dl_i(0) <= dl_iq1(0)(15 downto 0);
-- kd_dl_q(0) <= dl_iq1(0)(31 downto 16);
-- kd_dl_i(1) <= dl_iq1(1)(15 downto 0);
-- kd_dl_q(1) <= dl_iq1(1)(31 downto 16);
-- kd_dl_i(2) <= dl_iq1(2)(15 downto 0);
-- kd_dl_q(2) <= dl_iq1(2)(31 downto 16);
-- kd_dl_i(3) <= dl_iq1(3)(15 downto 0);
-- kd_dl_q(3) <= dl_iq1(3)(31 downto 16);

-- rm_dl_i(0) <= dl_iq2(0)(15 downto 0);
-- rm_dl_q(0) <= dl_iq2(0)(31 downto 16);
-- rm_dl_i(1) <= dl_iq2(1)(15 downto 0);
-- rm_dl_q(1) <= dl_iq2(1)(31 downto 16);
-- rm_dl_i(2) <= dl_iq2(2)(15 downto 0);
-- rm_dl_q(2) <= dl_iq2(2)(31 downto 16);
-- rm_dl_i(3) <= dl_iq2(3)(15 downto 0);
-- rm_dl_q(3) <= dl_iq2(3)(31 downto 16);

-- sb_dl_i(0) <= dl_iq3(0)(15 downto 0);
-- sb_dl_q(0) <= dl_iq3(0)(31 downto 16);
-- sb_dl_i(1) <= dl_iq3(1)(15 downto 0);
-- sb_dl_q(1) <= dl_iq3(1)(31 downto 16);
-- sb_dl_i(2) <= dl_iq3(2)(15 downto 0);
-- sb_dl_q(2) <= dl_iq3(2)(31 downto 16);
-- sb_dl_i(3) <= dl_iq3(3)(15 downto 0);
-- sb_dl_q(3) <= dl_iq3(3)(31 downto 16);

data_sync_dl <= dl_iq_sync(0) when master_lane_ind = '0' else dl_iq_sync(2);

dl_iq_sw : entity work.din_iq_sw
port map(
   clk_368p64             => dspclk_368p64,
   data_sync              => data_sync_dl,--dl_iq_sync(0),
   clk_122p88             => clk_122p88              , --: in  std_logic;
   clk_100                => clk_100                 , --: in  std_logic;
   axi_clk                => clk_61p44               , --: in  std_logic;
   rst                    => cpri_rst                , --: in  std_logic;
   cpri_linkup            => cpri_linkup(1 downto 0) , --: in  std_logic_vector(cpri_num downto 0);
   din_i0                 => dl_i0                   , --: in  arr_4_16_stdlogic;
   din_q0                 => dl_q0                   , --: in  arr_4_16_stdlogic;
   din_i1                 => dl_i1                   , --: in  arr_4_16_stdlogic;
   din_q1                 => dl_q1                   , --: in  arr_4_16_stdlogic;
   din_i2                 => dl_i2                   , --: in  arr_4_16_stdlogic;
   din_q2                 => dl_q2                   , --: in  arr_4_16_stdlogic;
   din_i3                 => dl_i3                   , --: in  arr_4_16_stdlogic;
   din_q3                 => dl_q3                   , --: in  arr_4_16_stdlogic;
   op_id0                 => op_id0                  , --: in  arr_2_6_stdlogic;
   op_id1                 => op_id1                  , --: in  arr_2_6_stdlogic;
--   cp                     => cp,
   dcm_dout_i             => dcm_dl_i                , --: out arr_4_16_stdlogic;
   dcm_dout_q             => dcm_dl_q                , --: out arr_4_16_stdlogic;
   kddi_dout_i            => kddi_dl_i               , --: out arr_4_16_stdlogic;
   kddi_dout_q            => kddi_dl_q               , --: out arr_4_16_stdlogic;
   rm_dout_i              => rm_dl_i                 , --: out arr_4_16_stdlogic;
   rm_dout_q              => rm_dl_q                 , --: out arr_4_16_stdlogic;
   sb_dout_i              => sb_dl_i                 , --: out arr_4_16_stdlogic;
   sb_dout_q              => sb_dl_q                 ); --: out arr_4_16_stdlogic

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (cpri_linkup(0)= '1') then
        dl_ref_10m <= tdd_sync_dly(0);
	
        -- tdd_valid <= tdd_valid_s(0);
    elsif(cpri_linkup(1)= '1') then
        dl_ref_10m <= tdd_sync_dly(1);
	
        -- tdd_valid <= tdd_valid_s(1);
    else
        dl_ref_10m <= '0';
	
        -- tdd_valid <= '0';
    end if;
end if;
end process;

UL_REF_10M_DLY_BANK : for n in 0 to 1 generate

Inst_ul_ref_10m_dly : entity work.shift_total_5us
PORT MAP(
A     =>  ul_ref_10m_dly_val(n),--: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
D     =>  ul_ref_10m_dly(n)    ,--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
CLK   =>  clk_122p88         ,--: IN STD_LOGIC;
CE    =>  '1'   ,--: IN STD_LOGIC;
Q     =>  ul_ref_10m(n)    --: OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
);
end generate;

tdd_gen : entity work.uq_tdd_gen
 port map(
    i_rst                => cpri_rst,
    clk                    => clk_122p88, -- // 122.88m
     clk_100m            => clk_100,
--    tdd_valid            => tdd_valid,
    tdd_mode            => tdd_mode,
    tick_10ms            => dl_ref_10m,
    dl_slt_num1            => dl_slt_num1,
    dl_sym_num1            => dl_sym_num1,
    ul_slt_num1            => ul_slt_num1,
    ul_sym_num1            => ul_sym_num1,
    trx_periodicity1    => trx_periodicity1, --    // 0~10ms 0.1ms step // 50 is 5ms
    patt2_onoff            => patt2_onoff, --        // '0' : On, '1' : Off
    dl_slt_num2            => dl_slt_num2,
    dl_sym_num2            => dl_sym_num2,
    ul_slt_num2            => ul_slt_num2,
    ul_sym_num2            => ul_sym_num2,
    trx_periodicity2    => trx_periodicity2, --    // 0~10ms 0.1ms step
    tdd_out             => tdd_sync_in,
    i_tsync_chk_clr     => tsync_chk_clr,
	tsync_valid           => tdd_valid
);  

-- ul_ref_gen : entity work.ul_start_ref_gen
 -- port map(
    -- clk               	=> clk_122p88, -- // 122.88m
    -- rst_n           	=> rst_n,
    -- tdd_sync            => tdd_sync_in,
    -- ul_ref            	=> ul_ref
-- );

tdd_ctrl_dl : entity work.tdd_ctrl
 port map(
    clk_122p88m       => clk_122p88     , --:  in std_logic;
    loc_clk           => clk_100        , --:  in std_logic;
    reset             => cpri_rst       , --:  in std_logic;
    tdd_sync_in       => tdd_sync_in    , --:  in std_logic;
    tdd_inv           => '0'            , --:  in std_logic;
    rising_pull       => r_pull_dl      , --:  in std_logic_vector(16 downto 0);
    rising_push       => r_push_dl      , --:  in std_logic_vector(16 downto 0);
    falling_pull      => f_pull_dl      , --:  in std_logic_vector(16 downto 0);
    falling_push      => f_push_dl      , --:  in std_logic_vector(16 downto 0);
    tdd_mode          => "00",--tdd_mode       , --:  in std_logic_vector(1 downto 0);
    tdd_sync_out      => dl_det_tsync   ); --: out std_logic

tdd_ctrl_ul : entity work.tdd_ctrl
 port map(
    clk_122p88m       => clk_122p88     , --:  in std_logic;
    loc_clk           => clk_100        , --:  in std_logic;
    reset             => cpri_rst       , --:  in std_logic;
    tdd_sync_in       => tdd_sync_in    , --:  in std_logic;
    tdd_inv           => '1'            , --:  in std_logic;
    rising_pull       => r_pull_ul      , --:  in std_logic_vector(16 downto 0);
    rising_push       => r_push_ul      , --:  in std_logic_vector(16 downto 0);
    falling_pull      => f_pull_ul      , --:  in std_logic_vector(16 downto 0);
    falling_push      => f_push_ul      , --:  in std_logic_vector(16 downto 0);
    tdd_mode          => "00",--tdd_mode       , --:  in std_logic_vector(1 downto 0);
    tdd_sync_out      => ul_det_tsync   ); --: out std_logic

tdd_ctrl_rf_dl : entity work.tdd_ctrl
 port map(
    clk_122p88m       => clk_122p88       , --:  in std_logic;
    loc_clk           => clk_100          , --:  in std_logic;
    reset             => cpri_rst         , --:  in std_logic;
    tdd_sync_in       => tdd_sync_in      , --:  in std_logic;
    tdd_inv           => '0'              , --:  in std_logic;
    rising_pull       => r_pull_dl_rf     , --:  in std_logic_vector(16 downto 0);
    rising_push       => r_push_dl_rf     , --:  in std_logic_vector(16 downto 0);
    falling_pull      => f_pull_dl_rf     , --:  in std_logic_vector(16 downto 0);
    falling_push      => f_push_dl_rf     , --:  in std_logic_vector(16 downto 0);
    tdd_mode          => tdd_mode         , --:  in std_logic_vector(1 downto 0);
    tdd_sync_out      => tdd_sync_dl      ); --: out std_logic

process(clk_100)
begin
if rising_edge(clk_100) then
	case(tdd_mon_sel) is
		when x"0"      => TDD_MON    <= tdd_sync_dl;
		when x"1"      => TDD_MON    <= tdd_sync_ul;
		when x"2"      => TDD_MON    <= dl_ref_10m_s(0);--mxl_fb_sw(0);
		 when x"3"      => TDD_MON    <= dl_ref_10m_s(1);
		-- when x"4" 	   => TDD_MON	 <= fb_sw(0);
		-- when x"5"      => TDD_MON	 <= fb_sw(1);
		when others    => TDD_MON    <= tdd_sync_dl;
	end case;
end if;
end process;

tdd_ctrl_rf_ul : entity work.tdd_ctrl
 port map(
    clk_122p88m       => clk_122p88       , --:  in std_logic;
    loc_clk           => clk_100          , --:  in std_logic;
    reset             => cpri_rst         , --:  in std_logic;
    tdd_sync_in       => tdd_sync_in      , --:  in std_logic;
    tdd_inv           => '1'              , --:  in std_logic;
    rising_pull       => r_pull_ul_rf     , --:  in std_logic_vector(16 downto 0);
    rising_push       => r_push_ul_rf     , --:  in std_logic_vector(16 downto 0);
    falling_pull      => f_pull_ul_rf     , --:  in std_logic_vector(16 downto 0);
    falling_push      => f_push_ul_rf     , --:  in std_logic_vector(16 downto 0);
    tdd_mode          => tdd_mode         , --:  in std_logic_vector(1 downto 0);
    tdd_sync_out      => tdd_sync_ul      ); --: out std_logic

rssi_alm_ctrl : entity work.tdd_ctrl
 port map(
    clk_122p88m       => clk_122p88       , --:  in std_logic;
    loc_clk           => clk_100          , --:  in std_logic;
    reset             => cpri_rst         , --:  in std_logic;
    tdd_sync_in       => tdd_sync_in      , --:  in std_logic;
    tdd_inv           => '1'              , --:  in std_logic;
    rising_pull       => r_pull_ul_rssi   , --:  in std_logic_vector(16 downto 0);
    rising_push       => r_push_ul_rssi   , --:  in std_logic_vector(16 downto 0);
    falling_pull      => f_pull_ul_rssi   , --:  in std_logic_vector(16 downto 0);
    falling_push      => f_push_ul_rssi   , --:  in std_logic_vector(16 downto 0);
    tdd_mode          => tdd_mode         , --:  in std_logic_vector(1 downto 0);
    tdd_sync_out      => tdd_sync_rssi      ); --: out std_logic

l1_reset_out_s <= l1_reset_out or l1_reset_ctrl_reg;

L1_RESET_BLK : entity work.l1_reset_dly
 port map(
    clk_25m                 => fpga_25mhz               ,  --: in  std_logic;
    l1_reset_in             => l1_reset_out_s           ,  --: in  std_logic;
    l1_reset_out            => l1_reset                 ); --: out std_logic

    l1_reset_reg <= l1_reset_out;

    cfr_axi_awaddr_s <= x"000" & "00" & cfr_axi_awaddr(17 downto 0);
    cfr_axi_araddr_s <= x"000" & "00" & cfr_axi_araddr(17 downto 0);
	
	mapper_rst_n <= link_chg_rst_n;--not (mapper_reset(0) or mapper_reset(1));
	
	pow_en_sync(0) <= pow_en_fb(0) or (not fb_in_tready);
	pow_en_sync(1) <= pow_en_fb(1) or (not fb_in_tready);
	pow_en_sync(2) <= pow_en_fb(2) or (not fb_in_tready);
	pow_en_sync(3) <= pow_en_fb(3) or (not fb_in_tready);

dl_path: entity work.dl_path_n77_100m
port map
(
    clk_491p52              => clk_491p52         , --: in  std_logic;
    clk_122p88              => clk_122p88         , --: in  std_logic;
    clk_61p44               => clk_61p44          , --: in  std_logic;
    clk_100                 => clk_100            , --: in  std_logic;
    rst_n                   => mapper_rst_n,--rst_n              , --: in  std_logic;
    tsync_dly_in            => dl_ref_10m_s           , --: in  std_logic_vector(1 downto 0);
    tsync_dly_out           => tdd_sync_dly       , --: out std_logic_vector(1 downto 0);
    tdd_sync                => dl_det_tsync       , --: in  std_logic;
    delay_dcm_01            => dl_dly_dcm_01      , --: in  std_logic_vector(13 downto 0);
    delay_dcm_23            => dl_dly_dcm_23      , --: in  std_logic_vector(13 downto 0);
    delay_kddi_01           => dl_dly_kddi_01     , --: in  std_logic_vector(13 downto 0);
    delay_kddi_23           => dl_dly_kddi_23     , --: in  std_logic_vector(13 downto 0);
    delay_rm_01             => dl_dly_rm_01       , --: in  std_logic_vector(13 downto 0);
    delay_rm_23             => dl_dly_rm_23       , --: in  std_logic_vector(13 downto 0);
    delay_sb_01             => dl_dly_sb_01       , --: in  std_logic_vector(13 downto 0);
    delay_sb_23             => dl_dly_sb_23       , --: in  std_logic_vector(13 downto 0);
	peak_sel                => peak_sel           , --: in  std_logic;
	pow_en_fb			=> pow_en_sync,--pow_en_fb,
	fa_det_threshold        => fa_det_threshold, --: in std_logic_vector(31 downto 0);
	fa_detect	 			=> fa_detect, --: out  arr_4_4_stdlogic;
    dcm_din_i               => dcm_dl_i           , --: in  arr_4_16_stdlogic;
    dcm_din_q               => dcm_dl_q           , --: in  arr_4_16_stdlogic;
    dcm_in_pow              => dcm_dl_pow         , --: in  arr_4_32_stdlogic;
    dcm_in_peak             => dcm_dl_peak        , --: in  arr_4_32_stdlogic;
    dcm_path_en             => dcm_dl_path_en     , --: in  std_logic_vector(MIMO_NUM downto 0);
    dcm_input_gain          => dcm_input_gain     , --: in  arr_4_16_stdlogic;
    dcm_slope               => dcm_dl_slope       , --: in  arr_4_16_stdlogic;
    dcm_curve               => dcm_dl_curve       , --: in  arr_4_16_stdlogic;
    kddi_din_i              => kddi_dl_i          , --: in  arr_mimo_16_stdlogic;
    kddi_din_q              => kddi_dl_q          , --: in  arr_mimo_16_stdlogic;
    kddi_in_pow             => kddi_dl_pow        , --: in  arr_4_32_stdlogic;
    kddi_in_peak            => kddi_dl_peak       , --: in  arr_4_32_stdlogic;
    kddi_path_en            => kddi_dl_path_en    , --: in  std_logic_vector(MIMO_NUM downto 0);
    kddi_input_gain         => kddi_input_gain    , --: in  arr_4_16_stdlogic
    kddi_slope              => kddi_dl_slope      , --: in  arr_4_16_stdlogic;
    kddi_curve              => kddi_dl_curve      , --: in  arr_4_16_stdlogic;
    rm_din_i                => rm_dl_i            , --: in  arr_mimo_16_stdlogic;
    rm_din_q                => rm_dl_q            , --: in  arr_mimo_16_stdlogic;
    rm_in_pow               => rm_dl_pow          , --: in  arr_4_32_stdlogic;
    rm_in_peak              => rm_dl_peak         , --: in  arr_4_32_stdlogic;
    rm_path_en              => rm_dl_path_en      , --: in  std_logic_vector(MIMO_NUM downto 0);
    rm_input_gain           => rm_input_gain      , --: in  arr_4_16_stdlogic
    rm_slope                => rm_dl_slope        , --: in  arr_4_16_stdlogic;
    rm_curve                => rm_dl_curve        , --: in  arr_4_16_stdlogic;
    sum_power               => dl_sum_pow         , --: out arr_4_32_stdlogic;
    sum_peak                => dl_sum_peak        , --: out arr_4_32_stdlogic;
    sb_din_i                => sb_dl_i            , --: in  arr_mimo_16_stdlogic;
    sb_din_q                => sb_dl_q            , --: in  arr_mimo_16_stdlogic;
    sb_in_pow               => sb_dl_pow          , --: in  arr_4_32_stdlogic;
    sb_in_peak              => sb_dl_peak         , --: in  arr_4_32_stdlogic;
    sb_path_en              => sb_dl_path_en      , --: in  std_logic_vector(MIMO_NUM downto 0);
    sb_input_gain           => sb_input_gain      , --: in  arr_4_16_stdlogic;
    sb_slope                => sb_dl_slope        , --: in  arr_4_16_stdlogic;
    sb_curve                => sb_dl_curve        , --: in  arr_4_16_stdlogic;
    axi_rst_n               => axi_rst_n          , --: in  std_logic;
    axi_cfr_awvalid         => cfr_axi_awvalid    , --: in  std_logic;
    axi_cfr_awready         => cfr_axi_awready    , --: out std_logic;
    axi_cfr_awaddr          => cfr_axi_awaddr_s     , --: in  std_logic_vector(31 downto 0);
    axi_cfr_wvalid          => cfr_axi_wvalid     , --: in  std_logic;
    axi_cfr_wready          => cfr_axi_wready     , --: out std_logic;
    axi_wdata               => cfr_axi_wdata      , --: in  std_logic_vector(31 downto 0);
    axi_cfr_bvalid          => cfr_axi_bvalid     , --: out std_logic;
    axi_bready              => cfr_axi_bready     , --: in  std_logic;
    axi_bresp               => cfr_axi_bresp      , --: out std_logic_vector(1 downto 0);
    axi_cfr_araddr          => cfr_axi_araddr_s     , --: in  std_logic_vector(31 downto 0);
    axi_cfr_arvalid         => cfr_axi_arvalid    , --: in  std_logic;
    axi_cfr_aready          => cfr_axi_arready    , --: out std_logic;
    axi_cfr_rvalid          => cfr_axi_rvalid     , --: out std_logic;
    axi_rready              => cfr_axi_rready     , --: in  std_logic;
    axi_rresp               => cfr_axi_rresp      , --: out std_logic_vector(1 downto 0);
    axi_cfr_rdata           => cfr_axi_rdata      , --: out std_logic_vector(31 downto 0);
    dpd_gain                => dpd_gain           , --: in  arr_4_16_stdlogic;
    dpd_in_rdy              => DPD_IN_tready      , --: in  std_logic;
    dpd_in                  => DPD_IN_tdata       , --: out std_logic_vector(255 downto 0);
    dpd_in_valid            => DPD_IN_tvalid      , --: out std_logic;
    dpd_out_rdy             => DPD_OUT_tready     , --: out std_logic;
    dpd_out_valid           => DPD_OUT_tvalid     , --: in  std_logic;
    dpd_out                 => DPD_OUT_tdata      , --: in  std_logic_vector(255 downto 0);
    output_gain             => dl_out_gain        , --: in  arr_4_16_stdlogic;
    pow_sel                 => pow_sel            , --: in  std_logic_vector( 1 downto 0);
    out_power               => dl_out_pow         , --: out arr_4_32_stdlogic;
    out_peak                => dl_out_peak        , --: out arr_4_32_stdlogic;
    dout_s0_i               => dl_out_s0_i        , --: out arr_4_16_stdlogic;
    dout_s0_q               => dl_out_s0_q        , --: out arr_4_16_stdlogic;
    dout_s1_i               => dl_out_s1_i        , --: out arr_4_16_stdlogic;
    dout_s1_q               => dl_out_s1_q       ); --: out arr_4_16_stdlogic

fb_ctrl_blk : entity work.fb_ctrl
generic map(
    clock_frequency         => 491_520          )   --system clock frequency in khz 61_440, 122_880, 245_760, 491_520
port map(
    clk                     => clk_491p52       , --: in  std_logic;
    loc_clk                 => clk_100          , --: in  std_logic;
    clk_122p88              => clk_122p88       , --: in  std_logic;
    clk_61p44               => clk_61p44        , --: in  std_logic;
    --rst                     => dpd_rst          , --: in  std_logic;
    rst_n                   => mapper_rst_n,--dpd_rst_n,--
    tdd_sync                => dl_det_tsync     , --: in  std_logic;
    srx_ctrl_tready         => SRX_CTRL_tready  , --: out std_logic;
    srx_ctrl_tvalid         => srx_ctrl_tvalid  , --: in  std_logic;
    srx_ctrl_tdata          => srx_ctrl_tdata   , --: in  std_logic_vector(7 downto 0);
    mxl_fb_sw               => mxl_fb_sw        , --: in  std_logic_vector(1 downto 0);
    fb_ona                  => fb_ona           , --: in  std_logic;
    fb_sw_dly               => fb_sw_dly        , --: in  std_logic_vector(10 downto 0);
    fb_sw                   => fb_sw            , --: out std_logic_vector(1 downto 0);
	fb_sw_cnt_out			=> fb_sw_cnt_out	, --: out std_logic_vector(23 downto 0);
	fb_in_gain				=> fb_in_gain		, --: in  std_logic_vector(15 downto 0);
    fb0_i_s0                => fb0_i_s0         , --: in  std_logic_vector(15 downto 0);
    fb0_i_s1                => fb0_i_s1         , --: in  std_logic_vector(15 downto 0);
    fb0_q_s0                => fb0_q_s0         , --: in  std_logic_vector(15 downto 0);
    fb0_q_s1                => fb0_q_s1         , --: in  std_logic_vector(15 downto 0);
    fb1_i_s0                => fb1_i_s0         , --: in  std_logic_vector(15 downto 0);
    fb1_i_s1                => fb1_i_s1         , --: in  std_logic_vector(15 downto 0);
    fb1_q_s0                => fb1_q_s0         , --: in  std_logic_vector(15 downto 0);
    fb1_q_s1                => fb1_q_s1         , --: in  std_logic_vector(15 downto 0);
    fb_in_tready            => fb_in_tready     , --: in  std_logic;
    fb_in_tdata             => fb_in_tdata      , --: out std_logic_vector(63 downto 0);
    fb_in_tuser             => fb_in_tuser      , --: out std_logic_vector(7 downto 0);
    fb_in_tvalid            => fb_in_tvalid     , --: out std_logic
    fb_valid                => fb_valid,
	pow_en_fb			=> pow_en_fb,
	peak_sel                => peak_sel         , --: in  std_logic;
    fb_pow                  => fb_pow           , --: out arr_4_32_stdlogic;
    fb_peak                 => fb_peak          ); --: out arr_4_32_stdlogic

jesd_blk : entity work.jesd_8tx_8rx_iq
port map(
    axi_aresetn             => axi_rst_n                       , --: in  std_logic;
    reset_n                 => rst_n                           , --: in  std_logic;
    gt_powergood            => gt_powergood                    , --: out std_logic;
    ref_clk                 => jesd_ref_clk                    , --: in  std_logic;
    -- clk_100                 => clk_100                         , --: in  std_logic;
    tx_core_clk             => clk_245p76                      , --: in  std_logic; --245.76Mhz
    rx_core_clk             => clk_245p76                      , --: in  std_logic; --245.76Mhz
    clk_491p52              => clk_491p52                      , --: in  std_logic; --491.52Mhz
    drpclk                  => clk_61p44                       , --: in  std_logic;
    tx_sysref               => jesd_sysref                     , --: in  std_logic;
    rx_sysref               => jesd_sysref                     , --: in  std_logic;
    meta_mode               => "00"                            , --: in  std_logic_vector(1 downto 0);
    jesd_qpll_lock          => jesd_qpll_lock                  , --: out std_logic;
    jesd_irq                => jesd_irq                        , --: out std_logic_vector(1 downto 0);
    adc0_i                  => adc0_i                          , --: out std_logic_vector( 15 downto 0);
    adc0_q                  => adc0_q                          , --: out std_logic_vector( 15 downto 0);
    adc1_i                  => adc1_i                          , --: out std_logic_vector( 15 downto 0);
    adc1_q                  => adc1_q                          , --: out std_logic_vector( 15 downto 0);
    adc2_i                  => adc2_i                          , --: out std_logic_vector( 15 downto 0);
    adc2_q                  => adc2_q                          , --: out std_logic_vector( 15 downto 0);
    adc3_i                  => adc3_i                          , --: out std_logic_vector( 15 downto 0);
    adc3_q                  => adc3_q                          , --: out std_logic_vector( 15 downto 0);
    fb0_i_s0                => fb0_i_s0                        , --: out std_logic_vector( 15 downto 0);
    fb0_q_s0                => fb0_q_s0                        , --: out std_logic_vector( 15 downto 0);
    fb0_i_s1                => fb0_i_s1                        , --: out std_logic_vector( 15 downto 0);
    fb0_q_s1                => fb0_q_s1                        , --: out std_logic_vector( 15 downto 0);
    fb1_i_s0                => fb1_i_s0                        , --: out std_logic_vector( 15 downto 0);
    fb1_q_s0                => fb1_q_s0                        , --: out std_logic_vector( 15 downto 0);
    fb1_i_s1                => fb1_i_s1                        , --: out std_logic_vector( 15 downto 0);
    fb1_q_s1                => fb1_q_s1                        , --: out std_logic_vector( 15 downto 0);
    dac_i_s0               => dl_out_s0_i                  , --: in  std_logic_vector( 15 downto 0);
    dac_q_s0               => dl_out_s0_q                  , --: in  std_logic_vector( 15 downto 0);
    dac_i_s1               => dl_out_s1_i                  , --: in  std_logic_vector( 15 downto 0);
    dac_q_s1               => dl_out_s1_q                  , --: in  std_logic_vector( 15 downto 0);
    txp                     => jesd_tx_p                       , --: out std_logic_vector( 7 downto 0);
    txn                     => jesd_tx_n                       , --: out std_logic_vector( 7 downto 0);
    rxp                     => jesd_rx_p                       , --: in  std_logic_vector( 7 downto 0);
    rxn                     => jesd_rx_n                       , --: in  std_logic_vector( 7 downto 0);
    axi_clk                 => clk_61p44                       , --: in  std_logic;
    rx_axi_awaddr           => jesd_rx_axi_awaddr(11 downto 0) , --: in  std_logic_vector( 11 downto 0);
    rx_axi_wdata            => jesd_rx_axi_wdata               , --: in  std_logic_vector( 31 downto 0);
    rx_axi_araddr           => jesd_rx_axi_araddr(11 downto 0) , --: in  std_logic_vector( 11 downto 0);
    rx_axi_awvalid          => jesd_rx_axi_awvalid             , --: in  std_logic;
    rx_axi_awready          => jesd_rx_axi_awready             , --: out std_logic;
    rx_axi_wvalid           => jesd_rx_axi_wvalid              , --: in  std_logic;
    rx_axi_wready           => jesd_rx_axi_wready              , --: out std_logic;
    rx_axi_bready           => jesd_rx_axi_bready              , --: in  std_logic;
    rx_axi_bresp            => jesd_rx_axi_bresp               , --: out std_logic_vector(1 downto 0);
    rx_axi_bvalid           => jesd_rx_axi_bvalid              , --: out std_logic;
    rx_axi_arvalid          => jesd_rx_axi_arvalid             , --: in  std_logic;
    rx_axi_arready          => jesd_rx_axi_arready             , --: out std_logic;
    rx_axi_rdata            => jesd_rx_axi_rdata               , --: out std_logic_vector( 31 downto 0);
    rx_axi_rvalid           => jesd_rx_axi_rvalid              , --: out std_logic;
    rx_axi_rready           => jesd_rx_axi_rready              , --: in  std_logic;
    rx_axi_rresp            => jesd_rx_axi_rresp               , --: out std_logic_vector(1 downto 0);
    tx_axi_awaddr           => jesd_tx_axi_awaddr(11 downto 0) , --: in  std_logic_vector( 11 downto 0);
    tx_axi_wdata            => jesd_tx_axi_wdata               , --: in  std_logic_vector( 31 downto 0);
    tx_axi_araddr           => jesd_tx_axi_araddr(11 downto 0) , --: in  std_logic_vector( 11 downto 0);
    tx_axi_awvalid          => jesd_tx_axi_awvalid             , --: in  std_logic;
    tx_axi_awready          => jesd_tx_axi_awready             , --: out std_logic;
    tx_axi_wvalid           => jesd_tx_axi_wvalid              , --: in  std_logic;
    tx_axi_wready           => jesd_tx_axi_wready              , --: out std_logic;
    tx_axi_bready           => jesd_tx_axi_bready              , --: in  std_logic;
    tx_axi_bresp            => jesd_tx_axi_bresp               , --: out std_logic_vector(1 downto 0);
    tx_axi_bvalid           => jesd_tx_axi_bvalid              , --: out std_logic;
    tx_axi_arvalid          => jesd_tx_axi_arvalid             , --: in  std_logic;
    tx_axi_arready          => jesd_tx_axi_arready             , --: out std_logic;
    tx_axi_rdata            => jesd_tx_axi_rdata               , --: out std_logic_vector( 31 downto 0);
    tx_axi_rvalid           => jesd_tx_axi_rvalid              , --: out std_logic;
    tx_axi_rready           => jesd_tx_axi_rready              , --: in  std_logic;
    tx_axi_rresp            => jesd_tx_axi_rresp               , --: out std_logic_vector(1 downto 0);
    txdiffctrl              => jesd_tx_diff_ctrl               , --: in  std_logic_vector( 4 downto 0);
    cw_data                 => cw_data                         , --: in  std_logic_vector(15 downto 0);
    rfic_loop               => rfic_loop                       ); --: in  std_logic_vector( 1 downto 0)

ul_in_i(0)    <= adc0_i;
ul_in_q(0)    <= adc0_q;
ul_in_i(1)    <= adc1_i;
ul_in_q(1)    <= adc1_q;
ul_in_i(2)    <= adc2_i;
ul_in_q(2)    <= adc2_q;
ul_in_i(3)    <= adc3_i;
ul_in_q(3)    <= adc3_q;

ul_path : entity work.ul_path_n77_100m
port map
(
    clk_491p52              => clk_491p52       , --: in  std_logic;
    clk_368p64              => dspclk_368p64       , --: in  std_logic;		
    clk_122p88              => clk_122p88       , --: in  std_logic;
    clk_61p44               => clk_61p44        , --: in  std_logic;
    rst_n                   => mapper_rst_n,--rst_n            , --: in  std_logic;
    tdd_sync                => ul_det_tsync     , --: in  std_logic;
	tsync_dly_in            => dl_ref_10m_s     ,
    tsync_dly_out           => ul_ref_10m_dly   ,
    din_i                   => ul_in_i          , --: in  arr_4_16_stdlogic;
    din_q                   => ul_in_q          , --: in  arr_4_16_stdlogic;
    in_power                => ul_in_pow        , --: in  arr_4_32_stdlogic;
    in_peak                 => ul_in_peak       , --: in  arr_4_32_stdlogic;
    input_gain              => ul_in_gain       , --: in  arr_4_16_stdlogic;
    dc_path_en              => dcm_ul_path_en   , --: in  arr_mimo_16_stdlogic;
    dc_output_gain          => dcm_output_gain  , --: in  arr_4_16_stdlogic;
    dc_out_pow              => dcm_ul_pow       , --: out arr_4_32_stdlogic;
    dc_out_peak             => dcm_ul_peak      , --: out arr_4_32_stdlogic;
    dc_dout_i               => dc_dout_i       , --: out arr_4_16_stdlogic;
    dc_dout_q               => dc_dout_q       , --: out arr_4_16_stdlogic;
    kd_path_en              => kddi_ul_path_en  , --: in  arr_mimo_16_stdlogic;
    kd_output_gain          => kddi_output_gain , --: in  arr_4_16_stdlogic;
    kd_out_pow              => kddi_ul_pow      , --: out arr_4_32_stdlogic;
    kd_out_peak             => kddi_ul_peak     , --: out arr_4_32_stdlogic;
    kd_dout_i               => kd_dout_i      , --: out arr_4_16_stdlogic;
    kd_dout_q               => kd_dout_q      , --: out arr_4_16_stdlogic;
    rm_path_en              => rm_ul_path_en    , --: in  arr_mimo_16_stdlogic;
    rm_output_gain          => rm_output_gain   , --: in  arr_4_16_stdlogic;
    rm_out_pow              => rm_ul_pow        , --: out arr_4_32_stdlogic;
    rm_out_peak             => rm_ul_peak       , --: out arr_4_32_stdlogic;
    rm_dout_i               => rm_dout_i        , --: out arr_4_16_stdlogic;
    rm_dout_q               => rm_dout_q        , --: out arr_4_16_stdlogic;
    sb_path_en              => sb_ul_path_en    , --: in  arr_mimo_16_stdlogic;
    sb_output_gain          => sb_output_gain   , --: in  arr_4_16_stdlogic;
    sb_out_pow              => sb_ul_pow        , --: out arr_4_32_stdlogic;
    sb_out_peak             => sb_ul_peak       , --: out arr_4_32_stdlogic;
    sb_dout_i               => sb_dout_i        , --: out arr_4_16_stdlogic;
    sb_dout_q               => sb_dout_q        , --: out arr_4_16_stdlogic;
    delay_dc_01             => ul_dly_dcm_01    , --: in  std_logic_vector(13 downto 0);
    delay_dc_23             => ul_dly_dcm_23    , --: in  std_logic_vector(13 downto 0);
    delay_kd_01             => ul_dly_kddi_01   , --: in  std_logic_vector(13 downto 0);
    delay_kd_23             => ul_dly_kddi_23   , --: in  std_logic_vector(13 downto 0);
    delay_rm_01             => ul_dly_rm_01     , --: in  std_logic_vector(13 downto 0);
    delay_rm_23             => ul_dly_rm_23     , --: in  std_logic_vector(13 downto 0);
    delay_sb_01             => ul_dly_sb_01     , --: in  std_logic_vector(13 downto 0);
    delay_sb_23             => ul_dly_sb_23     ,
    ul_iq_sync              => ul_iq_sync); --: in  std_logic_vector(13 downto 0);

ul_iq_sw : entity work.dout_iq_sw
port map(
   clk_368p64          => dspclk_368p64,
   data_sync          => ul_iq_sync,
   clk_122p88          => clk_122p88              , --: in  std_logic;
   clk_100             => clk_100                 , --: in  std_logic;
    axi_clk             => clk_61p44               , --: in  std_logic;
   rst                 => cpri_rst                , --: in  std_logic;
   cpri_linkup         => cpri_linkup(1 downto 0) , --: in  std_logic_vector(1 downto 0);
   dcm_din_i           => dc_dout_i               , --: in  arr_4_16_stdlogic;
   dcm_din_q           => dc_dout_q               , --: in  arr_4_16_stdlogic;
   kddi_din_i          => kd_dout_i              , --: in  arr_4_16_stdlogic;
   kddi_din_q          => kd_dout_q              , --: in  arr_4_16_stdlogic;
   rm_din_i            => rm_dout_i                , --: in  arr_4_16_stdlogic;
   rm_din_q            => rm_dout_q                , --: in  arr_4_16_stdlogic;
   sb_din_i            => sb_dout_i                , --: in  arr_4_16_stdlogic;
   sb_din_q            => sb_dout_q                , --: in  arr_4_16_stdlogic;
   op_id0              => op_id0                  , --: in  arr_2_6_stdlogic;
   op_id1              => op_id1                  , --: in  arr_2_6_stdlogic;
   dout_i0             => ul_i0                   , --: out arr_4_16_stdlogic;
   dout_q0             => ul_q0                   , --: out arr_4_16_stdlogic;
   dout_i1             => ul_i1                   , --: out arr_4_16_stdlogic;
   dout_q1             => ul_q1                   , --: out arr_4_16_stdlogic;
   dout_i2             => ul_i2                   , --: out arr_4_16_stdlogic;
   dout_q2             => ul_q2                   , --: out arr_4_16_stdlogic;
   dout_i3             => ul_i3                   , --: out arr_4_16_stdlogic;
   dout_q3             => ul_q3                   ); --: out arr_4_16_stdlogic

dcm_dout_iq(0)(15 downto 0)  <= ul_i0(0);
dcm_dout_iq(0)(31 downto 16) <= ul_q0(0);
dcm_dout_iq(1)(15 downto 0)  <= ul_i0(1);
dcm_dout_iq(1)(31 downto 16) <= ul_q0(1);
dcm_dout_iq(2)(15 downto 0)  <= ul_i0(2);
dcm_dout_iq(2)(31 downto 16) <= ul_q0(2);
dcm_dout_iq(3)(15 downto 0)  <= ul_i0(3);
dcm_dout_iq(3)(31 downto 16) <= ul_q0(3);

kddi_dout_iq(0)(15 downto 0)  <= ul_i1(0);
kddi_dout_iq(0)(31 downto 16) <= ul_q1(0);
kddi_dout_iq(1)(15 downto 0)  <= ul_i1(1);
kddi_dout_iq(1)(31 downto 16) <= ul_q1(1);
kddi_dout_iq(2)(15 downto 0)  <= ul_i1(2);
kddi_dout_iq(2)(31 downto 16) <= ul_q1(2);
kddi_dout_iq(3)(15 downto 0)  <= ul_i1(3);
kddi_dout_iq(3)(31 downto 16) <= ul_q1(3);

rm_dout_iq(0)(15 downto 0)  <= ul_i2(0);
rm_dout_iq(0)(31 downto 16) <= ul_q2(0);
rm_dout_iq(1)(15 downto 0)  <= ul_i2(1);
rm_dout_iq(1)(31 downto 16) <= ul_q2(1);
rm_dout_iq(2)(15 downto 0)  <= ul_i2(2);
rm_dout_iq(2)(31 downto 16) <= ul_q2(2);
rm_dout_iq(3)(15 downto 0)  <= ul_i2(3);
rm_dout_iq(3)(31 downto 16) <= ul_q2(3);

sb_dout_iq(0)(15 downto 0)  <= ul_i3(0);
sb_dout_iq(0)(31 downto 16) <= ul_q3(0);
sb_dout_iq(1)(15 downto 0)  <= ul_i3(1);
sb_dout_iq(1)(31 downto 16) <= ul_q3(1);
sb_dout_iq(2)(15 downto 0)  <= ul_i3(2);
sb_dout_iq(2)(31 downto 16) <= ul_q3(2);
sb_dout_iq(3)(15 downto 0)  <= ul_i3(3);
sb_dout_iq(3)(31 downto 16) <= ul_q3(3);

-- dcm_dout_iq(0)(15 downto 0)  <= dc_dout_i(0);
-- dcm_dout_iq(0)(31 downto 16) <= dc_dout_q(0);
-- dcm_dout_iq(1)(15 downto 0)  <= dc_dout_i(1);
-- dcm_dout_iq(1)(31 downto 16) <= dc_dout_q(1);
-- dcm_dout_iq(2)(15 downto 0)  <= dc_dout_i(2);
-- dcm_dout_iq(2)(31 downto 16) <= dc_dout_q(2);
-- dcm_dout_iq(3)(15 downto 0)  <= dc_dout_i(3);
-- dcm_dout_iq(3)(31 downto 16) <= dc_dout_q(3);

-- kddi_dout_iq(0)(15 downto 0)  <= kd_dout_i(0);
-- kddi_dout_iq(0)(31 downto 16) <= kd_dout_q(0);
-- kddi_dout_iq(1)(15 downto 0)  <= kd_dout_i(1);
-- kddi_dout_iq(1)(31 downto 16) <= kd_dout_q(1);
-- kddi_dout_iq(2)(15 downto 0)  <= kd_dout_i(2);
-- kddi_dout_iq(2)(31 downto 16) <= kd_dout_q(2);
-- kddi_dout_iq(3)(15 downto 0)  <= kd_dout_i(3);
-- kddi_dout_iq(3)(31 downto 16) <= kd_dout_q(3);

-- rm_dout_iq(0)(15 downto 0)  <= rm_dout_i(0);
-- rm_dout_iq(0)(31 downto 16) <= rm_dout_q(0);
-- rm_dout_iq(1)(15 downto 0)  <= rm_dout_i(1);
-- rm_dout_iq(1)(31 downto 16) <= rm_dout_q(1);
-- rm_dout_iq(2)(15 downto 0)  <= rm_dout_i(2);
-- rm_dout_iq(2)(31 downto 16) <= rm_dout_q(2);
-- rm_dout_iq(3)(15 downto 0)  <= rm_dout_i(3);
-- rm_dout_iq(3)(31 downto 16) <= rm_dout_q(3);

-- sb_dout_iq(0)(15 downto 0)  <= sb_dout_i(0);
-- sb_dout_iq(0)(31 downto 16) <= sb_dout_q(0);
-- sb_dout_iq(1)(15 downto 0)  <= sb_dout_i(1);
-- sb_dout_iq(1)(31 downto 16) <= sb_dout_q(1);
-- sb_dout_iq(2)(15 downto 0)  <= sb_dout_i(2);
-- sb_dout_iq(2)(31 downto 16) <= sb_dout_q(2);
-- sb_dout_iq(3)(15 downto 0)  <= sb_dout_i(3);
-- sb_dout_iq(3)(31 downto 16) <= sb_dout_q(3);

mxl_fbrx_cal <= mxl_fbrx_cal_s;
mxl_fb_en <= mxl_fb_en_s;

mxl_tx_en_reg_s <= mxl_tx_en_reg when optic_sw_reg = '1' else "0000";

mxl_ctrl_blk : entity work.mxl_ctrl
port map(
    clk_122p88              => clk_122p88       , --: in  std_logic; --122.88mhz
    loc_clk                 => clk_100          , --: in  std_logic;
    rst                     => cpri_rst         , --: in  std_logic;
    tdd_sync_dl             => tdd_sync_dl      , --: in  std_logic;
    tdd_sync_ul             => tdd_sync_ul      , --: in  std_logic;
    tx_en                   => mxl_tx_en_reg_s    , --: in  std_logic_vector(3 downto 0);
    rx_en                   => mxl_rx_en_reg    , --: in  std_logic_vector(3 downto 0);
    tdd_mode                => tdd_mode         , --: in  std_logic_vector(1 downto 0);
    cal_mode                => cal_mode         , --: in  std_logic_vector(1 downto 0);
    fbsel_mode              => fbsel_mode       , --: in  std_logic_vector(1 downto 0);
    bg_cal_duration         => bg_cal_duration  ,
    mxl_tx_en               => mxl_tx_en_s        , --: out std_logic_vector(3 downto 0);
    mxl_rx_en               => mxl_rx_en        , --: out std_logic_vector(3 downto 0);
    mxl_fb_en               => mxl_fb_en_s        , --: out std_logic_vector(1 downto 0);
    mxl_fbrx_cal            => mxl_fbrx_cal_s     , --: out std_logic;
    mxl_fb_sw               => mxl_fb_sw        , --: out std_logic_vector(1 downto 0);
	xdpd_rfs				=> xdpd_rfs,
	tdd_sync_dl_sync		=> tdd_sync_dl_sync,
	fa_detect				=> fa_detect,
    fb_ona                  => fb_ona           ); --: out std_logic


  MXL_RXFB0_ID0 <= mxl_fb_sw(0);
  MXL_RXFB1_ID0 <= mxl_fb_sw(1);

mxl_tx_en <= mxl_tx_en_s;


mxl_gain_blk : entity work.mxl_mgain
port map(
    clk                    => clk_25          , --: in  std_logic;                    -- 25Mhz
    loc_clk                => clk_100         , --: in  std_logic;
    rst_n                  => loc_rst_n       , --: in  std_logic;
    gain_m0                => mxl_gain(0)     , --: in  std_logic_vector(4 downto 0);
    gain_m1                => mxl_gain(1)     , --: in  std_logic_vector(4 downto 0);
    gain_m2                => mxl_gain(2)     , --: in  std_logic_vector(4 downto 0);
    gain_m3                => mxl_gain(3)     , --: in  std_logic_vector(4 downto 0);
    mgain_clk              => mxl_mgain_clk   , --: out std_logic;                    -- max 30Mhz
    mgain_stb              => mxl_mgain_stb   , --: out std_logic;
    mgain_data             => mxl_mgain_data  ); --: out std_logic_vector(1 downto 0)

mxl_rssi_blk : entity work.mxl_rssi
port map(
    loc_clk                => clk_100         , --: in std_logic;
    rssi_clk               => mxl_rssi_clk    , --: in std_logic;
    rssi_stb               => mxl_rssi_stb    , --: in std_logic;
    rssi_data              => mxl_rssi_data   , --: in std_logic;
	tdd_sync_rssi	   	   => tdd_sync_rssi	  , --: in std_logic;
    peak                   => mxl_peak        , --: out std_logic_vector(3 downto 0);
    hi                     => mxl_hi          , --: out std_logic_vector(3 downto 0);
    lo                     => mxl_lo          ); --: out std_logic_vector(3 downto 0)


RFU_TEMP_SCL_BUF : IOBUF
    port map (
      IO         => RFU_TEMP_SCL   ,
      I          => scl_out(0)     ,
      O          => scl_in(0)      ,
      T          => scl_t(0)       );

RFU_TEMP_SDA_BUF : IOBUF
    port map (
      IO         => RFU_TEMP_SDA   ,
      I          => sda_out(0)     ,
      O          => sda_in(0)      ,
      T          => sda_t(0)       );


SFP_I2C_BUF : for n in 1 to 4 generate
    SFP_SCL_BUF : IOBUF
        port map (
          IO         => SFP_SCL(n-1)   ,
          I          => scl_out(n)     ,
          O          => scl_in(n)      ,
          T          => scl_t(n)       );

    SFP_SDA_BUF : IOBUF
        port map (
          IO         => SFP_SDA(n-1)   ,
          I          => sda_out(n)     ,
          O          => sda_in(n)      ,
          T          => sda_t(n)       );
end generate;


  LED_G         <= g_led_reg;
  LED_R         <= r_led_reg;


  SFP_DIS       <= sfp_disable_reg;

MXL_RST_N     <= not mxl_rst_reg;


process(clk_100)
begin
if rising_edge(clk_100) then
    if (RFU_INSERT = '0') then
            RFU_RX_EN       <= not rfu_rx_en_reg;
            RFU_TX_EN       <= rfu_tx_en_reg;
            RFU_DL_TDD_SYNC <= tdd_sync_dl;
            RFU_UL_TDD_SYNC <= tdd_sync_ul;
            RFU_ORX         <= fb_sw;
            RFU_FRS         <= '0';
            RFU_ATT_DATA    <= '0';
            RFU_ATT_CLK     <= '0';
            RFU_ATT_LE      <= "0000";
    else
        if (rfu_io_test_mode = "01") then
            RFU_RX_EN       <= "1111";
            RFU_TX_EN       <= "1111";
            RFU_DL_TDD_SYNC <= '1';
            RFU_UL_TDD_SYNC <= '1';
            RFU_ORX         <= "11";
            RFU_FRS         <= '1';
            RFU_ATT_DATA    <= '1';
            RFU_ATT_CLK     <= '1';
            RFU_ATT_LE      <= "1111";
        elsif (rfu_io_test_mode = "10") then
            RFU_RX_EN       <= test_reg(13)&test_reg(12)&test_reg(1)&test_reg(0);
            RFU_TX_EN       <= test_reg(15)&test_reg(14)&test_reg(3)&test_reg(2);
            RFU_DL_TDD_SYNC <= test_reg(8);
            RFU_UL_TDD_SYNC <= test_reg(9);
            RFU_ORX         <= test_reg(18)&test_reg(10);
            RFU_FRS         <= test_reg(11);
            RFU_ATT_DATA    <= test_reg(5);
            RFU_ATT_CLK     <= test_reg(4);
            RFU_ATT_LE      <= test_reg(17)&test_reg(16)&test_reg(7)&test_reg(6);
        else
            RFU_RX_EN       <= "0000";
            RFU_TX_EN       <= "0000";
            RFU_DL_TDD_SYNC <= '0';
            RFU_UL_TDD_SYNC <= '0';
            RFU_ORX         <= "00";
            RFU_FRS         <= '0';
            RFU_ATT_DATA    <= '0';
            RFU_ATT_CLK     <= '0';
            RFU_ATT_LE      <= "0000";
        end if;
    end if;
end if;
end process;


process(clk_25)
begin
if rising_edge(clk_25) then
    if (loc_rst_n = '0') then
        led_cnt     <= (others =>'0');
        working_led <= '1';
    else
        if (led_cnt = x"BEBC1F") then --500ms
            led_cnt     <= (others =>'0');
            working_led <= not working_led;
        else
            led_cnt     <= led_cnt + '1';
        end if;
    end if;
end if;
end process;



LED(0)  <= working_led;
LED(1)  <= working_led;
LED(2)  <= working_led;
LED(3)  <= working_led;
LED(4)  <= working_led;
LED(5)  <= working_led;
LED(6)  <= working_led;
LED(7)  <= working_led;


ONE_PPS_MON   <= ONE_PPS;
OPTIC_SW      <= optic_sw_reg;

MXL_IO1		  <= mxl_io1_reg;
MXL_CHIP_MODE <= mxl_chip_mode_reg;-- when mxl_init_reg = '0' else "ZZ";
MXL_CLK_SEL   <= mxl_clk_sel_reg;
MXL_PAP       <= mxl_pap_reg;

-- MXL_MGAIN_CLK 	<= 'Z';
-- MXL_MGAIN_STB 	<= 'Z';
-- MXL_MGAIN_DATA	<= "ZZ";

end beh;







