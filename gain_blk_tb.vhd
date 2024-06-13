library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;


entity gain_blk_tb is
end;

architecture bench of gain_blk_tb is

  component GAIN_BLK_16
      port (
      clk : in std_logic;     
      gain : in std_logic_vector(15 downto 0);
      din : in std_logic_vector(15 downto 0);
      dout : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk     : std_logic;
  signal reset   : std_logic;
  signal gain   : std_logic_vector(15 downto 0);
  signal din   : std_logic_vector(15 downto 0);
  signal dout : std_logic_vector(15 downto 0);

begin

  GAIN_BLK_16_inst : GAIN_BLK_16
    port map (
      clk     => clk,
      gain   => gain,
      din   => din,
      dout => dout
    );



   reset<=  '1' after      0 ns,
            '0' after     27 ns;


  clk_process : process
  begin
  clk <= '1';
  wait for clk_period/2;
  clk <= '0';
  wait for clk_period/2;
  end process clk_process;


process(clk)
begin
if rising_edge(clk) then
   if reset = '1' then
        gain   <= (others=> '0');
        din   <= (others=> '0');
   else
        gain <= x"0ff6";
        din <= "0000100000000000";
   end if;
end if;
end process;


end;
