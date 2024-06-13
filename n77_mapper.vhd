--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- title         : payload mapper_test for cpri framer
-- project       :
---------------------------------------------------------------------------
-- file name     : mapper.vhd
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


entity n77_mapper is
port(
    reset         : in  std_logic                      ; -- active high reset
    clk_368p64    : in  std_logic                      ; -- 368.64mhz
    clk_122p88    : in  std_logic                      ;
    i0_m0         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m0         : in  std_logic_vector( 15 downto  0);
    i0_m1         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m1         : in  std_logic_vector( 15 downto  0);
    i0_m2         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m2         : in  std_logic_vector( 15 downto  0);
    i0_m3         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q0_m3         : in  std_logic_vector( 15 downto  0);
    i1_m0         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m0         : in  std_logic_vector( 15 downto  0);
    i1_m1         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m1         : in  std_logic_vector( 15 downto  0);
    i1_m2         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m2         : in  std_logic_vector( 15 downto  0);
    i1_m3         : in  std_logic_vector( 15 downto  0); -- 122.88mhz
    q1_m3         : in  std_logic_vector( 15 downto  0);
    iq_tx_enable  : in  std_logic                      ;
    tdd_sync      : in  std_logic                      ;
    tdd_sync_lock : in  std_logic                      ;
    dout          : out std_logic_vector( 63 downto 0));
end n77_mapper;

architecture arch of n77_mapper is

    signal iq0_m0          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq0_m1          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq0_m2          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq0_m3          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq1_m0          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq1_m1          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq1_m2          : std_logic_vector(43 downto 0)   :=  x"00000000000";
    signal iq1_m3          : std_logic_vector(43 downto 0)   :=  x"00000000000";

    signal n77_iq_valid    : std_logic;

    signal n77_valid_cnt   : integer range 0 to 3;
    signal n77_in_data     : std_logic_vector(351 downto  0);
    signal n77_frame_data  : std_logic_vector(351 downto  0);
    signal n77_frame_buf   : std_logic_vector(31 downto  0);
    signal n77_wr_en       : std_logic;
    signal n77_rd_en       : std_logic;
    signal fifo_rst        : std_logic;
    signal n77_empty       : std_logic;

    signal rd_en_0         : std_logic;

    signal rst_122p88      : std_logic;
    signal rst_368p64      : std_logic;

    signal cnt_word        : integer range 0 to 95;
    signal cnt_start       : integer range 0 to 3;

    signal rd_data_count   : std_logic_vector(3 downto 0);
    signal wr_data_count   : std_logic_vector(3 downto 0);

    signal tdd_sync_cnt    : integer range 0 to 2;

    signal tsync_frame32   : std_logic_vector(31 downto 0);
    signal tsync_lock32    : std_logic_vector(31 downto 0);


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



  bfp_comp_64_40_iq0_m0 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i0_m0             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q0_m0             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq0_m0            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => n77_iq_valid      ); --: out std_logic;

  bfp_comp_64_40_iq0_m1 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i0_m1             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q0_m1             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq0_m1            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;

  bfp_comp_64_40_iq0_m2 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i0_m2             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q0_m2             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq0_m2            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;

  bfp_comp_64_40_iq0_m3 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i0_m3             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q0_m3             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq0_m3            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;


  bfp_comp_64_40_iq1_m0 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i1_m0             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q1_m0             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq1_m0            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;

  bfp_comp_64_40_iq1_m1 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i1_m1             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q1_m1             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq1_m1            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;

  bfp_comp_64_40_iq1_m2 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i1_m2             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q1_m2             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq1_m2            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;

  bfp_comp_64_40_iq1_m3 : entity work.bfp_comp_64_44
    port map (
      rst           => rst_122p88        , --: in  std_logic;
      clk           => clk_122p88        , --: in  std_logic;
      i_in          => i1_m3             , --: in  std_logic_logic_vector(15 downto 0);
      q_in          => q1_m3             , --: in  std_logic_logic_vector(15 downto 0);
      comp_iq       => iq1_m3            , --: out std_logic_logic_vector(43 downto 0);
      comp_iq_valid => open              ); --: out std_logic;


process(clk_122p88)
begin
if rising_edge(clk_122p88)  then
    if (rst_122p88 = '1') then
        n77_in_data    <= (others => '0');
    else
        if (n77_iq_valid = '1') then
            n77_in_data <= iq1_m3 & iq1_m2 & iq1_m1 & iq1_m0 & iq0_m3 & iq0_m2 & iq0_m1 & iq0_m0;
        end if;
    end if;
end if;
end process;


n77_wr_en <= n77_iq_valid;


mapper_fifo_n77 : entity work.fifo_352bit
  port map(
    wr_clk        => clk_122p88           , --: in  std_logic;
    rd_clk        => clk_368p64           , --: in  std_logic;
    rst           => fifo_rst             , --: in  std_logic;
    din           => n77_in_data          , --: in  std_logic_vector(351 downto  0);
    wr_en         => n77_wr_en            , --: in  std_logic;
    rd_en         => n77_rd_en            , --: in  std_logic;
    dout          => n77_frame_data       , --: out std_logic_vector(351 downto  0);
    full          => open                 , --: out std_logic;
    empty         => n77_empty            ,
    rd_data_count => rd_data_count        ,
    wr_data_count => wr_data_count        );

--ila_map_b : entity work.ila_map_b
--port map(
--	clk			=> clk_122p88,
--	probe0		=> iq0_m0,--44
--    probe1		=> iq1_m0--44
--);
--ila_map_a : entity work.ila_map_a
--port map(
--	clk			=> clk_368p64,
--	probe0		=> n77_frame_data(43 downto 0),--44
--    probe1		=> n77_frame_data(219 downto 176)--44
--);

--====================================================================================

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        cnt_word      <= 0;
        cnt_start     <= 0;
    else
        if (iq_tx_enable = '1') then
              cnt_word    <= 0;

            if( cnt_start = 3 ) then
                cnt_start   <= cnt_start;
            else
                cnt_start   <= cnt_start + 1;
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


process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (n77_empty = '0') then
        n77_rd_en <= rd_en_0;
    else
        n77_rd_en <= '0';
    end if;
end if;
end process;

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        tdd_sync_cnt    <= 0;
    else
        if (tdd_sync_cnt = 2) then
            tdd_sync_cnt    <= 0;
        else
            tdd_sync_cnt    <= tdd_sync_cnt + 1;
        end if;
    end if;
end if;
end process;

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        tsync_frame32 <= (others => '0');
        tsync_lock32  <= (others => '0');
    else
        if (tdd_sync_cnt = 2) then
            tsync_frame32  <= tdd_sync & tsync_frame32(31 downto 1);
            tsync_lock32   <= tdd_sync_lock & tsync_lock32(31 downto 1);
        end if;
    end if;
end if;
end process;


--====================================================================================
  process(clk_368p64)
  begin
    if rising_edge(clk_368p64) then
      if (rst_368p64 = '1') then
            dout    <= (others => '0') ;
            rd_en_0 <='0';
      else
        case cnt_word is
        when 0  => dout <= (others => '0');                rd_en_0 <='0';
        when 1  => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 2  => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 3  => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 4  => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 5  => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 6  => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 7  => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 8  => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 9  => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 10 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 11 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 12 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 13 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 14 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 15 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 16 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 17 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 18 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 19 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 20 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 21 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 22 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 23 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 24 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 25 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 26 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 27 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 28 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 29 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 30 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 31 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 32 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 33 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 34 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 35 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 36 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 37 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 38 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 39 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 40 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 41 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 42 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 43 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 44 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 45 => dout <= tsync_lock32 & tsync_frame32;   rd_en_0 <='0';
        when 46 => dout <= (others => '0');                rd_en_0 <='0';
        when 47 => dout <= (others => '0');                rd_en_0 <='0';
        when 48 => dout <= (others => '0');                rd_en_0 <='0';
        when 49 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 50 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 51 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 52 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 53 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 54 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 55 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 56 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 57 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 58 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 59 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 60 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 61 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 62 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 63 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 64 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 65 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 66 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 67 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 68 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 69 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 70 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 71 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 72 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 73 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 74 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 75 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 76 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 77 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 78 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 79 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 80 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 81 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 82 => dout <= n77_frame_data( 63 downto   0); rd_en_0 <='0';
        when 83 => dout <= n77_frame_data(127 downto  64); rd_en_0 <='0';
        when 84 => dout <= n77_frame_data(191 downto 128); rd_en_0 <='1';
        when 85 => dout <= n77_frame_data(255 downto 192); rd_en_0 <='0'; n77_frame_buf <= n77_frame_data(351 downto 320);
        when 86 => dout <= n77_frame_data(319 downto 256); rd_en_0 <='0';
        when 87 => dout <= n77_frame_data( 31 downto   0) & n77_frame_buf; rd_en_0 <='0';
        when 88 => dout <= n77_frame_data( 95 downto  32); rd_en_0 <='0';
        when 89 => dout <= n77_frame_data(159 downto  96); rd_en_0 <='0';
        when 90 => dout <= n77_frame_data(223 downto 160); rd_en_0 <='1';
        when 91 => dout <= n77_frame_data(287 downto 224); rd_en_0 <='0';
        when 92 => dout <= n77_frame_data(351 downto 288); rd_en_0 <='0';
        when 93 => dout <= (others => '0');                rd_en_0 <='0';
        when 94 => dout <= (others => '0');                rd_en_0 <='0';
        when others => dout <= (others => '0');            rd_en_0 <='0';
        end case;
      end if;
    end if ;
  end process;
--====================================================================================
--====================================================================================



end arch;