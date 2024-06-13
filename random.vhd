library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
Library xpm;
use xpm.vcomponents.all;

entity random is
 port (
	clk             : in  std_logic; 
	reset_n         : in  std_logic;
	rbit_out        : out std_logic
	);
end entity;

 architecture rtl of random is
   signal lfsr       : std_logic_vector (3 downto 0);
   signal feedback   : std_logic;

 begin

feedback <= not(lfsr(3) xor lfsr(2));  

process (clk) 
begin
if (rising_edge(clk)) then
	if (reset_n = '0') then
		lfsr <= (others => '0');
	else
		lfsr <= lfsr(2 downto 0) & feedback;
	end if; 
end if;
end process sr_pr;

rbit_out <= lfsr(3);
  

end rtl;
