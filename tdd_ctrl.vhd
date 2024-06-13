
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity tdd_ctrl is
port(
    clk_122p88m	    : in  std_logic;
    loc_clk         : in  std_logic;
    reset           : in  std_logic;
    tdd_sync_in     : in  std_logic;
	tdd_inv			: in  std_logic;

    rising_pull     : in  std_logic_vector(16 downto 0);
    rising_push     : in  std_logic_vector(16 downto 0);
    falling_pull    : in  std_logic_vector(16 downto 0);
    falling_push    : in  std_logic_vector(16 downto 0);

	tdd_mode		: in  std_logic_vector(1 downto 0);

    tdd_sync_out    : out std_logic
    );
end tdd_ctrl;

architecture data of tdd_ctrl is

signal rising_pull_set	     : integer range 0 to 131071:= 0;
signal rising_push_set	     : integer range 0 to 131071:= 0;
signal falling_pull_set	     : integer range 0 to 131071:= 0;
signal falling_push_set	     : integer range 0 to 131071:= 0;

signal low_cnt		         : integer range 0 to 1228799;
signal last_low		         : integer range 0 to 1228799;
signal high_cnt		         : integer range 0 to 1228799;
signal last_high	         : integer range 0 to 1228799;

signal max_low_en	         : std_logic;
signal max_high_en	         : std_logic;

signal rising_pull_sig	     : std_logic;
signal rising_push_sig	     : std_logic;
signal falling_pull_sig	     : std_logic;
signal falling_push_sig	     : std_logic;

signal rising_pull_s0		 : std_logic_vector(16 downto 0);
signal rising_pull_s1		 : std_logic_vector(16 downto 0);
signal rising_push_s0		 : std_logic_vector(16 downto 0);
signal rising_push_s1		 : std_logic_vector(16 downto 0);
signal falling_pull_s0		 : std_logic_vector(16 downto 0);
signal falling_pull_s1		 : std_logic_vector(16 downto 0);
signal falling_push_s0		 : std_logic_vector(16 downto 0);
signal falling_push_s1		 : std_logic_vector(16 downto 0);

signal tdd_mode_s1           : std_logic_vector(1 downto 0);

signal tdd_sync				 : std_logic;

begin


rising_pull_sync_blk : entity work.d_sync
generic map(
    bits    => 17                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk_122p88m       , --: in   std_logic;
    d_in    => rising_pull       , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => rising_pull_s1    ); --: out std_logic_vector(bits-1 downto 0)

rising_push_sync_blk : entity work.d_sync
generic map(
    bits    => 17                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk_122p88m       , --: in   std_logic;
    d_in    => rising_push       , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => rising_push_s1    ); --: out std_logic_vector(bits-1 downto 0)

falling_pull_sync_blk : entity work.d_sync
generic map(
    bits    => 17                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk_122p88m       , --: in   std_logic;
    d_in    => falling_pull      , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => falling_pull_s1   ); --: out std_logic_vector(bits-1 downto 0)

falling_push_sync_blk : entity work.d_sync
generic map(
    bits    => 17                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk_122p88m       , --: in   std_logic;
    d_in    => falling_push      , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => falling_push_s1   ); --: out std_logic_vector(bits-1 downto 0)


process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if (tdd_inv = '0') then
		tdd_sync	<= tdd_sync_in;
	else
		tdd_sync	<= not tdd_sync_in;
	end if;
end if;
end process;

rising_pull_set		<= conv_integer(rising_pull_s1); -- +5
rising_push_set		<= conv_integer(rising_push_s1);
falling_pull_set	<= conv_integer(falling_pull_s1); -- +5
falling_push_set	<= conv_integer(falling_push_s1);


process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if (reset = '1') then
		low_cnt <= 0;
		last_low <= 0;
	else
		if (tdd_sync = '0') then
			low_cnt		<= low_cnt + 1;
			max_low_en	<= '1';
		else
			if (max_low_en = '1') then
				last_low	<= low_cnt;
				max_low_en	<= '0';
			else
				low_cnt		<= 0;
			end if;
		end if;
	end if;
end if;
end process;

process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if (reset = '1') then
		high_cnt <= 0;
		last_high <= 0;
	else
		if (tdd_sync = '1') then
			high_cnt   	<= high_cnt + 1;
			max_high_en <= '1';
		else
			if (max_high_en = '1') then
				last_high	<= high_cnt;
				max_high_en	<= '0';
			else
				high_cnt	<= 0;
			end if;
		end if;
	end if;
end if;
end process;

process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if (low_cnt > (last_low + 2 - rising_pull_set)) then
		rising_pull_sig  <= '1';
	else
		rising_pull_sig  <= '0';
	end if;

	if ((high_cnt < rising_push_set and high_cnt > 0) or (low_cnt > last_low + 2 - rising_push_set)) then
		rising_push_sig  <= '0';
	else
		rising_push_sig  <= '1';
	end if;
end if;
end process;

process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if (high_cnt > (last_high + 2 - falling_pull_set)) then
		falling_pull_sig <= '0';
	else
		falling_pull_sig <= '1';
	end if;

	if ((low_cnt < falling_push_set and low_cnt > 0) or (high_cnt > last_high + 2 - falling_push_set)) then
		falling_push_sig <= '1';
	else
		falling_push_sig <= '0';
	end if;
end if;
end process;

tdd_mode_sync_blk : entity work.d_sync
generic map(
    bits    => 2         ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk      , --: in   std_logic;
    out_clk => clk_122p88m  , --: in   std_logic;
    d_in    => tdd_mode     , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => tdd_mode_s1  ); --: out std_logic_vector(bits-1 downto 0)


process(clk_122p88m)
begin
if rising_edge(clk_122p88m) then
	if( tdd_mode_s1 = "10") then
		if ( tdd_inv = '0') then
			tdd_sync_out <= '0';
		else
			tdd_sync_out <= '1';
		end if;
	elsif ( tdd_mode_s1 = "01") then
		if ( tdd_inv = '0') then
			tdd_sync_out <= '1';
		else
			tdd_sync_out <= '0';
		end if;
	else
		if (last_high = 0 or last_low = 0) then
			tdd_sync_out	<= '0';
		else
			tdd_sync_out	<= (tdd_sync or rising_pull_sig or falling_push_sig) and (falling_pull_sig and rising_push_sig);
		end if;
	end if;
end if;
end process;



end data;