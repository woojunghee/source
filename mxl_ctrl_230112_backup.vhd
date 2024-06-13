library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
Library UNISIM;
use UNISIM.vCOMPONENTs.all;
Library xpm;
use xpm.vcomponents.all;

entity mxl_ctrl is
port(
    clk_122p88    : in  std_logic; --122.88mhz
    loc_clk       : in  std_logic;
    rst           : in  std_logic;
    tdd_sync_dl   : in  std_logic;
    tdd_sync_ul   : in  std_logic;

    tx_en         : in  std_logic_vector(3 downto 0);
    rx_en         : in  std_logic_vector(3 downto 0);
    tdd_mode      : in  std_logic_vector(1 downto 0);
    cal_mode      : in  std_logic_vector(1 downto 0);
    fbsel_mode    : in  std_logic_vector(1 downto 0);

    mxl_tx_en     : out std_logic_vector(3 downto 0);
    mxl_rx_en     : out std_logic_vector(3 downto 0);
    mxl_fb_en     : out std_logic_vector(1 downto 0);
    mxl_fbrx_cal  : out std_logic;
    mxl_fb_sw     : out std_logic_vector(1 downto 0);
    fb_ona        : out std_logic
);

end mxl_ctrl;

architecture beh of mxl_ctrl is
 signal tdd_cnt         : integer range 0 to 19;
 signal cnt_500us       : integer range 0 to 61439;
 signal sw_cnt          : integer range 0 to 5;
 signal tdd_mode_s1     : std_logic_vector(1 downto 0);
 signal cal_mode_s1     : std_logic_vector(1 downto 0);
 signal fbsel_mode_s1   : std_logic_vector(1 downto 0);
 signal tx_en_s1        : std_logic_vector(3 downto 0);
 signal rx_en_s1        : std_logic_vector(3 downto 0);

 signal tdd_sync_dl_s0  : std_logic;

 signal rxfb0_id0       : std_logic;
 signal rxfb1_id0       : std_logic;
 signal fbrx_cal        : std_logic;

 attribute ASYNC_REG : string;


begin


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    tdd_sync_dl_s0  <= tdd_sync_dl;
end if;
end process;

tx_en_sync_blk : entity work.d_sync
generic map(
    bits    => 4         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk      , --: in   std_logic;
    out_clk => clk_122p88   , --: in   std_logic;
    d_in    => tx_en        , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => tx_en_s1     ); --: out std_logic_vector(bits-1 downto 0)

rx_en_sync_blk : entity work.d_sync
generic map(
    bits    => 4         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk      , --: in   std_logic;
    out_clk => clk_122p88   , --: in   std_logic;
    d_in    => rx_en        , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => rx_en_s1     ); --: out std_logic_vector(bits-1 downto 0)


tdd_mode_sync_blk : entity work.d_sync
generic map(
    bits    => 2         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk      , --: in   std_logic;
    out_clk => clk_122p88   , --: in   std_logic;
    d_in    => tdd_mode     , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => tdd_mode_s1  ); --: out std_logic_vector(bits-1 downto 0)
--
cal_mode_sync_blk : entity work.d_sync
generic map(
    bits    => 2         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk      , --: in   std_logic;
    out_clk => clk_122p88   , --: in   std_logic;
    d_in    => cal_mode     , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => cal_mode_s1  ); --: out std_logic_vector(bits-1 downto 0)

fbsel_mode_sync_blk : entity work.d_sync
generic map(
    bits    => 2         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk       , --: in   std_logic;
    out_clk => clk_122p88    , --: in   std_logic;
    d_in    => fbsel_mode    , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => fbsel_mode_s1 ); --: out std_logic_vector(bits-1 downto 0)

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if ( rst = '1') then
        tdd_cnt         <= 0;
    else
        if (tdd_sync_dl = '1' and tdd_sync_dl_s0 = '0') then
            if (tdd_cnt = 19) then
                tdd_cnt <= 0;
            else
                tdd_cnt <= tdd_cnt + 1;
            end if;
        end if;
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (tdd_cnt = 1) then
        if (cnt_500us = 61439) then
            cnt_500us   <= 0;
            if (sw_cnt = 5) then
                sw_cnt <= sw_cnt;
            else
                sw_cnt <= sw_cnt + 1;
            end if;
        else
            cnt_500us   <= cnt_500us + 1;
        end if;
        fb_ona  <= '1';
    else
        cnt_500us   <= 0;
        sw_cnt      <= 0;
        fb_ona  <= '0';
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (sw_cnt = 1) then
        rxfb0_id0   <= '0';
        rxfb1_id0   <= '0';
        fbrx_cal    <= '1';
    elsif (sw_cnt = 2) then
        rxfb0_id0   <= '0';
        rxfb1_id0   <= '1';
        fbrx_cal    <= '1';
    elsif (sw_cnt = 3) then
        rxfb0_id0   <= '1';
        rxfb1_id0   <= '1';
        fbrx_cal    <= '1';
    elsif (sw_cnt = 4) then
        rxfb0_id0   <= '1';
        rxfb1_id0   <= '0';
        fbrx_cal    <= '1';
    else
        rxfb0_id0   <= '0';
        rxfb1_id0   <= '0';
        fbrx_cal    <= '0';
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (cal_mode_s1 = "00") then
        mxl_fbrx_cal <= '0';
    elsif (cal_mode_s1 = "01") then
        mxl_fbrx_cal <= '1';
    else
        mxl_fbrx_cal <= fbrx_cal;
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (fbsel_mode_s1 = "00") then
        mxl_fb_sw(0) <= '0';
        mxl_fb_sw(1) <= '0';
    elsif (fbsel_mode_s1 = "01") then
        mxl_fb_sw(0) <= '1';
        mxl_fb_sw(1) <= '1';
    else
        mxl_fb_sw(0) <= rxfb0_id0;
        mxl_fb_sw(1) <= rxfb1_id0;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (tdd_mode_s1 = "10") then
        mxl_fb_en  <= "00";
        mxl_tx_en  <= "0000";
        mxl_rx_en  <= rx_en_s1;
    elsif (tdd_mode_s1 = "01") then
        mxl_fb_en  <= (tx_en_s1(3) or tx_en_s1(2)) & (tx_en_s1(1) or tx_en_s1(0));
        mxl_tx_en  <= tx_en_s1;
        mxl_rx_en  <= "0000";
    else
        mxl_tx_en  <= (tdd_sync_dl and tx_en_s1(3)) & (tdd_sync_dl and tx_en_s1(2)) & (tdd_sync_dl and tx_en_s1(1)) & (tdd_sync_dl and tx_en_s1(0));
        mxl_rx_en  <= (tdd_sync_ul and rx_en_s1(3)) & (tdd_sync_ul and rx_en_s1(2)) & (tdd_sync_ul and rx_en_s1(1)) & (tdd_sync_ul and rx_en_s1(0));
        mxl_fb_en  <= (tdd_sync_dl and (tx_en_s1(3) or tx_en_s1(2))) & (tdd_sync_dl and (tx_en_s1(1) or tx_en_s1(0)));
    end if;
end if;
end process;




end beh;



