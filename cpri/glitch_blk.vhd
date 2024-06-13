library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
Library UNISIM;
use UNISIM.vCOMPONENTs.all;
Library xpm;
use xpm.vcomponents.all;


entity glitch_blk is 
port(
	i_clk				: in  std_logic;
	i_sel				: in  std_logic;
	i_los				: in  std_logic;
	i_lof				: in  std_logic;
	o_gtreset			: out std_logic);
end glitch_blk;

architecture beh of glitch_blk is

signal los_shift		: std_logic_vector(2 downto 0);
signal sm				: std_logic_vector(3 downto 0);
signal cnt_l 			: integer range 0 to 368640 := 0;
signal cnt_h 			: integer range 0 to 60 := 0;
signal gtreset_s		: std_logic;

begin

o_gtreset <= gtreset_s when i_sel = '1' else '0';

process(i_clk)
begin
    if rising_edge(i_clk) then
		los_shift <= los_shift(1 downto 0) & i_los;
		case(sm) is
			when "0000" => 
				cnt_l <= 0;
				cnt_h <= 0;
				gtreset_s <= '0';
				if (los_shift(0) = '1' and los_shift(1) = '0') then
					sm <= "0001";
				end if;
			when "0001" =>				
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 60 and cnt_l = 0) then 
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "0010";
				end if;
			when "0010" =>
				if (i_lof = '1') then
					gtreset_s <= '1';	-- 1회
					sm <= "0011";
				else
					gtreset_s <= '0';
					sm <= "0000";
				end if;
			when "0011" =>
				gtreset_s <= '0';
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 10 and cnt_l = 0) then 
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "0100";
				end if;			
			when "0100" =>
				if (i_lof = '1') then
					gtreset_s <= '1';	-- 2회
					sm <= "0101";
				else
					gtreset_s <= '0';
					sm <= "0000";
				end if;
			when "0101" =>
				gtreset_s <= '0';
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 10 and cnt_l = 0) then 
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "0110";
				end if;				
			when "0110" =>
				if (i_lof = '1') then
					gtreset_s <= '1';	-- 3회
					sm <= "0111";
				else
					gtreset_s <= '0';
					sm <= "0000";
				end if;
			when "0111" =>
				gtreset_s <= '0';
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 10 and cnt_l = 0) then 
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "1000";
				end if;				
			when "1000" =>
				if (i_lof = '1') then
					gtreset_s <= '1';	-- 4회
					sm <= "1001";
				else
					gtreset_s <= '0';
					sm <= "0000";
				end if;
			when "1001" =>
				gtreset_s <= '0';
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 10 and cnt_l = 0) then 
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "1010";
				end if;				
			when "1010" =>
				if (i_lof = '1') then
					gtreset_s <= '1';	-- 5회
					sm <= "1011";
				else
					gtreset_s <= '0';
					sm <= "0000";
				end if;
			when "1011" =>
				gtreset_s <= '0';
				if cnt_l = 368640 then
					cnt_l <= 0;
					cnt_h <= cnt_h + 1;
				else
					cnt_l <= cnt_l + 1;
					cnt_h <= cnt_h;
				end if;
				if (cnt_h = 10 and cnt_l = 0) then
					cnt_l <= 0;
					cnt_h <= 0;
					sm <= "0000";
				end if;
			when others =>
				cnt_l <= 0;
				cnt_h <= 0;
				gtreset_s <= '0';
				sm <= "0000";
		end case;
	end if;
  end process;

end beh;



