library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity eth_sw_tb is
end;

architecture bench of eth_sw_tb is

  component eth_sw
    generic (
      port0_table_num     : integer;
      port1_table_num     : integer;
      port2_table_num     : integer
    );
      port (
      clk                 : in std_logic;
      port0_rst_n         : in std_logic;
      port1_rst_n         : in std_logic;
      port2_rst_n         : in std_logic;
      rx0_axis_eth_tready : out std_logic;
      rx0_axis_eth_tdata  : in std_logic_vector(7 downto 0);
      rx0_axis_eth_tvalid : in std_logic;
      rx0_axis_eth_tlast  : in std_logic;
      rx0_packet_cnt      : out std_logic_vector(15 downto 0);
      rx1_axis_eth_tready : out std_logic;
      rx1_axis_eth_tdata  : in std_logic_vector(7 downto 0);
      rx1_axis_eth_tvalid : in std_logic;
      rx1_axis_eth_tlast  : in std_logic;
      rx1_packet_cnt      : out std_logic_vector(15 downto 0);
      rx2_axis_eth_tready : out std_logic;
      rx2_axis_eth_tdata  : in std_logic_vector(7 downto 0);
      rx2_axis_eth_tvalid : in std_logic;
      rx2_axis_eth_tlast  : in std_logic;
      rx2_packet_cnt      : out std_logic_vector(15 downto 0);
      tx0_axis_eth_tready : in std_logic;
      tx0_axis_eth_tdata  : out std_logic_vector(7 downto 0);
      tx0_axis_eth_tvalid : out std_logic;
      tx0_axis_eth_tlast  : out std_logic;
      tx0_packet_cnt      : out std_logic_vector(15 downto 0);
      tx1_axis_eth_tready : in std_logic;
      tx1_axis_eth_tdata  : out std_logic_vector(7 downto 0);
      tx1_axis_eth_tvalid : out std_logic;
      tx1_axis_eth_tlast  : out std_logic;
      tx1_packet_cnt      : out std_logic_vector(15 downto 0);
      tx2_axis_eth_tready : in std_logic;
      tx2_axis_eth_tdata  : out std_logic_vector(7 downto 0);
      tx2_axis_eth_tvalid : out std_logic;
      tx2_axis_eth_tlast  : out std_logic;
      tx2_packet_cnt      : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 2.712 ns;
  -- Generics
  constant port0_table_num : integer := 9;
  constant port1_table_num : integer := 2;
  constant port2_table_num : integer := 2;

  -- Ports
  signal clk : std_logic;
  signal port0_rst_n         : std_logic;
  signal port1_rst_n         : std_logic;
  signal port2_rst_n         : std_logic;
  signal rx0_axis_eth_tready : std_logic;
  signal rx0_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal rx0_axis_eth_tvalid : std_logic;
  signal rx0_axis_eth_tlast  : std_logic;
  signal rx0_packet_cnt      : std_logic_vector(15 downto 0);
  signal rx1_axis_eth_tready : std_logic;
  signal rx1_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal rx1_axis_eth_tvalid : std_logic;
  signal rx1_axis_eth_tlast  : std_logic;
  signal rx1_packet_cnt      : std_logic_vector(15 downto 0);
  signal rx2_axis_eth_tready : std_logic;
  signal rx2_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal rx2_axis_eth_tvalid : std_logic;
  signal rx2_axis_eth_tlast  : std_logic;
  signal rx2_packet_cnt      : std_logic_vector(15 downto 0);
  signal tx0_axis_eth_tready : std_logic;
  signal tx0_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal tx0_axis_eth_tvalid : std_logic;
  signal tx0_axis_eth_tlast  : std_logic;
  signal tx0_packet_cnt      : std_logic_vector(15 downto 0);
  signal tx1_axis_eth_tready : std_logic;
  signal tx1_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal tx1_axis_eth_tvalid : std_logic;
  signal tx1_axis_eth_tlast  : std_logic;
  signal tx1_packet_cnt      : std_logic_vector(15 downto 0);
  signal tx2_axis_eth_tready : std_logic;
  signal tx2_axis_eth_tdata  : std_logic_vector(7 downto 0);
  signal tx2_axis_eth_tvalid : std_logic;
  signal tx2_axis_eth_tlast  : std_logic;
  signal tx2_packet_cnt      : std_logic_vector(15 downto 0);
  signal fr                  : std_logic_vector(7 downto 0);
  signal sa                  : std_logic_vector(7 downto 0);


  signal cnt                 : integer := 0;

  type rom_type is array (natural range <>) of std_logic_vector (9 downto 0);
  constant mii_data : rom_type := (
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"D5",
    "01" & X"FF", -- Destination Address (Broadcast)
    "01" & X"FF",
    "01" & X"FF",
    "01" & X"FF",
    "01" & X"FF",
    "01" & X"FF",
    "01" & X"00", -- Source Address       (5A)
    "01" & X"02",
    "01" & X"03",
    "01" & X"04",
    "01" & X"05",
    "01" & X"06",
    "01" & X"00",
    "01" & X"2E", -- Length/Type = Length = 46
    "01" & X"01",
    "01" & X"02",
    "01" & X"03",
    "01" & X"04",
    "01" & X"05",
    "01" & X"06",
    "01" & X"07",
    "01" & X"08",
    "01" & X"09",
    "01" & X"0A",
    "01" & X"0B",
    "01" & X"0C",
    "01" & X"0D",
    "01" & X"0E",
    "01" & X"0F",
    "01" & X"10",
    "01" & X"11",
    "01" & X"12",
    "01" & X"13",
    "01" & X"14",
    "01" & X"15",
    "01" & X"16",
    "01" & X"17",
    "01" & X"18",
    "01" & X"19",
    "01" & X"1A",
    "01" & X"1B",
    "01" & X"1C",
    "01" & X"1D",
    "01" & X"1E",
    "01" & X"1F",
    "01" & X"20",
    "01" & X"21",
    "01" & X"22",
    "01" & X"23",
    "01" & X"24",
    "01" & X"25",
    "01" & X"26",
    "01" & X"27",
    "01" & X"28",
    "01" & X"29",
    "01" & X"2A",
    "01" & X"2B",
    "01" & X"2C",
    "01" & X"2D",
    "11" & X"2E", -- 46th Byte of Data
    "10" & X"00",


    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",
    "10" & X"00",


    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"55",
    "01" & X"D5",
    "01" & X"00", -- Destination Address (DA)
    "01" & X"02",
    "01" & X"03",
    "01" & X"04",
    "01" & X"05",
    "01" & X"06",
    "01" & X"00", -- Source Address       (5A)
    "01" & X"02",
    "01" & X"03",
    "01" & X"04",
    "01" & X"05",
    "01" & X"06",
    "01" & X"80", -- Length/Type = Type = 8000
    "01" & X"00",
    "01" & X"01",
    "01" & X"02",
    "01" & X"03",
    "01" & X"04",
    "01" & X"05",
    "01" & X"06",
    "01" & X"07",
    "01" & X"08",
    "01" & X"09",
    "01" & X"0A",
    "01" & X"0B",
    "01" & X"0C",
    "01" & X"0D",
    "01" & X"0E",
    "01" & X"0F",
    "01" & X"10",
    "01" & X"11",
    "01" & X"12",
    "01" & X"13",
    "01" & X"14",
    "01" & X"15",
    "01" & X"16",
    "01" & X"17",
    "01" & X"18",
    "01" & X"19",
    "01" & X"1A",
    "01" & X"1B",
    "01" & X"1C",
    "01" & X"1D",
    "01" & X"1E",
    "01" & X"1F",
    "01" & X"20",
    "01" & X"21",
    "01" & X"22",
    "01" & X"23",
    "01" & X"24",
    "01" & X"25",
    "01" & X"26",
    "01" & X"27",
    "01" & X"28",
    "01" & X"29",
    "01" & X"2A",
    "01" & X"2B",
    "01" & X"2C",
    "01" & X"2D",
    "01" & X"2E",
    "11" & X"2F" -- 47th Data byte





);

begin

  eth_sw_inst : eth_sw
    generic map (
      port0_table_num     => port0_table_num,
      port1_table_num     => port1_table_num,
      port2_table_num     => port2_table_num
    )
    port map (
      clk                 => clk,
      port0_rst_n         => port0_rst_n,
      port1_rst_n         => port1_rst_n,
      port2_rst_n         => port2_rst_n,
      rx0_axis_eth_tready => rx0_axis_eth_tready,
      rx0_axis_eth_tdata  => rx0_axis_eth_tdata,
      rx0_axis_eth_tvalid => rx0_axis_eth_tvalid,
      rx0_axis_eth_tlast  => rx0_axis_eth_tlast,
      rx0_packet_cnt      => rx0_packet_cnt,
      rx1_axis_eth_tready => rx1_axis_eth_tready,
      rx1_axis_eth_tdata  => rx1_axis_eth_tdata,
      rx1_axis_eth_tvalid => rx1_axis_eth_tvalid,
      rx1_axis_eth_tlast  => rx1_axis_eth_tlast,
      rx1_packet_cnt      => rx1_packet_cnt,
      rx2_axis_eth_tready => rx2_axis_eth_tready,
      rx2_axis_eth_tdata  => rx2_axis_eth_tdata,
      rx2_axis_eth_tvalid => rx2_axis_eth_tvalid,
      rx2_axis_eth_tlast  => rx2_axis_eth_tlast,
      rx2_packet_cnt      => rx2_packet_cnt,
      tx0_axis_eth_tready => tx0_axis_eth_tready,
      tx0_axis_eth_tdata  => tx0_axis_eth_tdata,
      tx0_axis_eth_tvalid => tx0_axis_eth_tvalid,
      tx0_axis_eth_tlast  => tx0_axis_eth_tlast,
      tx0_packet_cnt      => tx0_packet_cnt,
      tx1_axis_eth_tready => tx1_axis_eth_tready,
      tx1_axis_eth_tdata  => tx1_axis_eth_tdata,
      tx1_axis_eth_tvalid => tx1_axis_eth_tvalid,
      tx1_axis_eth_tlast  => tx1_axis_eth_tlast,
      tx1_packet_cnt      => tx1_packet_cnt,
      tx2_axis_eth_tready => tx2_axis_eth_tready,
      tx2_axis_eth_tdata  => tx2_axis_eth_tdata,
      tx2_axis_eth_tvalid => tx2_axis_eth_tvalid,
      tx2_axis_eth_tlast  => tx2_axis_eth_tlast,
      tx2_packet_cnt      => tx2_packet_cnt
    );

clk_process : process
begin
    clk <= '1';
wait for clk_period/2;
    clk <= '0';
wait for clk_period/2;
end process clk_process;


   port0_rst_n <=  '0' after       0 ns,
                   '1' after     500 ns;

   port1_rst_n <=  '0' after       0 ns,
                   '1' after     500 ns;

   port2_rst_n <=  '0' after       0 ns,
                   '1' after     500 ns;

process(clk)
begin
if rising_edge(clk) then
    if (port0_rst_n = '0') then
        cnt <= 0;
        tx0_axis_eth_tready <= '0';
        tx1_axis_eth_tready <= '0';
        tx2_axis_eth_tready <= '0';
        fr <= x"01";
    else
        if (cnt = 4095) then
            cnt <= 0;
            fr  <= fr + x"01";
        else
            if (rx0_axis_eth_tready = '1') then
                cnt <= cnt + 1;
            end if;
        end if;
        --tx0_axis_eth_tready <= not tx0_axis_eth_tready;
        --tx1_axis_eth_tready <= not tx1_axis_eth_tready;
        --tx2_axis_eth_tready <= not tx2_axis_eth_tready;

        tx0_axis_eth_tready <= '1';
        tx1_axis_eth_tready <= '1';
        tx2_axis_eth_tready <= '1';
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (port0_rst_n = '0') then
        rx0_axis_eth_tvalid <= '0';
        rx0_axis_eth_tlast  <= '0';
        rx0_axis_eth_tdata  <= x"00";
        sa                  <= x"00";
    else
        if (cnt < 170) then
            rx0_axis_eth_tvalid <= mii_data(cnt)(8);
            rx0_axis_eth_tlast  <= mii_data(cnt)(9);
            if (cnt = 19 or cnt = 148) then
                sa <= sa + '1';
                rx0_axis_eth_tdata  <= sa; --sa
            elsif (cnt = 142) then
                rx0_axis_eth_tdata  <= x"01"; --da
            else
                rx0_axis_eth_tdata  <= mii_data(cnt)(7 downto 0);
            end if;
        else
            if (cnt < 1670) then
                rx0_axis_eth_tdata  <= fr;
                rx0_axis_eth_tvalid <= '1';
                rx0_axis_eth_tlast  <= '0';
            elsif (cnt = 1670) then
                rx0_axis_eth_tdata  <= x"00";
                rx0_axis_eth_tvalid <= '1';
                rx0_axis_eth_tlast  <= '1';
            elsif (cnt = 1671) then
                rx0_axis_eth_tdata  <= x"00";
                rx0_axis_eth_tvalid <= '0';
                rx0_axis_eth_tlast  <= '1';
            end if;
        end if;
    end if;

    if (port1_rst_n = '0') then
        rx1_axis_eth_tvalid <= '0';
        rx1_axis_eth_tlast  <= '0';
        rx1_axis_eth_tdata  <= x"00";
    else
        if (cnt < 170) then
            rx1_axis_eth_tvalid <= mii_data(cnt)(8);
            rx1_axis_eth_tlast  <= mii_data(cnt)(9);
            if (cnt = 19 or cnt = 148) then
                rx1_axis_eth_tdata  <= x"01"; --sa
            elsif (cnt = 142) then
                rx1_axis_eth_tdata  <= x"02"; --da
            else
                rx1_axis_eth_tdata  <= mii_data(cnt)(7 downto 0);
            end if;
        else
            if (cnt < 1970) then
                rx1_axis_eth_tdata  <= fr + x"01";
                rx1_axis_eth_tvalid <= '1';
                rx1_axis_eth_tlast  <= '0';
            elsif (cnt = 1970) then
                rx1_axis_eth_tdata  <= x"00";
                rx1_axis_eth_tvalid <= '1';
                rx1_axis_eth_tlast  <= '1';
            elsif (cnt = 1971) then
                rx1_axis_eth_tdata  <= x"00";
                rx1_axis_eth_tvalid <= '0';
                rx1_axis_eth_tlast  <= '1';
            end if;
        end if;
    end if;

    if (port1_rst_n = '0') then
        rx2_axis_eth_tvalid <= '0';
        rx2_axis_eth_tlast  <= '0';
        rx2_axis_eth_tdata  <= x"00";
    else
        if (cnt < 170) then
            rx2_axis_eth_tvalid <= mii_data(cnt)(8);
            rx2_axis_eth_tlast  <= mii_data(cnt)(9);
            if (cnt = 19 or cnt = 148) then
                rx2_axis_eth_tdata  <= x"02"; --sa
            elsif (cnt = 142) then
                rx2_axis_eth_tdata  <= x"01"; --da
            else
                rx2_axis_eth_tdata  <= mii_data(cnt)(7 downto 0);
            end if;
        else
            if (cnt < 1970) then
                rx2_axis_eth_tdata  <= fr + x"02";
                rx2_axis_eth_tvalid <= '1';
                rx2_axis_eth_tlast  <= '0';
            elsif (cnt = 1970) then
                rx2_axis_eth_tdata  <= x"00";
                rx2_axis_eth_tvalid <= '1';
                rx2_axis_eth_tlast  <= '1';
            elsif (cnt = 1971) then
                rx2_axis_eth_tdata  <= x"00";
                rx2_axis_eth_tvalid <= '0';
                rx2_axis_eth_tlast  <= '1';
            end if;
        end if;
    end if;
end if;
end process;





end;
