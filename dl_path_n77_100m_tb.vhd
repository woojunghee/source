library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity dl_path_n77_100m_tb is
end;

architecture bench of dl_path_n77_100m_tb is

  component dl_path_n77_100m
      port (
      clk_491p52      : in std_logic;
      clk_122p88      : in std_logic;
      clk_61p44       : in std_logic;
      clk_100         : in std_logic;
      rst_n           : in std_logic;
      tdd_sync        : in std_logic;
      delay_dk        : in std_logic_vector(14 downto 0);
      delay_rs        : in std_logic_vector(14 downto 0);
      dcm_din_i       : in arr_4_16_stdlogic;
      dcm_din_q       : in arr_4_16_stdlogic;
      dcm_in_pow      : out arr_4_32_stdlogic;
      dcm_in_peak     : out arr_4_32_stdlogic;
      dcm_path_en     : in std_logic_vector(MIMO_NUM downto 0);
      dcm_input_gain  : in arr_4_16_stdlogic;
      dcm_slope       : in arr_4_16_stdlogic;
      dcm_curve       : in arr_4_16_stdlogic;
      kddi_din_i      : in arr_4_16_stdlogic;
      kddi_din_q      : in arr_4_16_stdlogic;
      kddi_in_pow     : out arr_4_32_stdlogic;
      kddi_in_peak    : out arr_4_32_stdlogic;
      kddi_path_en    : in std_logic_vector(MIMO_NUM downto 0);
      kddi_input_gain : in arr_4_16_stdlogic;
      kddi_slope      : in arr_4_16_stdlogic;
      kddi_curve      : in arr_4_16_stdlogic;
      rm_din_i        : in arr_4_16_stdlogic;
      rm_din_q        : in arr_4_16_stdlogic;
      rm_in_pow       : out arr_4_32_stdlogic;
      rm_in_peak      : out arr_4_32_stdlogic;
      rm_path_en      : in std_logic_vector(MIMO_NUM downto 0);
      rm_input_gain   : in arr_4_16_stdlogic;
      rm_slope        : in arr_4_16_stdlogic;
      rm_curve        : in arr_4_16_stdlogic;
      sb_din_i        : in arr_4_16_stdlogic;
      sb_din_q        : in arr_4_16_stdlogic;
      sb_in_pow       : out arr_4_32_stdlogic;
      sb_in_peak      : out arr_4_32_stdlogic;
      sb_path_en      : in std_logic_vector(MIMO_NUM downto 0);
      sb_input_gain   : in arr_4_16_stdlogic;
      sb_slope        : in arr_4_16_stdlogic;
      sb_curve        : in arr_4_16_stdlogic;
      axi_rst_n       : in std_logic;
      axi_cfr_awvalid : in std_logic;
      axi_cfr_awready : out std_logic;
      axi_cfr_awaddr  : in std_logic_vector(31 downto 0);
      axi_cfr_wvalid  : in std_logic;
      axi_cfr_wready  : out std_logic;
      axi_wdata       : in std_logic_vector(31 downto 0);
      axi_cfr_bvalid  : out std_logic;
      axi_bready      : in std_logic;
      axi_bresp       : out std_logic_vector(1 downto 0);
      axi_cfr_araddr  : in std_logic_vector(31 downto 0);
      axi_cfr_arvalid : in std_logic;
      axi_cfr_aready  : out std_logic;
      axi_cfr_rvalid  : out std_logic;
      axi_rready      : in std_logic;
      axi_rresp       : out std_logic_vector(1 downto 0);
      axi_cfr_rdata   : out std_logic_vector(31 downto 0);
      dpd_gain        : in arr_4_16_stdlogic;
      dpd_in_rdy      : in std_logic;
      dpd_in          : out std_logic_vector(255 downto 0);
      dpd_in_valid    : out std_logic;
      dpd_out_rdy     : out std_logic;
      dpd_out_valid   : in std_logic;
      dpd_out         : in std_logic_vector(255 downto 0);
      output_gain     : in arr_4_16_stdlogic;
      pow_sel         : in std_logic_vector( 3 downto 0);
      out_power       : out arr_4_32_stdlogic;
      out_peak        : out arr_4_32_stdlogic;
      dout_s0_i       : out arr_4_16_stdlogic;
      dout_s0_q       : out arr_4_16_stdlogic;
      dout_s1_i       : out arr_4_16_stdlogic;
      dout_s1_q       : out arr_4_16_stdlogic
    );
  end component;

  -- Clock period

  constant clk_122p88_period : time := 8.138 ns;
  constant clk_491p52_period : time := 2.034 ns;
  constant clk_61p44_period  : time := 16.276 ns;
  constant clk_100_period    : time := 10 ns;
  -- Generics

  -- Ports
  signal clk_491p52      : std_logic;
  signal clk_122p88      : std_logic;
  signal clk_61p44       : std_logic;
  signal clk_100         : std_logic;
  signal rst_n           : std_logic;
  signal tdd_sync        : std_logic;
  signal delay_dk        : std_logic_vector(14 downto 0);
  signal delay_rs        : std_logic_vector(14 downto 0);
  signal dcm_din_i       : arr_4_16_stdlogic;
  signal dcm_din_q       : arr_4_16_stdlogic;
  signal dcm_in_pow      : arr_4_32_stdlogic;
  signal dcm_in_peak     : arr_4_32_stdlogic;
  signal dcm_path_en     : std_logic_vector(MIMO_NUM downto 0);
  signal dcm_input_gain  : arr_4_16_stdlogic;
  signal dcm_slope       : arr_4_16_stdlogic;
  signal dcm_curve       : arr_4_16_stdlogic;
  signal kddi_din_i      : arr_4_16_stdlogic;
  signal kddi_din_q      : arr_4_16_stdlogic;
  signal kddi_in_pow     : arr_4_32_stdlogic;
  signal kddi_in_peak    : arr_4_32_stdlogic;
  signal kddi_path_en    : std_logic_vector(MIMO_NUM downto 0);
  signal kddi_input_gain : arr_4_16_stdlogic;
  signal kddi_slope      : arr_4_16_stdlogic;
  signal kddi_curve      : arr_4_16_stdlogic;
  signal rm_din_i        : arr_4_16_stdlogic;
  signal rm_din_q        : arr_4_16_stdlogic;
  signal rm_in_pow       : arr_4_32_stdlogic;
  signal rm_in_peak      : arr_4_32_stdlogic;
  signal rm_path_en      : std_logic_vector(MIMO_NUM downto 0);
  signal rm_input_gain   : arr_4_16_stdlogic;
  signal rm_slope        : arr_4_16_stdlogic;
  signal rm_curve        : arr_4_16_stdlogic;
  signal sb_din_i        : arr_4_16_stdlogic;
  signal sb_din_q        : arr_4_16_stdlogic;
  signal sb_in_pow       : arr_4_32_stdlogic;
  signal sb_in_peak      : arr_4_32_stdlogic;
  signal sb_path_en      : std_logic_vector(MIMO_NUM downto 0);
  signal sb_input_gain   : arr_4_16_stdlogic;
  signal sb_slope        : arr_4_16_stdlogic;
  signal sb_curve        : arr_4_16_stdlogic;
  signal axi_rst_n       : std_logic;
  signal axi_cfr_awvalid : std_logic;
  signal axi_cfr_awready : std_logic;
  signal axi_cfr_awaddr  : std_logic_vector(31 downto 0);
  signal axi_cfr_wvalid  : std_logic;
  signal axi_cfr_wready  : std_logic;
  signal axi_wdata       : std_logic_vector(31 downto 0);
  signal axi_cfr_bvalid  : std_logic;
  signal axi_bready      : std_logic;
  signal axi_bresp       : std_logic_vector(1 downto 0);
  signal axi_cfr_araddr  : std_logic_vector(31 downto 0);
  signal axi_cfr_arvalid : std_logic;
  signal axi_cfr_aready  : std_logic;
  signal axi_cfr_rvalid  : std_logic;
  signal axi_rready      : std_logic;
  signal axi_rresp       : std_logic_vector(1 downto 0);
  signal axi_cfr_rdata   : std_logic_vector(31 downto 0);
  signal dpd_gain        : arr_4_16_stdlogic;
  signal dpd_in_rdy      : std_logic;
  signal dpd_in          : std_logic_vector(255 downto 0);
  signal dpd_in_valid    : std_logic;
  signal dpd_out_rdy     : std_logic;
  signal dpd_out_valid   : std_logic;
  signal dpd_out         : std_logic_vector(255 downto 0);
  signal output_gain     : arr_4_16_stdlogic;
  signal pow_sel         : std_logic_vector( 3 downto 0);
  signal out_power       : arr_4_32_stdlogic;
  signal out_peak        : arr_4_32_stdlogic;
  signal dout_s0_i       : arr_4_16_stdlogic;
  signal dout_s0_q       : arr_4_16_stdlogic;
  signal dout_s1_i       : arr_4_16_stdlogic;
  signal dout_s1_q       : arr_4_16_stdlogic;

  signal tdd_cnt             : integer range 0 to 614399;

begin

  dl_path_n77_100m_inst : dl_path_n77_100m
    port map (
      clk_491p52      => clk_491p52,
      clk_122p88      => clk_122p88,
      clk_61p44       => clk_61p44,
      clk_100         => clk_100,
      rst_n           => rst_n,
      tdd_sync        => tdd_sync,
      delay_dk        => delay_dk,
      delay_rs        => delay_rs,
      dcm_din_i       => dcm_din_i,
      dcm_din_q       => dcm_din_q,
      dcm_in_pow      => dcm_in_pow,
      dcm_in_peak     => dcm_in_peak,
      dcm_path_en     => dcm_path_en,
      dcm_input_gain  => dcm_input_gain,
      dcm_slope       => dcm_slope,
      dcm_curve       => dcm_curve,
      kddi_din_i      => kddi_din_i,
      kddi_din_q      => kddi_din_q,
      kddi_in_pow     => kddi_in_pow,
      kddi_in_peak    => kddi_in_peak,
      kddi_path_en    => kddi_path_en,
      kddi_input_gain => kddi_input_gain,
      kddi_slope      => kddi_slope,
      kddi_curve      => kddi_curve,
      rm_din_i        => rm_din_i,
      rm_din_q        => rm_din_q,
      rm_in_pow       => rm_in_pow,
      rm_in_peak      => rm_in_peak,
      rm_path_en      => rm_path_en,
      rm_input_gain   => rm_input_gain,
      rm_slope        => rm_slope,
      rm_curve        => rm_curve,
      sb_din_i        => sb_din_i,
      sb_din_q        => sb_din_q,
      sb_in_pow       => sb_in_pow,
      sb_in_peak      => sb_in_peak,
      sb_path_en      => sb_path_en,
      sb_input_gain   => sb_input_gain,
      sb_slope        => sb_slope,
      sb_curve        => sb_curve,
      axi_rst_n       => axi_rst_n,
      axi_cfr_awvalid => axi_cfr_awvalid,
      axi_cfr_awready => axi_cfr_awready,
      axi_cfr_awaddr  => axi_cfr_awaddr,
      axi_cfr_wvalid  => axi_cfr_wvalid,
      axi_cfr_wready  => axi_cfr_wready,
      axi_wdata       => axi_wdata,
      axi_cfr_bvalid  => axi_cfr_bvalid,
      axi_bready      => axi_bready,
      axi_bresp       => axi_bresp,
      axi_cfr_araddr  => axi_cfr_araddr,
      axi_cfr_arvalid => axi_cfr_arvalid,
      axi_cfr_aready  => axi_cfr_aready,
      axi_cfr_rvalid  => axi_cfr_rvalid,
      axi_rready      => axi_rready,
      axi_rresp       => axi_rresp,
      axi_cfr_rdata   => axi_cfr_rdata,
      dpd_gain        => dpd_gain,
      dpd_in_rdy      => dpd_in_rdy,
      dpd_in          => dpd_in,
      dpd_in_valid    => dpd_in_valid,
      dpd_out_rdy     => dpd_out_rdy,
      dpd_out_valid   => dpd_out_valid,
      dpd_out         => dpd_out,
      output_gain     => output_gain,
      pow_sel         => pow_sel,
      out_power       => out_power,
      out_peak        => out_peak,
      dout_s0_i       => dout_s0_i,
      dout_s0_q       => dout_s0_q,
      dout_s1_i       => dout_s1_i,
      dout_s1_q       => dout_s1_q
    );

   rst_n <=  '0' after      0 ns,
             '1' after     100 ns;

   axi_rst_n <=  '0' after      0 ns,
                 '1' after     100 ns;



   clk_100_process : process
   begin
    clk_100 <= '1';
   wait for clk_100_period/2;
    clk_100 <= '0';
   wait for clk_100_period/2;
   end process clk_100_process;

   clk_61p44_process : process
   begin
    clk_61p44 <= '1';
   wait for clk_61p44_period/2;
    clk_61p44 <= '0';
   wait for clk_61p44_period/2;
   end process clk_61p44_process;

   clk_122p88_process : process
   begin
    clk_122p88 <= '1';
   wait for clk_122p88_period/2;
    clk_122p88 <= '0';
   wait for clk_122p88_period/2;
   end process clk_122p88_process;

   clk_491p52_process : process
   begin
    clk_491p52 <= '1';
   wait for clk_491p52_period/2;
    clk_491p52 <= '0';
   wait for clk_491p52_period/2;
   end process clk_491p52_process;



process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( rst_n = '0' ) then
        delay_dk          <= "000000000000001";
        delay_rs          <= "000000000000001";
        dcm_din_i(0)      <= x"0000";
        dcm_din_i(1)      <= x"0000";
        dcm_din_i(2)      <= x"0000";
        dcm_din_i(3)      <= x"0000";
        dcm_din_q(0)      <= x"0000";
        dcm_din_q(1)      <= x"0000";
        dcm_din_q(2)      <= x"0000";
        dcm_din_q(3)      <= x"0000";
        dcm_path_en       <= "0000";
        dcm_input_gain(0) <= x"0000";
        dcm_input_gain(1) <= x"0000";
        dcm_input_gain(2) <= x"0000";
        dcm_input_gain(3) <= x"0000";
        dcm_slope(0)      <= x"0000";
        dcm_slope(1)      <= x"0000";
        dcm_slope(2)      <= x"0000";
        dcm_slope(3)      <= x"0000";
        dcm_curve(0)      <= x"0000";
        dcm_curve(1)      <= x"0000";
        dcm_curve(2)      <= x"0000";
        dcm_curve(3)      <= x"0000";

        kddi_din_i(0)      <= x"0000";
        kddi_din_i(1)      <= x"0000";
        kddi_din_i(2)      <= x"0000";
        kddi_din_i(3)      <= x"0000";
        kddi_din_q(0)      <= x"0000";
        kddi_din_q(1)      <= x"0000";
        kddi_din_q(2)      <= x"0000";
        kddi_din_q(3)      <= x"0000";
        kddi_path_en       <= "0000";
        kddi_input_gain(0) <= x"0000";
        kddi_input_gain(1) <= x"0000";
        kddi_input_gain(2) <= x"0000";
        kddi_input_gain(3) <= x"0000";
        kddi_slope(0)      <= x"0000";
        kddi_slope(1)      <= x"0000";
        kddi_slope(2)      <= x"0000";
        kddi_slope(3)      <= x"0000";
        kddi_curve(0)      <= x"0000";
        kddi_curve(1)      <= x"0000";
        kddi_curve(2)      <= x"0000";
        kddi_curve(3)      <= x"0000";


        rm_din_i(0)      <= x"0000";
        rm_din_i(1)      <= x"0000";
        rm_din_i(2)      <= x"0000";
        rm_din_i(3)      <= x"0000";
        rm_din_q(0)      <= x"0000";
        rm_din_q(1)      <= x"0000";
        rm_din_q(2)      <= x"0000";
        rm_din_q(3)      <= x"0000";
        rm_path_en       <= "0000";
        rm_input_gain(0) <= x"0000";
        rm_input_gain(1) <= x"0000";
        rm_input_gain(2) <= x"0000";
        rm_input_gain(3) <= x"0000";
        rm_slope(0)      <= x"0000";
        rm_slope(1)      <= x"0000";
        rm_slope(2)      <= x"0000";
        rm_slope(3)      <= x"0000";
        rm_curve(0)      <= x"0000";
        rm_curve(1)      <= x"0000";
        rm_curve(2)      <= x"0000";
        rm_curve(3)      <= x"0000";


        sb_din_i(0)      <= x"0000";
        sb_din_i(1)      <= x"0000";
        sb_din_i(2)      <= x"0000";
        sb_din_i(3)      <= x"0000";
        sb_din_q(0)      <= x"0000";
        sb_din_q(1)      <= x"0000";
        sb_din_q(2)      <= x"0000";
        sb_din_q(3)      <= x"0000";
        sb_path_en       <= "0000";
        sb_input_gain(0) <= x"0000";
        sb_input_gain(1) <= x"0000";
        sb_input_gain(2) <= x"0000";
        sb_input_gain(3) <= x"0000";
        sb_slope(0)      <= x"0000";
        sb_slope(1)      <= x"0000";
        sb_slope(2)      <= x"0000";
        sb_slope(3)      <= x"0000";
        sb_curve(0)      <= x"0000";
        sb_curve(1)      <= x"0000";
        sb_curve(2)      <= x"0000";
        sb_curve(3)      <= x"0000";

        dpd_gain(0)       <= x"0000";
        dpd_gain(1)       <= x"0000";
        dpd_gain(2)       <= x"0000";
        dpd_gain(3)       <= x"0000";
        pow_sel           <= x"0";
        dpd_in_rdy        <= '0';

    else
        delay_dk          <= "000000000000000";
        delay_rs          <= "000000000000000";
        dcm_din_i(0)      <= x"0800";
        dcm_din_i(1)      <= x"0800";
        dcm_din_i(2)      <= x"0800";
        dcm_din_i(3)      <= x"0800";
        dcm_din_q(0)      <= x"0800";
        dcm_din_q(1)      <= x"0800";
        dcm_din_q(2)      <= x"0800";
        dcm_din_q(3)      <= x"0800";
        dcm_path_en       <= "1111";
        dcm_input_gain(0) <= x"0800";
        dcm_input_gain(1) <= x"0800";
        dcm_input_gain(2) <= x"0800";
        dcm_input_gain(3) <= x"0800";
        dcm_slope(0)      <= x"0000";
        dcm_slope(1)      <= x"0000";
        dcm_slope(2)      <= x"0000";
        dcm_slope(3)      <= x"0000";
        dcm_curve(0)      <= x"0000";
        dcm_curve(1)      <= x"0000";
        dcm_curve(2)      <= x"0000";
        dcm_curve(3)      <= x"0000";

        kddi_din_i(0)      <= x"0800";
        kddi_din_i(1)      <= x"0800";
        kddi_din_i(2)      <= x"0800";
        kddi_din_i(3)      <= x"0800";
        kddi_din_q(0)      <= x"0800";
        kddi_din_q(1)      <= x"0800";
        kddi_din_q(2)      <= x"0800";
        kddi_din_q(3)      <= x"0800";
        kddi_path_en       <= "1111";
        kddi_input_gain(0) <= x"0800";
        kddi_input_gain(1) <= x"0800";
        kddi_input_gain(2) <= x"0800";
        kddi_input_gain(3) <= x"0800";
        kddi_slope(0)      <= x"0000";
        kddi_slope(1)      <= x"0000";
        kddi_slope(2)      <= x"0000";
        kddi_slope(3)      <= x"0000";
        kddi_curve(0)      <= x"0000";
        kddi_curve(1)      <= x"0000";
        kddi_curve(2)      <= x"0000";
        kddi_curve(3)      <= x"0000";

        rm_din_i(0)      <= x"0800";
        rm_din_i(1)      <= x"0800";
        rm_din_i(2)      <= x"0800";
        rm_din_i(3)      <= x"0800";
        rm_din_q(0)      <= x"0800";
        rm_din_q(1)      <= x"0800";
        rm_din_q(2)      <= x"0800";
        rm_din_q(3)      <= x"0800";
        rm_path_en       <= "1111";
        rm_input_gain(0) <= x"0800";
        rm_input_gain(1) <= x"0800";
        rm_input_gain(2) <= x"0800";
        rm_input_gain(3) <= x"0800";
        rm_slope(0)      <= x"0000";
        rm_slope(1)      <= x"0000";
        rm_slope(2)      <= x"0000";
        rm_slope(3)      <= x"0000";
        rm_curve(0)      <= x"0000";
        rm_curve(1)      <= x"0000";
        rm_curve(2)      <= x"0000";
        rm_curve(3)      <= x"0000";

        sb_din_i(0)      <= x"0800";
        sb_din_i(1)      <= x"0800";
        sb_din_i(2)      <= x"0800";
        sb_din_i(3)      <= x"0800";
        sb_din_q(0)      <= x"0800";
        sb_din_q(1)      <= x"0800";
        sb_din_q(2)      <= x"0800";
        sb_din_q(3)      <= x"0800";
        sb_path_en       <= "1111";
        sb_input_gain(0) <= x"0800";
        sb_input_gain(1) <= x"0800";
        sb_input_gain(2) <= x"0800";
        sb_input_gain(3) <= x"0800";
        sb_slope(0)      <= x"0000";
        sb_slope(1)      <= x"0000";
        sb_slope(2)      <= x"0000";
        sb_slope(3)      <= x"0000";
        sb_curve(0)      <= x"0000";
        sb_curve(1)      <= x"0000";
        sb_curve(2)      <= x"0000";
        sb_curve(3)      <= x"0000";

        dpd_gain(0)       <= x"0800";
        dpd_gain(1)       <= x"0800";
        dpd_gain(2)       <= x"0800";
        dpd_gain(3)       <= x"0800";
        pow_sel           <= x"4";
        dpd_in_rdy        <= '1';
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if ( rst_n = '0' ) then
        tdd_cnt <= 0;
    else
        if (tdd_cnt = 614399) then
            tdd_cnt <= 0;
        else
            tdd_cnt <= tdd_cnt + 1;
        end if;
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (tdd_cnt < 140329) then
        tdd_sync    <= '0';
    else
        tdd_sync    <= '1';
    end if;
end if;
end process;


end;
