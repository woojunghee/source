library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bfp_comp_64_44 is
    port(
        rst           : in  std_logic;
        clk           : in  std_logic;
        i_in          : in  std_logic_vector(15 downto 0);
        q_in          : in  std_logic_vector(15 downto 0);
        comp_iq       : out std_logic_vector(43 downto 0);
        comp_iq_valid : out std_logic
        );
end bfp_comp_64_44;

architecture Behavioral of bfp_comp_64_44 is

signal out_data_temp_1 : std_logic_vector(21 downto 0) := "00" & x"00000";
signal out_data_temp_2 : std_logic_vector(21 downto 0) := "00" & x"00000";
signal i_in_1          : std_logic_vector(15 downto 0) := x"0000";
signal q_in_1          : std_logic_vector(15 downto 0) := x"0000";
signal i_in_2          : std_logic_vector(15 downto 0) := x"0000";
signal q_in_2          : std_logic_vector(15 downto 0) := x"0000";
signal fr_num          : std_logic                     := '0';

begin


process(clk)
begin
if rising_edge(clk) then
    if (rst = '1') then
        fr_num <= '1';
        i_in_1 <= x"0000";
        q_in_1 <= x"0000";
        i_in_2 <= x"0000";
        q_in_2 <= x"0000";
    else
        if fr_num = '0' then
            i_in_1 <= i_in;
            q_in_1 <= q_in;
        else
            i_in_2 <= i_in;
            q_in_2 <= q_in;
        end if;
        fr_num    <= not fr_num;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
if fr_num = '0' then
    if ((i_in_1(15) = i_in_1(14)) and (i_in_2(15) = i_in_2(14)) and (q_in_1(15) = q_in_1(14)) and (q_in_2(15) = q_in_2(14))) then
        if ((i_in_1(15) = i_in_1(13)) and (i_in_2(15) = i_in_2(13)) and (q_in_1(15) = q_in_1(13)) and (q_in_2(15) = q_in_2(13))) then
            if ((i_in_1(15) = i_in_1(12)) and (i_in_2(15) = i_in_2(12)) and (q_in_1(15) = q_in_1(12)) and (q_in_2(15) = q_in_2(12))) then
                if ((i_in_1(15) = i_in_1(11)) and (i_in_2(15) = i_in_2(11)) and (q_in_1(15) = q_in_1(11)) and (q_in_2(15) = q_in_2(11))) then
                    if ((i_in_1(15) = i_in_1(10)) and (i_in_2(15) = i_in_2(10)) and (q_in_1(15) = q_in_1(10)) and (q_in_2(15) = q_in_2(10))) then
                        if ((i_in_1(15) = i_in_1(9))  and (i_in_2(15) = i_in_2(9))  and (q_in_1(15) = q_in_1(9))  and (q_in_2(15) = q_in_2(9))) then
                            out_data_temp_1 <= "00" & q_in_1(15) & i_in_1(15) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5) & q_in_1(4) & i_in_1(4) & q_in_1(3) & i_in_1(3) & q_in_1(2) & i_in_1(2) & q_in_1(1) & i_in_1(1) & q_in_1(0) & i_in_1(0);
                            out_data_temp_2 <= "00" & q_in_2(15) & i_in_2(15) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5) & q_in_2(4) & i_in_2(4) & q_in_2(3) & i_in_2(3) & q_in_2(2) & i_in_2(2) & q_in_2(1) & i_in_2(1) & q_in_2(0) & i_in_2(0);
                        else
                            out_data_temp_1 <= "01" & q_in_1(15) & i_in_1(15) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5) & q_in_1(4) & i_in_1(4) & q_in_1(3) & i_in_1(3) & q_in_1(2) & i_in_1(2) & q_in_1(1) & i_in_1(1);
                            out_data_temp_2 <= "00" & q_in_2(15) & i_in_2(15) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5) & q_in_2(4) & i_in_2(4) & q_in_2(3) & i_in_2(3) & q_in_2(2) & i_in_2(2) & q_in_2(1) & i_in_2(1);
                        end if;
                    else
                        out_data_temp_1 <= "10" & q_in_1(15) & i_in_1(15) & q_in_1(10) & i_in_1(10) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5) & q_in_1(4) & i_in_1(4) & q_in_1(3) & i_in_1(3) & q_in_1(2) & i_in_1(2);
                        out_data_temp_2 <= "00" & q_in_2(15) & i_in_2(15) & q_in_2(10) & i_in_2(10) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5) & q_in_2(4) & i_in_2(4) & q_in_2(3) & i_in_2(3) & q_in_2(2) & i_in_2(2);
                    end if;
                else
                    out_data_temp_1 <= "11" & q_in_1(15) & i_in_1(15) & q_in_1(11) & i_in_1(11) & q_in_1(10) & i_in_1(10) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5) & q_in_1(4) & i_in_1(4) & q_in_1(3) & i_in_1(3);
                    out_data_temp_2 <= "00" & q_in_2(15) & i_in_2(15) & q_in_2(11) & i_in_2(11) & q_in_2(10) & i_in_2(10) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5) & q_in_2(4) & i_in_2(4) & q_in_2(3) & i_in_2(3);
                end if;
            else
                out_data_temp_1 <= "00" & q_in_1(15) & i_in_1(15) & q_in_1(12) & i_in_1(12) & q_in_1(11) & i_in_1(11) & q_in_1(10) & i_in_1(10) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5) & q_in_1(4) & i_in_1(4);
                out_data_temp_2 <= "01" & q_in_2(15) & i_in_2(15) & q_in_2(12) & i_in_2(12) & q_in_2(11) & i_in_2(11) & q_in_2(10) & i_in_2(10) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5) & q_in_2(4) & i_in_2(4);
            end if;
        else
            out_data_temp_1 <= "01" & q_in_1(15) & i_in_1(15) & q_in_1(13) & i_in_1(13) & q_in_1(12) & i_in_1(12) & q_in_1(11) & i_in_1(11) & q_in_1(10) & i_in_1(10) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6) & q_in_1(5) & i_in_1(5);
            out_data_temp_2 <= "01" & q_in_2(15) & i_in_2(15) & q_in_2(13) & i_in_2(13) & q_in_2(12) & i_in_2(12) & q_in_2(11) & i_in_2(11) & q_in_2(10) & i_in_2(10) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6) & q_in_2(5) & i_in_2(5);
        end if;
    else
        out_data_temp_1 <= "10" & q_in_1(15) & i_in_1(15) & q_in_1(14) & i_in_1(14) & q_in_1(13) & i_in_1(13) & q_in_1(12) & i_in_1(12) & q_in_1(11) & i_in_1(11) & q_in_1(10) & i_in_1(10) & q_in_1(9) & i_in_1(9) & q_in_1(8) & i_in_1(8) & q_in_1(7) & i_in_1(7) & q_in_1(6) & i_in_1(6);
        out_data_temp_2 <= "01" & q_in_2(15) & i_in_2(15) & q_in_2(14) & i_in_2(14) & q_in_2(13) & i_in_2(13) & q_in_2(12) & i_in_2(12) & q_in_2(11) & i_in_2(11) & q_in_2(10) & i_in_2(10) & q_in_2(9) & i_in_2(9) & q_in_2(8) & i_in_2(8) & q_in_2(7) & i_in_2(7) & q_in_2(6) & i_in_2(6);
    end if;
end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if (rst = '1') then
        comp_iq <= (others=>'0');
        comp_iq_valid  <= '0';
    else
        if (fr_num = '1') then
            comp_iq <= out_data_temp_2 & out_data_temp_1;
            comp_iq_valid  <= '0';
        else
            comp_iq_valid  <= '1';
        end if;
    end if;
end if;
end process;

end Behavioral;