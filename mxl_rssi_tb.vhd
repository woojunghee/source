library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mxl_rssi_tb is
end;

architecture bench of mxl_rssi_tb is

  component mxl_rssi
      port (
      rssi_clk  : in std_logic;
      rssi_stb  : in std_logic;
      rssi_data : in std_logic;
      peak      : out std_logic_vector(3 downto 0);
      hi        : out std_logic_vector(3 downto 0);
      lo        : out std_logic_vector(3 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk       : std_logic;
  signal rssi_clk  : std_logic;
  signal rssi_stb  : std_logic := '0';
  signal rssi_data : std_logic := '0';
  signal peak      : std_logic_vector(3 downto 0);
  signal hi        : std_logic_vector(3 downto 0);
  signal lo        : std_logic_vector(3 downto 0);

  signal cnt       : integer range 0 to 15 := 15;
  signal rst_n     : std_logic;

begin

  mxl_rssi_inst : mxl_rssi
    port map (
      rssi_clk  => rssi_clk,
      rssi_stb  => rssi_stb,
      rssi_data => rssi_data,
      peak      => peak,
      hi        => hi,
      lo        => lo
    );

   rst_n  <=  '0' after      0 ns,
              '1' after     27 ns;


 clk_process : process
 begin
    clk <= '0';
 wait for clk_period/2;
    clk <= '1';
 wait for clk_period/2;
 end process clk_process;

 rssi_clk_process : process
 begin
    rssi_clk <= '1';
 wait for clk_period/2;
    rssi_clk <= '0';
 wait for clk_period/2;
 end process rssi_clk_process;

process(clk)
begin
if rising_edge(clk) then
    if (rst_n = '0') then
        cnt <= 0;
    else
        if (cnt = 15) then
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
    case cnt is
        when  0  => rssi_data <= '1'; rssi_stb <= '1';
        when  1  => rssi_data <= '0'; rssi_stb <= '0';
        when  2  => rssi_data <= '0'; rssi_stb <= '0';
        when  3  => rssi_data <= '0'; rssi_stb <= '0';
        when  4  => rssi_data <= '1'; rssi_stb <= '0';
        when  5  => rssi_data <= '1'; rssi_stb <= '0';
        when  6  => rssi_data <= '1'; rssi_stb <= '0';
        when  7  => rssi_data <= '0'; rssi_stb <= '0';
        when  8  => rssi_data <= '1'; rssi_stb <= '0';
        when  9  => rssi_data <= '1'; rssi_stb <= '0';
        when 10  => rssi_data <= '1'; rssi_stb <= '0';
        when 11  => rssi_data <= '0'; rssi_stb <= '0';
        when 12  => rssi_data <= '0'; rssi_stb <= '0';
        when 13  => rssi_data <= '0'; rssi_stb <= '0';
        when 14  => rssi_data <= '1'; rssi_stb <= '0';
        when 15  => rssi_data <= '0'; rssi_stb <= '0';
    end case;
end if;
end process;




end;
