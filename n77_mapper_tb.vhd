library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity n77_mapper_tb is
end;

architecture bench of n77_mapper_tb is

component n77_mapper
    port (
    reset         : in std_logic;
    clk_368p64    : in std_logic;
    clk_122p88    : in std_logic;
    i0_m0         : in std_logic_vector( 15 downto  0);
    q0_m0         : in std_logic_vector( 15 downto  0);
    i0_m1         : in std_logic_vector( 15 downto  0);
    q0_m1         : in std_logic_vector( 15 downto  0);
    i0_m2         : in std_logic_vector( 15 downto  0);
    q0_m2         : in std_logic_vector( 15 downto  0);
    i0_m3         : in std_logic_vector( 15 downto  0);
    q0_m3         : in std_logic_vector( 15 downto  0);
    i1_m0         : in std_logic_vector( 15 downto  0);
    q1_m0         : in std_logic_vector( 15 downto  0);
    i1_m1         : in std_logic_vector( 15 downto  0);
    q1_m1         : in std_logic_vector( 15 downto  0);
    i1_m2         : in std_logic_vector( 15 downto  0);
    q1_m2         : in std_logic_vector( 15 downto  0);
    i1_m3         : in std_logic_vector( 15 downto  0);
    q1_m3         : in std_logic_vector( 15 downto  0);
    iq_tx_enable  : in std_logic;
    tdd_sync      : in std_logic;
    tdd_sync_lock : in std_logic;
    dout          : out std_logic_vector( 63 downto 0)
  );
end component;


component n77_demapper
    port (
    reset                  : in std_logic;
    clk_368p64             : in std_logic;
    clk_122p88             : in std_logic;
    din                    : in std_logic_vector( 63 downto  0);
    basic_frame_first_word : in std_logic;
    i0_m0                  : out std_logic_vector( 15 downto  0);
    q0_m0                  : out std_logic_vector( 15 downto  0);
    i0_m1                  : out std_logic_vector( 15 downto  0);
    q0_m1                  : out std_logic_vector( 15 downto  0);
    i0_m2                  : out std_logic_vector( 15 downto  0);
    q0_m2                  : out std_logic_vector( 15 downto  0);
    i0_m3                  : out std_logic_vector( 15 downto  0);
    q0_m3                  : out std_logic_vector( 15 downto  0);
    i1_m0                  : out std_logic_vector( 15 downto  0);
    q1_m0                  : out std_logic_vector( 15 downto  0);
    i1_m1                  : out std_logic_vector( 15 downto  0);
    q1_m1                  : out std_logic_vector( 15 downto  0);
    i1_m2                  : out std_logic_vector( 15 downto  0);
    q1_m2                  : out std_logic_vector( 15 downto  0);
    i1_m3                  : out std_logic_vector( 15 downto  0);
    q1_m3                  : out std_logic_vector( 15 downto  0);
    tdd_sync               : out std_logic;
    tdd_sync_lock          : out std_logic
  );
end component;


  component bfp_comp_64_44
      port (
      rst           : in std_logic;
      clk           : in std_logic;
      i_in          : in std_logic_vector(15 downto 0);
      q_in          : in std_logic_vector(15 downto 0);
      comp_iq       : out std_logic_vector(43 downto 0);
      comp_iq_valid : out std_logic
    );
  end component;

  component bfp_decomp_44_64
      port (
      rst           : in std_logic;
      clk           : in std_logic;
      comp_iq       : in std_logic_vector(43 downto 0);
      comp_iq_valid : in std_logic;
      i_out         : out std_logic_vector(15 downto 0);
      q_out         : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period        : time := 5 ns;
  constant clk_122p88_period : time := 9 ns;
  constant clk_368p64_period : time := 3 ns;

  --constant clk_122p88_period : time := 8.138 ns;
  --constant clk_368p64_period : time := 2.713 ns;
  -- Generics

  -- Ports
  signal rst                    : std_logic;
  signal clk                    : std_logic;

  signal i0_m0                : std_logic_vector(15 downto 0);
  signal q0_m0                : std_logic_vector(15 downto 0);
  signal i0_m1                : std_logic_vector(15 downto 0);
  signal q0_m1                : std_logic_vector(15 downto 0);
  signal i0_m2                : std_logic_vector(15 downto 0);
  signal q0_m2                : std_logic_vector(15 downto 0);
  signal i0_m3                : std_logic_vector(15 downto 0);
  signal q0_m3                : std_logic_vector(15 downto 0);

  signal i1_m0                : std_logic_vector(15 downto 0);
  signal q1_m0                : std_logic_vector(15 downto 0);
  signal i1_m1                : std_logic_vector(15 downto 0);
  signal q1_m1                : std_logic_vector(15 downto 0);
  signal i1_m2                : std_logic_vector(15 downto 0);
  signal q1_m2                : std_logic_vector(15 downto 0);
  signal i1_m3                : std_logic_vector(15 downto 0);
  signal q1_m3                : std_logic_vector(15 downto 0);

  signal i0_m0_out            : std_logic_vector(15 downto 0);
  signal q0_m0_out            : std_logic_vector(15 downto 0);
  signal i0_m1_out            : std_logic_vector(15 downto 0);
  signal q0_m1_out            : std_logic_vector(15 downto 0);
  signal i0_m2_out            : std_logic_vector(15 downto 0);
  signal q0_m2_out            : std_logic_vector(15 downto 0);
  signal i0_m3_out            : std_logic_vector(15 downto 0);
  signal q0_m3_out            : std_logic_vector(15 downto 0);

  signal i1_m0_out            : std_logic_vector(15 downto 0);
  signal q1_m0_out            : std_logic_vector(15 downto 0);
  signal i1_m1_out            : std_logic_vector(15 downto 0);
  signal q1_m1_out            : std_logic_vector(15 downto 0);
  signal i1_m2_out            : std_logic_vector(15 downto 0);
  signal q1_m2_out            : std_logic_vector(15 downto 0);
  signal i1_m3_out            : std_logic_vector(15 downto 0);
  signal q1_m3_out            : std_logic_vector(15 downto 0);

  signal clk_368p64             : std_logic;
  signal clk_122p88             : std_logic;
  signal iq_tx_enable           : std_logic;
  signal dout                   : std_logic_vector( 63 downto 0);

  signal freerun_cnt            : integer range 0 to 95           := 95;
  signal basic_frame_first_word : std_logic;
  signal cnt_word               : integer range 0 to 95           := 95;
  signal tog                    : std_logic :='0';

  signal tdd_cnt                : integer range 0 to 12287        := 12287;
  signal tdd_sync               : std_logic :='0';
  signal tdd_sync_lock          : std_logic :='1';
  signal tdd_sync_out           : std_logic;
  signal tdd_sync_lock_out      : std_logic;

begin


   rst  <=  '1' after      0 ns,
            '0' after     27 ns;

clk_process : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process clk_process;

clk_368p64_process : process
begin
    clk_368p64 <= '1';
    wait for clk_368p64_period/2;
    clk_368p64 <= '0';
    wait for clk_368p64_period/2;
end process clk_368p64_process;

clk_122p88_process : process
begin
    clk_122p88 <= '1';
    wait for clk_122p88_period/2;
    clk_122p88 <= '0';
    wait for clk_122p88_period/2;
end process clk_122p88_process;


n77_mapper_inst : n77_mapper
  port map (
    reset         => rst,
    clk_368p64    => clk_368p64,
    clk_122p88    => clk_122p88,
    i0_m0         => i0_m0,
    q0_m0         => q0_m0,
    i0_m1         => i0_m1,
    q0_m1         => q0_m1,
    i0_m2         => i0_m2,
    q0_m2         => q0_m2,
    i0_m3         => i0_m3,
    q0_m3         => q0_m3,
    i1_m0         => i1_m0,
    q1_m0         => q1_m0,
    i1_m1         => i1_m1,
    q1_m1         => q1_m1,
    i1_m2         => i1_m2,
    q1_m2         => q1_m2,
    i1_m3         => i1_m3,
    q1_m3         => q1_m3,
    iq_tx_enable  => iq_tx_enable,
    tdd_sync      => tdd_sync,
    tdd_sync_lock => tdd_sync_lock,
    dout          => dout
  );


n77_demapper_inst : n77_demapper
  port map (
    reset                  => rst,
    clk_368p64             => clk_368p64,
    clk_122p88             => clk_122p88,
    din                    => dout,
    basic_frame_first_word => basic_frame_first_word,
    i0_m0                  => i0_m0_out,
    q0_m0                  => q0_m0_out,
    i0_m1                  => i0_m1_out,
    q0_m1                  => q0_m1_out,
    i0_m2                  => i0_m2_out,
    q0_m2                  => q0_m2_out,
    i0_m3                  => i0_m3_out,
    q0_m3                  => q0_m3_out,
    i1_m0                  => i1_m0_out,
    q1_m0                  => q1_m0_out,
    i1_m1                  => i1_m1_out,
    q1_m1                  => q1_m1_out,
    i1_m2                  => i1_m2_out,
    q1_m2                  => q1_m2_out,
    i1_m3                  => i1_m3_out,
    q1_m3                  => q1_m3_out,
    tdd_sync               => tdd_sync_out,
    tdd_sync_lock          => tdd_sync_lock_out
  );





--process(clk_491p52)
--begin
--if rising_edge(clk_491p52) then
--    if rst = '1' then
--        tog <= '0';
--    else
--        tog <= not tog;
--    end if;
--end if;
--end process;
--
--n77_iq_valid    <= tog;
--
--process(clk_491p52)
--begin
--if rising_edge(clk_491p52) then
--   if rst = '1' then
--        n77_iq_m0_in <= x"0000000000";
--        n77_iq_m0_in <= x"0000000000";
--   else
--        if (tog = '1') then
--            n77_iq_m0_in <= n77_iq_m0_in + '1';
--            n77_iq_m0_in <= n77_iq_m0_in + '1';
--        end if;
--   end if;
--end if;
--end process;



process(clk_122p88)
begin
if rising_edge(clk_122p88) then
   if rst = '1' then
        i0_m0   <= (others => '0');
        q0_m0   <= (others => '0');
        i0_m1   <= (others => '0');
        q0_m1   <= (others => '0');
        i0_m2   <= (others => '0');
        q0_m2   <= (others => '0');
        i0_m3   <= (others => '0');
        q0_m3   <= (others => '0');
        i1_m0   <= (others => '0');
        q1_m0   <= (others => '0');
        i1_m1   <= (others => '0');
        q1_m1   <= (others => '0');
        i1_m2   <= (others => '0');
        q1_m2   <= (others => '0');
        i1_m3   <= (others => '0');
        q1_m3   <= (others => '0');

   else
        i0_m0 <= i0_m0 + '1';
        q0_m0 <= q0_m0 + '1';
        i0_m1 <= i0_m1 + '1';
        q0_m1 <= q0_m1 + '1';
        i0_m2 <= i0_m2 + '1';
        q0_m2 <= q0_m2 + '1';
        i0_m3 <= i0_m3 + '1';
        q0_m3 <= q0_m3 + '1';
        i1_m0 <= i1_m0 - '1';
        q1_m0 <= q1_m0 - '1';
        i1_m1 <= i1_m1 - '1';
        q1_m1 <= q1_m1 - '1';
        i1_m2 <= i1_m2 - '1';
        q1_m2 <= q1_m2 - '1';
        i1_m3 <= i1_m3 - '1';
        q1_m3 <= q1_m3 - '1';
   end if;
end if;
end process;


process(clk_368p64)
begin
if rising_edge(clk_368p64)	 then
	if (rst = '1') then
		freerun_cnt <= 0;
	else
		if (freerun_cnt=95) then
			freerun_cnt <= 0;
		else
			freerun_cnt <= freerun_cnt + 1;
		end if;
	end if;
end if;
end process;

i_iq_tx_enable : process(clk_368p64)
begin
if rising_edge(clk_368p64)	 then
  if freerun_cnt = 94 then
	  iq_tx_enable <= '1';
  else
	  iq_tx_enable <= '0';
  end if;
end if;
end process;

tx_free_run_cnt : process(clk_368p64)
begin
if rising_edge(clk_368p64)	 then
  if rst = '1' then
	cnt_word	  <= 0;
  elsif iq_tx_enable = '1' then
	cnt_word	  <= 0;
  else
	cnt_word	  <= cnt_word + 1;
  end if;
end if;
end process;

process(clk_368p64)
begin
if rising_edge(clk_368p64)	 then
  basic_frame_first_word <= iq_tx_enable;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88)	 then
	if (rst = '1') then
		tdd_cnt <= 0;
	else
		if (tdd_cnt = 6292) then
			tdd_cnt <= 0;
		else
			tdd_cnt <= tdd_cnt + 1;
		end if;
	end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if ( tdd_cnt = 6292 ) then
        tdd_sync    <= not tdd_sync;
        tdd_sync_lock   <= not tdd_sync_lock;
    end if;
end if;
end process;



end;
