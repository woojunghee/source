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
    rst             : in  std_logic;
    tdd_sync        : in  std_logic;

    srx_ctrl_tready : out std_logic;
    srx_ctrl_tvalid : in  std_logic;
    srx_ctrl_tdata  : in  std_logic_vector(7 downto 0);

    mxl_fb_sw       : in  std_logic_vector(1 downto 0);
    fb_ona          : in  std_logic;
    fb_sw_dly       : in  std_logic_vector(10 downto 0);
    fb_sw           : out std_logic_vector(1 downto 0);

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

 signal pow_din_i       : arr_4_16_stdlogic;
 signal pow_din_vld     : std_logic_vector(3 downto 0);



 attribute async_reg : string;


begin

rst_blk_245p76 : xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst,
     dest_clk  => clk,
     dest_arst => rst_sync
  );

rst_n_sync  <= rst_sync;

path_en_sync_blk : entity work.d_sync
generic map(
    bits    => 11         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk        , --: in   std_logic;
    out_clk => clk            , --: in   std_logic;
    d_in    => fb_sw_dly      , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => fb_sw_dly_sync ); --: out std_logic_vector(bits-1 downto 0)


process(clk)
begin
if rising_edge(clk) then
    srx_ctrl_tready    <= '1';
    if (rst_sync = '1') then
        fb_sel    <= "00";
        fb_sw_reg <= "11";
    else
        if (srx_ctrl_tvalid = '1') then
            case(srx_ctrl_tdata) is
                when x"00"      => fb_sel    <= "00";  fb_sw_reg <= "11";
                when x"01"      => fb_sel    <= "01";  fb_sw_reg <= "10";
                when x"02"      => fb_sel    <= "10";  fb_sw_reg <= "11";
                when x"03"      => fb_sel    <= "11";  fb_sw_reg <= "01";
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
    if (rst_sync = '1') then
        fb_vld    <= '0';
        dly_cnt   <= 0;
        fb_sel_s0 <= "00";
    else
        fb_sel_s0 <= fb_sel;
        if (fb_sel_s0 /= fb_sel) then
            dly_cnt <= 0;
            fb_vld  <= '0';
        else
            if (dly_cnt = dly_set) then
                dly_cnt <= dly_cnt;
                fb_vld  <= '1';
            else
                dly_cnt <= dly_cnt + 1;
                fb_vld  <= '0';
            end if;
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (rst_sync = '1') then
        fb_in_buf   <= ( others => '0' );
        fb_port     <= x"00";
        pow_din_i   <= ( others => ( others => '0' ));
        pow_din_vld <= "0000";
    else
        if (fb_vld = '1') then
            if ( fb_sel_s0 = "00" ) then
                fb_in_buf    <= fb0_q_s1 & fb0_i_s1 & fb0_q_s0 & fb0_i_s0;
                fb_port      <= x"00";
                pow_din_i(0) <= fb0_i_s0;
                pow_din_i(1) <= x"0000";
                pow_din_i(2) <= x"0000";
                pow_din_i(3) <= x"0000";
                pow_din_vld  <= "0001";
            elsif ( fb_sel_s0 = "01" ) then
                fb_in_buf    <= fb0_q_s1 & fb0_i_s1 & fb0_q_s0 & fb0_i_s0;
                fb_port      <= x"01";
                pow_din_i(0) <= x"0000";
                pow_din_i(1) <= fb0_i_s0;
                pow_din_i(2) <= x"0000";
                pow_din_i(3) <= x"0000";
                pow_din_vld  <= "0010";
            elsif ( fb_sel_s0 = "10" ) then
                fb_in_buf    <= fb1_q_s1 & fb1_i_s1 & fb1_q_s0 & fb1_i_s0;
                fb_port      <= x"02";
                pow_din_i(0) <= x"0000";
                pow_din_i(1) <= x"0000";
                pow_din_i(2) <= fb1_i_s0;
                pow_din_i(3) <= x"0000";
                pow_din_vld  <= "0100";
            elsif ( fb_sel_s0 = "11" ) then
                fb_in_buf    <= fb1_q_s1 & fb1_i_s1 & fb1_q_s0 & fb1_i_s0;
                fb_port      <= x"03";
                pow_din_i(0) <= x"0000";
                pow_din_i(1) <= x"0000";
                pow_din_i(2) <= x"0000";
                pow_din_i(3) <= fb1_i_s0;
                pow_din_vld  <= "1000";
            end if;
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
        if (fb_ona = '1') then
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
        fb_sw   <= not mxl_fb_sw;
    else
        fb_sw   <= fb_sw_reg;
    end if;
end if;
end process;



fb_pow_bank : for n in 0 to 3 generate
  fb_pow_mea : entity work.pow_mea_fb_r
    generic map (
      clock_frequency => clock_frequency,
      check_time      => 20
    )
    port map (
      clk             => clk           , --: in std_logic;
      loc_clk         => loc_clk       , --: in std_logic;
      reset_n         => rst_n_sync    , --: in std_logic;
      tdd_sync        => tdd_sync      , --: in std_logic;
      din_i           => pow_din_i(n)  , --: in std_logic_vector(15 downto 0);
      din_vld         => pow_din_vld(n),--: in std_logic;
      power           => fb_pow(n)     , --: out std_logic_vector(31 downto 0);
      peak_power      => fb_peak(n)    );--: out std_logic_vector(31 downto 0)
end generate;







end beh;




