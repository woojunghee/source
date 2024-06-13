

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
library work;
use work.my_package.all;


Library xpm;
use xpm.vcomponents.all;

entity mac_table_gen is
generic (
      table_num : integer := 1 );
port(
    clk                 : in  std_logic; -- 368.64mhz
    reset_n             : in  std_logic;
    s_add               : in  std_logic_vector(47 downto 0);
    s_add_vld           : in  std_logic;
    mac_table           : out arr_mac_num_48_stdlogic(0 to table_num)
    );
end mac_table_gen;

architecture data of mac_table_gen is

type arr_100us_table_integer	is array (0 to table_num)	of integer range 0 to 36863;
type arr_30s_table_integer	    is array (0 to table_num)	of integer range 0 to 299999;


signal mac_table_reg : arr_mac_num_48_stdlogic(0 to table_num);

signal exist         : std_logic_vector(table_num downto 0);
signal empty         : std_logic_vector(table_num downto 0);
signal check         : std_logic;


signal cnt_100us     : arr_100us_table_integer;
signal cnt_30s       : arr_30s_table_integer;
signal table_clr     : std_logic_vector(table_num downto 0);
signal time_over     : std_logic_vector(table_num downto 0);
signal time_over_s0  : std_logic_vector(table_num downto 0);
signal table_gen     : std_logic_vector(table_num downto 0);




begin

process(clk)
variable write_ok   : std_logic;
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        mac_table_reg <= (others => (others => '0'));
        exist         <= (others => '0');
        empty         <= (others => '1');
        table_gen     <= (others => '0');
        write_ok            := '0';
    else
        if (s_add_vld = '1') then
            for n in 0 to table_num loop
                if (mac_table_reg(n) = s_add) then
                    exist(n) <= '1';
                else
                    exist(n) <= '0';
                end if;

                if (mac_table_reg(n) = x"000000000000") then
                    empty(n) <= '1';
                else
                    empty(n) <= '0';
                end if;
            end loop;
            check <= '1';


            if ( exist(table_num downto 0) = "0" and check = '1') then
                for n in 0 to table_num  loop
                    if ( empty(n)= '1' and write_ok='0') then
                        mac_table_reg(n) <= s_add;
                        table_gen(n)     <= '1';
                        write_ok         := '1';
                    end if;
                    if (n=table_num ) then
                        write_ok         :='0';
                    end if;
                end loop;
            else
                table_gen       <= (others => '0');
            end if;
        else
            for n in 0 to table_num loop
                if (table_clr(n) = '1') then
                    mac_table_reg(n)    <= (others => '0');
                end if;
            end loop;
            check <= '0';
            exist <= (others =>'0');
        end if;
    end if;
end if;
end process;

mac_table   <= mac_table_reg;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        for n in 0 to table_num loop
            cnt_100us(n) <= 0;
            cnt_30s(n)   <= 0;
            time_over(n) <= '0';
        end loop;
    else
        for n in 0 to table_num loop
            if (exist(n) = '1' or table_gen(n) = '1') then
                cnt_100us(n) <= 0;
                cnt_30s(n)   <= 0;
                time_over(n) <= '0';
            else
                if (cnt_100us(n) = 36863) then
                    cnt_100us(n) <= 0;
                    --if (cnt_30s(n) = 299999) then
                    if (cnt_30s(n) = 299999) then
                        cnt_30s(n)    <= 0;
                        time_over(n) <= '1';
                    else
                        cnt_30s(n)    <= cnt_30s(n) + 1;
                        time_over(n) <= '0';
                    end if;
                else
                    cnt_100us(n)   <= cnt_100us(n) + 1;
                end if;
            end if;
        end loop;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        table_clr       <= (others => '0');
        time_over_s0    <= (others => '0');
    else
        for n in 0 to table_num loop
            time_over_s0(n) <= time_over(n);
            if (time_over_s0(n) = '0' and time_over(n) = '1') then
                table_clr(n) <= '1';
            else
                table_clr(n) <= '0';
            end if;
        end loop;
    end if;
end if;
end process;



end data;