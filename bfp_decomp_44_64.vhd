library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bfp_decomp_44_64 is
    port(
        rst           : in  std_logic;
        clk           : in  std_logic;
        comp_iq       : in  std_logic_vector(43 downto 0);
        comp_iq_valid : in std_logic;
        i_out         : out std_logic_vector(15 downto 0);
        q_out         : out std_logic_vector(15 downto 0)
        );
end bfp_decomp_44_64;

architecture Behavioral of bfp_decomp_44_64 is

signal comp_iq_s : std_logic_vector(43 downto 0);
signal exp1      : std_logic_vector(1 downto 0);
signal exp2      : std_logic_vector(1 downto 0);
signal expo      : std_logic_vector(3 downto 0);
signal i_in_s_0  : std_logic_vector(9 downto 0);
signal q_in_s_0  : std_logic_vector(9 downto 0);
signal i_in_s_1  : std_logic_vector(9 downto 0);
signal q_in_s_1  : std_logic_vector(9 downto 0);
signal i_out_s_0 : std_logic_vector(15 downto 0);
signal q_out_s_0 : std_logic_vector(15 downto 0);
signal i_out_s_1 : std_logic_vector(15 downto 0);
signal q_out_s_1 : std_logic_vector(15 downto 0);


begin

process(clk)
begin
if rising_edge(clk) then
    if rst = '1' then
        comp_iq_s <= (others => '0');
    else
        comp_iq_s <= comp_iq;
    end if;
end if;
end process;

exp1 <= comp_iq_s(43 downto 42);
exp2 <= comp_iq_s(21 downto 20);

expo    <= exp1 & exp2;
i_in_s_0 <= comp_iq_s(18) & comp_iq_s(16) & comp_iq_s(14) & comp_iq_s(12) & comp_iq_s(10) & comp_iq_s( 8) & comp_iq_s( 6) & comp_iq_s( 4) & comp_iq_s( 2) & comp_iq_s( 0);
q_in_s_0 <= comp_iq_s(19) & comp_iq_s(17) & comp_iq_s(15) & comp_iq_s(13) & comp_iq_s(11) & comp_iq_s( 9) & comp_iq_s( 7) & comp_iq_s( 5) & comp_iq_s( 3) & comp_iq_s( 1);
i_in_s_1 <= comp_iq_s(40) & comp_iq_s(38) & comp_iq_s(36) & comp_iq_s(34) & comp_iq_s(32) & comp_iq_s(30) & comp_iq_s(28) & comp_iq_s(26) & comp_iq_s(24) & comp_iq_s(22);
q_in_s_1 <= comp_iq_s(41) & comp_iq_s(39) & comp_iq_s(37) & comp_iq_s(35) & comp_iq_s(33) & comp_iq_s(31) & comp_iq_s(29) & comp_iq_s(27) & comp_iq_s(25) & comp_iq_s(23);


process(clk)
begin
if rising_edge(clk) then
    case expo is
        when    x"0"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9 downto 0);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9 downto 0);
        when    x"1"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9 downto 0) & i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9 downto 0) & q_in_s_0(9);
        when    x"2"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9 downto 0) & i_in_s_0(9) & not i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9 downto 0) & q_in_s_0(9) & not q_in_s_0(9);
        when    x"3"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9 downto 0) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9 downto 0) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9);
        when    x"4"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9) & i_in_s_0(9 downto 0) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9) & not i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9) & q_in_s_0(9 downto 0) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9) & not q_in_s_0(9);
        when    x"5"    =>
              i_out_s_0 <= i_in_s_0(9) & i_in_s_0(9 downto 0) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9) & q_in_s_0(9 downto 0) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9);
        when    x"6"    =>
              i_out_s_0 <= i_in_s_0(9 downto 0) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9) & not i_in_s_0(9) & i_in_s_0(9) & not i_in_s_0(9);
              q_out_s_0 <= q_in_s_0(9 downto 0) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9) & not q_in_s_0(9) & q_in_s_0(9) & not q_in_s_0(9);
        when others     =>
              i_out_s_0 <= (others=>'0');
              q_out_s_0 <= (others=>'0');
    end case;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    case expo is
        when    x"0"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9 downto 0);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9 downto 0);
        when    x"1"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9 downto 0) & i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9 downto 0) & q_in_s_1(9);
        when    x"2"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9 downto 0) & i_in_s_1(9) & not i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9 downto 0) & q_in_s_1(9) & not q_in_s_1(9);
        when    x"3"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9 downto 0) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9 downto 0) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9);
        when    x"4"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9) & i_in_s_1(9 downto 0) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9) & not i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9) & q_in_s_1(9 downto 0) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9) & not q_in_s_1(9);
        when    x"5"    =>
              i_out_s_1 <= i_in_s_1(9) & i_in_s_1(9 downto 0) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9) & q_in_s_1(9 downto 0) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9);
        when    x"6"    =>
              i_out_s_1 <= i_in_s_1(9 downto 0) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9) & not i_in_s_1(9) & i_in_s_1(9) & not i_in_s_1(9);
              q_out_s_1 <= q_in_s_1(9 downto 0) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9) & not q_in_s_1(9) & q_in_s_1(9) & not q_in_s_1(9);
        when others     =>
              i_out_s_1 <= (others=>'0');
              q_out_s_1 <= (others=>'0');
    end case;
end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            i_out    <= (others => '0');
            q_out    <= (others => '0');
        else
            if (comp_iq_valid = '1') then
                i_out <= i_out_s_0;
                q_out <= q_out_s_0;
            else
                i_out <= i_out_s_1;
                q_out <= q_out_s_1;
            end if;
        end if;
    end if;
end process;


end Behavioral;
