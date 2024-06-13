library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;


entity ul_ddc is
port
(
    clk_491p52   : in  std_logic;
    clk_122p88   : in  std_logic;
    clk_61p44    : in  std_logic;

    rst_n        : in  std_logic;

    path_en      : in  std_logic;

    din_i        : in  std_logic_vector(15 downto 0);
    din_q        : in  std_logic_vector(15 downto 0);
    tdd_sync     : in  std_logic;
    dds_data     : in  std_logic_vector(31 downto 0);
    dds_valid    : in  std_logic;

    output_gain  : in  std_logic_vector(15 downto 0);
    out_pow      : out std_logic_vector(31 downto 0);
    out_peak     : out std_logic_vector(31 downto 0);

    dout_i       : out std_logic_vector(15 downto 0);
    dout_q       : out std_logic_vector(15 downto 0)
);
end ul_ddc;

architecture beh of ul_ddc is

----------------------------------------------------------------

  signal rst_n_122p88       : std_logic;
  signal rst_n_491p52       : std_logic;

  signal path_en_s0         : std_logic;
  signal path_en_s1         : std_logic;

  signal comp_in_i          : std_logic_vector(15 downto 0);
  signal comp_in_q          : std_logic_vector(15 downto 0);

  signal fir_in_i           : std_logic_vector(15 downto 0);
  signal fir_in_q           : std_logic_vector(15 downto 0);

  signal flat_in_i          : std_logic_vector(15 downto 0);
  signal flat_in_q          : std_logic_vector(15 downto 0);

  signal flat_out_i         : std_logic_vector(15 downto 0);
  signal flat_out_q         : std_logic_vector(15 downto 0);

  signal gain_in_i          : std_logic_vector(15 downto 0);
  signal gain_in_q          : std_logic_vector(15 downto 0);

  signal gain_out_i         : std_logic_vector(15 downto 0);
  signal gain_out_q         : std_logic_vector(15 downto 0);

  signal dec2_1st_in_valid  : std_logic;
  signal dec2_1st_in_rdy    : std_logic;
  signal dec2_1st_in        : std_logic_vector(31 downto 0);
  signal dec2_1st_out_valid : std_logic;
  signal dec2_1st_out       : std_logic_vector(63 downto 0);

  signal dec2_2nd_in_valid  : std_logic;
  signal dec2_2nd_in_rdy    : std_logic;
  signal dec2_2nd_in_i      : std_logic_vector(15 downto 0);
  signal dec2_2nd_in_q      : std_logic_vector(15 downto 0);
  signal dec2_2nd_in        : std_logic_vector(31 downto 0);
  signal dec2_2nd_out_valid : std_logic;
  signal dec2_2nd_out       : std_logic_vector(63 downto 0);

  signal fifo_in            : std_logic_vector(31 downto 0);
  signal fifo_out           : std_logic_vector(31 downto 0);
  signal fifo_rd_en         : std_logic;
  signal fifo_in_valid      : std_logic;

  signal fir_out_i          : std_logic_vector(15 downto 0);
  signal fir_out_q          : std_logic_vector(15 downto 0);

  signal comp_in_a          : std_logic_vector(31 downto 0);
  signal comp_in_b          : std_logic_vector(31 downto 0);
  signal comp_in_valid      : std_logic;
  signal comp_out           : std_logic_vector(79 downto 0);
  signal comp_out_valid     : std_logic;

  signal pow_i              : std_logic_vector(15 downto 0);
  signal pow_q              : std_logic_vector(15 downto 0);

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


rst_122p88  <= not rst_n_122p88;
rst_491p52  <= not rst_n_491p52;


process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    path_en_s0    <= path_en;
    path_en_s1    <= path_en_s0;
    if ( path_en_s1 = '1' ) then
        comp_in_i   <= din_i;
        comp_in_q   <= din_q;
    else
        comp_in_i   <= (others=>'0');
        comp_in_q   <= (others=>'0');
    end if;
end if;
end process;


process (clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( rst_n_491p52 = '0') then
        comp_in_a     <= (others =>'0');
        comp_in_b     <= (others =>'0');
        comp_in_valid <= '0';
    else
        if ( dds_valid = '1' ) then
            comp_in_a     <= comp_in_q & comp_in_i;
            comp_in_b     <= dds_data;
            comp_in_valid <= '1';
        else
            comp_in_valid <= '0';
        end if;
    end if;
end if;
end process;

nco_comp : entity work.mult_comp
  port map (
    aclk               => clk_491p52     , --: in  std_logic;
    aresetn            => rst_n_491p52   , --: in  std_logic;
    s_axis_a_tvalid    => comp_in_valid  , --: in  std_logic;
    s_axis_a_tdata     => comp_in_a      , --: in  std_logic_vector(31 downto 0);
    s_axis_b_tvalid    => comp_in_valid  , --: in  std_logic;
    s_axis_b_tdata     => comp_in_b      , --: in  std_logic_vector(31 downto 0);
    m_axis_dout_tvalid => comp_out_valid , --: out std_logic;
    m_axis_dout_tdata  => comp_out       );--: out std_logic_vector(79 downto 0)

process (clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (dec2_1st_in_rdy = '1') then
        fir_in_q          <= comp_out(72) & comp_out(66 downto 52) + comp_out(51);
        fir_in_i          <= comp_out(32) & comp_out(26 downto 12) + comp_out(11);
        dec2_1st_in_valid <= comp_out_valid;
    end if;
end if;
end process;

dec2_1st_in <= fir_in_q & fir_in_i;

dec2_1st : entity work.fir_dec2_491p52
 port map(
    aresetn            => rst_n_491p52       , --: in  std_logic;
    aclk               => clk_491p52         , --: in  std_logic;
    s_axis_data_tvalid => dec2_1st_in_valid  , --: in  std_logic;
    s_axis_data_tready => dec2_1st_in_rdy    , --: out std_logic;
    s_axis_data_tdata  => dec2_1st_in        , --: in  std_logic_vector(31 downto 0);
    m_axis_data_tvalid => dec2_1st_out_valid , --: out std_logic;
    m_axis_data_tdata  => dec2_1st_out       );  --: out std_logic_vector(63 downto 0)

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if (dec2_2nd_in_rdy = '1') then
        dec2_2nd_in_i     <= dec2_1st_out(31) & dec2_1st_out(29 downto 15) + dec2_1st_out(14);
        dec2_2nd_in_q     <= dec2_1st_out(63) & dec2_1st_out(61 downto 47) + dec2_1st_out(46);
        dec2_2nd_in_valid <= dec2_1st_out_valid;
    end if;
end if;
end process;

dec2_2nd_in <= dec2_2nd_in_q & dec2_2nd_in_i;

dec2_2nd : entity work.fir_dec2_245p76
 port map(
    aresetn            => rst_n_491p52       ,  --: in  std_logic;
    aclk               => clk_491p52         ,  --: in  std_logic;
    s_axis_data_tvalid => dec2_2nd_in_valid  ,  --: in  std_logic;
    s_axis_data_tready => dec2_2nd_in_rdy    ,  --: out std_logic;
    s_axis_data_tdata  => dec2_2nd_in        ,  --: in  std_logic_vector(31 downto 0);
    m_axis_data_tvalid => dec2_2nd_out_valid ,  --: out std_logic;
    m_axis_data_tdata  => dec2_2nd_out       ); --: out std_logic_vector(63 downto 0)

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    fir_out_i     <= dec2_2nd_out(31) & dec2_2nd_out(29 downto 15) + dec2_2nd_out(14);
    fir_out_q     <= dec2_2nd_out(63) & dec2_2nd_out(61 downto 47) + dec2_2nd_out(46);
    fifo_in_valid <= dec2_2nd_out_valid;
end if;
end process;

-- fir_out_cdc_i : xpm_cdc_array_single
 -- generic map (
   -- DEST_SYNC_FF   => 2  ,
   -- INIT_SYNC_FF   => 0  ,
   -- SIM_ASSERT_CHK => 0  ,
   -- SRC_INPUT_REG  => 1  ,
   -- WIDTH          => 16 )
 -- port map (
   -- dest_out => flat_in_i  ,
   -- dest_clk => clk_122p88 ,
   -- src_clk  => clk_491p52 ,
   -- src_in   => fir_out_i  );

-- fir_out_cdc_q : xpm_cdc_array_single
 -- generic map (
   -- DEST_SYNC_FF   => 2  ,
   -- INIT_SYNC_FF   => 0  ,
   -- SIM_ASSERT_CHK => 0  ,
   -- SRC_INPUT_REG  => 1  ,
   -- WIDTH          => 16 )
 -- port map (
   -- dest_out => flat_in_q  ,
   -- dest_clk => clk_122p88 ,
   -- src_clk  => clk_491p52 ,
   -- src_in   => fir_out_q  );
   
fifo_in <= fir_out_q & fir_out_i;

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_491p52				, --: IN STD_LOGIC;
    wr_clk 					=> clk_491p52				, --: IN STD_LOGIC;
	rd_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    rd_clk 					=> clk_122p88				, --: IN STD_LOGIC;
    din    					=> fifo_in					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> fifo_in_valid			, --: IN STD_LOGIC;
    rd_en  					=> fifo_rd_en				, --: IN STD_LOGIC;
    dout   					=> fifo_out					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_n_122p88 = '0') then
        fifo_rd_en  <= '0';
    else
        fifo_rd_en  <= '1';
    end if;
end if;
end process;

flat_in_q <= fifo_out(31 downto 16);
flat_in_i <= fifo_out(15 downto 0);


-- iq_slope : entity work.iq_slope
-- port map(
--     clk    => clk_122p88   , --: in  std_logic;
--     rst_n  => rst_n_122p88 , --: in  std_logic;
--     din_i  => flat_in_i    , --: in  std_logic_vector(15 downto 0);
--     din_q  => flat_in_q    , --: in  std_logic_vector(15 downto 0);
--     slope  => slope        , --: in  std_logic_vector(15 downto 0);
--     curve  => curve        , --: in  std_logic_vector(15 downto 0);
--     dout_i => flat_out_i   , --: out std_logic_vector(15 downto 0);
--     dout_q => flat_out_q   ); --: out std_logic_vector(15 downto 0)

--gain_in_i   <= flat_out_i;
--gain_in_q   <= flat_out_q;

gain_in_i   <= flat_in_i;
gain_in_q   <= flat_in_q;

out_gain_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk_122p88  , --: in  std_logic;
    gain    => output_gain , --: in  std_logic_vector(15 downto 0);
    din     => gain_in_i   , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_i  ); --: out std_logic_vector(15 downto 0)

out_gain_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk_122p88  , --: in  std_logic;
    gain    => output_gain , --: in  std_logic_vector(15 downto 0);
    din     => gain_in_q   , --: in  std_logic_vector(15 downto 0);
    dout    => gain_out_q  ); --: out std_logic_vector(15 downto 0)

--process(clk_122p88)
--begin
--if rising_edge(clk_122p88) then
--    if (pow_sel = x"0") then
--        pow_i <= gain_out_i;
--        pow_q <= gain_out_q;
--    elsif (pow_sel = x"1") then
--        pow_i <= fir_in_i;
--        pow_q <= fir_in_q;
--    elsif (pow_sel = x"2") then
--        pow_i <= dec2_2nd_in_i;
--        pow_q <= dec2_2nd_in_q;
--    elsif (pow_sel = x"3") then
--        pow_i <= fir_out_i;
--        pow_q <= fir_out_q;
--    end if;
--end if;
--end process;

 pow_i <= gain_out_i;
 pow_q <= gain_out_q;


out_pow_mea : entity work.pow_mea_tdd_u
 generic map(
    clock_frequency => 122_880        , -- system clock frequency in khz 7_680, 15_360, 30_720, 61_440, 122_880, 245_760, 491_520
    unit_frequency  => 61_440         , -- unit clock frequency in khz 7_680, 5_760
    tdd_period      => 5_000          , -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   => 1_142          , -- tdd_high_time(us) 3_857, 1_142
    check_time      => 20_000         ) -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
 port map(
    clk             => clk_122p88     , --: in  std_logic;
    clk_unit        => clk_61p44      , --: in  std_logic;
    clk_tdd         => clk_122p88     , --: in  std_logic;
    reset_n         => rst_n_122p88   , --: in  std_logic;
    tdd_sync        => tdd_sync       , --: in  std_logic;
    din_i           => pow_i          , --: in  std_logic_vector(15 downto 0);
    din_q           => pow_q          , --: in  std_logic_vector(15 downto 0);
    din_vld         => '1'            , --: in  std_logic;
    chk_en          => '1'            , --: in  std_logic;
    power           => out_pow        , --: out std_logic_vector(31 downto 0);
    peak_power      => out_peak       ); --: out std_logic_vector(31 downto 0)

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    dout_i    <= gain_out_i;
    dout_q    <= gain_out_q;
end if;
end process;


end beh;

