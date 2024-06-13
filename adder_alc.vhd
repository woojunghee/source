LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity adder_alc is Port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    din_a       : in  std_logic_vector(15 downto 0);
    din_b       : in  std_logic_vector(15 downto 0);
    sum_out     : out std_logic_vector(15 downto 0));
end adder_alc;

architecture Behavioral of adder_alc is

signal sum_tmp   : std_logic_vector(15 downto 0):=(others => '0');

begin

sum_tmp  <= din_a + din_b;

process(clk)
begin
if rising_edge(clk) then
    if reset = '1' then
        sum_out <= (others => '0');
    elsif (din_a(15) =  din_b(15)) then
        if (din_a(15) = sum_tmp(15)) then           -- case 2 : din_a and din_b and their sum have same sign --> no overflow
            sum_out <= sum_tmp;
		else                                        -- case 3 : din_a and din_b have same sign but their sum has different sign --> overflow
			if (din_a(15) = '0') then
				sum_out <= "0111111111111111";
			else
				sum_out <= "1000000000000000";
			end if;
		end if;
	else                                           -- case 1 : din_a and din_b have different sign --> never overflow
		sum_out <= sum_tmp;
	end if;
end if;
end process;


end Behavioral;
