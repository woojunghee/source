----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2017/06/26 16:51:48
-- Design Name:
-- Module Name: blk_reset - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity l1_reset_dly is
 Port (
	  clk_25m					:  in std_logic;

	  l1_reset_in	        	:  in std_logic;
	  l1_reset_out				: out std_logic
	  );
end l1_reset_dly;

architecture Behavioral of l1_reset_dly is

signal cnt_l1_rst			: integer range 0 to 12500255:= 0 ;	-- 500 ms
signal l1_reset_reg			: std_logic;


begin

process(clk_25m)
begin
if rising_edge(clk_25m) then
	if (l1_reset_in = '0') then
		l1_reset_reg <= '1';
		cnt_l1_rst	 <= 0;
	else
		if(cnt_l1_rst = 12500255) then
			cnt_l1_rst	<= 12500255;
			l1_reset_reg	<= '1';
		elsif(cnt_l1_rst = 12499999) then
			cnt_l1_rst	<= cnt_l1_rst + 1;
			l1_reset_reg	<= '0';
		else
			cnt_l1_rst	<= cnt_l1_rst + 1;
		end if;
	end if;
end if;
end process;

l1_reset_out <= l1_reset_reg;

end Behavioral;
