library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mxl_mgain_tb is
end;

architecture bench of mxl_mgain_tb is

  component mxl_mgain
      port (
      clk        : in std_logic;
      rst_n      : in std_logic;
      gain_m0    : in std_logic_vector(4 downto 0);
      gain_m1    : in std_logic_vector(4 downto 0);
      gain_m2    : in std_logic_vector(4 downto 0);
      gain_m3    : in std_logic_vector(4 downto 0);
      mgain_clk  : out std_logic;
      mgain_stb  : out std_logic;
      mgain_data : out std_logic_vector(1 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk        : std_logic;
  signal rst_n      : std_logic;
  signal gain_m0    : std_logic_vector(4 downto 0);
  signal gain_m1    : std_logic_vector(4 downto 0);
  signal gain_m2    : std_logic_vector(4 downto 0);
  signal gain_m3    : std_logic_vector(4 downto 0);
  signal mgain_clk  : std_logic;
  signal mgain_stb  : std_logic;
  signal mgain_data : std_logic_vector(1 downto 0);

begin

  mxl_mgain_inst : mxl_mgain
    port map (
      clk        => clk,
      rst_n      => rst_n,
      gain_m0    => gain_m0,
      gain_m1    => gain_m1,
      gain_m2    => gain_m2,
      gain_m3    => gain_m3,
      mgain_clk  => mgain_clk,
      mgain_stb  => mgain_stb,
      mgain_data => mgain_data
    );

   clk_process : process
   begin
   clk <= '1';
   wait for clk_period/2;
   clk <= '0';
   wait for clk_period/2;
   end process clk_process;

   rst_n  <=  '0' after      0 ns,
              '1' after     27 ns;


process(clk)
begin
if rising_edge(clk) then
    gain_m0 <= "11111";
    gain_m1 <= "00001";
    gain_m2 <= "00000";
    gain_m3 <= "11111";
end if;
end process;

end;
