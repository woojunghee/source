
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity dc_offset_16_n is
port(
	rst_n		: in  std_logic;
	clk			: in  std_logic;
	tdd_sync	: in  std_logic;
	din			: in  std_logic_vector(15 downto 0);
	dout		: out std_logic_vector(15 downto 0)
	);
end dc_offset_16_n;

architecture data of dc_offset_16_n is

signal din_ave		: std_logic_vector(31 downto 0);
signal din_sum		: std_logic_vector(15 downto 0);      
signal din_sum_32	: std_logic_vector(31 downto 0);
signal doff_pow_buff: std_logic_vector(15 downto 0);

begin

process(clk)
begin
if rising_edge(clk) then
	if(rst_n = '0')then                   
		dout 			<= (others => '0');   
		din_ave			<= (others => '0');   
		din_sum			<= (others => '0');   
		doff_pow_buff	<= (others => '0');
	else
		if (tdd_sync = '1') then
			dout 			<= din - doff_pow_buff; 	
			din_sum			<= din - doff_pow_buff;
			din_ave			<= din_ave + din_sum_32;
			doff_pow_buff	<= din_ave(31 downto 16);
		else
			dout 			<= din;			
		end if;
	end if;
end if;
end process;

din_sum_32 <= din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) & din_sum(15) &  din_sum(15) & din_sum(15) & din_sum;


end data;