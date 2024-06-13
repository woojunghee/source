library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity dl_duc is
port
(
    clk_491p52   : in  std_logic;
    clk_122p88   : in  std_logic;
    clk_61p44    : in  std_logic;

    rst_n        : in  std_logic;

    din_i        : in  std_logic_vector(15 downto 0);
    din_q        : in  std_logic_vector(15 downto 0);
    tdd_sync     : in  std_logic;
	peak_sel     : in  std_logic;
	fa_det_threshold       : in std_logic_vector(31 downto 0);
	fa_detect	 : out  std_logic:='0';													   
    in_pow       : out std_logic_vector(31 downto 0);
    in_peak      : out std_logic_vector(31 downto 0);
	pow_en_fb	: in  std_logic;

    slope        : in  std_logic_vector(15 downto 0);
    curve        : in  std_logic_vector(15 downto 0);

    path_en      : in  std_logic;

    input_gain   : in  std_logic_vector(15 downto 0);
    dds_data     : in  std_logic_vector(31 downto 0);
    dds_valid    : in  std_logic;

    dout_i       : out std_logic_vector(15 downto 0);
    dout_q       : out std_logic_vector(15 downto 0);
    dout_vld     : out std_logic
);
end dl_duc;

architecture beh of dl_duc is

----------------------------------------------------------------

  signal rst_n_491p52       : std_logic;
  signal rst_n_122p88       : std_logic;

  signal path_en_s0         : std_logic;
  signal path_en_s1         : std_logic;


  signal sample_cnt         : integer range 0 to 15;

  signal flat_in_i          : std_logic_vector(15 downto 0);
  signal flat_in_q          : std_logic_vector(15 downto 0);

  signal flat_out_i         : std_logic_vector(15 downto 0);
  signal flat_out_q         : std_logic_vector(15 downto 0);

  signal gain_in_i          : std_logic_vector(15 downto 0);
  signal gain_in_q          : std_logic_vector(15 downto 0);

  signal gain_out_i         : std_logic_vector(15 downto 0);
  signal gain_out_q         : std_logic_vector(15 downto 0);

  signal int2_1st_in_valid  : std_logic;
  signal int2_1st_in_rdy    : std_logic;
  signal int2_1st_in        : std_logic_vector(31 downto 0);
  signal int2_1st_out_valid : std_logic;
  signal int2_1st_out       : std_logic_vector(63 downto 0);

  signal int2_2nd_in_valid  : std_logic;
  signal int2_2nd_in_rdy    : std_logic;
  signal int2_2nd_in_i      : std_logic_vector(15 downto 0);
  signal int2_2nd_in_q      : std_logic_vector(15 downto 0);
  signal int2_2nd_in        : std_logic_vector(31 downto 0);
  signal int2_2nd_out_valid : std_logic;
  signal int2_2nd_out       : std_logic_vector(63 downto 0);

  signal fir_out_i          : std_logic_vector(15 downto 0);
  signal fir_out_q          : std_logic_vector(15 downto 0);

  signal comp_in_a          : std_logic_vector(31 downto 0);
  signal comp_in_a_vld      : std_logic;
  signal comp_in_b          : std_logic_vector(31 downto 0);
  signal comp_in_b_vld      : std_logic;
  signal comp_out           : std_logic_vector(79 downto 0);
  signal comp_out_valid     : std_logic;
	signal in_pow_s       : std_logic_vector(31 downto 0);													

  signal rst_122p88         : std_logic;
  signal rst_491p52         : std_logic;

  attribute ASYNC_REG    : string;
  attribute ASYNC_REG of path_en_s0 : signal is "true";
  attribute ASYNC_REG of path_en_s1 : signal is "true";

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

in_pow_mea : entity work.pow_mea_tdd_u
 generic map(
    clock_frequency => 122_880        , -- system clock frequency in khz 7_680, 15_360, 30_720, 61_440, 122_880, 245_760, 491_520
    unit_frequency  => 61_440         , -- unit clock frequency in khz 7_680, 5_760
    tdd_period      => 5_000          , -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   => 3_857          , -- tdd_high_time(us) 3_857, 1_142
    check_time      => 20_000         ) -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
 port map(
    clk             => clk_122p88     , --: in  std_logic;
    clk_unit        => clk_61p44      , --: in  std_logic;
    clk_tdd         => clk_122p88     , --: in  std_logic;
    reset_n         => rst_n_122p88   , --: in  std_logic;
    tdd_sync        => tdd_sync       , --: in  std_logic;
    din_i           => din_i          , --: in  std_logic_vector(15 downto 0);
    din_q           => din_q          , --: in  std_logic_vector(15 downto 0);
    din_vld         => pow_en_fb      , --: in  std_logic;
    chk_en          => pow_en_fb      , --: in  std_logic;
    power           => in_pow_s         , --: out std_logic_vector(31 downto 0);
    peak_power      => in_peak        ); --: out std_logic_vector(31 downto 0)
	in_pow <= in_pow_s;
	
process(clk_122p88)
begin
if rising_edge(clk_122p88) then
	if (in_pow_s > fa_det_threshold) then
		fa_detect <= '1';
	else
		fa_detect <= '0';
	end if;
end if;
end process;								

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    path_en_s0    <= path_en;
    path_en_s1    <= path_en_s0;
    if ( path_en_s1 = '1' ) then
        flat_in_i   <= din_i;
        flat_in_q   <= din_q;
    else
        flat_in_i   <= (others=>'0');
        flat_in_q   <= (others=>'0');
    end if;
end if;
end process;

 iq_slope : entity work.iq_slope
 port map(
     clk    => clk_122p88   , --: in  std_logic;
     rst_n  => rst_n_122p88 , --: in  std_logic;
     din_i  => flat_in_i    , --: in  std_logic_vector(15 downto 0);
     din_q  => flat_in_q    , --: in  std_logic_vector(15 downto 0);
     slope  => slope        , --: in  std_logic_vector(15 downto 0);
     curve  => curve        , --: in  std_logic_vector(15 downto 0);
     dout_i => flat_out_i   , --: out std_logic_vector(15 downto 0);
     dout_q => flat_out_q   ); --: out std_logic_vector(15 downto 0)

gain_in_i   <= flat_out_i;
gain_in_q   <= flat_out_q;

in_gain_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk_122p88 ,  --: in  std_logic;
    gain    => input_gain ,  --: in  std_logic_vector(15 downto 0);
    din     => gain_in_i  ,  --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_i ); --: out std_logic_vector(15 downto 0)

in_gain_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk_122p88 ,  --: in  std_logic;
    gain    => input_gain ,  --: in  std_logic_vector(15 downto 0);
    din     => gain_in_q  ,  --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_q ); --: out std_logic_vector(15 downto 0)

int2_1st_in <= gain_out_q & gain_out_i;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if(rst_n_491p52 = '0') then
        sample_cnt <= 0;
    else
        if (sample_cnt = 3) then    -- 491.52m/122.88m=4
            sample_cnt <= 0;
        else
            sample_cnt <= sample_cnt + 1;
        end if;
    end if;
end if;
end process;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( sample_cnt = 2 ) then
        int2_1st_in_valid <= '1';
    else
        int2_1st_in_valid <= '0';
    end if;
end if;
end process;

int2_1st : entity work.fir_int2_122p88
 port map(
    aresetn            => rst_n_491p52       ,  --: in  std_logic;
    aclk               => clk_491p52         ,  --: in  std_logic;
    s_axis_data_tvalid => int2_1st_in_valid  ,  --: in  std_logic;
    s_axis_data_tready => open               ,  --: out std_logic;
    s_axis_data_tdata  => int2_1st_in        ,  --: in  std_logic_vector(31 downto 0);
    m_axis_data_tvalid => int2_1st_out_valid ,  --: out std_logic;
    m_axis_data_tdata  => int2_1st_out       ); --: out std_logic_vector(63 downto 0)

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( int2_1st_out_valid = '1' ) then
        int2_2nd_in_i    <= int2_1st_out(31) & int2_1st_out(28 downto 14) + int2_1st_out(13);
        int2_2nd_in_q    <= int2_1st_out(63) & int2_1st_out(60 downto 46) + int2_1st_out(45);
    end if;
end if;
end process;

int2_2nd_in <= int2_2nd_in_q & int2_2nd_in_i;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    int2_2nd_in_valid <= int2_1st_out_valid;
end if;
end process;

int2_2nd : entity work.fir_int2_245p76
 port map(
    aresetn            => rst_n_491p52       , --: in  std_logic;
    aclk               => clk_491p52         , --: in  std_logic;
    s_axis_data_tvalid => int2_2nd_in_valid  , --: in  std_logic;
    s_axis_data_tready => open               , --: out std_logic;
    s_axis_data_tdata  => int2_2nd_in        , --: in  std_logic_vector(31 downto 0);
    m_axis_data_tvalid => int2_2nd_out_valid , --: out std_logic;
    m_axis_data_tdata  => int2_2nd_out       );  --: out std_logic_vector(63 downto 0)

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( int2_2nd_out_valid = '1' ) then
        comp_in_a(15 downto 0)  <= int2_2nd_out(31) & int2_2nd_out(29 downto 15) + int2_2nd_out(14);
        comp_in_a(31 downto 16) <= int2_2nd_out(63) & int2_2nd_out(61 downto 47) + int2_2nd_out(46);
        comp_in_a_vld           <= '1';
    else
        comp_in_a               <= (others =>'0');
        comp_in_a_vld           <= '0';
    end if;
end if;
end process;


process (clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( rst_n_491p52 = '0') then
        comp_in_b     <= (others =>'0');
        comp_in_b_vld <= '0';
    else
        if ( dds_valid = '1' ) then
            comp_in_b     <= dds_data;
            comp_in_b_vld <= '1';
        else
            comp_in_b     <= (others =>'0');
            comp_in_b_vld <= '0';
        end if;
    end if;
end if;
end process;

nco_comp : entity work.mult_comp
  port map (
    aclk                    => clk_491p52           , --: in  std_logic;
    aresetn                 => rst_n_491p52         , --: in  std_logic;
    s_axis_a_tvalid         => comp_in_a_vld        , --: in  std_logic;
    s_axis_a_tdata          => comp_in_a            , --: in  std_logic_vector(31 downto 0);
    s_axis_b_tvalid         => comp_in_b_vld        , --: in  std_logic;
    s_axis_b_tdata          => comp_in_b            , --: in  std_logic_vector(31 downto 0);
    m_axis_dout_tvalid      => comp_out_valid       , --: out std_logic;
    m_axis_dout_tdata       => comp_out             );--: out std_logic_vector(79 downto 0)


process (clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( rst_n_491p52 = '0' ) then
        dout_i    <= (others =>'0');
        dout_q    <= (others =>'0');
        dout_vld  <= '0';
    else
        if ( comp_out_valid = '1' ) then
            dout_q  <= comp_out(72) & comp_out(69 downto 55) + comp_out(54);
            dout_i  <= comp_out(32) & comp_out(29 downto 15) + comp_out(14);
            dout_vld  <= '1';
        else
            dout_i    <= (others =>'0');
            dout_q    <= (others =>'0');
            dout_vld  <= '0';
        end if;
    end if;
end if;
end process;


end beh;

