library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity mxl_mgain is
port(
    clk             : in  std_logic;                    -- 25Mhz
    loc_clk         : in  std_logic;
    rst_n           : in  std_logic;
    gain_m0         : in  std_logic_vector(4 downto 0);
    gain_m1         : in  std_logic_vector(4 downto 0);
    gain_m2         : in  std_logic_vector(4 downto 0);
    gain_m3         : in  std_logic_vector(4 downto 0);
    mgain_clk       : out std_logic;                    -- max 30Mhz
    mgain_stb       : out std_logic;
    mgain_data      : out std_logic_vector(1 downto 0)
    );
end mxl_mgain;

architecture Behavioral of mxl_mgain is

signal cnt              : integer range 0 to 11 := 11;
signal gain_m0_sync     : std_logic_vector(4 downto 0);
signal gain_m1_sync     : std_logic_vector(4 downto 0);
signal gain_m2_sync     : std_logic_vector(4 downto 0);
signal gain_m3_sync     : std_logic_vector(4 downto 0);

begin

-- rf port change
-- dl rf port 0 -> 2
-- dl rf port 1 -> 3
-- dl rf port 2 -> 0
-- dl rf port 3 -> 1

gain_m0_sync_blk : entity work.d_sync
generic map(
    bits    => 5                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk               , --: in   std_logic;
    d_in    => gain_m0           , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => gain_m2_sync      ); --: out std_logic_vector(bits-1 downto 0)

gain_m1_sync_blk : entity work.d_sync
generic map(
    bits    => 5                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk               , --: in   std_logic;
    d_in    => gain_m1           , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => gain_m3_sync      ); --: out std_logic_vector(bits-1 downto 0)

gain_m2_sync_blk : entity work.d_sync
generic map(
    bits    => 5                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk               , --: in   std_logic;
    d_in    => gain_m2           , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => gain_m0_sync      ); --: out std_logic_vector(bits-1 downto 0)

gain_m3_sync_blk : entity work.d_sync
generic map(
    bits    => 5                ) --: natural := 16; -- number of bit.
port map(
    in_clk  => loc_clk           , --: in   std_logic;
    out_clk => clk               , --: in   std_logic;
    d_in    => gain_m3           , --: in   std_logic_vector(bits-1 downto 0);
    d_out   => gain_m1_sync      ); --: out std_logic_vector(bits-1 downto 0)


process(clk)
begin
if rising_edge(clk) then
    if (rst_n = '0') then
        cnt <= 0;
    else
        if (cnt= 11) then
            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if (rst_n = '0') then
        mgain_data(0)   <= '0';
        mgain_data(1)   <= '0';
        mgain_stb       <= '0';
    else
        case cnt is
            when  0  => mgain_data(0)   <= gain_m0_sync(4);
                        mgain_data(1)   <= '0';
                        mgain_stb       <= '1';
            when  1  => mgain_data(0)   <= gain_m0_sync(2);
                        mgain_data(1)   <= gain_m0_sync(3);
                        mgain_stb       <= '0';
            when  2  => mgain_data(0)   <= gain_m0_sync(0);
                        mgain_data(1)   <= gain_m0_sync(1);
                        mgain_stb       <= '0';
            when  3  => mgain_data(0)   <= gain_m1_sync(4);
                        mgain_data(1)   <= '0';
                        mgain_stb       <= '0';
            when  4  => mgain_data(0)   <= gain_m1_sync(2);
                        mgain_data(1)   <= gain_m1_sync(3);
                        mgain_stb       <= '0';
            when  5  => mgain_data(0)   <= gain_m1_sync(0);
                        mgain_data(1)   <= gain_m1_sync(1);
                        mgain_stb       <= '0';
            when  6  => mgain_data(0)   <= gain_m2_sync(4);
                        mgain_data(1)   <= '0';
                        mgain_stb       <= '0';
            when  7  => mgain_data(0)   <= gain_m2_sync(2);
                        mgain_data(1)   <= gain_m2_sync(3);
                        mgain_stb       <= '0';
            when  8  => mgain_data(0)   <= gain_m2_sync(0);
                        mgain_data(1)   <= gain_m2_sync(1);
                        mgain_stb       <= '0';
            when  9  => mgain_data(0)   <= gain_m3_sync(4);
                        mgain_data(1)   <= '0';
                        mgain_stb       <= '0';
            when 10  => mgain_data(0)   <= gain_m3_sync(2);
                        mgain_data(1)   <= gain_m3_sync(3);
                        mgain_stb       <= '0';
            when 11  => mgain_data(0)   <= gain_m3_sync(0);
                        mgain_data(1)   <= gain_m3_sync(1);
                        mgain_stb       <= '0';
        end case;
    end if;
end if;
end process;


mgain_clk   <= not clk;


end Behavioral;
