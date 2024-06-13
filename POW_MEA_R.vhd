-- fdd avg : 17ms
-- tdd avg : dl(21 ms) ,ul(74 ms)

-- tdd period = 5ms

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
Library xpm;
use xpm.vcomponents.all;


entity pow_mea_r is
generic(
    clock_frequency : integer := 245_760;   --system clock frequency in khz 61_440, 122_880, 245_760, 491_520
    check_time      : integer := 80);       --check cycle(ms) 5 10 20 40 80 ..
port(
    clk             : in  std_logic;
    loc_clk         : in  std_logic;
    reset_n         : in  std_logic;
    tdd_sync        : in  std_logic;
    din_i           : in  std_logic_vector(15 downto 0);
    peak_sel        : in  std_logic;
    power           : out std_logic_vector(31 downto 0);
    peak_power      : out std_logic_vector(31 downto 0)
    );
end pow_mea_r;

architecture data of pow_mea_r is

constant unit_sample   : integer := clock_frequency / 61440;
constant ave_cnt_max   : integer := unit_sample * 1048576;
constant cnt_max_533us : integer := unit_sample * 32768;

constant tdd_cnt_max   : integer := (check_time/5)-1;

signal din_i_buf       : std_logic_vector(15 downto 0);
signal square_i        : std_logic_vector(31 downto 0);
signal din_square      : std_logic_vector(53 downto 0);
signal din_ave         : std_logic_vector(53 downto 0);
signal din_peak        : std_logic_vector(31 downto 0);
signal ave_buff        : std_logic_vector(31 downto 0);
signal power_d         : std_logic_vector(31 downto 0);
signal peak_power_d    : std_logic_vector(31 downto 0);
signal tdd_sync_s0     : std_logic;
signal tdd_sync_s1     : std_logic;

signal start_cnt       : integer range 0 to 255;
signal tdd_rst         : std_logic;

signal ave_cnt         : integer range 0 to ave_cnt_max;
signal ave_cnt_533     : integer range 0 to cnt_max_533us;

signal ave_buf_533     : std_logic_vector(31 downto 0);
signal din_ave_533     : std_logic_vector(53 downto 0);

signal peak_sel_s      : std_logic;

attribute ASYNC_REG    : string;


attribute ASYNC_REG of tdd_sync_s0   : signal is "true";
attribute ASYNC_REG of tdd_sync_s1   : signal is "true";

begin

 peak_sel_sync : xpm_cdc_single
 generic map (
    DEST_SYNC_FF   => 4         ,
    INIT_SYNC_FF   => 0         ,
    SIM_ASSERT_CHK => 0         ,
    SRC_INPUT_REG  => 1         )
  port map (
    dest_out       => peak_sel_s,
    dest_clk       => clk       ,
    src_clk        => loc_clk   ,
    src_in         => peak_sel  );


process(clk)
begin
if rising_edge(clk) then
    tdd_sync_s0 <= tdd_sync;
    tdd_sync_s1 <= tdd_sync_s0;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        start_cnt   <= 0;
    else
        if (tdd_sync_s1 = '0' and tdd_sync_s0 = '1') then
            if (start_cnt = tdd_cnt_max) then
                start_cnt <= 0;
            else
                start_cnt <= start_cnt + 1;
            end if;
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (start_cnt = tdd_cnt_max and tdd_sync_s1 = '0' and tdd_sync_s0 = '1') then
        tdd_rst <= '1';
    else
        tdd_rst <= '0';
    end if;
end if;
end process;


process (clk)
begin
if rising_edge(clk) then
    din_i_buf    <= din_i;
end if;
end process;

 i_mult_16x16 : entity work.mult_16x16
port map(
    clk             => clk          , --: in std_logic;
    a               => din_i_buf    , --: in std_logic_vector(15 downto 0);
    b               => din_i_buf    , --: in std_logic_vector(15 downto 0);
    ce              => '1'          , --: in std_logic;
    p               => square_i     );--: out std_logic_vector(31 downto 0)

din_square  <= sxt(square_i, 54);

process (clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        ave_buff <= (others => '0');
        din_ave  <= (others => '0');
        ave_cnt  <= 0;
        power_d  <= (others => '0');
    else
        if (tdd_rst = '1') then
            ave_buff <= ave_buff;
            din_ave  <= (others => '0');
            ave_cnt  <= 0;
            power_d  <= ave_buff;
        else
            if (tdd_sync_s1 = '1') then
                if (ave_cnt = ave_cnt_max ) then
                    case(unit_sample) is
                        when 1      => ave_buff <= din_ave(50 downto 19);
                        when 2      => ave_buff <= din_ave(51 downto 20);
                        when 4      => ave_buff <= din_ave(52 downto 21);
                        when 8      => ave_buff <= din_ave(53 downto 22);
                        when others => ave_buff <= din_ave(51 downto 20);
                    end case;
                    ave_cnt  <= 0;
                    din_ave  <= din_square;
                else
                    ave_cnt  <= ave_cnt + 1;
                    din_ave  <= din_ave + din_square;
                end if;
            end if;
        end if;
    end if;
end if;
end process;


pow_sync_blk : xpm_cdc_array_single
 generic map (
   DEST_SYNC_FF   => 4 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 ,
   SRC_INPUT_REG  => 1 ,
   WIDTH          => 32 )
 port map (
   dest_out       => power          ,
   dest_clk       => loc_clk        ,
   src_clk        => clk            ,
   src_in         => power_d        );


process (clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        ave_buf_533  <= (others => '0');
        din_ave_533  <= (others => '0');
        ave_cnt_533  <= 0;
    else
        if (tdd_rst = '1') then
            ave_buf_533  <= ave_buf_533;
            din_ave_533  <= (others => '0');
            ave_cnt_533  <= 0;
        else
            if (tdd_sync_s1 = '1') then
                if (ave_cnt_533 = cnt_max_533us ) then
                    case(unit_sample) is
                        when 1  => ave_buf_533 <= din_ave_533(45 downto 14);
                        when 2  => ave_buf_533 <= din_ave_533(46 downto 15);
                        when 4  => ave_buf_533 <= din_ave_533(47 downto 16);
                        when 8  => ave_buf_533 <= din_ave_533(48 downto 17);
                        when others  => ave_buf_533 <= din_ave_533(49 downto 18);
                    end case;
                    ave_cnt_533 <= 0;
                    din_ave_533 <= din_square;
                else
                    ave_cnt_533 <= ave_cnt_533 + 1;
                    din_ave_533 <= din_ave_533 + din_square;
                end if;
            end if;
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        din_peak     <= (others => '0');
        peak_power_d <= (others => '0');
    else
        if (tdd_rst = '1') then
            din_peak        <= (others => '0');
            peak_power_d    <= din_peak;
        else
            if (peak_sel_s = '0' )then
                if (din_peak < ave_buf_533) then
                    din_peak <= ave_buf_533;
                else
                    din_peak <= din_peak;
                end if;
            else
                if (din_peak < square_i) then
                    din_peak <= square_i(30 downto 0) & '0';
                else
                    din_peak <= din_peak;
                end if;
            end if;
        end if;
    end if;
end if;
end process;


peak_sync_blk : xpm_cdc_array_single
 generic map (
   DEST_SYNC_FF   => 4 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 ,
   SRC_INPUT_REG  => 1 ,
   WIDTH          => 32 )
 port map (
   dest_out       => peak_power     ,
   dest_clk       => loc_clk        ,
   src_clk        => clk            ,
   src_in         => peak_power_d   );


end data;