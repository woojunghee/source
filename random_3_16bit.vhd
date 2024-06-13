library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
Library xpm;
use xpm.vcomponents.all;

entity random_3_16bit is
 port (
	clk             : in  std_logic;
	reset_n         : in  std_logic;
	random          : out std_logic_vector(15 downto 0)
	);
end entity;

 architecture rtl of random_3_16bit is
   signal lfsr       : std_logic_vector (2 downto 0);
   signal feedback   : std_logic;

 begin

feedback <= not(lfsr(2) xor lfsr(1));

process (clk)
begin
if (rising_edge(clk)) then
	if (reset_n = '0') then
		lfsr <= (others => '0');
	else
		lfsr <= lfsr(1 downto 0) & feedback;
	end if;
end if;
end process;

random <= lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr(2) & lfsr;
--random <= "0000000000000" & lfsr;


end rtl;
