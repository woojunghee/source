library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;

--
--2
entity adder_alc_tb is
end;

architecture bench of adder_alc_tb is

  component adder_alc
      port (
      clk : in std_logic;
      reset : in std_logic;
      din_a : in std_logic_vector(15 downto 0);
      din_b : in std_logic_vector(15 downto 0);
      sum_out : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk     : std_logic;
  signal reset   : std_logic;
  signal din_a   : std_logic_vector(15 downto 0);
  signal din_b   : std_logic_vector(15 downto 0);
  signal sum_out : std_logic_vector(15 downto 0);

begin

  adder_alc_inst : adder_alc
    port map (
      clk     => clk,
      reset   => reset,
      din_a   => din_a,
      din_b   => din_b,
      sum_out => sum_out
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
        din_a   <= (others=> '0');
        din_b   <= (others=> '0');
   else
        din_a <= (others=> '1');
        din_b <= din_b + '1';
   end if;
end if;
end process;


end;
