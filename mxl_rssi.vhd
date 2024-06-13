library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity mxl_rssi is
port(
    loc_clk         : in std_logic;
    rssi_clk        : in std_logic;
    rssi_stb        : in std_logic;
    rssi_data       : in std_logic;
	tdd_sync_rssi	: in std_logic;
    peak            : out std_logic_vector(3 downto 0);
    hi              : out std_logic_vector(3 downto 0);
    lo              : out std_logic_vector(3 downto 0)
    );
end mxl_rssi;

architecture Behavioral of mxl_rssi is

signal rx_peak            : std_logic_vector(3 downto 0) := "0000";
signal rx_hi              : std_logic_vector(3 downto 0) := "0000";
signal rx_lo              : std_logic_vector(3 downto 0) := "0000";

signal cnt                : integer range 0 to 15 := 15;

begin


process(rssi_clk)
begin
if falling_edge(rssi_clk) then
    if (rssi_stb = '1') then
        cnt <= 1;
    else
        if (cnt= 15) then
            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
    end if;
end if;
end process;

-- rf port change
-- rf port 0 -> 2
-- rf port 1 -> 3
-- rf port 2 -> 0
-- rf port 3 -> 1

process(rssi_clk)
begin
if rising_edge(rssi_clk) then
	if (tdd_sync_rssi = '1') then
    case cnt is
        when  0  => rx_peak(2) <= rssi_data;
        when  1  => rx_hi(2)   <= rssi_data;
        when  2  => rx_lo(2)   <= rssi_data;
        when  3  => null;
        when  4  => rx_peak(3) <= rssi_data;
        when  5  => rx_hi(3)   <= rssi_data;
        when  6  => rx_lo(3)   <= rssi_data;
        when  7  => null;
        when  8  => rx_peak(0) <= rssi_data;
        when  9  => rx_hi(0)   <= rssi_data;
        when 10  => rx_lo(0)   <= rssi_data;
        when 11  => null;
        when 12  => rx_peak(1) <= rssi_data;
        when 13  => rx_hi(1)   <= rssi_data;
        when 14  => rx_lo(1)   <= rssi_data;
        when 15  => null;
    end case;
	end if;
end if;
end process;

peak_sync_blk : entity work.d_sync
generic map(
    bits    => 4                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => rssi_clk          , --: in   std_logic;
    out_clk => loc_clk           , --: in   std_logic;
    d_in    => rx_peak           , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => peak              ); --: out std_logic_vector(bits-1 downto 0)

hi_sync_blk : entity work.d_sync
generic map(
    bits    => 4                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => rssi_clk          , --: in   std_logic;
    out_clk => loc_clk           , --: in   std_logic;
    d_in    => rx_hi             , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => hi                ); --: out std_logic_vector(bits-1 downto 0)

lo_sync_blk : entity work.d_sync
generic map(
    bits    => 4                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => rssi_clk          , --: in   std_logic;
    out_clk => loc_clk           , --: in   std_logic;
    d_in    => rx_lo             , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => lo                ); --: out std_logic_vector(bits-1 downto 0)



end Behavioral;
