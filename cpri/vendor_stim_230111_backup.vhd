library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vendor_stim is
  port (
    clk            : in  std_logic;
    rst            : in  std_logic;
    iq_tx_enable   : in  std_logic;
    bffw           : in  std_logic;
    vs_tx_0_16_0   : in  std_logic_vector(31 downto 0);
    vs_tx_0_16_1   : in  std_logic_vector(31 downto 0);
    vs_tx_0_16_2   : in  std_logic_vector(31 downto 0);
    vs_tx_0_16_3   : in  std_logic_vector(31 downto 0);
    vendor_tx_data : out std_logic_vector(127 downto 0);
    vendor_tx_xs   : in  std_logic_vector(1 downto 0);
    vendor_tx_ns   : in  std_logic_vector(5 downto 0);
    vendor_rx_data : in  std_logic_vector(127 downto 0);
    vendor_rx_xs   : in  std_logic_vector(1 downto 0);
    vendor_rx_ns   : in  std_logic_vector(5 downto 0);
    vs_rx_0_16_0   : out std_logic_vector(31 downto 0);
    vs_rx_0_16_1   : out std_logic_vector(31 downto 0);
    vs_rx_0_16_2   : out std_logic_vector(31 downto 0);
    vs_rx_0_16_3   : out std_logic_vector(31 downto 0)
  );
end entity vendor_stim;

architecture imp of vendor_stim is

  signal iq_tx_enable_d1    : std_logic := '0';
  signal vs_rx_0_16         : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_16_s0      : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_16_s1      : std_logic_vector(127 downto 0):= (others => '0');

begin


  -- Send to the CPRI core
tx_data : process(clk)
begin
if rising_edge(clk) then
    if ( rst = '1' ) then
        vendor_tx_data    <= (others => '0');
    else
        iq_tx_enable_d1 <= iq_tx_enable;
        if ( iq_tx_enable_d1 ) = '1' then
            if ( vendor_tx_xs = "00" ) then
                case ( vendor_tx_ns ) is
                    when "010000"   =>
                        vendor_tx_data( 31 downto  0) <= vs_tx_0_16_0;
                        vendor_tx_data( 63 downto 32) <= vs_tx_0_16_1;
                        vendor_tx_data( 95 downto 64) <= vs_tx_0_16_2;
                        vendor_tx_data(127 downto 96) <= vs_tx_0_16_3;
                    when others     => vendor_tx_data <= (others => '0');
                end case;
            end if;
        end if;
    end if;
end if;
end process;

rx_data : process(clk)
begin
if rising_edge(clk) then
    if ( bffw = '1' ) then
        if ( vendor_rx_xs = "00" ) then
            case( vendor_rx_ns ) is
                when "010000"   =>
                    vs_rx_0_16      <= vendor_rx_data;
                    vs_rx_0_16_s0   <= vs_rx_0_16;
                    vs_rx_0_16_s1   <= vs_rx_0_16_s0;
                when others     => vs_rx_0_16   <= vs_rx_0_16;
            end case;
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if ( vs_rx_0_16_s1 = vs_rx_0_16_s0 and vs_rx_0_16_s1 = vs_rx_0_16 ) then
        vs_rx_0_16_0 <= vs_rx_0_16( 31 DOWNTO 0);
        vs_rx_0_16_1 <= vs_rx_0_16( 63 DOWNTO 32);
        vs_rx_0_16_2 <= vs_rx_0_16( 95 DOWNTO 64);
        vs_rx_0_16_3 <= vs_rx_0_16(127 DOWNTO 96);
    end if;
end if;
end process;


end imp;
