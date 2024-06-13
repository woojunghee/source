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
Library xpm;
use xpm.vcomponents.all;


entity reset_blk is
Port (
	clk					: in std_logic;
	mmcm_locked			: in std_logic;
	rst_n				: out std_logic
);
end reset_blk;

architecture Behavioral of reset_blk is

signal cnt_rst			: integer range 0 to 153599;	-- 1ms
signal rst_n_buf		: std_logic;

begin


process(mmcm_locked, clk)
begin
if (mmcm_locked='0') then
	cnt_rst	<= 0;
	rst_n_buf		<= '0';
elsif rising_edge(clk) then
	if(cnt_rst = 153599)then
		cnt_rst	<= 153599;		
		rst_n_buf		<= '1';
	else
		cnt_rst 	<= cnt_rst + 1;
		rst_n_buf		<= '0';
	end if;
end if;
end process;

rst_n <= rst_n_buf;




end Behavioral;
