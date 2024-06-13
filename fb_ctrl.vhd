library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
library unisim;
use unisim.vcomponents.all;
library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity fb_ctrl is
generic(
    clock_frequency : integer := 245_760   --system clock frequency in khz 61_440, 122_880, 245_760, 491_520
);
port(
    clk             : in  std_logic; --245.76mhz
    loc_clk         : in  std_logic;
    clk_122p88      : in  std_logic;
    clk_61p44       : in  std_logic;
--    rst             : in  std_logic;
    rst_n           : in  std_logic;
    tdd_sync        : in  std_logic;

    srx_ctrl_tready : out std_logic;
    srx_ctrl_tvalid : in  std_logic;
    srx_ctrl_tdata  : in  std_logic_vector(7 downto 0);

    mxl_fb_sw       : in  std_logic_vector(1 downto 0);
    fb_ona          : in  std_logic;
    fb_sw_dly       : in  std_logic_vector(10 downto 0);
    fb_sw           : out std_logic_vector(1 downto 0);
	fb_sw_cnt_out	: out std_logic_vector(23 downto 0);

	fb_in_gain		: in  std_logic_vector(15 downto 0);
    fb0_i_s0        : in  std_logic_vector(15 downto 0);
    fb0_i_s1        : in  std_logic_vector(15 downto 0);
    fb0_q_s0        : in  std_logic_vector(15 downto 0);
    fb0_q_s1        : in  std_logic_vector(15 downto 0);

    fb1_i_s0        : in  std_logic_vector(15 downto 0);
    fb1_i_s1        : in  std_logic_vector(15 downto 0);
    fb1_q_s0        : in  std_logic_vector(15 downto 0);
    fb1_q_s1        : in  std_logic_vector(15 downto 0);

    fb_in_tready    : in  std_logic;
    fb_in_tdata     : out std_logic_vector(63 downto 0);
    fb_in_tuser     : out std_logic_vector(7 downto 0);
    fb_in_tvalid    : out std_logic;
    fb_valid        : out std_logic;
	pow_en_fb	: out std_logic_vector(3 downto 0);
	-- tdd_sync_dl_sync : in std_logic;

	peak_sel        : in  std_logic;

    fb_pow          : out arr_4_32_stdlogic;
    fb_peak         : out arr_4_32_stdlogic
);

end fb_ctrl;

architecture beh of fb_ctrl is
 signal rst_sync        : std_logic;
 signal rst_n_sync      : std_logic;
 signal dly_cnt         : integer range 0 to 1023;
 signal dly_set         : integer range 0 to 1023;
 signal fb_sel          : std_logic_vector(1 downto 0);
 signal fb_sel_s0       : std_logic_vector(1 downto 0);
 signal fb_vld          : std_logic;
 signal fb_port         : std_logic_vector(7 downto 0);
 signal fb_sw_dly_sync  : std_logic_vector(10 downto 0);
 signal fb_in_buf       : std_logic_vector(63 downto 0);
 signal fb_sw_reg       : std_logic_vector(1 downto 0);

 signal pow_din_i_s0      : arr_4_16_stdlogic;
 signal pow_din_i_s1      : arr_4_16_stdlogic;
 signal pow_din_q_s0      : arr_4_16_stdlogic;
 signal pow_din_q_s1      : arr_4_16_stdlogic;
 signal pow_en            : std_logic_vector(3 downto 0);

 signal fb0_i_s0_gain_out : std_logic_vector(15 downto 0);
 signal fb0_i_s1_gain_out : std_logic_vector(15 downto 0);
 signal fb0_q_s0_gain_out : std_logic_vector(15 downto 0);
 signal fb0_q_s1_gain_out : std_logic_vector(15 downto 0);
 signal fb1_i_s0_gain_out : std_logic_vector(15 downto 0);
 signal fb1_i_s1_gain_out : std_logic_vector(15 downto 0);
 signal fb1_q_s0_gain_out : std_logic_vector(15 downto 0);
 signal fb1_q_s1_gain_out : std_logic_vector(15 downto 0);
 signal fb_sw_cnt          : std_logic_vector(23 downto 0);

 attribute async_reg : string;


begin

--ila_fb_inst : entity work.ila_fb
--port map(
--	clk			=> clk,
--	probe0(0)	=> srx_ctrl_tvalid,--1
--	probe1		=> srx_ctrl_tdata,--8
--	probe2		=> fb_sel,--2
--	probe3(0)	=> fb_vld,--1
--	probe4(0)	=> fb_ona,--1
--	probe5		=> fb_port,--8
--	probe6		=> fb_in_buf,--64
--	probe7(0)	=> fb_in_tready--1
--);

rst_blk_245p76 : xpm_cdc_sync_rst
 generic map (
   DEST_SYNC_FF   => 2 ,
   INIT           => 1 ,
   INIT_SYNC_FF   => 0 ,
   SIM_ASSERT_CHK => 0 )
 port map (
   dest_rst       => rst_n_sync ,
   dest_clk       => clk   ,
   src_rst        => rst_n        );

--rst_blk_245p76 : xpm_cdc_async_rst
--  generic map (
--     DEST_SYNC_FF    => 2, -- integer; range: 2-10
--     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
--  )
--  port map (
--     src_arst  => rst,
--     dest_clk  => clk,
--     dest_arst => rst_sync
--  );

--rst_n_sync  <= not rst_sync;

path_en_sync_blk : entity work.d_sync
generic map(
    bits    => 11         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk    , --: in   std_logic;
    out_clk => clk        , --: in   std_logic;
    d_in    => fb_sw_dly  , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => fb_sw_dly_sync ); --: out std_logic_vector(bits-1 downto 0)

fb0_gain_s0_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb0_i_s0   , --: in  std_logic_vector(15 downto 0);
    dout    => fb0_i_s0_gain_out); --: out std_logic_vector(15 downto 0)

fb0_gain_s1_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb0_i_s1   , --: in  std_logic_vector(15 downto 0);
    dout    => fb0_i_s1_gain_out); --: out std_logic_vector(15 downto 0)

fb0_gain_s0_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb0_q_s0   , --: in  std_logic_vector(15 downto 0);
    dout    => fb0_q_s0_gain_out); --: out std_logic_vector(15 downto 0)

fb0_gain_s1_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb0_q_s1   , --: in  std_logic_vector(15 downto 0);
    dout    => fb0_q_s1_gain_out); --: out std_logic_vector(15 downto 0);

fb1_gain_s0_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb1_i_s0   , --: in  std_logic_vector(15 downto 0);
    dout    => fb1_i_s0_gain_out); --: out std_logic_vector(15 downto 0)

fb1_gain_s1_i : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb1_i_s1   , --: in  std_logic_vector(15 downto 0);
    dout    => fb1_i_s1_gain_out); --: out std_logic_vector(15 downto 0)

fb1_gain_s0_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb1_q_s0   , --: in  std_logic_vector(15 downto 0);
    dout    => fb1_q_s0_gain_out); --: out std_logic_vector(15 downto 0)

fb1_gain_s1_q : entity work.GAIN_BLK_16
 port map(
    clk     => clk        , --: in  std_logic;
    gain    => fb_in_gain , --: in  std_logic_vector(15 downto 0);
    din     => fb1_q_s1   , --: in  std_logic_vector(15 downto 0);
    dout    => fb1_q_s1_gain_out); --: out std_logic_vector(15 downto 0);

process(clk)
begin
if rising_edge(clk) then
    srx_ctrl_tready    <= '1';
    if (rst_n_sync = '0') then
        fb_sel    <= "00";
        fb_sw_reg <= "11";
    else
        if (srx_ctrl_tvalid = '1') then--230303_fix (logensys fb sw adapt)
            case(srx_ctrl_tdata) is
                when x"00"      => fb_sel    <= "00";  fb_sw_reg <= "11";--"11";
                when x"01"      => fb_sel    <= "01";  fb_sw_reg <= "00";--"10";
                when x"02"      => fb_sel    <= "10";  fb_sw_reg <= "11";--"11";
                when x"03"      => fb_sel    <= "11";  fb_sw_reg <= "00";--"01";
                when others     => null;
            end case;
        end if;
    end if;
end if;
end process;



dly_set <= conv_integer(fb_sw_dly_sync);

process(clk)
begin
if rising_edge(clk) then
    if (rst_n_sync = '0') then
        fb_vld    <= '0';
        dly_cnt   <= 0;
        fb_sel_s0 <= "00";
		fb_sw_cnt	<= x"000000";
    else
        fb_sel_s0 <= fb_sel;
        if ((fb_sel_s0 /= fb_sel) or (fb_ona= '1')) then
            dly_cnt <= 0;
            fb_vld  <= '0';
			fb_sw_cnt		<= x"000000";
        else
            if (dly_cnt = dly_set) then
                dly_cnt <= dly_cnt;
                fb_vld  <= '1';
            else
                dly_cnt <= dly_cnt + 1;
                fb_vld  <= '0';
            end if;
			fb_sw_cnt		<= fb_sw_cnt + '1';
        end if;
    end if;
end if;
end process;

fb_sw_cnt_out <= fb_sw_cnt;
fb_valid <= fb_vld;

process(clk)
begin
if rising_edge(clk) then
    if (rst_n_sync = '0') then
        fb_in_buf   <= ( others => '0' );
        fb_port     <= x"00";
        pow_din_i_s0 <= ( others => ( others => '0' ));
        pow_din_q_s0 <= ( others => ( others => '0' ));
        pow_din_i_s1 <= ( others => ( others => '0' ));
        pow_din_q_s1 <= ( others => ( others => '0' ));
        pow_en       <= "0000";
    else
        if (fb_vld = '1') then
            -- if (fb_ona= '1') then
                -- fb_in_buf    <= fb0_q_s1_gain_out & fb0_i_s1_gain_out & fb0_q_s0_gain_out & fb0_i_s0_gain_out;
                -- fb_port      <= x"00";
                -- pow_din_i_s0 <= ( others => ( others => '0' ));
                -- pow_din_q_s0 <= ( others => ( others => '0' ));
                -- pow_din_i_s1 <= ( others => ( others => '0' ));
                -- pow_din_q_s1 <= ( others => ( others => '0' ));
                -- pow_en       <= "0000";
            -- else
                if ( fb_sel_s0 = "00" ) then
                    fb_in_buf    <= fb0_q_s1_gain_out & fb0_i_s1_gain_out & fb0_q_s0_gain_out & fb0_i_s0_gain_out;
                    fb_port      <= x"00";
                    pow_din_i_s0(0) <= fb0_i_s0_gain_out;
                    pow_din_q_s0(0) <= fb0_q_s0_gain_out;
                    pow_din_i_s1(0) <= fb0_i_s1_gain_out;
                    pow_din_q_s1(0) <= fb0_q_s1_gain_out;
                    pow_din_i_s0(1) <= x"0000";
                    pow_din_q_s0(1) <= x"0000";
                    pow_din_i_s1(1) <= x"0000";
                    pow_din_q_s1(1) <= x"0000";
                    pow_din_i_s0(2) <= x"0000";
                    pow_din_q_s0(2) <= x"0000";
                    pow_din_i_s1(2) <= x"0000";
                    pow_din_q_s1(2) <= x"0000";
                    pow_din_i_s0(3) <= x"0000";
                    pow_din_q_s0(3) <= x"0000";
                    pow_din_i_s1(3) <= x"0000";
                    pow_din_q_s1(3) <= x"0000";
                    pow_en          <= "0001";
                elsif ( fb_sel_s0 = "01" ) then
                    fb_in_buf    <= fb0_q_s1_gain_out & fb0_i_s1_gain_out & fb0_q_s0_gain_out & fb0_i_s0_gain_out;
                    fb_port      <= x"01";
                    pow_din_i_s0(0) <= x"0000";
                    pow_din_q_s0(0) <= x"0000";
                    pow_din_i_s1(0) <= x"0000";
                    pow_din_q_s1(0) <= x"0000";
                    pow_din_i_s0(1) <= fb0_i_s0_gain_out;
                    pow_din_q_s0(1) <= fb0_q_s0_gain_out;
                    pow_din_i_s1(1) <= fb0_i_s1_gain_out;
                    pow_din_q_s1(1) <= fb0_q_s1_gain_out;
                    pow_din_i_s0(2) <= x"0000";
                    pow_din_q_s0(2) <= x"0000";
                    pow_din_i_s1(2) <= x"0000";
                    pow_din_q_s1(2) <= x"0000";
                    pow_din_i_s0(3) <= x"0000";
                    pow_din_q_s0(3) <= x"0000";
                    pow_din_i_s1(3) <= x"0000";
                    pow_din_q_s1(3) <= x"0000";
                    pow_en          <= "0010";
                elsif ( fb_sel_s0 = "10" ) then
                    fb_in_buf    <= fb1_q_s1_gain_out & fb1_i_s1_gain_out & fb1_q_s0_gain_out & fb1_i_s0_gain_out;
                    fb_port      <= x"02";
                    pow_din_i_s0(0) <= x"0000";
                    pow_din_q_s0(0) <= x"0000";
                    pow_din_i_s1(0) <= x"0000";
                    pow_din_q_s1(0) <= x"0000";
                    pow_din_i_s0(1) <= x"0000";
                    pow_din_q_s0(1) <= x"0000";
                    pow_din_i_s1(1) <= x"0000";
                    pow_din_q_s1(1) <= x"0000";
                    pow_din_i_s0(2) <= fb1_i_s0_gain_out;
                    pow_din_q_s0(2) <= fb1_q_s0_gain_out;
                    pow_din_i_s1(2) <= fb1_i_s1_gain_out;
                    pow_din_q_s1(2) <= fb1_q_s1_gain_out;
                    pow_din_i_s0(3) <= x"0000";
                    pow_din_q_s0(3) <= x"0000";
                    pow_din_i_s1(3) <= x"0000";
                    pow_din_q_s1(3) <= x"0000";
                    pow_en          <= "0100";
                elsif ( fb_sel_s0 = "11" ) then
                    fb_in_buf    <= fb1_q_s1_gain_out & fb1_i_s1_gain_out & fb1_q_s0_gain_out & fb1_i_s0_gain_out;
                    fb_port      <= x"03";
                    pow_din_i_s0(0) <= x"0000";
                    pow_din_q_s0(0) <= x"0000";
                    pow_din_i_s1(0) <= x"0000";
                    pow_din_q_s1(0) <= x"0000";
                    pow_din_i_s0(1) <= x"0000";
                    pow_din_q_s0(1) <= x"0000";
                    pow_din_i_s1(1) <= x"0000";
                    pow_din_q_s1(1) <= x"0000";
                    pow_din_i_s0(2) <= x"0000";
                    pow_din_q_s0(2) <= x"0000";
                    pow_din_i_s1(2) <= x"0000";
                    pow_din_q_s1(2) <= x"0000";
                    pow_din_i_s0(3) <= fb1_i_s0_gain_out;
                    pow_din_q_s0(3) <= fb1_q_s0_gain_out;
                    pow_din_i_s1(3) <= fb1_i_s1_gain_out;
                    pow_din_q_s1(3) <= fb1_q_s1_gain_out;
                    pow_en          <= "1000";
                end if;
            -- end if;
		else
			fb_in_buf   <= ( others => '0' );
			-- fb_port     <= x"00";
			pow_din_i_s0 <= ( others => ( others => '0' ));
			pow_din_q_s0 <= ( others => ( others => '0' ));
			pow_din_i_s1 <= ( others => ( others => '0' ));
			pow_din_q_s1 <= ( others => ( others => '0' ));
			pow_en       <= "0000";
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if (fb_in_tready = '0') then
        fb_in_tdata  <= ( others => '0' );
        fb_in_tuser  <= ( others => '0' );
        fb_in_tvalid <= '0';
    else
        if (fb_ona = '1' or fb_vld = '0') then
		--if (tdd_sync_dl_sync = '1') then
            fb_in_tdata  <= ( others => '0' );
            fb_in_tuser  <= '1' & fb_port(6 downto 0);
            fb_in_tvalid <= '1';
        else
            fb_in_tdata  <= fb_in_buf;
            fb_in_tuser  <= fb_port;
            fb_in_tvalid <= '1';
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
   if (fb_ona= '1') then
       fb_sw   <= not mxl_fb_sw;--mxl_fb_sw;--230303_fix (logensys fb sw adapt)
   else
        fb_sw   <= fb_sw_reg;
   end if;
end if;
end process;

fb_pow_bank : for n in 0 to 3 generate
fb_pow_mea : entity work.pow_mea_tdd_s2_u
 generic map(
    clock_frequency => 491_520        , -- system clock frequency in khz 7_680, 61_440, 30_720, 61_440, 122_880, 245_760, 491_520
    unit_frequency  => 61_440         , -- unit clock frequency in khz 7_680, 5_760
    tdd_period      => 5_000          , -- tdd_period(us) 2_500, 5_000 ..
    tdd_high_time   => 3_857          , -- tdd_high_time(us) 3_857, 1_142
    check_time      => 20_000         ) -- check cycle(us) 20_000, 40_000, 80_000 ~ 320_000
 port map(
    clk             => clk             , --: in  std_logic;
    clk_unit        => clk_61p44       , --: in  std_logic;
    clk_tdd         => clk_122p88      , --: in  std_logic;
    reset_n         => rst_n_sync      , --: in  std_logic;
    tdd_sync        => tdd_sync        , --: in  std_logic;
    din_i_s0        => pow_din_i_s0(n) , --: in  std_logic_vector(15 downto 0);
    din_q_s0        => pow_din_q_s0(n) , --: in  std_logic_vector(15 downto 0);
    din_i_s1        => pow_din_i_s1(n) , --: in  std_logic_vector(15 downto 0);
    din_q_s1        => pow_din_q_s1(n) , --: in  std_logic_vector(15 downto 0);
    din_vld         => pow_en(n)       , --: in  std_logic;
    chk_en          => pow_en(n)       , --: in  std_logic;
    power           => fb_pow(n)       , --: out std_logic_vector(31 downto 0);
    peak_power      => fb_peak(n)      ); --: out std_logic_vector(31 downto 0)
end generate;


pow_en_fb <= pow_en;


end beh;




