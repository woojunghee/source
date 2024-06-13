

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
library work;
use work.my_package.all;


Library xpm;
use xpm.vcomponents.all;

entity mac_table_gen_d is
generic (
      table_num : integer := 1;
      port_num  : integer := 1 );
port(
    clk                 : in  std_logic; -- 368.64mhz
    reset_n             : in  std_logic;
    s_add               : in  std_logic_vector(47 downto 0);
    s_add_vld           : in  std_logic;
    d_add               : in  arr_n_48_stdlogic(port_num downto 0);
    d_add_vld           : in  arr_n_1_stdlogic(port_num downto 0);
    da_exist            : out std_logic_vector(port_num downto 0);
    da_chk_done         : out std_logic_vector(port_num downto 0);
    rx_exist            : out std_logic_vector(port_num downto 0)

    );
end mac_table_gen_d;

architecture data of mac_table_gen_d is

type arr_300us_table_integer	is array (0 to table_num)	of integer range 0 to 131071;
type arr_300ms_table_integer	is array (0 to table_num)	of integer range 0 to 1023;
type arr_30s_table_integer	    is array (0 to table_num)	of integer range 0 to 127;

type arr_table_port_integer	    is array (0 to port_num)	of integer range 0 to table_num;

signal table_cnt     : integer range 0 to table_num;
signal table_cnt_s0  : integer range 0 to table_num;
signal table_cnt_s1  : integer range 0 to table_num;
signal table_cnt_s2  : integer range 0 to table_num;

signal chk_cnt       : integer range 0 to table_num;

signal gen_cnt       : integer range 0 to table_num;
signal table_clr_cnt : integer range 0 to table_num;
signal table_clr     : std_logic_vector(table_num downto 0);

signal mac_table_reg : arr_mac_num_48_stdlogic(0 to table_num);

signal exist         : std_logic_vector(table_num downto 0);
signal empty         : std_logic_vector(table_num downto 0);
signal chk_done      : std_logic;
signal chk_vld       : std_logic;
signal gen_vld       : std_logic;

signal cnt_300ms     : arr_300ms_table_integer;
signal cnt_300us     : arr_300us_table_integer;
signal cnt_30s       : arr_30s_table_integer;
signal time_over     : std_logic_vector(table_num downto 0);
signal time_over_s0  : std_logic_vector(table_num downto 0);
signal table_gen     : std_logic_vector(table_num downto 0);

signal add           : std_logic_vector(5 downto 0);
signal data_in       : std_logic_vector(47 downto 0);
signal table_data    : std_logic_vector(47 downto 0);

signal we            : std_logic;
signal write_done    : std_logic;

signal da_chk_cnt    : arr_table_port_integer;
signal da_chk_vld    : std_logic_vector(port_num downto 0);
signal da_chk_vld_s0 : std_logic_vector(port_num downto 0);
signal da_chk_vld_s1 : std_logic_vector(port_num downto 0);




begin

process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        table_cnt <= 0;
    else
        if (table_cnt = table_num) then
            table_cnt <= 0;
        else
            table_cnt <= table_cnt + 1;
        end if;
    end if;
end if;
end process;

da_chk_bank : for n in 0 to port_num generate
process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        da_chk_done(n) <= '1';
        da_chk_vld(n)  <= '0';
        da_chk_cnt(n)  <= 0;
    else
        if (d_add_vld(n) = '1') then
            da_chk_done(n) <= '0';
            da_chk_vld(n)  <= '1';
            da_chk_cnt(n)  <= table_cnt;
        else
            if (da_chk_vld(n) = '1' and table_cnt = da_chk_cnt(n)) then
                da_chk_vld(n)  <= '0';
                da_chk_done(n) <= '1';
            end if;
        end if;
    end if;
    da_chk_vld_s0   <= da_chk_vld;
    da_chk_vld_s1   <= da_chk_vld_s0;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        da_exist(n) <= '0';
        rx_exist(n) <= '0';
    else
        if (d_add_vld(n) = '1') then
            da_exist(n) <= '0';
            rx_exist(n) <= '0';
        else
            if (da_chk_vld_s0(n) = '1') then
                if (table_data = d_add(n) or d_add(n) = x"ffffffffffff" or d_add(n)(40) = '1') then
                    da_exist(n) <= '1';
                end if;
                if (table_data = d_add(n)) then
                    rx_exist(n) <= '1';
                end if;
            end if;
        end if;
    end if;
end if;
end process;
end generate;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        chk_done <= '0';
        chk_vld  <= '0';
        chk_cnt  <= 0;
    else
        if (s_add_vld = '1') then
            chk_done <= '0';
            chk_vld  <= '1';
            chk_cnt  <= table_cnt;
        else
            if (chk_vld = '1' and table_cnt = chk_cnt) then
                chk_vld  <= '0';
                chk_done <= '1';
            else
                chk_vld  <= chk_vld;
                chk_done <= '0';
            end if;
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    table_cnt_s0    <= table_cnt;
    table_cnt_s1    <= table_cnt_s0;
    table_cnt_s2    <= table_cnt_s1;
    if (reset_n = '0') then
        exist   <= (others => '0');
        empty   <= (others => '1');
        add     <= (others => '0');
        data_in <= (others => '0');
    else
        if (table_clr(table_num downto 0) /= "0" ) then
            for n in 0 to table_num loop
                if (table_clr(n) = '1') then
                    add        <= conv_std_logic_vector(n,6);
                    data_in    <= (others => '0');
                end if;
            end loop;
        else
            data_in <= s_add;
            if (chk_vld = '1') then
                if (table_data = s_add) then
                    exist(table_cnt_s2) <= '1';
                else
                    exist(table_cnt_s2) <= '0';
                end if;

                if (table_data = x"000000000000") then
                    empty(table_cnt_s2) <= '1';
                else
                    empty(table_cnt_s2) <= '0';
                end if;
            end if;

           -- mac_table_reg(table_cnt_s0)   <= table_data;

            add <= conv_std_logic_vector(table_cnt,6);
        end if;
    end if;
end if;
end process;




mac_table_mem : entity work.mac_table_mem
  port map(
    a           => add          , --: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    d           => data_in      , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    clk         => clk          , --: IN STD_LOGIC;
    we          => we           , --: IN STD_LOGIC;
    qspo        => table_data   ); --: OUT STD_LOGIC_VECTOR(47 DOWNTO 0)


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        gen_cnt   <= 0;
        gen_vld <= '0';
    else
        if (chk_done = '1') then
            gen_cnt     <= table_cnt;
            gen_vld     <= '1';
        else
            if (gen_vld = '1' and table_cnt = gen_cnt) then
                gen_vld <= '0';
            else
                gen_vld <= gen_vld;
            end if;
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        table_gen  <= (others => '0');
        we         <= '0';
        write_done <= '0';
    else
        if (table_clr(table_num downto 0) /= "0" ) then
            we <= '1';
        else
            if (gen_vld = '1') then
                if ( exist(table_num downto 0) = "0") then
                    if ( empty(table_cnt)= '1' and write_done = '0') then
                        we                   <= '1';
                        table_gen(table_cnt) <= '1';
                        write_done           <= '1';
                    else
                        table_gen            <= (others => '0');
                        we                   <= '0';
                    end if;
                end if;
            else
                we         <= '0';
                write_done <= '0';
            end if;
        end if;
    end if;
end if;
end process;


--mac_table   <= mac_table_reg;


cnt_bank : for n in 0 to table_num generate
process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        cnt_300us(n) <= 0;
        cnt_300ms(n) <= 0;
        cnt_30s(n)   <= 0;
        time_over(n) <= '0';
    else
        if (exist(n) = '1' or table_gen(n) = '1') then
            cnt_300us(n) <= 0;
            cnt_300ms(n) <= 0;
            cnt_30s(n)   <= 0;
            time_over(n) <= '0';
        else
            if (cnt_300us(n) = 110591) then
                cnt_300us(n) <= 0;
                if (cnt_300ms(n) = 999) then
                    cnt_300ms(n)    <= 0;
                    if (cnt_30s(n) = 99) then
                        cnt_30s(n)    <= 0;
                        time_over(n) <= '1';
                    else
                        cnt_30s(n)    <= cnt_30s(n) + 1;
                        time_over(n) <= '0';
                    end if;
                else
                    cnt_300ms(n)    <= cnt_300ms(n) + 1;
                end if;
            else
                cnt_300us(n)   <= cnt_300us(n) + 1;
            end if;
        end if;
    end if;
end if;
end process;
end generate;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        table_clr       <= (others => '0');
        time_over_s0    <= (others => '0');
    else
        if (gen_vld = '0') then
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
end if;
end process;




end data;