library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity dl_path_n77_100m is
port
(
    clk_491p52      : in  std_logic;
    clk_122p88      : in  std_logic;
    clk_61p44       : in  std_logic;
    clk_100         : in  std_logic;

    rst_n           : in  std_logic;

    tsync_dly_in    : in  std_logic_vector(1 downto 0);
    tsync_dly_out   : out std_logic_vector(1 downto 0);
    tdd_sync        : in  std_logic;

    delay_dcm_01    : in  std_logic_vector(13 downto 0);
    delay_dcm_23    : in  std_logic_vector(13 downto 0);
    delay_kddi_01   : in  std_logic_vector(13 downto 0);
    delay_kddi_23   : in  std_logic_vector(13 downto 0);
    delay_rm_01     : in  std_logic_vector(13 downto 0);
    delay_rm_23     : in  std_logic_vector(13 downto 0);
    delay_sb_01     : in  std_logic_vector(13 downto 0);
    delay_sb_23     : in  std_logic_vector(13 downto 0);
	peak_sel        : in  std_logic;
	pow_en_fb	: in  std_logic_vector(3 downto 0);
    fa_det_threshold       : in std_logic_vector(31 downto 0);
	fa_detect	 : out  arr_4_4_stdlogic;													   

    dcm_din_i       : in  arr_4_16_stdlogic;
    dcm_din_q       : in  arr_4_16_stdlogic;
    dcm_in_pow      : out arr_4_32_stdlogic;
    dcm_in_peak     : out arr_4_32_stdlogic;
    dcm_path_en     : in  std_logic_vector(3 downto 0);
    dcm_input_gain  : in  arr_4_16_stdlogic;
    dcm_slope       : in  arr_4_16_stdlogic;
    dcm_curve       : in  arr_4_16_stdlogic;

    kddi_din_i      : in  arr_4_16_stdlogic;
    kddi_din_q      : in  arr_4_16_stdlogic;
    kddi_in_pow     : out arr_4_32_stdlogic;
    kddi_in_peak    : out arr_4_32_stdlogic;
    kddi_path_en    : in  std_logic_vector(3 downto 0);
    kddi_input_gain : in  arr_4_16_stdlogic;
    kddi_slope      : in  arr_4_16_stdlogic;
    kddi_curve      : in  arr_4_16_stdlogic;

    rm_din_i        : in  arr_4_16_stdlogic;
    rm_din_q        : in  arr_4_16_stdlogic;
    rm_in_pow       : out arr_4_32_stdlogic;
    rm_in_peak      : out arr_4_32_stdlogic;
    rm_path_en      : in  std_logic_vector(3 downto 0);
    rm_input_gain   : in  arr_4_16_stdlogic;
    rm_slope        : in  arr_4_16_stdlogic;
    rm_curve        : in  arr_4_16_stdlogic;

    sb_din_i        : in  arr_4_16_stdlogic;
    sb_din_q        : in  arr_4_16_stdlogic;
    sb_in_pow       : out arr_4_32_stdlogic;
    sb_in_peak      : out arr_4_32_stdlogic;
    sb_path_en      : in  std_logic_vector(3 downto 0);
    sb_input_gain   : in  arr_4_16_stdlogic;
    sb_slope        : in  arr_4_16_stdlogic;
    sb_curve        : in  arr_4_16_stdlogic;

	sum_power       : out arr_4_32_stdlogic;
    sum_peak        : out arr_4_32_stdlogic;

    axi_rst_n       : in  std_logic;
    axi_cfr_awvalid : in  std_logic;
    axi_cfr_awready : out std_logic;
    axi_cfr_awaddr  : in  std_logic_vector(31 downto 0);
    axi_cfr_wvalid  : in  std_logic;
    axi_cfr_wready  : out std_logic;
    axi_wdata       : in  std_logic_vector(31 downto 0);
    axi_cfr_bvalid  : out std_logic;
    axi_bready      : in  std_logic;
    axi_bresp       : out std_logic_vector(1 downto 0);
    axi_cfr_araddr  : in  std_logic_vector(31 downto 0);
    axi_cfr_arvalid : in  std_logic;
    axi_cfr_aready  : out std_logic;
    axi_cfr_rvalid  : out std_logic;
    axi_rready      : in  std_logic;
    axi_rresp       : out std_logic_vector(1 downto 0);
    axi_cfr_rdata   : out std_logic_vector(31 downto 0);

    dpd_gain        : in  arr_4_16_stdlogic;

    dpd_in_rdy      : in  std_logic;
    dpd_in          : out std_logic_vector(255 downto 0);
    dpd_in_valid    : out std_logic;

    dpd_out_rdy     : out std_logic;
    dpd_out_valid   : in  std_logic;
    dpd_out         : in  std_logic_vector(255 downto 0);

    output_gain     : in  arr_4_16_stdlogic;

    pow_sel         : in  std_logic_vector( 3 downto 0);
    out_power       : out arr_4_32_stdlogic;
    out_peak        : out arr_4_32_stdlogic;

    dout_s0_i       : out arr_4_16_stdlogic;
    dout_s0_q       : out arr_4_16_stdlogic;
    dout_s1_i       : out arr_4_16_stdlogic;
    dout_s1_q       : out arr_4_16_stdlogic
);
end dl_path_n77_100m;

architecture beh of dl_path_n77_100m is

----------------------------------------------------------------

signal rst_n_122p88   : std_logic;
signal rst_n_491p52   : std_logic;

signal path_en        : std_logic_vector(MIMO_NUM downto 0);

signal dcm_dly_i      : arr_4_16_stdlogic;
signal dcm_dly_q      : arr_4_16_stdlogic;
signal kddi_dly_i     : arr_4_16_stdlogic;
signal kddi_dly_q     : arr_4_16_stdlogic;
signal rm_dly_i       : arr_4_16_stdlogic;
signal rm_dly_q       : arr_4_16_stdlogic;
signal sb_dly_i       : arr_4_16_stdlogic;
signal sb_dly_q       : arr_4_16_stdlogic;

signal dcm_dds        : std_logic_vector(31 downto 0);
signal dcm_dds_valid  : std_logic;
signal kddi_dds       : std_logic_vector(31 downto 0);
signal kddi_dds_valid : std_logic;
signal rm_dds         : std_logic_vector(31 downto 0);
signal rm_dds_valid   : std_logic;
signal sb_dds         : std_logic_vector(31 downto 0);
signal sb_dds_valid   : std_logic;

signal dcm_dout_i     : arr_mimo_16_stdlogic;
signal dcm_dout_q     : arr_mimo_16_stdlogic;
signal dcm_dout_vld   : std_logic_vector(MIMO_NUM downto 0);

signal kddi_dout_i    : arr_mimo_16_stdlogic;
signal kddi_dout_q    : arr_mimo_16_stdlogic;
signal kddi_dout_vld  : std_logic_vector(MIMO_NUM downto 0);

signal dk_dout_vld    : std_logic_vector(MIMO_NUM downto 0);

signal rm_dout_i      : arr_mimo_16_stdlogic;
signal rm_dout_q      : arr_mimo_16_stdlogic;
signal rm_dout_vld    : std_logic_vector(MIMO_NUM downto 0);

signal sb_dout_i      : arr_mimo_16_stdlogic;
signal sb_dout_q      : arr_mimo_16_stdlogic;
signal sb_dout_vld    : std_logic_vector(MIMO_NUM downto 0);

signal rs_dout_vld    : std_logic_vector(MIMO_NUM downto 0);

signal dk_dout_i      : arr_mimo_16_stdlogic;
signal dk_dout_q      : arr_mimo_16_stdlogic;

signal rs_dout_i      : arr_mimo_16_stdlogic;
signal rs_dout_q      : arr_mimo_16_stdlogic;

signal sum_i          : arr_4_16_stdlogic := (others => (others => '0'));
signal sum_q          : arr_4_16_stdlogic := (others => (others => '0'));

signal cfr_in         : std_logic_vector(127 downto 0);
signal cfr_in_rdy     : std_logic;
signal cfr_in_valid   : std_logic_vector(MIMO_NUM downto 0);
signal cfr_out        : std_logic_vector(127 downto 0);
signal cfr_out_i      : arr_4_16_stdlogic;
signal cfr_out_q      : arr_4_16_stdlogic;
signal cfr_out_rdy    : std_logic;
signal cfr_out_vld    : std_logic;

signal int2_in_i      : arr_4_16_stdlogic;
signal int2_in_q      : arr_4_16_stdlogic;
signal int2_in        : arr_mimo_32_stdlogic;
signal int2_out_valid : std_logic_vector(MIMO_NUM downto 0);
signal int2_out       : arr_mimo_128_stdlogic;

signal pow_out_i      : arr_4_16_stdlogic;
signal pow_out_q      : arr_4_16_stdlogic;
signal pow_sel_sync   : std_logic_vector( 3 downto 0);

signal dpd_in_s0_i    : arr_4_16_stdlogic;
signal dpd_in_s0_q    : arr_4_16_stdlogic;
signal dpd_in_s1_i    : arr_4_16_stdlogic;
signal dpd_in_s1_q    : arr_4_16_stdlogic;

signal dpd_out_s0_i   : arr_4_16_stdlogic;
signal dpd_out_s0_q   : arr_4_16_stdlogic;
signal dpd_out_s1_i   : arr_4_16_stdlogic;
signal dpd_out_s1_q   : arr_4_16_stdlogic;

signal gain_out_s0_i  : arr_4_16_stdlogic;
signal gain_out_s0_q  : arr_4_16_stdlogic;
signal gain_out_s1_i  : arr_4_16_stdlogic;
signal gain_out_s1_q  : arr_4_16_stdlogic;

signal rand_3_16bit   : std_logic_vector(15 downto 0);

signal dcm_user_in    : std_logic_vector(7 downto 0);
signal dcm_user_out   : std_logic_vector(7 downto 0);

signal rm_user_in     : std_logic_vector(7 downto 0);
signal rm_user_out    : std_logic_vector(7 downto 0);

signal dpd_in_s0_i_s    : arr_4_16_stdlogic;
signal dpd_in_s0_q_s    : arr_4_16_stdlogic;
signal dpd_in_s1_i_s    : arr_4_16_stdlogic;
signal dpd_in_s1_q_s    : arr_4_16_stdlogic;

signal dc_off_s0_i   : arr_4_16_stdlogic;
signal dc_off_s0_q   : arr_4_16_stdlogic;
signal dc_off_s1_i   : arr_4_16_stdlogic;
signal dc_off_s1_q   : arr_4_16_stdlogic;
----------------------------------------------------------------
begin


rst_blk_122p88 : xpm_cdc_sync_rst
 generic map (
   DEST_SYNC_FF   => 2 ,
   INIT           => 1 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 )
 port map (
   dest_rst       => rst_n_122p88 ,
   dest_clk       => clk_122p88   ,
   src_rst        => rst_n        );

rst_blk_491p52 : xpm_cdc_sync_rst
 generic map (
   DEST_SYNC_FF   => 2 ,
   INIT           => 1 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 )
 port map (
   dest_rst       => rst_n_491p52 ,
   dest_clk       => clk_491p52   ,
   src_rst        => rst_n        );

dcm_user_in(0)  <= tsync_dly_in(0);
tsync_dly_out(0)    <= dcm_user_out(0);

dcm_dly_blk0 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => dcm_din_i(0)  , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => dcm_din_q(0)  , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => dcm_din_i(1)  , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => dcm_din_q(1)  , --: in  std_logic_vector(15 downto 0);
    din_user        => dcm_user_in   , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_dcm_01  , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => dcm_dly_i(0)  , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => dcm_dly_q(0)  , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => dcm_dly_i(1)  , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => dcm_dly_q(1)  , --: out std_logic_vector(15 downto 0);
    dout_user       => dcm_user_out  );--: out std_logic_vector(7 downto 0)

dcm_dly_blk1 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => dcm_din_i(2)  , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => dcm_din_q(2)  , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => dcm_din_i(3)  , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => dcm_din_q(3)  , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_dcm_23  , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => dcm_dly_i(2)  , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => dcm_dly_q(2)  , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => dcm_dly_i(3)  , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => dcm_dly_q(3)  , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)


kddi_dly_blk0 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => kddi_din_i(0) , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => kddi_din_q(0) , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => kddi_din_i(1) , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => kddi_din_q(1) , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_kddi_01 , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => kddi_dly_i(0) , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => kddi_dly_q(0) , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => kddi_dly_i(1) , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => kddi_dly_q(1) , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)

kddi_dly_blk1 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => kddi_din_i(2) , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => kddi_din_q(2) , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => kddi_din_i(3) , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => kddi_din_q(3) , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_kddi_23 , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => kddi_dly_i(2) , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => kddi_dly_q(2) , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => kddi_dly_i(3) , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => kddi_dly_q(3) , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)

rm_user_in(0)    <= tsync_dly_in(1);
tsync_dly_out(1) <= rm_user_out(0);

rm_dly_blk0 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => rm_din_i(0)   , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => rm_din_q(0)   , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => rm_din_i(1)   , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => rm_din_q(1)   , --: in  std_logic_vector(15 downto 0);
    din_user        => rm_user_in    , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_rm_01   , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => rm_dly_i(0)   , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => rm_dly_q(0)   , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => rm_dly_i(1)   , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => rm_dly_q(1)   , --: out std_logic_vector(15 downto 0)
    dout_user       => rm_user_out   );--: out std_logic_vector(7 downto 0)

rm_dly_blk1 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => rm_din_i(2)   , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => rm_din_q(2)   , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => rm_din_i(3)   , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => rm_din_q(3)   , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_rm_23   , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => rm_dly_i(2)   , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => rm_dly_q(2)   , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => rm_dly_i(3)   , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => rm_dly_q(3)   , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)

sb_dly_blk0 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => sb_din_i(0)   , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => sb_din_q(0)   , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => sb_din_i(1)   , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => sb_din_q(1)   , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_sb_01   , --: in  std_logic_vector(13 downto 0);
    dout_i_m0       => sb_dly_i(0)   , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => sb_dly_q(0)   , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => sb_dly_i(1)   , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => sb_dly_q(1)   , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)

sb_dly_blk1 : entity work.delay_blk_uram
port map(
    clk             => clk_122p88    , --: in  std_logic;
    rst_n           => rst_n_122p88  , --: in  std_logic;
    din_i_m0        => sb_din_i(2)   , --: in  std_logic_vector(15 downto 0);
    din_q_m0        => sb_din_q(2)   , --: in  std_logic_vector(15 downto 0);
    din_i_m1        => sb_din_i(3)   , --: in  std_logic_vector(15 downto 0);
    din_q_m1        => sb_din_q(3)   , --: in  std_logic_vector(15 downto 0);
    din_user        => x"00"         , --: in  std_logic_vector(7 downto 0);
    delay_parameter => delay_sb_23   , --: in  std_logic_vector(14 downto 0);
    dout_i_m0       => sb_dly_i(2)   , --: out std_logic_vector(15 downto 0);
    dout_q_m0       => sb_dly_q(2)   , --: out std_logic_vector(15 downto 0);
    dout_i_m1       => sb_dly_i(3)   , --: out std_logic_vector(15 downto 0);
    dout_q_m1       => sb_dly_q(3)   , --: out std_logic_vector(15 downto 0)
    dout_user       => open          );--: out std_logic_vector(7 downto 0)

dl_dds_dcm : entity work.dds_dcm
port map
(
    aclk               => clk_491p52     , --: in std_logic;
    aresetn            => rst_n_491p52   , --: in std_logic;
    m_axis_data_tvalid => dcm_dds_valid  , --: out std_logic;
    m_axis_data_tdata  => dcm_dds        ); --: out std_logic_vector(31 downto 0);

dl_dds_kddi : entity work.dds_kddi
port map
(
    aclk               => clk_491p52     , --: in std_logic;
    aresetn            => rst_n_491p52   , --: in std_logic;
    m_axis_data_tvalid => kddi_dds_valid , --: out std_logic;
    m_axis_data_tdata  => kddi_dds       ); --: out std_logic_vector(31 downto 0);

dl_dds_rm : entity work.dds_rm
port map
(
    aclk               => clk_491p52     , --: in std_logic;
    aresetn            => rst_n_491p52   , --: in std_logic;
    m_axis_data_tvalid => rm_dds_valid   , --: out std_logic;
    m_axis_data_tdata  => rm_dds         ); --: out std_logic_vector(31 downto 0);

dl_dds_sb : entity work.dds_sb
port map
(
    aclk               => clk_491p52     , --: in std_logic;
    aresetn            => rst_n_491p52   , --: in std_logic;
    m_axis_data_tvalid => sb_dds_valid   , --: out std_logic;
    m_axis_data_tdata  => sb_dds         ); --: out std_logic_vector(31 downto 0);


dl_duc_dcm_bank : for n in 0 to mimo_num generate
dl_duc_blk : entity work.dl_duc
port map(
    clk_491p52          => clk_491p52        , --: in  std_logic;
    clk_122p88          => clk_122p88        , --: in  std_logic;
    clk_61p44           => clk_61p44         , --: in  std_logic;
    rst_n               => rst_n             , --: in  std_logic;
    din_i               => dcm_dly_i(n)      , --: in  std_logic_vector(15 downto 0);
    din_q               => dcm_dly_q(n)      , --: in  std_logic_vector(15 downto 0);
    tdd_sync            => tdd_sync          , --: in  std_logic;
	peak_sel            => peak_sel          , --: in  std_logic;
    fa_det_threshold    => fa_det_threshold, --: in std_logic_vector(31 downto 0);
	fa_detect	 		=> fa_detect(0)(n), --: out  std_logic:='0';	
    in_pow              => dcm_in_pow(n)     , --: out std_logic_vector(31 downto 0);
    in_peak             => dcm_in_peak(n)    , --: out std_logic_vector(31 downto 0);
	pow_en_fb			=> pow_en_fb(n),
    slope               => dcm_slope(n)      , --: in  std_logic_vector(15 downto 0);
    curve               => dcm_curve(n)      , --: in  std_logic_vector(15 downto 0);
    path_en             => dcm_path_en(n)    , --: in  std_logic;
    input_gain          => dcm_input_gain(n) , --: in  std_logic_vector(15 downto 0);
    dds_data            => dcm_dds           , --: in  std_logic_vector(15 downto 0);
    dds_valid           => dcm_dds_valid     , --: in  std_logic;
    dout_i              => dcm_dout_i(n)     , --: out std_logic_vector(15 downto 0);
    dout_q              => dcm_dout_q(n)     , --: out std_logic_vector(15 downto 0);
    dout_vld            => dcm_dout_vld(n)   ); --: out std_logic

end generate;

dl_duc_kddi_bank : for n in 0 to mimo_num generate
dl_duc_blk : entity work.dl_duc
port map(
    clk_491p52          => clk_491p52        , --: in  std_logic;
    clk_122p88          => clk_122p88        , --: in  std_logic;
    clk_61p44           => clk_61p44         , --: in  std_logic;
    rst_n               => rst_n             , --: in  std_logic;
    din_i               => kddi_dly_i(n)     , --: in  std_logic_vector(15 downto 0);
    din_q               => kddi_dly_q(n)     , --: in  std_logic_vector(15 downto 0);
    tdd_sync            => tdd_sync          , --: in  std_logic;
	peak_sel            => peak_sel          , --: in  std_logic;
    fa_det_threshold    => fa_det_threshold, --: in std_logic_vector(31 downto 0);
	fa_detect	 		=> fa_detect(1)(n), --: out  std_logic:='0';	
    in_pow              => kddi_in_pow(n)    , --: out std_logic_vector(31 downto 0);
    in_peak             => kddi_in_peak(n)   , --: out std_logic_vector(31 downto 0);
	pow_en_fb			=> pow_en_fb(n),
    slope               => kddi_slope(n)     , --: in  std_logic_vector(15 downto 0);
    curve               => kddi_curve(n)     , --: in  std_logic_vector(15 downto 0);
    path_en             => kddi_path_en(n)   , --: in  std_logic;
    input_gain          => kddi_input_gain(n), --: in  std_logic_vector(15 downto 0);
    dds_data            => kddi_dds          , --: in  std_logic_vector(15 downto 0);
    dds_valid           => kddi_dds_valid    , --: in  std_logic;
    dout_i              => kddi_dout_i(n)    , --: out std_logic_vector(15 downto 0);
    dout_q              => kddi_dout_q(n)    , --: out std_logic_vector(15 downto 0);
    dout_vld            => kddi_dout_vld(n)  ); --: out std_logic

end generate;

dl_duc_rm_bank : for n in 0 to mimo_num generate
dl_duc_blk : entity work.dl_duc
port map(
    clk_491p52          => clk_491p52        , --: in  std_logic;
    clk_122p88          => clk_122p88        , --: in  std_logic;
    clk_61p44           => clk_61p44         , --: in  std_logic;
    rst_n               => rst_n             , --: in  std_logic;
    din_i               => rm_dly_i(n)       , --: in  std_logic_vector(15 downto 0);
    din_q               => rm_dly_q(n)       , --: in  std_logic_vector(15 downto 0);
    tdd_sync            => tdd_sync          , --: in  std_logic;
	peak_sel            => peak_sel          , --: in  std_logic;
    fa_det_threshold    => fa_det_threshold, --: in std_logic_vector(31 downto 0);
	fa_detect	 		=> fa_detect(2)(n), --: out  std_logic:='0';	
    in_pow              => rm_in_pow(n)      , --: out std_logic_vector(31 downto 0);
    in_peak             => rm_in_peak(n)     , --: out std_logic_vector(31 downto 0);
	pow_en_fb			=> pow_en_fb(n),
    slope               => rm_slope(n)       , --: in  std_logic_vector(15 downto 0);
    curve               => rm_curve(n)       , --: in  std_logic_vector(15 downto 0);
    path_en             => rm_path_en(n)     , --: in  std_logic;
    input_gain          => rm_input_gain(n)  , --: in  std_logic_vector(15 downto 0);
    dds_data            => rm_dds            , --: in  std_logic_vector(15 downto 0);
    dds_valid           => rm_dds_valid      , --: in  std_logic;
    dout_i              => rm_dout_i(n)      , --: out std_logic_vector(15 downto 0);
    dout_q              => rm_dout_q(n)      , --: out std_logic_vector(15 downto 0);
    dout_vld            => rm_dout_vld(n)    ); --: out std_logic
end generate;

dl_duc_sb_bank : for n in 0 to mimo_num generate
dl_duc_blk : entity work.dl_duc
port map(
    clk_491p52          => clk_491p52        , --: in  std_logic;
    clk_122p88          => clk_122p88        , --: in  std_logic;
    clk_61p44           => clk_61p44         , --: in  std_logic;
    rst_n               => rst_n             , --: in  std_logic;
    din_i               => sb_dly_i(n)       , --: in  std_logic_vector(15 downto 0);
    din_q               => sb_dly_q(n)       , --: in  std_logic_vector(15 downto 0);
    tdd_sync            => tdd_sync          , --: in  std_logic;
	peak_sel            => peak_sel          , --: in  std_logic;
    fa_det_threshold    => fa_det_threshold, --: in std_logic_vector(31 downto 0);
	fa_detect	 		=> fa_detect(3)(n), --: out  std_logic:='0';	
    in_pow              => sb_in_pow(n)      , --: out std_logic_vector(31 downto 0);
    in_peak             => sb_in_peak(n)     , --: out std_logic_vector(31 downto 0);
	pow_en_fb			=> pow_en_fb(n),
    slope               => sb_slope(n)       , --: in  std_logic_vector(15 downto 0);
    curve               => sb_curve(n)       , --: in  std_logic_vector(15 downto 0);
    path_en             => sb_path_en(n)     , --: in  std_logic;
    input_gain          => sb_input_gain(n)  , --: in  std_logic_vector(15 downto 0);
    dds_data            => sb_dds            , --: in  std_logic_vector(15 downto 0);
    dds_valid           => sb_dds_valid      , --: in  std_logic;s
    dout_i              => sb_dout_i(n)      , --: out std_logic_vector(15 downto 0);
    dout_q              => sb_dout_q(n)      , --: out std_logic_vector(15 downto 0);
    dout_vld            => sb_dout_vld(n)    ); --: out std_logic

end generate;

sum_bank : for n in 0 to mimo_num generate
process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( dcm_dout_vld(n) = '1' and kddi_dout_vld(n) = '1' ) then
        dk_dout_i(n)   <= dcm_dout_i(n) + kddi_dout_i(n);
        dk_dout_q(n)   <= dcm_dout_q(n) + kddi_dout_q(n);
        dk_dout_vld(n) <= '1';
    else
        dk_dout_i(n)   <= (others => '0');
        dk_dout_q(n)   <= (others => '0');
        dk_dout_vld(n) <= '0';
    end if;

    if ( rm_dout_vld(n) = '1' and sb_dout_vld(n) = '1' ) then
        rs_dout_i(n)   <= rm_dout_i(n) + sb_dout_i(n);
        rs_dout_q(n)   <= rm_dout_q(n) + sb_dout_q(n);
        rs_dout_vld(n) <= '1';
    else
        rs_dout_i(n)   <= (others => '0');
        rs_dout_q(n)   <= (others => '0');
        rs_dout_vld(n) <= '0';
    end if;

    if ( dk_dout_vld(n) = '1' and rs_dout_vld(n) = '1' ) then
        sum_i(n)     <= dk_dout_i(n) + rs_dout_i(n);
        sum_q(n)     <= dk_dout_q(n) + rs_dout_q(n);
        cfr_in_valid(n) <= '1';
    else
        sum_i(n)     <= (others => '0');
        sum_q(n)     <= (others => '0');
        cfr_in_valid(n) <= '0';
    end if;
end if;
end process;

end generate;


sum_pow_bank : for n in 0 to 3 generate
sum_pow_mea : entity work.pow_mea_tdd_u
 generic map(
    clock_frequency => 491_520        , -- system clock frequency in khz 7_680, 15_360, 30_720, 61_440, 122_880, 245_760, 491_520
    unit_frequency  => 61_440         , -- unit clock frequency in khz 7_680, 5_760
    tdd_period      => 5_000          , -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   => 3_857          , -- tdd_high_time(us) 3_857, 1_142
    check_time      => 20_000         ) -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
 port map(
    clk             => clk_491p52     , --: in  std_logic;
    clk_unit        => clk_61p44      , --: in  std_logic;
    clk_tdd         => clk_122p88     , --: in  std_logic;
    reset_n         => rst_n_491p52   , --: in  std_logic;
    tdd_sync        => tdd_sync       , --: in  std_logic;
    din_i           => sum_i(n)       , --: in  std_logic_vector(15 downto 0);
    din_q           => sum_q(n)       , --: in  std_logic_vector(15 downto 0);
    din_vld         => '1'            , --: in  std_logic;
    chk_en          => '1',--pow_en_fb(n)            , --: in  std_logic;
    power           => sum_power(n)   , --: out std_logic_vector(31 downto 0);
    peak_power      => sum_peak(n)    ); --: out std_logic_vector(31 downto 0)
end generate;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (cfr_in_rdy = '1') then
        cfr_in <= sum_q(3) & sum_i(3) & sum_q(2) & sum_i(2) & sum_q(1) & sum_i(1) & sum_q(0) & sum_i(0);
    else
        cfr_in <= (others => '0');
    end if;
end if;
end process;

CFR_BLK : entity work.pc_cfr_n77
 port map(
    s_axi_aclk             => clk_61p44         , --: in  std_logic;
    s_axi_aresetn          => axi_rst_n         , --: in  std_logic;
    s_axi_awvalid          => axi_cfr_awvalid   , --: in  std_logic;
    s_axi_awready          => axi_cfr_awready   , --: out std_logic;
    s_axi_awaddr           => axi_cfr_awaddr    , --: in  std_logic_vector( 31 downto  0);
    s_axi_wvalid           => axi_cfr_wvalid    , --: in  std_logic;
    s_axi_wready           => axi_cfr_wready    , --: out std_logic;
    s_axi_wdata            => axi_wdata         , --: in  std_logic_vector( 31 downto  0);
    s_axi_bvalid           => axi_cfr_bvalid    , --: out std_logic;
    s_axi_bready           => axi_bready        , --: in  std_logic;
    s_axi_bresp            => axi_bresp         , --: out std_logic_vector(  1 downto  0);
    s_axi_arvalid          => axi_cfr_arvalid   , --: in  std_logic;
    s_axi_arready          => axi_cfr_aready    , --: out std_logic;
    s_axi_araddr           => axi_cfr_araddr    , --: in  std_logic_vector( 31 downto  0);
    s_axi_rvalid           => axi_cfr_rvalid    , --: out std_logic;
    s_axi_rready           => axi_rready        , --: in  std_logic;
    s_axi_rdata            => axi_cfr_rdata     , --: out std_logic_vector( 31 downto  0);
    s_axi_rresp            => axi_rresp         , --: out std_logic_vector(  1 downto  0);
    aclk                   => clk_491p52        , --: in  std_logic;
    aresetn                => rst_n_491p52      , --: in  std_logic;
    s_axis_din_tvalid      => cfr_in_valid(0)   , --: in  std_logic;
    s_axis_din_tready      => cfr_in_rdy        , --: out std_logic;
    s_axis_din_tdata       => cfr_in            , --: in  std_logic_vector(127 downto  0);
    event_s_din_underrun   => open              , --: out std_logic;
    m_axis_dout_tvalid     => cfr_out_vld       , --: out std_logic;
    m_axis_dout_tready     => cfr_out_rdy       , --: in  std_logic;
    m_axis_dout_tdata      => cfr_out           , --: out std_logic_vector(127 downto  0);
    event_m_dout_overrun   => open              ); --: out std_logic


process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    cfr_out_rdy    <= '1';
    cfr_out_q(3)    <= cfr_out(127 downto 112);
    cfr_out_i(3)    <= cfr_out(111 downto  96);
    cfr_out_q(2)    <= cfr_out( 95 downto  80);
    cfr_out_i(2)    <= cfr_out( 79 downto  64);
    cfr_out_q(1)    <= cfr_out( 63 downto  48);
    cfr_out_i(1)    <= cfr_out( 47 downto  32);
    cfr_out_q(0)    <= cfr_out( 31 downto  16);
    cfr_out_i(0)    <= cfr_out( 15 downto   0);
end if;
end process;

dpd_in_gain_bank : for n in 0 to mimo_num generate
dpd_in_gain_i : entity work.GAIN_BLK_16
 port map(
    clk                    => clk_491p52        , --: in  std_logic;
    gain                   => dpd_gain(n)       , --: in  std_logic_vector(15 downto 0);
    din                    => cfr_out_i(n)      , --: in  std_logic_vector(15 downto 0);
    dout                   => int2_in_i(n)      );--: out std_logic_vector(15 downto 0)

dpd_in_gain_q : entity work.GAIN_BLK_16
 port map(
    clk                    => clk_491p52        , --: in  std_logic;
    gain                   => dpd_gain(n)       , --: in  std_logic_vector(15 downto 0);
    din                    => cfr_out_q(n)      , --: in  std_logic_vector(15 downto 0);
    dout                   => int2_in_q(n)      );--: out std_logic_vector(15 downto 0)
end generate;

--dpd_in_i    <= dpd_in_buf_i;
--dpd_in_q    <= dpd_in_buf_q;

-- to DPD

dpd_in_int2_bank : for n in 0 to mimo_num generate
int2_in(n) <= int2_in_q(n) & int2_in_i(n);

fir_int2_491p52 : entity work.fir_int2_491p52
  port map(
    aresetn                 => rst_n_491p52      , --: IN STD_LOGIC;
    aclk                    => clk_491p52        , --: IN STD_LOGIC;
    s_axis_data_tvalid      => '1'               , --: IN STD_LOGIC;
    s_axis_data_tready      => open              , --: OUT STD_LOGIC;
    s_axis_data_tdata       => int2_in(n)        , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid      => int2_out_valid(n) , --: OUT STD_LOGIC;
    m_axis_data_tdata       => int2_out(n)       ); --: OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
end generate;

random_blk : entity work.random_3_16bit
 port map(
 clk         => clk_491p52   , --: in  std_logic;
 reset_n     => rst_n_491p52 , --: in  std_logic;
 random      => rand_3_16bit ); --: out std_logic


dpd_in_bank : for n in 0 to mimo_num generate
process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    path_en(n)  <= dcm_path_en(n) or kddi_path_en(n) or rm_path_en(n) or sb_path_en(n);
    if ( path_en(n) = '1' and dpd_in_rdy = '1') then
        if ( int2_out_valid(n) = '1' ) then

			if (int2_out(n)(31)= '0' and int2_out(n)(30) /= '0') then
				dpd_in_s0_i(n) <= x"7fff";
			elsif (int2_out(n)(31)= '0' and int2_out(n)(29 downto 14) = x"ffff") then
				dpd_in_s0_i(n) <= x"7fff";
			elsif (int2_out(n)(31)= '1' and int2_out(n)(30)/='1') then
				dpd_in_s0_i(n) <= x"8000";
			else
				dpd_in_s0_i(n) <= int2_out(n)( 31) & int2_out(n)( 29 downto  15) + int2_out(n)( 14);
			end if;
			if (int2_out(n)(63)= '0' and int2_out(n)(62) /= '0') then
				dpd_in_s0_q(n) <= x"7fff";
			elsif (int2_out(n)(63)= '0' and int2_out(n)(61 downto 46) = x"ffff") then
				dpd_in_s0_q(n) <= x"7fff";
			elsif (int2_out(n)(63)= '1' and int2_out(n)(62) /= '1') then
				dpd_in_s0_q(n) <= x"8000";
			else
				dpd_in_s0_q(n) <= int2_out(n)( 63) & int2_out(n)(61 downto  47) + int2_out(n)( 46);
			end if;
			if (int2_out(n)(95)= '0' and int2_out(n)(94) /= '0') then
				dpd_in_s1_i(n) <= x"7fff";
			elsif (int2_out(n)(95)= '0' and int2_out(n)(93 downto 78) = x"ffff") then
				dpd_in_s1_i(n) <= x"7fff";
			elsif (int2_out(n)(95)= '1' and int2_out(n)(94) /= '1') then
				dpd_in_s1_i(n) <= x"8000";
			else
				dpd_in_s1_i(n) <= int2_out(n)( 95) & int2_out(n)( 93 downto  79) + int2_out(n)( 78);
			end if;
			if (int2_out(n)(127)= '0' and int2_out(n)(126) /= '0') then
				dpd_in_s1_q(n) <= x"7fff";
			elsif (int2_out(n)(127)= '0' and int2_out(n)(125 downto 110) = x"ffff") then
				dpd_in_s1_q(n) <= x"7fff";
			elsif (int2_out(n)(127)= '1' and int2_out(n)(126) /= '1') then
				dpd_in_s1_q(n) <= x"8000";
			else
				dpd_in_s1_q(n) <= int2_out(n)(127) & int2_out(n)(125 downto 111) + int2_out(n)(110);
			end if;
        end if;
    else
    dpd_in_s0_i(n)   <= rand_3_16bit;
    dpd_in_s0_q(n)   <= not rand_3_16bit;
    dpd_in_s1_i(n)   <= rand_3_16bit;
    dpd_in_s1_q(n)   <= not rand_3_16bit;
    end if;
end if;
end process;
end generate;

-------------------------------------------230712_dc_cancel_insert
-- dc_cancel_bank_dpd_in : for n in 0 to mimo_num generate
-- dc_cancel_s0_i_dpd_in : entity work.dc_offset_16_n
-- port map(
	-- rst_n				=> rst_n_491p52				,	
	-- clk					=> clk_491p52				,	
	-- tdd_sync			=> '1'                      ,
	-- din					=> dpd_in_s0_i(n)         ,
	-- dout				=> dpd_in_s0_i_s(n)			);	

-- dc_cancel_s0_q_dpd_in : entity work.dc_offset_16_n
-- port map(
	-- rst_n				=> rst_n_491p52				,	
	-- clk					=> clk_491p52				,	
	-- tdd_sync			=> '1'                      ,
	-- din					=> dpd_in_s0_q(n)         ,
	-- dout				=> dpd_in_s0_q_s(n)			);	

-- dc_cancel_s1_i_dpd_in : entity work.dc_offset_16_n
-- port map(
	-- rst_n				=> rst_n_491p52				,	
	-- clk					=> clk_491p52				,	
	-- tdd_sync			=> '1'                      ,
	-- din					=> dpd_in_s1_i(n)         ,
	-- dout				=> dpd_in_s1_i_s(n)			);	

-- dc_cancel_s1_q_dpd_in : entity work.dc_offset_16_n
-- port map(
	-- rst_n				=> rst_n_491p52				,	
	-- clk					=> clk_491p52				,	
	-- tdd_sync			=> '1'                      ,
	-- din					=> dpd_in_s1_q(n)         ,
	-- dout				=> dpd_in_s1_q_s(n)			);
-- end generate;
-------------------------------------------

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (dpd_in_rdy = '1') then
        dpd_in  <= dpd_in_s1_q(3) & dpd_in_s1_i(3) & dpd_in_s0_q(3) & dpd_in_s0_i(3) & dpd_in_s1_q(2) & dpd_in_s1_i(2) & dpd_in_s0_q(2) & dpd_in_s0_i(2) & dpd_in_s1_q(1) & dpd_in_s1_i(1) & dpd_in_s0_q(1) & dpd_in_s0_i(1) & dpd_in_s1_q(0) & dpd_in_s1_i(0) & dpd_in_s0_q(0) & dpd_in_s0_i(0);
		-- dpd_in  <= dpd_in_s1_q_s(3) & dpd_in_s1_i_s(3) & dpd_in_s0_q_s(3) & dpd_in_s0_i_s(3) & dpd_in_s1_q_s(2) & dpd_in_s1_i_s(2) & dpd_in_s0_q_s(2) & dpd_in_s0_i_s(2) & dpd_in_s1_q_s(1) & dpd_in_s1_i_s(1) & dpd_in_s0_q_s(1) & dpd_in_s0_i_s(1) & dpd_in_s1_q_s(0) & dpd_in_s1_i_s(0) & dpd_in_s0_q_s(0) & dpd_in_s0_i_s(0);
        dpd_in_valid    <= '1';
    else
        dpd_in_valid    <= '0';
    end if;
end if;
end process;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    dpd_out_rdy <= '1';
    if (dpd_out_valid = '1') then
        dpd_out_s0_i(0) <= dpd_out( 15 downto   0);
        dpd_out_s0_q(0) <= dpd_out( 31 downto  16);
        dpd_out_s1_i(0) <= dpd_out( 47 downto  32);
        dpd_out_s1_q(0) <= dpd_out( 63 downto  48);
        dpd_out_s0_i(1) <= dpd_out( 79 downto  64);
        dpd_out_s0_q(1) <= dpd_out( 95 downto  80);
        dpd_out_s1_i(1) <= dpd_out(111 downto  96);
        dpd_out_s1_q(1) <= dpd_out(127 downto 112);
        dpd_out_s0_i(2) <= dpd_out(143 downto 128);
        dpd_out_s0_q(2) <= dpd_out(159 downto 144);
        dpd_out_s1_i(2) <= dpd_out(175 downto 160);
        dpd_out_s1_q(2) <= dpd_out(191 downto 176);
        dpd_out_s0_i(3) <= dpd_out(207 downto 192);
        dpd_out_s0_q(3) <= dpd_out(223 downto 208);
        dpd_out_s1_i(3) <= dpd_out(239 downto 224);
        dpd_out_s1_q(3) <= dpd_out(255 downto 240);
    else
        dpd_out_s0_i(0) <= ( others => '0');
        dpd_out_s0_q(0) <= ( others => '0');
        dpd_out_s1_i(0) <= ( others => '0');
        dpd_out_s1_q(0) <= ( others => '0');
        dpd_out_s0_i(1) <= ( others => '0');
        dpd_out_s0_q(1) <= ( others => '0');
        dpd_out_s1_i(1) <= ( others => '0');
        dpd_out_s1_q(1) <= ( others => '0');
        dpd_out_s0_i(2) <= ( others => '0');
        dpd_out_s0_q(2) <= ( others => '0');
        dpd_out_s1_i(2) <= ( others => '0');
        dpd_out_s1_q(2) <= ( others => '0');
        dpd_out_s0_i(3) <= ( others => '0');
        dpd_out_s0_q(3) <= ( others => '0');
        dpd_out_s1_i(3) <= ( others => '0');
        dpd_out_s1_q(3) <= ( others => '0');
    end if;
end if;
end process;



out_gain_bank : for n in 0 to mimo_num generate
out_gain_s0_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk_491p52      , --: in  std_logic;
    gain    => output_gain(n)  , --: in  std_logic_vector(15 downto 0);
    din     => dpd_out_s0_i(n) , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_s0_i(n)); --: out std_logic_vector(15 downto 0)

out_gain_s1_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk_491p52      , --: in  std_logic;
    gain    => output_gain(n)  , --: in  std_logic_vector(15 downto 0);
    din     => dpd_out_s1_i(n) , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_s1_i(n)); --: out std_logic_vector(15 downto 0)

out_gain_s0_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk_491p52      , --: in  std_logic;
    gain    => output_gain(n)  , --: in  std_logic_vector(15 downto 0);
    din     => dpd_out_s0_q(n) , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_s0_q(n)); --: out std_logic_vector(15 downto 0)

out_gain_s1_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk_491p52      , --: in  std_logic;
    gain    => output_gain(n)  , --: in  std_logic_vector(15 downto 0);
    din     => dpd_out_s1_q(n) , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_s1_q(n)); --: out std_logic_vector(15 downto 0)
end generate;


dout_s0_i   <= gain_out_s0_i;
dout_s0_q   <= gain_out_s0_q;
dout_s1_i   <= gain_out_s1_i;
dout_s1_q   <= gain_out_s1_q;

--pow_sel_sync_blk : entity work.d_sync
--generic map(
--    bits            => 4           ) --: natural := 16; -- number of bit.
--port map(
--    in_clk          => clk_100    , --: in   std_logic;
--    out_clk         => clk_491p52 , --: in   std_logic;
--    d_in            => pow_sel    , --: in   std_logic_vector(bits-1 downto 0);
--    d_out           => pow_sel_sync); --: out std_logic_vector(bits-1 downto 0)

--process(clk_491p52)
--begin
--if rising_edge(clk_491p52) then
--    case(pow_sel_sync) is
--        when x"0" =>   pow_out_i    <= sum_i;
--                       pow_out_q    <= sum_q;
--        when x"1" =>   pow_out_i    <= cfr_out_i;
--                       pow_out_q    <= cfr_out_q;
--        when x"2" =>   pow_out_i    <= int2_in_i;
--                       pow_out_q    <= int2_in_q;
--        when x"3" =>   pow_out_i    <= dpd_in_s0_i;
--                       pow_out_q    <= dpd_in_s0_q;
--        when x"4" =>   pow_out_i    <= dpd_in_s1_i;
--                       pow_out_q    <= dpd_in_s1_q;
--        when x"5" =>   pow_out_i    <= dpd_out_s0_i;
--                       pow_out_q    <= dpd_out_s0_q;
--        when x"6" =>   pow_out_i    <= dpd_out_s1_i;
--                       pow_out_q    <= dpd_out_s1_q;
--        when x"7" =>   pow_out_i    <= gain_out_s0_i;
--                       pow_out_q    <= gain_out_s0_q;
--        when x"8" =>   pow_out_i    <= gain_out_s1_i;
--                       pow_out_q    <= gain_out_s1_q;
--        when others => pow_out_i    <= gain_out_s0_i;
--                       pow_out_q    <= gain_out_s0_q;
--    end case;
--end if;
--end process;



--out_pow_bank : for n in 0 to 3 generate
--  out_pow_mea : entity work.pow_mea_r
--    generic map (
--      clock_frequency => 491_520,
--      check_time      => 40
--    )
--    port map (
--      clk             => clk_491p52   , --: in std_logic;
--      loc_clk         => clk_100      , --: in std_logic;
--      reset_n         => rst_n_491p52 , --: in std_logic;
--      tdd_sync        => tdd_sync     , --: in std_logic;
--      din_i           => pow_out_i(n) , --: in std_logic_vector(15 downto 0);
--	  peak_sel        => peak_sel     , --: in std_logic;
--      power           => out_power(n) , --: out std_logic_vector(31 downto 0);
--      peak_power      => out_peak(n)  );--: out std_logic_vector(31 downto 0)
--end generate;

out_pow_bank : for n in 0 to 3 generate
out_pow_mea : entity work.pow_mea_tdd_s2_u
 generic map(
    clock_frequency => 491_520        , -- system clock frequency in khz 7_680, 15_360, 30_720, 61_440, 122_880, 245_760, 491_520
    unit_frequency  => 61_440         , -- unit clock frequency in khz 7_680, 5_760
    tdd_period      => 5_000          , -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   => 3_857          , -- tdd_high_time(us) 3_857, 1_142
    check_time      => 20_000         ) -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
 port map(
    clk             => clk_491p52       , --: in  std_logic;
    clk_unit        => clk_61p44        , --: in  std_logic;
    clk_tdd         => clk_122p88       , --: in  std_logic;
    reset_n         => rst_n_491p52     , --: in  std_logic;
    tdd_sync        => tdd_sync         , --: in  std_logic;
    din_i_s0        => gain_out_s0_i(n) , --: in  std_logic_vector(15 downto 0);
    din_q_s0        => gain_out_s0_q(n) , --: in  std_logic_vector(15 downto 0);
    din_i_s1        => gain_out_s1_i(n) , --: in  std_logic_vector(15 downto 0);
    din_q_s1        => gain_out_s1_q(n) , --: in  std_logic_vector(15 downto 0);
    din_vld         => '1'              , --: in  std_logic;
    chk_en          => '1',--pow_en_fb(n)              , --: in  std_logic;
    power           => out_power(n)     , --: out std_logic_vector(31 downto 0);
    peak_power      => out_peak(n)     ); --: out std_logic_vector(31 downto 0)
end generate;





end beh;

