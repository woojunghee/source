

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mxl_ctrl_tb is
end;

architecture bench of mxl_ctrl_tb is

  component mxl_ctrl
      port (
      clk_122p88    : in  std_logic;
      loc_clk       : in  std_logic;
      rst           : in  std_logic;
      tdd_sync_dl   : in  std_logic;
      tdd_sync_ul   : in  std_logic;
      tx_en         : in  std_logic_vector(3 downto 0);
      rx_en         : in  std_logic_vector(3 downto 0);
      tdd_mode      : in  std_logic_vector(1 downto 0);
      cal_mode      : in  std_logic_vector(1 downto 0);
      fbsel_mode    : in  std_logic_vector(1 downto 0);
      mxl_tx_en     : out std_logic_vector(3 downto 0);
      mxl_rx_en     : out std_logic_vector(3 downto 0);
      mxl_fb_en     : out std_logic_vector(1 downto 0);
      mxl_fbrx_cal  : out std_logic;
      mxl_fb_sw     : out std_logic_vector(1 downto 0);
      fb_ona        : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period        : time                          := 8.138 ns; --122.88
  constant clk_100_period    : time := 10 ns;
  -- Generics

  -- Ports
  signal clk           : std_logic;
  signal clk_100       : std_logic;
  signal rst           : std_logic;
  signal tdd_sync_dl   : std_logic;
  signal tdd_sync_ul   : std_logic;
  signal tx_en         : std_logic_vector(3 downto 0):= "1111";
  signal rx_en         : std_logic_vector(3 downto 0):= "1111";
  signal tdd_mode      : std_logic_vector(1 downto 0):= "11";
  signal cal_mode      : std_logic_vector(1 downto 0):= "11";
  signal fbsel_mode    : std_logic_vector(1 downto 0):= "11";
  signal mxl_tx_en     : std_logic_vector(3 downto 0);
  signal mxl_rx_en     : std_logic_vector(3 downto 0);
  signal mxl_fb_en     : std_logic_vector(1 downto 0);
  signal mxl_fbrx_cal  : std_logic;
  signal mxl_fb_sw     : std_logic_vector(1 downto 0);
  signal fb_ona        : std_logic;
  signal tdd_cnt       : integer range 0 to 614399;
  signal tdd_sync      : std_logic;


begin

  mxl_ctrl_inst : mxl_ctrl
    port map (
      clk_122p88   => clk,
      loc_clk      => clk_100,
      rst          => rst,
      tdd_sync_dl  => tdd_sync_dl,
      tdd_sync_ul  => tdd_sync_ul,
      tx_en        => tx_en,
      rx_en        => rx_en,
      tdd_mode     => tdd_mode,
      cal_mode     => cal_mode,
      fbsel_mode   => fbsel_mode,
      mxl_tx_en    => mxl_tx_en,
      mxl_rx_en    => mxl_rx_en,
      mxl_fb_en    => mxl_fb_en,
      mxl_fbrx_cal => mxl_fbrx_cal,
      mxl_fb_sw    => mxl_fb_sw,
      fb_ona       => fb_ona
    );

   rst <=  '1' after      0 ns,
           '0' after     100 ns;


   clk_process : process
   begin
   clk <= '1';
   wait for clk_period/2;
   clk <= '0';
   wait for clk_period/2;
   end process clk_process;

   clk_100_process : process
   begin
    clk_100 <= '1';
   wait for clk_100_period/2;
    clk_100 <= '0';
   wait for clk_100_period/2;
   end process clk_100_process;



process(clk)
begin
if rising_edge(clk) then
    if ( rst = '1' ) then
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

process(clk)
begin
if rising_edge(clk) then
    if (tdd_cnt < 140329) then
        tdd_sync    <= '0';
    else
        tdd_sync    <= '1';
    end if;
end if;
end process;


tdd_sync_dl <= tdd_sync;

tdd_sync_ul <= not tdd_sync;

end;
