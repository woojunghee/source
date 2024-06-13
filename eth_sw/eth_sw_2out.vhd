
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.my_package.all;

entity eth_sw_2out is
generic (
      rx_table_num  : integer := 1 ;
      tx0_table_num : integer := 1 ;
      tx1_table_num : integer := 2 );
port(
    clk                  : in  std_logic;
    reset_n              : in  std_logic;
    rx_axis_eth_tready   : out std_logic;
    rx_axis_eth_tdata    : in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid   : in  std_logic;
    rx_axis_eth_tlast    : in  std_logic;
    rx_mac_table         : in  arr_mac_num_48_stdlogic(0 to rx_table_num);

    tx0_axis_eth_tready  : in  std_logic;
    tx0_axis_eth_tdata   : out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid  : out std_logic;
    tx0_axis_eth_tlast   : out std_logic;
    tx0_mac_table        : in  arr_mac_num_48_stdlogic(0 to tx0_table_num);

    tx1_axis_eth_tready  : in  std_logic;
    tx1_axis_eth_tdata   : out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid  : out std_logic;
    tx1_axis_eth_tlast   : out std_logic;
    tx1_mac_table        : in  arr_mac_num_48_stdlogic(0 to tx1_table_num);

    d_add                : in std_logic_vector(47 downto 0);
    d_add_vld            : in std_logic
    );
end eth_sw_2out;

architecture data of eth_sw_2out is

signal check                : std_logic;
signal drop                 : std_logic_vector(1 downto 0);

signal rx_exist             : std_logic_vector(rx_table_num downto 0);
signal tx0_exist            : std_logic_vector(tx0_table_num downto 0);
signal tx1_exist            : std_logic_vector(tx1_table_num downto 0);

signal rx0_axis_eth_tvalid  : std_logic;
signal rx0_axis_eth_tready  : std_logic;
signal rx0_axis_eth_tdata   : std_logic_vector(7 downto 0);
signal rx0_axis_eth_tlast   : std_logic;

signal rx1_axis_eth_tvalid  : std_logic;
signal rx1_axis_eth_tready  : std_logic;
signal rx1_axis_eth_tdata   : std_logic_vector(7 downto 0);
signal rx1_axis_eth_tlast   : std_logic;


signal sw0_axis_eth_tready  : std_logic;
signal sw0_axis_eth_tdata   : std_logic_vector(7 downto 0);
signal sw0_axis_eth_tvalid  : std_logic;
signal sw0_axis_eth_tlast   : std_logic;

signal sw1_axis_eth_tready  : std_logic;
signal sw1_axis_eth_tdata   : std_logic_vector(7 downto 0);
signal sw1_axis_eth_tvalid  : std_logic;
signal sw1_axis_eth_tlast   : std_logic;

begin



rx_axis_eth_tready  <= rx0_axis_eth_tready;

process(clk)
begin
if rising_edge(clk) then
    if(rx0_axis_eth_tready = '1') then
        rx0_axis_eth_tdata   <= rx_axis_eth_tdata;
        rx0_axis_eth_tvalid  <= rx_axis_eth_tvalid;
        rx0_axis_eth_tlast   <= rx_axis_eth_tlast;
    else
        rx0_axis_eth_tdata   <= rx_axis_eth_tdata;
        rx0_axis_eth_tvalid  <= '0';
        rx0_axis_eth_tlast   <= '0';
    end if;
end if;
end process;

sw0_axis_eth_tready <= tx0_axis_eth_tready;

fifo_cas0 : entity work.fifo_eth_axi
  port map (
    s_aclk          => clk                   , --: IN STD_LOGIC;
    s_aresetn       => reset_n               , --: IN STD_LOGIC;
    s_axis_tvalid   => rx0_axis_eth_tvalid   , --: IN STD_LOGIC;
    s_axis_tready   => rx0_axis_eth_tready   , --: OUT STD_LOGIC;
    s_axis_tdata    => rx0_axis_eth_tdata    , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tlast    => rx0_axis_eth_tlast    , --: IN STD_LOGIC;
    m_axis_tvalid   => sw0_axis_eth_tvalid   , --: OUT STD_LOGIC;
    m_axis_tready   => sw0_axis_eth_tready   , --: IN STD_LOGIC;
    m_axis_tdata    => sw0_axis_eth_tdata    , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tlast    => sw0_axis_eth_tlast    ); --: OUT STD_LOGIC


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        tx0_exist <= (others => '0');
        tx1_exist <= (others => '0');
        drop      <= (others => '0');
    else
        if (d_add_vld = '1') then

            for n in 0 to rx_table_num loop
                if (rx_mac_table(n) = d_add) then
                    rx_exist(n) <= '1';
                else
                    rx_exist(n) <= '0';
                end if;
            end loop;

            for n in 0 to tx0_table_num loop
                if (tx0_mac_table(n) = d_add or d_add = x"ffffffffffff" or d_add(40) = '1') then
                    tx0_exist(n) <= '1';
                else
                    tx0_exist(n) <= '0';
                end if;
            end loop;

            for n in 0 to tx1_table_num loop
                if (tx1_mac_table(n) = d_add or d_add = x"ffffffffffff" or d_add(40) = '1') then
                    tx1_exist(n) <= '1';
                else
                    tx1_exist(n) <= '0';
                end if;
            end loop;


            check <= '1';
            if (check = '1') then
                if (rx_exist(rx_table_num downto 0) /= "0") then
                    drop(0) <= '1';
                    drop(1) <= '1';
                elsif ( tx0_exist(tx0_table_num downto 0) = "0"  and tx1_exist(tx1_table_num downto 0) = "0") then
                    drop(0) <= '0';
                    drop(1) <= '0';
                else

                    if ( tx0_exist(tx0_table_num downto 0) = "0" ) then
                        drop(0) <= '1';
                    else
                        drop(0) <= '0';
                    end if;

                    if ( tx1_exist(tx1_table_num downto 0) = "0" ) then
                        drop(1) <= '1';
                    else
                        drop(1) <= '0';
                    end if;
                end if;
            end if;
        else
            check <= '0';
        end if;
    end if;
end if;
end process;



process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        tx0_axis_eth_tdata  <= x"00";
        tx0_axis_eth_tvalid <= '0';
        tx0_axis_eth_tlast  <= '0';
        tx1_axis_eth_tdata  <= x"00";
        tx1_axis_eth_tvalid <= '0';
        tx1_axis_eth_tlast  <= '0';
    else
        if ( drop(0) = '1' ) then
            tx0_axis_eth_tdata  <= x"00";
            tx0_axis_eth_tvalid <= '0';
            tx0_axis_eth_tlast  <= '0';
        else
            tx0_axis_eth_tdata  <= sw0_axis_eth_tdata;
            tx0_axis_eth_tvalid <= sw0_axis_eth_tvalid;
            tx0_axis_eth_tlast  <= sw0_axis_eth_tlast;
        end if;

        if ( drop(1) = '1' ) then
            tx1_axis_eth_tdata  <= x"00";
            tx1_axis_eth_tvalid <= '0';
            tx1_axis_eth_tlast  <= '0';
        else
            tx1_axis_eth_tdata  <= sw0_axis_eth_tdata;
            tx1_axis_eth_tvalid <= sw0_axis_eth_tvalid;
            tx1_axis_eth_tlast  <= sw0_axis_eth_tlast;
        end if;
    end if;
end if;
end process;





end data;