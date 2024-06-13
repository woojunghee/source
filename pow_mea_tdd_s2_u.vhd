library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
Library xpm;
use xpm.vcomponents.all;

entity pow_mea_tdd_s2_u is
generic(
    clock_frequency : integer := 491_520;   -- system clock frequency in khz 7_680, 15_360, 30_720, 61_440, 122_880, 245_760, 491_520
                                            --                               5_760, 11_520, 23_040, 46_080, 92_160, 184_320, 368_640
    unit_frequency  : integer := 15_360;    -- unit clock frequency in khz 7_680, 5_760 ..
    tdd_period      : integer := 5_000;     -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   : integer := 3_857;     -- tdd_high_time(us) 3_857, 1_142 ..
    check_time      : integer := 80_000);   -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
port(
    clk             : in  std_logic;
    clk_unit        : in  std_logic;
    clk_tdd         : in  std_logic;
    reset_n         : in  std_logic;
    tdd_sync        : in  std_logic;
    din_i_s0        : in  std_logic_vector(15 downto 0);
    din_q_s0        : in  std_logic_vector(15 downto 0);
    din_i_s1        : in  std_logic_vector(15 downto 0);
    din_q_s1        : in  std_logic_vector(15 downto 0);
    din_vld         : in  std_logic;
    chk_en          : in  std_logic;
    power           : out std_logic_vector(31 downto 0);
    peak_power      : out std_logic_vector(31 downto 0)
    );
end pow_mea_tdd_s2_u;

architecture data of pow_mea_tdd_s2_u is

function log2ceil(n : integer) return integer is
    variable v : integer;
    begin
        v := 0;
        while 2 ** v < n loop
            v := v + 1;
        end loop;
    return v;
end function;

constant unit_sample     : integer := clock_frequency / unit_frequency;
constant unit_cnt_max    : integer := unit_sample;
constant unit_log        : integer := (log2ceil(unit_sample));

constant cnt_max_133     : integer := unit_frequency * 133/1000;
constant ave_cnt_max_133 : integer := (2 ** (log2ceil(cnt_max_133))) - 1;    -- 133 us
constant ave_log_133     : integer := (log2ceil(cnt_max_133));

constant cnt_max         : integer := (check_time / tdd_period) * ((tdd_high_time / 133)-2);
constant ave_cnt_max     : integer := (2 ** (log2ceil(cnt_max)-1)) - 1;
constant ave_log         : integer := (log2ceil(cnt_max)-1);

constant tdd_cnt_max     : integer := (check_time / tdd_period)-1;

signal rst_n_unit        : std_logic;
signal square_i          : std_logic_vector(31 downto 0);
signal square_q          : std_logic_vector(31 downto 0);
signal din_square_i      : std_logic_vector(unit_log + 31  downto 0);
signal din_square_q      : std_logic_vector(unit_log + 31  downto 0);
signal din_square        : std_logic_vector(unit_log + 31  downto 0);
signal power_u_stx       : std_logic_vector(ave_log_133 + 31 downto 0);
signal power_d_stx       : std_logic_vector(ave_log + 31 downto 0);
signal din_peak          : std_logic_vector(31 downto 0);
signal power_d           : std_logic_vector(31 downto 0);
signal power_u           : std_logic_vector(31 downto 0);
signal power_u_i         : std_logic_vector(31 downto 0);
signal power_u_q         : std_logic_vector(31 downto 0);
signal power_u_s         : std_logic_vector(31 downto 0);
signal power_d_133       : std_logic_vector(31 downto 0);
signal tdd_sync_s        : std_logic;
signal tdd_sync_d0       : std_logic;
signal tdd_sync_d1       : std_logic;

signal chk_trig          : std_logic;

signal chk_en_s          : std_logic;
signal unit_flag         : std_logic;
signal avg_flag          : std_logic;
signal avg_flag_133      : std_logic;
signal tdd_sync_133_d0   : std_logic;
signal tdd_sync_133_d1   : std_logic;
signal tdd_sync_ave      : std_logic;

signal ave_buff_i_s0     : std_logic_vector(31 downto 0);
signal ave_buff_i_s1     : std_logic_vector(31 downto 0);
signal ave_buff_q_s0     : std_logic_vector(31 downto 0);
signal ave_buff_q_s1     : std_logic_vector(31 downto 0);

signal ave_buff_u        : std_logic_vector(31 downto 0);
signal ave_buff_i        : std_logic_vector(31 downto 0);
signal ave_buff_q        : std_logic_vector(31 downto 0);
signal din_ave_u         : std_logic_vector(unit_log + 31 downto 0);

signal unit_cnt          : integer range 0 to unit_cnt_max;
signal ave_cnt_133       : integer range 0 to ave_cnt_max_133;
signal ave_buff_v_133    : std_logic_vector(31 downto 0);
signal din_ave_v_133     : std_logic_vector(ave_log_133 + 31 downto 0);
signal start_cnt         : integer range 0 to tdd_cnt_max;
signal ave_cnt           : integer range 0 to ave_cnt_max;
signal ave_buff_v        : std_logic_vector(31 downto 0);
signal din_ave_v         : std_logic_vector(ave_log + 31 downto 0);
signal power_d_v         : std_logic_vector(31 downto 0);
signal acc_i_s0          : std_logic_vector(47 downto 0);
signal acc_i_s1          : std_logic_vector(47 downto 0);
signal acc_q_s0          : std_logic_vector(47 downto 0);
signal acc_q_s1          : std_logic_vector(47 downto 0);

signal unit_clr          : std_logic;

signal din_i_s0_s        : std_logic_vector(15 downto 0);
signal din_q_s0_s        : std_logic_vector(15 downto 0);
signal din_i_s1_s        : std_logic_vector(15 downto 0);
signal din_q_s1_s        : std_logic_vector(15 downto 0);

begin

rst_blk_cdc : xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => reset_n,
     dest_clk  => clk_unit,
     dest_arst => rst_n_unit
  );

 chk_en_cdc : xpm_cdc_single
 generic map (
    DEST_SYNC_FF   => 2         ,
    INIT_SYNC_FF   => 0         ,
    SIM_ASSERT_CHK => 0         ,
    SRC_INPUT_REG  => 1         )
  port map (
    dest_out       => chk_en_s  ,
    dest_clk       => clk_unit  ,
    src_clk        => clk       ,
    src_in         => chk_en    );
    
process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        din_i_s0_s  <= (others => '0');
        din_q_s0_s  <= (others => '0');
        din_i_s1_s  <= (others => '0');
        din_q_s1_s  <= (others => '0');
    else
        if (chk_en = '1') then
            din_i_s0_s  <= din_i_s0;
            din_q_s0_s  <= din_q_s0;
            din_i_s1_s  <= din_i_s1;
            din_q_s1_s  <= din_q_s1;
        else
            din_i_s0_s  <= (others => '0');
            din_q_s0_s  <= (others => '0');
            din_i_s1_s  <= (others => '0');
            din_q_s1_s  <= (others => '0');
        end if;
    end if;
end if;
end process;

mult_acc_i0 : entity work.A_x_A_plus_P
  port map(
    CLK     => clk      , --: IN STD_LOGIC;
    A       => din_i_s0_s , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    P       => acc_i_s0 , --: OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    SCLRP   => unit_clr ); --: IN STD_LOGIC

mult_acc_i1 : entity work.A_x_A_plus_P
  port map(
    CLK     => clk      , --: IN STD_LOGIC;
    A       => din_i_s1_s , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    P       => acc_i_s1 , --: OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    SCLRP   => unit_clr ); --: IN STD_LOGIC

mult_acc_q0 : entity work.A_x_A_plus_P
  port map(
    CLK     => clk      , --: IN STD_LOGIC;
    A       => din_q_s0_s , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    P       => acc_q_s0 , --: OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    SCLRP   => unit_clr ); --: IN STD_LOGIC

mult_acc_q1 : entity work.A_x_A_plus_P
  port map(
    CLK     => clk      , --: IN STD_LOGIC;
    A       => din_q_s1_s , --: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    P       => acc_q_s1 , --: OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    SCLRP   => unit_clr ); --: IN STD_LOGIC

process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        unit_cnt  <= 0;
        unit_flag <= '0';
        unit_clr  <= '1';
    else
        if (unit_cnt = unit_cnt_max) then
            unit_cnt  <= 0;
            unit_flag <= '1';
            unit_clr  <= '1';
        else
            unit_cnt  <= unit_cnt + 1;
            unit_flag <= '0';
            unit_clr  <= '0';
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        ave_buff_i_s0 <= (others => '0');
        ave_buff_i_s1 <= (others => '0');
        ave_buff_q_s0 <= (others => '0');
        ave_buff_q_s1 <= (others => '0');
    else
        if (unit_flag = '1') then
            ave_buff_i_s0 <= acc_i_s0(unit_log + 32 downto unit_log + 1);
            ave_buff_i_s1 <= acc_i_s1(unit_log + 32 downto unit_log + 1);
            ave_buff_q_s0 <= acc_q_s0(unit_log + 32 downto unit_log + 1);
            ave_buff_q_s1 <= acc_q_s1(unit_log + 32 downto unit_log + 1);
        end if;
    end if;
end if;

end process;


--i_add : entity work.adder_32bit
--  port map(
--    A       => ave_buff_i_s0 , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    B       => ave_buff_i_s1 , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CLK     => clk           , --: IN STD_LOGIC;
--    S       => power_u_i     ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--
--q_add : entity work.adder_32bit
--  port map(
--    A       => ave_buff_q_s0 , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    B       => ave_buff_q_s1 , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CLK     => clk           , --: IN STD_LOGIC;
--    S       => power_u_q     ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--
--p_add : entity work.adder_32bit
--  port map(
--    A       => power_u_i     , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    B       => power_u_q     , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CLK     => clk           , --: IN STD_LOGIC;
--    S       => power_u       ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

process(clk)
begin
if rising_edge(clk) then
    power_u_i <= ave_buff_i_s0 + ave_buff_i_s1;
    power_u_q <= ave_buff_q_s0 + ave_buff_q_s1;
end if;
power_u <= power_u_i + power_u_q;
end process;

power_u_cdc : xpm_cdc_array_single
 generic map (
   DEST_SYNC_FF   => 2 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 ,
   SRC_INPUT_REG  => 1 ,
   WIDTH          => 32 )
 port map (
   dest_out       => power_u_s   ,
   dest_clk       => clk_unit    ,
   src_clk        => clk         ,
   src_in         => power_u     );

   power_u_stx  <= sxt(power_u_s, ave_log_133 + 32);

process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        ave_cnt_133  <= 0;
        avg_flag_133 <= '0';
    else
        if (chk_trig = '1') then
            ave_cnt_133  <= 0;
            avg_flag_133 <= '0';
        else
            if (ave_cnt_133 = ave_cnt_max_133) then
                ave_cnt_133  <= 0;
                avg_flag_133 <= '1';
            else
                ave_cnt_133  <= ave_cnt_133 + 1;
                avg_flag_133 <= '0';
            end if;
        end if;
    end if;
end if;
end process;


process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        ave_buff_v_133 <= (others => '0');
        din_ave_v_133  <= (others => '0');
    else
        if (chk_trig = '1') then
            din_ave_v_133  <= (others => '0');
            ave_buff_v_133 <= ave_buff_v_133;
        else
            if (avg_flag_133 = '1') then
                ave_buff_v_133 <= din_ave_v_133(ave_log_133 + 31 downto ave_log_133);
                din_ave_v_133  <= power_u_stx;
            else
                din_ave_v_133  <= din_ave_v_133 + power_u_stx;
            end if;
        end if;
    end if;
end if;
power_d_133 <= ave_buff_v_133;
end process;

 tdd_sync_cdc : xpm_cdc_single
 generic map (
    DEST_SYNC_FF   => 2          ,
    INIT_SYNC_FF   => 0          ,
    SIM_ASSERT_CHK => 0          ,
    SRC_INPUT_REG  => 1          )
  port map (
    dest_out       => tdd_sync_s ,
    dest_clk       => clk_unit   ,
    src_clk        => clk_tdd    ,
    src_in         => tdd_sync   );

process(clk_unit)
begin
if rising_edge(clk_unit) then
    tdd_sync_d0 <= tdd_sync_s;
    tdd_sync_d1 <= tdd_sync_d0;
end if;
end process;

process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        start_cnt <= 0;
        chk_trig  <= '0';
    else
        if (chk_en_s = '1') then
            if (tdd_sync_d1 = '0' and tdd_sync_d0 = '1') then
                if (start_cnt = tdd_cnt_max) then
                    start_cnt <= 0;
                    chk_trig  <= '1';
                else
                    start_cnt <= start_cnt + 1;
                    chk_trig  <= '0';
                end if;
            else
                chk_trig  <= '0';
            end if;
        else
            chk_trig  <= '0';
        end if;
    end if;
end if;
end process;

process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (avg_flag_133 = '1') then
        tdd_sync_133_d0 <= tdd_sync_d1;
        tdd_sync_133_d1 <= tdd_sync_133_d0;
    end if;

    tdd_sync_ave <= tdd_sync_133_d1 and tdd_sync_d1 and chk_en;
end if;
end process;

process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        ave_cnt  <= 0;
        avg_flag <= '0';
    else
        if (chk_trig = '1') then
            ave_cnt  <= 0;
            avg_flag <= '0';
        else
            if (avg_flag_133 = '1') then
                if (ave_cnt = ave_cnt_max) then
                    ave_cnt  <= 0;
                    avg_flag <= '1';
                else
                    if (tdd_sync_ave = '1') then
                        ave_cnt  <= ave_cnt + 1;
                    end if;
                    avg_flag <= '0';
                end if;
            end if;
        end if;
    end if;
end if;
end process;

power_d_stx  <= sxt(power_d_133, ave_log + 32);

process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        ave_buff_v <= (others => '0');
        din_ave_v  <= (others => '0');
        power_d_v  <= (others => '0');
    else
        if (chk_trig = '1') then
            power_d_v  <= ave_buff_v;
            din_ave_v  <= (others => '0');
            ave_buff_v <= (others => '0');
        else
            if (avg_flag_133 = '1') then
                if (avg_flag = '1') then
                    ave_buff_v <= din_ave_v(ave_log + 31 downto ave_log);
                    din_ave_v <= power_d_stx;
                else
                    if (tdd_sync_ave = '1') then
                        din_ave_v <= din_ave_v + power_d_stx;
                    end if;
                end if;
            end if;
        end if;
    end if;
end if;
power <= power_d_v;
end process;


process(clk_unit)
begin
if rising_edge(clk_unit) then
    if (rst_n_unit = '0') then
        din_peak     <= (others => '0');
        peak_power   <= (others => '0');
    else
        if (chk_trig = '1') then
            din_peak     <= (others => '0');
            peak_power   <= din_peak;
        else
            if (din_peak < power_d_133) then
                din_peak     <= power_d_133;
            end if;
        end if;
    end if;
end if;
end process;


end data;