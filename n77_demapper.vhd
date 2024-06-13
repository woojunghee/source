--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- title         : payload demapper for cpri framer
-- project       :
---------------------------------------------------------------------------
-- file name     : demapper.vhd
-- author        :
---------------------------------------------------------------------------
-- description   :
-- function      :
-- file hierarch :
---------------------------------------------------------------------------
-- rem(mark)     :

---------------------------------------------------------------------------
-- revisions history :
-- date        version  author  description
-- 2017/09/29  0.0      DK     initial release
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
Library xpm;
use xpm.vcomponents.all;

entity n77_demapper is
port(
    reset                  : in  std_logic; -- active high reset
    clk_368p64             : in  std_logic; -- 368.64mhz
    clk_122p88             : in  std_logic;
    din                    : in  std_logic_vector( 63 downto  0); -- iq_rx[63 : 0] , should be synchronized with cnt_word
    basic_frame_first_word : in  std_logic;
    i0_m0                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m0                  : out std_logic_vector( 15 downto  0);
    i0_m1                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m1                  : out std_logic_vector( 15 downto  0);
    i0_m2                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m2                  : out std_logic_vector( 15 downto  0);
    i0_m3                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m3                  : out std_logic_vector( 15 downto  0);
    i1_m0                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m0                  : out std_logic_vector( 15 downto  0);
    i1_m1                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m1                  : out std_logic_vector( 15 downto  0);
    i1_m2                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m2                  : out std_logic_vector( 15 downto  0);
    i1_m3                  : out std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m3                  : out std_logic_vector( 15 downto  0);
    tdd_sync               : out std_logic;
    tdd_sync_lock          : out std_logic
    );
end n77_demapper;

architecture arch of n77_demapper is

    signal n77_frame_data     : std_logic_vector(351 downto 0) := (others => '0');
    signal n77_frame_buf      : std_logic_vector(31 downto 0) := (others => '0');
    signal n77_iq_data        : std_logic_vector(351 downto 0) := (others => '0');

    signal iq0_m0             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq0_m1             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq0_m2             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq0_m3             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq1_m0             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq1_m1             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq1_m2             : std_logic_vector(43 downto 0)   := x"00000000000";
    signal iq1_m3             : std_logic_vector(43 downto 0)   := x"00000000000";

    signal n77_empty          : std_logic;
    signal n77_wr_en          : std_logic;
    signal cnt_word           : integer range 0 to 95;
    signal n77_out_cnt        : integer range 0 to 9;
    signal n77_rd_en          : std_logic;
    signal n77_iq_valid       : std_logic;

    signal cnt_start          : integer range 0 to 3;
    signal fifo_rst           : std_logic;

    signal rst_122p88         : std_logic;
    signal rst_368p64         : std_logic;

    signal rd_data_count      : std_logic_vector(3 downto 0);
    signal wr_data_count      : std_logic_vector(3 downto 0);

    signal tdd_sync_cnt       : integer range 0 to 11;

    signal tdd_sync_frame_cnt :integer range 0 to 31;
    signal tsync_frame32      : std_logic_vector(31 downto 0);
    signal tsync_lock32       : std_logic_vector(31 downto 0);
    signal tsync_rst          : std_logic;

begin

rst_blk_368p64: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 4, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => reset,
     dest_clk  => clk_368p64,
     dest_arst => rst_368p64
  );

rst_blk_122p88: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 4, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => reset,
     dest_clk  => clk_122p88,
     dest_arst => rst_122p88
  );

  --=================================================================================
  process(clk_368p64)
  begin
    if rising_edge(clk_368p64) then
      if (rst_368p64 = '1') then
            n77_wr_en      <= '0';
            n77_frame_data <= (others => '0');
            tsync_frame32  <= (others => '0');
            tsync_lock32   <= (others => '0');
      else
        case  cnt_word is
        when 0  =>                                          n77_wr_en <= '0';
        when 1  => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 2  => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 3  => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 4  => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 5  => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 6  => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 7  => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 8  => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 9  => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 10 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 11 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 12 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 13 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 14 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 15 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 16 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 17 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 18 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 19 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 20 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 21 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 22 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 23 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 24 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 25 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 26 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 27 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 28 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 29 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 30 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 31 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 32 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 33 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 34 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 35 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 36 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 37 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 38 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 39 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 40 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 41 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 42 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 43 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 44 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 45 => n77_wr_en <= '0'; tsync_lock32 <=din(63 downto 32); tsync_frame32 <=din(31 downto 0); tsync_rst <= '1';
        when 46 => n77_wr_en <= '0'; tsync_rst <= '0';
        when 47 => n77_wr_en <= '0';
        when 48 => n77_wr_en <= '0';
        when 49 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 50 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 51 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 52 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 53 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 54 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 55 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 56 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 57 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 58 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 59 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 60 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 61 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 62 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 63 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 64 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 65 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 66 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 67 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 68 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 69 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 70 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 71 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 72 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 73 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 74 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 75 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 76 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 77 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 78 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 79 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 80 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 81 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 82 => n77_frame_data( 63 downto   0) <= din;   n77_wr_en <= '0';
        when 83 => n77_frame_data(127 downto  64) <= din;   n77_wr_en <= '0';
        when 84 => n77_frame_data(191 downto 128) <= din;   n77_wr_en <= '0';
        when 85 => n77_frame_data(255 downto 192) <= din;   n77_wr_en <= '0';
        when 86 => n77_frame_data(319 downto 256) <= din;   n77_wr_en <= '0';
        when 87 => n77_frame_data(351 downto 320) <= din(31 downto 0);  n77_frame_buf <= din(63 downto 32); n77_wr_en <= '1';
        when 88 => n77_frame_data( 95 downto  32) <= din;   n77_frame_data(31 downto 0) <= n77_frame_buf; n77_wr_en <= '0';
        when 89 => n77_frame_data(159 downto  96) <= din;   n77_wr_en <= '0';
        when 90 => n77_frame_data(223 downto 160) <= din;   n77_wr_en <= '0';
        when 91 => n77_frame_data(287 downto 224) <= din;   n77_wr_en <= '0';
        when 92 => n77_frame_data(351 downto 288) <= din;   n77_wr_en <= '1';
        when 93 => n77_wr_en <= '0';
        when 94 => n77_wr_en <= '0';
        when others =>  n77_wr_en <= '0';
        end case;
      end if;
    end if ;
  end process;


-- n77

process(clk_122p88)
begin
if rising_edge(clk_122p88)  then
    if (rst_122p88 = '1') then
        n77_out_cnt <= 0;
    else
        if (n77_out_cnt=1) then
            n77_out_cnt <= 0;
        else
            n77_out_cnt <= n77_out_cnt + 1;
        end if;
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88)  then
    if (n77_out_cnt = 1 and n77_empty='0') then
        n77_rd_en    <= '1';
        n77_iq_valid <= '1';
    else
        n77_rd_en    <= '0';
        n77_iq_valid <= '0';
    end if;
end if;
end process;

demapper_fifo : entity work.fifo_352bit
  port map(
    wr_clk   => clk_368p64     , --: in  std_logic;
    rd_clk   => clk_122p88     , --: in  std_logic;
    rst      => fifo_rst       , --: in  std_logic;
    din      => n77_frame_data , --: in  std_logic_vector(319 downto  0);
    wr_en    => n77_wr_en      , --: in  std_logic;
    rd_en    => n77_rd_en      , --: in  std_logic;
    dout     => n77_iq_data    , --: out std_logic_vector(319 downto  0);
    full     => open           , --: out std_logic;
    empty    => n77_empty      ,--);
    rd_data_count => rd_data_count        ,
    wr_data_count => wr_data_count        );

process(clk_122p88)
begin
if rising_edge(clk_122p88)  then
    if (rst_122p88 = '1') then
        iq0_m0    <= (others => '0');
        iq0_m1    <= (others => '0');
        iq0_m2    <= (others => '0');
        iq0_m3    <= (others => '0');
        iq1_m0    <= (others => '0');
        iq1_m1    <= (others => '0');
        iq1_m2    <= (others => '0');
        iq1_m3    <= (others => '0');
    else
        iq0_m0    <= n77_iq_data( 43 downto   0);
        iq0_m1    <= n77_iq_data( 87 downto  44);
        iq0_m2    <= n77_iq_data(131 downto  88);
        iq0_m3    <= n77_iq_data(175 downto 132);
        iq1_m0    <= n77_iq_data(219 downto 176);
        iq1_m1    <= n77_iq_data(263 downto 220);
        iq1_m2    <= n77_iq_data(307 downto 264);
        iq1_m3    <= n77_iq_data(351 downto 308);
    end if;
end if;
end process;


  --=================================================================================
  --============cnt_word synchronized with basic_frame_first_word ===================
  --=================================================================================

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        cnt_word      <= 0;
        cnt_start      <= 0;
       else
        if (basic_frame_first_word = '1') then
              cnt_word    <= 0;

            if( cnt_start = 3 ) then
                cnt_start    <= cnt_start;
            else
                cnt_start    <= cnt_start + 1;
              end if;

        else
            cnt_word    <= cnt_word + 1;
        end if;
       end if;
    end if;
end process;

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (cnt_start = 0) then
        fifo_rst <= '1';
    elsif (cnt_start = 1) then
        if (cnt_word >= 0) then
            fifo_rst <= '0';
        else
            fifo_rst <= '1';
        end if;
    else
        fifo_rst <= '0';
    end if;
end if;
end process;


--de compress

  bfp_decomp_40_64_iq0_m0 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq0_m0       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i0_m0        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q0_m0        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq0_m1 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq0_m1       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i0_m1        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q0_m1        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq0_m2 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq0_m2       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i0_m2        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q0_m2        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq0_m3 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq0_m3       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i0_m3        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q0_m3        ); --: in  std_logic_logic_vector(15 downto 0);



  bfp_decomp_40_64_iq1_m0 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq1_m0       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i1_m0        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q1_m0        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq1_m1 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq1_m1       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i1_m1        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q1_m1        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq1_m2 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq1_m2       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i1_m2        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q1_m2        ); --: in  std_logic_logic_vector(15 downto 0);

  bfp_decomp_40_64_iq1_m3 : entity work.bfp_decomp_44_64
    port map (
      rst           => rst_122p88   ,  --: in  std_logic;
      clk           => clk_122p88   ,  --: in  std_logic;
      comp_iq       => iq1_m3       ,  --: in  std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid ,  --: in  std_logic;
      i_out         => i1_m3        ,  --: in  std_logic_logic_vector(15 downto 0);
      q_out         => q1_m3        ); --: in  std_logic_logic_vector(15 downto 0);


--- tsync

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1' or tsync_rst = '1') then
        tdd_sync_cnt       <= 0;
        tdd_sync_frame_cnt <= 0;
    else
        if (tdd_sync_cnt = 2) then
            tdd_sync_cnt       <= 0;
            if (tdd_sync_frame_cnt = 31) then
                tdd_sync_frame_cnt <= 0;
            else
                tdd_sync_frame_cnt <= tdd_sync_frame_cnt + 1;
            end if;
        else
            tdd_sync_cnt       <= tdd_sync_cnt + 1;
        end if;
    end if;
end if;
end process;


process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        tdd_sync      <= '0';
        tdd_sync_lock <= '0';
    else
        if (tdd_sync_cnt = 1) then
            tdd_sync        <= tsync_frame32(tdd_sync_frame_cnt);
            tdd_sync_lock   <= tsync_lock32(tdd_sync_frame_cnt);
        end if;
    end if;
end if;
end process;



end arch;