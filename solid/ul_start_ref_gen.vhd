library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
library unisim;
use unisim.vcomponents.all;
library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity ul_start_ref_gen is
generic(
    clock_frequency : integer := 245_760   --system clock frequency in khz 61_440, 122_880, 245_760, 491_520
);
port(
    clk             : in  std_logic; --122.88mhz
    rst_n           : in  std_logic;
    tdd_sync        : in  std_logic;
    ul_ref          : out std_logic_vector(1 downto 0)
);

end ul_start_ref_gen;

architecture beh of ul_start_ref_gen is
 signal rst_n_sync        : std_logic;
 signal tdd_sync_s0       : std_logic;
 signal tdd_sync_s1       : std_logic;
 signal start_flag        : std_logic;
 signal trig_10ms		  : std_logic;

begin

rst_blk_cdc : xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst_n,
     dest_clk  => clk,
     dest_arst => rst_n_sync
  );

process(clk)
begin
if rising_edge(clk) then
    tdd_sync_s0 <= not tdd_sync;
    tdd_sync_s1 <= tdd_sync_s0;
    if (rst_n_sync = '0') then
        start_flag <= '0';
		trig_10ms <= '0';
    else
        if (tdd_sync_s1 = '0' and tdd_sync_s0 = '1') then
            start_flag <= '1';
			trig_10ms <= not trig_10ms;
        else
            start_flag <= '0';
			trig_10ms <= trig_10ms;
        end if;
    end if;
end if;
end process;

process(clk)
variable cnt : integer range 0 to 5;
begin
if rising_edge(clk) then
    if (rst_n_sync = '0') then
        cnt := 5;
        ul_ref     <= "00";
    else
        if (start_flag = '1' and trig_10ms = '1') then
            cnt := 0;
            ul_ref     <= "00";
        else
            if (cnt = 5) then
                cnt := cnt;
                ul_ref     <= "00";
            else
                cnt := cnt + 1;
                ul_ref     <= "11";
            end if;
        end if;
    end if;
end if;
end process;

end beh;




