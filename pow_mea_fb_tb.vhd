library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pow_mea_fb_tb is
end;

architecture bench of pow_mea_fb_tb is

  component pow_mea_fb_r
    generic (
      clock_frequency : integer;
      check_time : integer
    );
      port (
      clk        : in std_logic;
      loc_clk    : in std_logic;
      reset_n    : in std_logic;
      tdd_sync   : in std_logic;
      din_i      : in std_logic_vector(15 downto 0);
      din_vld    : in std_logic;
      peak_sel   : in std_logic;
      power      : out std_logic_vector(31 downto 0);
      peak_power : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 10 ns;
  constant clk_122p88_period : time := 8.138 ns;
  -- Generics
  constant clock_frequency : integer := 122_880;
  constant check_time : integer := 40;

  -- Ports
  signal rst        : std_logic;
  signal clk        : std_logic;
  signal clk_122p88 : std_logic;
  signal loc_clk    : std_logic;
  signal reset_n    : std_logic;
  signal tdd_sync   : std_logic;
  signal din_i      : std_logic_vector(15 downto 0);
  signal din_vld    : std_logic;
  signal peak_sel   : std_logic := '0';
  signal power      : std_logic_vector(31 downto 0);
  signal peak_power : std_logic_vector(31 downto 0);
  signal tdd_cnt    : integer range 0 to 614399:= 0;

begin

  pow_mea_fb_inst : pow_mea_fb_r
    generic map (
      clock_frequency => clock_frequency,
      check_time      => check_time
    )
    port map (
      clk             => clk_122p88,
      loc_clk         => loc_clk,
      reset_n         => reset_n,
      tdd_sync        => tdd_sync,
      din_i           => din_i,
      din_vld         => din_vld,
      peak_sel        => peak_sel,
      power           => power,
      peak_power      => peak_power
    );


   rst  <=  '1' after      0 ns,
            '0' after      1 us;

reset_n <= not rst;

 clk_process : process
 begin
    loc_clk <= '1';
 wait for clk_period/2;
    loc_clk <= '0';
 wait for clk_period/2;
 end process clk_process;

clk_122p88_process : process
begin
    clk_122p88 <= '1';
wait for clk_122p88_period/2;
    clk_122p88 <= '0';
wait for clk_122p88_period/2;
end process clk_122p88_process;



process(clk_122p88)
begin
if rising_edge(clk_122p88)	 then
	if (rst = '1') then
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
    if ( tdd_cnt = 0) then
        tdd_sync <= '1';
    elsif ( tdd_cnt = 456410) then
        tdd_sync <= '0';
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88)	 then

--    din_vld <= '1';
    din_i   <= x"0005";
end if;
end process;


   din_vld  <=  '1' after      0 ns,
                '0' after      1 ms,
                '1' after      2 ms,
                '0' after     10 ms,
                '1' after     20 ms,
                '0' after    100 ms,
                '1' after    200 ms,
                '0' after    500 ms,
                '1' after    600 ms,
                '0' after    700 ms,
                '1' after   1000 ms,
                '0' after   1100 ms,
                '0' after   1200 ms;


end;
