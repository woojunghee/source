library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vendor_stim is
  port (
    clk            	: in  std_logic;
    rst            	: in  std_logic;
    iq_tx_enable   	: in  std_logic;
    bffw           	: in  std_logic;
	vs_tx_16_0   	: in  std_logic_vector(31 downto 0);
    vs_tx_80_0   	: in  std_logic_vector(31 downto 0);
	vs_tx_80_1   	: in  std_logic_vector(31 downto 0);
	vs_tx_80_3   	: in  std_logic_vector(31 downto 0);
	vs_tx_144_0   	: in  std_logic_vector(31 downto 0);
	vs_tx_144_1   	: in  std_logic_vector(31 downto 0);
    vendor_tx_data 	: out std_logic_vector(127 downto 0);
    vendor_tx_xs   	: in  std_logic_vector(1 downto 0);
    vendor_tx_ns   	: in  std_logic_vector(5 downto 0);
    vendor_rx_data 	: in  std_logic_vector(127 downto 0);
    vendor_rx_xs   	: in  std_logic_vector(1 downto 0);
    vendor_rx_ns   	: in  std_logic_vector(5 downto 0);
	vs_rx_16_0   	: out std_logic_vector(31 downto 0);
    vs_rx_80_0   	: out std_logic_vector(31 downto 0);
	vs_rx_80_1   	: out std_logic_vector(31 downto 0);
	vs_rx_80_2   	: out std_logic_vector(31 downto 0);
	vs_rx_80_3   	: out std_logic_vector(31 downto 0);
	vs_rx_144_0   	: out std_logic_vector(31 downto 0);
	vs_rx_144_1   	: out std_logic_vector(31 downto 0);
	vs_rx_144_2   	: out std_logic_vector(31 downto 0);
	vs_rx_144_3   	: out std_logic_vector(31 downto 0)
  );
end entity vendor_stim;

architecture imp of vendor_stim is

  signal iq_tx_enable_d1    : std_logic := '0';
  signal vs_rx_0_16         : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_16_s0      : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_16_s1      : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_80         : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_80_s0      : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_80_s1      : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_144        : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_144_s0     : std_logic_vector(127 downto 0):= (others => '0');
  signal vs_rx_0_144_s1     : std_logic_vector(127 downto 0):= (others => '0');

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
            case ( vendor_rx_xs & vendor_tx_ns ) is
				when x"10"   =>
                    vendor_tx_data(31 downto 0) <= vs_tx_16_0;
                when x"50"   =>
                    vendor_tx_data(31 downto 0) <= vs_tx_80_0;
					vendor_tx_data(63 downto 32) <= vs_tx_80_1;
					vendor_tx_data(127 downto 96) <= vs_tx_80_3;
				when x"90"   =>
                    vendor_tx_data(31 downto 0) <= vs_tx_144_0;
					vendor_tx_data(63 downto 32) <= vs_tx_144_1;
                when others     => vendor_tx_data <= (others => '0');
            end case;
        end if;
    end if;
end if;
end process;

rx_data : process(clk)
begin
if rising_edge(clk) then
    if ( bffw = '1' ) then
        case( vendor_rx_xs & vendor_rx_ns ) is
			when x"10"   =>
                vs_rx_0_16      <= vendor_rx_data;
                vs_rx_0_16_s0   <= vs_rx_0_16;
                vs_rx_0_16_s1   <= vs_rx_0_16_s0;
            when x"50"   =>
                vs_rx_0_80      <= vendor_rx_data;
                vs_rx_0_80_s0   <= vs_rx_0_80;
                vs_rx_0_80_s1   <= vs_rx_0_80_s0;
			when x"90"   =>
                vs_rx_0_144     <= vendor_rx_data;
                vs_rx_0_144_s0  <= vs_rx_0_144;
                vs_rx_0_144_s1  <= vs_rx_0_144_s0;
            when others     => 
				vs_rx_0_16   <= vs_rx_0_16;
				vs_rx_0_80   <= vs_rx_0_80;
				vs_rx_0_144  <= vs_rx_0_144;
        end case;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
	if ( vs_rx_0_16_s1 = vs_rx_0_16_s0 and vs_rx_0_16_s1 = vs_rx_0_16 ) then
        vs_rx_16_0 <= vs_rx_0_16( 31 DOWNTO   0);
    end if;
    if ( vs_rx_0_80_s1 = vs_rx_0_80_s0 and vs_rx_0_80_s1 = vs_rx_0_80 ) then
        vs_rx_80_0 <= vs_rx_0_80( 31 DOWNTO  0);
		vs_rx_80_1 <= vs_rx_0_80( 63 DOWNTO 32);
		vs_rx_80_2 <= vs_rx_0_80( 95 DOWNTO 64);
		vs_rx_80_3 <= vs_rx_0_80(127 DOWNTO 96);
    end if;
	if ( vs_rx_0_144_s1 = vs_rx_0_144_s0 and vs_rx_0_144_s1 = vs_rx_0_144 ) then
		vs_rx_144_0 <= vs_rx_0_144( 31 DOWNTO  0);
		vs_rx_144_1 <= vs_rx_0_144( 63 DOWNTO 32);
		vs_rx_144_2 <= vs_rx_0_144( 95 DOWNTO 64);
		vs_rx_144_3 <= vs_rx_0_144(127 DOWNTO 96);
    end if;
end if;
end process;


end imp;
