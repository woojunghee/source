
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.my_package.all;

entity eth_sw is
generic (
      port0_table_num : integer := 2 ;
      port1_table_num : integer := 2 ;
      port2_table_num : integer := 2 );
port(
    clk                  : in  std_logic;

    port0_rst_n          : in  std_logic;
    port1_rst_n          : in  std_logic;
    port2_rst_n          : in  std_logic;

    rx0_axis_eth_tready  : out std_logic;
    rx0_axis_eth_tdata   : in  std_logic_vector(7 downto 0);
    rx0_axis_eth_tvalid  : in  std_logic;
    rx0_axis_eth_tlast   : in  std_logic;
    rx0_packet_cnt       : out std_logic_vector(15 downto 0);

    rx1_axis_eth_tready  : out std_logic;
    rx1_axis_eth_tdata   : in  std_logic_vector(7 downto 0);
    rx1_axis_eth_tvalid  : in  std_logic;
    rx1_axis_eth_tlast   : in  std_logic;
    rx1_packet_cnt       : out std_logic_vector(15 downto 0);

    rx2_axis_eth_tready  : out std_logic;
    rx2_axis_eth_tdata   : in  std_logic_vector(7 downto 0);
    rx2_axis_eth_tvalid  : in  std_logic;
    rx2_axis_eth_tlast   : in  std_logic;
    rx2_packet_cnt       : out std_logic_vector(15 downto 0);

    tx0_axis_eth_tready  : in  std_logic;
    tx0_axis_eth_tdata   : out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid  : out std_logic;
    tx0_axis_eth_tlast   : out std_logic;
    tx0_packet_cnt       : out std_logic_vector(15 downto 0);

    tx1_axis_eth_tready  : in  std_logic;
    tx1_axis_eth_tdata   : out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid  : out std_logic;
    tx1_axis_eth_tlast   : out std_logic;
    tx1_packet_cnt       : out std_logic_vector(15 downto 0);

    tx2_axis_eth_tready  : in  std_logic;
    tx2_axis_eth_tdata   : out std_logic_vector(7 downto 0);
    tx2_axis_eth_tvalid  : out std_logic;
    tx2_axis_eth_tlast   : out std_logic;
    tx2_packet_cnt       : out std_logic_vector(15 downto 0)
    );
end eth_sw;

architecture data of eth_sw is


signal rx0_da                : std_logic_vector(47 downto 0);
signal rx1_da                : std_logic_vector(47 downto 0);
signal rx2_da                : std_logic_vector(47 downto 0);
signal rx0_da_vld            : std_logic;
signal rx1_da_vld            : std_logic;
signal rx2_da_vld            : std_logic;

signal rx0_sa                : std_logic_vector(47 downto 0);
signal rx1_sa                : std_logic_vector(47 downto 0);
signal rx2_sa                : std_logic_vector(47 downto 0);
signal rx0_sa_vld            : std_logic;
signal rx1_sa_vld            : std_logic;
signal rx2_sa_vld            : std_logic;

signal port0_mac_table       : arr_mac_num_48_stdlogic(0 to port0_table_num);
signal port1_mac_table       : arr_mac_num_48_stdlogic(0 to port1_table_num);
signal port2_mac_table       : arr_mac_num_48_stdlogic(0 to port2_table_num);

signal s0_m1_axis_eth_tready : std_logic;
signal s0_m1_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s0_m1_axis_eth_tvalid : std_logic;
signal s0_m1_axis_eth_tlast  : std_logic;

signal s0_m2_axis_eth_tready : std_logic;
signal s0_m2_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s0_m2_axis_eth_tvalid : std_logic;
signal s0_m2_axis_eth_tlast  : std_logic;

signal s1_m0_axis_eth_tready : std_logic;
signal s1_m0_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s1_m0_axis_eth_tvalid : std_logic;
signal s1_m0_axis_eth_tlast  : std_logic;

signal s1_m2_axis_eth_tready : std_logic;
signal s1_m2_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s1_m2_axis_eth_tvalid : std_logic;
signal s1_m2_axis_eth_tlast  : std_logic;

signal s2_m0_axis_eth_tready : std_logic;
signal s2_m0_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s2_m0_axis_eth_tvalid : std_logic;
signal s2_m0_axis_eth_tlast  : std_logic;

signal s2_m1_axis_eth_tready : std_logic;
signal s2_m1_axis_eth_tdata  : std_logic_vector(7 downto 0);
signal s2_m1_axis_eth_tvalid : std_logic;
signal s2_m1_axis_eth_tlast  : std_logic;

signal tx0_chk_eth_tvalid    : std_logic;
signal tx0_chk_eth_tlast     : std_logic;
signal tx1_chk_eth_tvalid    : std_logic;
signal tx1_chk_eth_tlast     : std_logic;
signal tx2_chk_eth_tvalid    : std_logic;
signal tx2_chk_eth_tlast     : std_logic;

signal rx0_frm_cnt           : std_logic_vector(15 downto 0);
signal rx1_frm_cnt           : std_logic_vector(15 downto 0);
signal rx2_frm_cnt           : std_logic_vector(15 downto 0);
signal tx0_frm_cnt           : std_logic_vector(15 downto 0);
signal tx1_frm_cnt           : std_logic_vector(15 downto 0);
signal tx2_frm_cnt           : std_logic_vector(15 downto 0);


begin


mac_add_parser0 : entity work.mac_add_parser
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port0_rst_n           , --: in  std_logic;
    rx_axis_eth_tdata       => rx0_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx0_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx0_axis_eth_tlast    , --: in  std_logic;
    dest_mac_address        => rx0_da                , --: out std_logic_vector(47 downto 0);
    source_mac_address      => rx0_sa                , --: out std_logic_vector(47 downto 0);
    d_add_vld               => rx0_da_vld            , --: out std_logic;
    s_add_vld               => rx0_sa_vld            ); --: out std_logic

mac_add_parser1 : entity work.mac_add_parser
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port1_rst_n           , --: in  std_logic;
    rx_axis_eth_tdata       => rx1_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx1_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx1_axis_eth_tlast    , --: in  std_logic;
    dest_mac_address        => rx1_da                , --: out std_logic_vector(47 downto 0);
    source_mac_address      => rx1_sa                , --: out std_logic_vector(47 downto 0);
    d_add_vld               => rx1_da_vld            , --: out std_logic;
    s_add_vld               => rx1_sa_vld            ); --: out std_logic

mac_add_parser2 : entity work.mac_add_parser
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port2_rst_n           , --: in  std_logic;
    rx_axis_eth_tdata       => rx2_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx2_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx2_axis_eth_tlast    , --: in  std_logic;
    dest_mac_address        => rx2_da                , --: out std_logic_vector(47 downto 0);
    source_mac_address      => rx2_sa                , --: out std_logic_vector(47 downto 0);
    d_add_vld               => rx2_da_vld            , --: out std_logic;
    s_add_vld               => rx2_sa_vld            ); --: out std_logic


mac_table_gen0 : entity work.mac_table_gen
generic map(
    table_num => port0_table_num                     )
port map(
    clk                     => clk                   , --: in  std_logic; -- 368.64mhz
    reset_n                 => port0_rst_n           , --: in  std_logic;
    s_add                   => rx0_sa                , --: in  std_logic_vector(47 downto 0);
    s_add_vld               => rx0_sa_vld            , --: in  std_logic;
    mac_table               => port0_mac_table       ); --: out arr_mac_num_48_stdlogic(0 to table_num)

mac_table_gen1 : entity work.mac_table_gen
generic map(
    table_num => port1_table_num                     )
port map(
    clk                     => clk                   , --: in  std_logic; -- 368.64mhz
    reset_n                 => port1_rst_n           , --: in  std_logic;
    s_add                   => rx1_sa                , --: in  std_logic_vector(47 downto 0);
    s_add_vld               => rx1_sa_vld            , --: in  std_logic;
    mac_table               => port1_mac_table       ); --: out arr_mac_num_48_stdlogic(0 to table_num)

mac_table_gen2 : entity work.mac_table_gen
generic map(
    table_num => port2_table_num                    )
port map(
    clk                     => clk                   , --: in  std_logic; -- 368.64mhz
    reset_n                 => port2_rst_n           , --: in  std_logic;
    s_add                   => rx2_sa                , --: in  std_logic_vector(47 downto 0);
    s_add_vld               => rx2_sa_vld            , --: in  std_logic;
    mac_table               => port2_mac_table       ); --: out arr_mac_num_48_stdlogic(0 to table_num)


sw0 : entity work.eth_sw_2out
generic map(
    rx_table_num  => port0_table_num                 ,
    tx0_table_num => port1_table_num                 ,
    tx1_table_num => port2_table_num                 )
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port0_rst_n           , --: in  std_logic;
    rx_axis_eth_tready      => rx0_axis_eth_tready   , --: out std_logic;
    rx_axis_eth_tdata       => rx0_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx0_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx0_axis_eth_tlast    , --: in  std_logic;
    rx_mac_table            => port0_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to rx_table_num);
    tx0_axis_eth_tready     => s0_m1_axis_eth_tready , --: in  std_logic;
    tx0_axis_eth_tdata      => s0_m1_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid     => s0_m1_axis_eth_tvalid , --: out std_logic;
    tx0_axis_eth_tlast      => s0_m1_axis_eth_tlast  , --: out std_logic;
    tx0_mac_table           => port1_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx0_table_num);
    tx1_axis_eth_tready     => s0_m2_axis_eth_tready , --: in  std_logic;
    tx1_axis_eth_tdata      => s0_m2_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid     => s0_m2_axis_eth_tvalid , --: out std_logic;
    tx1_axis_eth_tlast      => s0_m2_axis_eth_tlast  , --: out std_logic;
    tx1_mac_table           => port2_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx1_table_num);
    d_add                   => rx0_da                , --: in std_logic_vector(47 downto 0);
    d_add_vld               => rx0_da_vld            ); --: in std_logic

sw1 : entity work.eth_sw_2out
generic map(
    rx_table_num  => port1_table_num                 ,
    tx0_table_num => port0_table_num                 ,
    tx1_table_num => port2_table_num                 )
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port1_rst_n           , --: in  std_logic;
    rx_axis_eth_tready      => rx1_axis_eth_tready   , --: out std_logic;
    rx_axis_eth_tdata       => rx1_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx1_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx1_axis_eth_tlast    , --: in  std_logic;
    rx_mac_table            => port1_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to rx_table_num);
    tx0_axis_eth_tready     => s1_m0_axis_eth_tready , --: in  std_logic;
    tx0_axis_eth_tdata      => s1_m0_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid     => s1_m0_axis_eth_tvalid , --: out std_logic;
    tx0_axis_eth_tlast      => s1_m0_axis_eth_tlast  , --: out std_logic;
    tx0_mac_table           => port0_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx0_table_num);
    tx1_axis_eth_tready     => s1_m2_axis_eth_tready , --: in  std_logic;
    tx1_axis_eth_tdata      => s1_m2_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid     => s1_m2_axis_eth_tvalid , --: out std_logic;
    tx1_axis_eth_tlast      => s1_m2_axis_eth_tlast  , --: out std_logic;
    tx1_mac_table           => port2_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx1_table_num);
    d_add                   => rx1_da                , --: in std_logic_vector(47 downto 0);
    d_add_vld               => rx1_da_vld            ); --: in std_logic

sw2 : entity work.eth_sw_2out
generic map(
    rx_table_num  => port2_table_num                 ,
    tx0_table_num => port0_table_num                 ,
    tx1_table_num => port1_table_num                 )
port map(
    clk                     => clk                   , --: in  std_logic;
    reset_n                 => port2_rst_n           , --: in  std_logic;
    rx_axis_eth_tready      => rx2_axis_eth_tready   , --: out std_logic;
    rx_axis_eth_tdata       => rx2_axis_eth_tdata    , --: in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid      => rx2_axis_eth_tvalid   , --: in  std_logic;
    rx_axis_eth_tlast       => rx2_axis_eth_tlast    , --: in  std_logic;
    rx_mac_table            => port2_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to rx_table_num);
    tx0_axis_eth_tready     => s2_m0_axis_eth_tready , --: in  std_logic;
    tx0_axis_eth_tdata      => s2_m0_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx0_axis_eth_tvalid     => s2_m0_axis_eth_tvalid , --: out std_logic;
    tx0_axis_eth_tlast      => s2_m0_axis_eth_tlast  , --: out std_logic;
    tx0_mac_table           => port0_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx0_table_num);
    tx1_axis_eth_tready     => s2_m1_axis_eth_tready , --: in  std_logic;
    tx1_axis_eth_tdata      => s2_m1_axis_eth_tdata  , --: out std_logic_vector(7 downto 0);
    tx1_axis_eth_tvalid     => s2_m1_axis_eth_tvalid , --: out std_logic;
    tx1_axis_eth_tlast      => s2_m1_axis_eth_tlast  , --: out std_logic;
    tx1_mac_table           => port1_mac_table       , --: in  arr_mac_num_48_stdlogic(0 to tx1_table_num);
    d_add                   => rx2_da                , --: in std_logic_vector(47 downto 0);
    d_add_vld               => rx2_da_vld            ); --: in std_logic


axis_interconnect_0 : entity work.axis_interconnect_s2_m1
  port map(
    ACLK                    => clk                   , --: IN STD_LOGIC;
    ARESETN                 => port0_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S01_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S00_AXIS_ARESETN        => port1_rst_n           , --: IN STD_LOGIC;
    S01_AXIS_ARESETN        => port2_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_TVALID         => s1_m0_axis_eth_tvalid , --: IN STD_LOGIC;
    S01_AXIS_TVALID         => s2_m0_axis_eth_tvalid , --: IN STD_LOGIC;
    S00_AXIS_TREADY         => s1_m0_axis_eth_tready , --: OUT STD_LOGIC;
    S01_AXIS_TREADY         => s2_m0_axis_eth_tready , --: OUT STD_LOGIC;
    S00_AXIS_TDATA          => s1_m0_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXIS_TDATA          => s2_m0_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXIS_TLAST          => s1_m0_axis_eth_tlast  , --: IN STD_LOGIC;
    S01_AXIS_TLAST          => s2_m0_axis_eth_tlast  , --: IN STD_LOGIC;
    M00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    M00_AXIS_ARESETN        => port0_rst_n           , --: IN STD_LOGIC;
    M00_AXIS_TVALID         => tx0_chk_eth_tvalid    , --: OUT STD_LOGIC;
    M00_AXIS_TREADY         => tx0_axis_eth_tready   , --: IN STD_LOGIC;
    M00_AXIS_TDATA          => tx0_axis_eth_tdata    , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXIS_TLAST          => tx0_chk_eth_tlast     , --: OUT STD_LOGIC;
    S00_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    S01_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    --M00_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s00_FIFO_DATA_COUNT     => open                  , --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s01_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

tx0_axis_eth_tvalid <= tx0_chk_eth_tvalid;
tx0_axis_eth_tlast  <= tx0_chk_eth_tlast;

axis_interconnect_1 : entity work.axis_interconnect_s2_m1
  port map(
    ACLK                    => clk                   , --: IN STD_LOGIC;
    ARESETN                 => port1_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S01_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S00_AXIS_ARESETN        => port0_rst_n           , --: IN STD_LOGIC;
    S01_AXIS_ARESETN        => port2_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_TVALID         => s0_m1_axis_eth_tvalid , --: IN STD_LOGIC;
    S01_AXIS_TVALID         => s2_m1_axis_eth_tvalid , --: IN STD_LOGIC;
    S00_AXIS_TREADY         => s0_m1_axis_eth_tready , --: OUT STD_LOGIC;
    S01_AXIS_TREADY         => s2_m1_axis_eth_tready , --: OUT STD_LOGIC;
    S00_AXIS_TDATA          => s0_m1_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXIS_TDATA          => s2_m1_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXIS_TLAST          => s0_m1_axis_eth_tlast  , --: IN STD_LOGIC;
    S01_AXIS_TLAST          => s2_m1_axis_eth_tlast  , --: IN STD_LOGIC;
    M00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    M00_AXIS_ARESETN        => port1_rst_n           , --: IN STD_LOGIC;
    M00_AXIS_TVALID         => tx1_chk_eth_tvalid    , --: OUT STD_LOGIC;
    M00_AXIS_TREADY         => tx1_axis_eth_tready   , --: IN STD_LOGIC;
    M00_AXIS_TDATA          => tx1_axis_eth_tdata    , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXIS_TLAST          => tx1_chk_eth_tlast     , --: OUT STD_LOGIC;
    S00_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    S01_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    --M00_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s00_FIFO_DATA_COUNT     => open                  , --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s01_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0

tx1_axis_eth_tvalid <= tx1_chk_eth_tvalid;
tx1_axis_eth_tlast  <= tx1_chk_eth_tlast;

axis_interconnect_2 : entity work.axis_interconnect_s2_m1
  port map(
    ACLK                    => clk                   , --: IN STD_LOGIC;
    ARESETN                 => port2_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S01_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    S00_AXIS_ARESETN        => port0_rst_n           , --: IN STD_LOGIC;
    S01_AXIS_ARESETN        => port1_rst_n           , --: IN STD_LOGIC;
    S00_AXIS_TVALID         => s0_m2_axis_eth_tvalid , --: IN STD_LOGIC;
    S01_AXIS_TVALID         => s1_m2_axis_eth_tvalid , --: IN STD_LOGIC;
    S00_AXIS_TREADY         => s0_m2_axis_eth_tready , --: OUT STD_LOGIC;
    S01_AXIS_TREADY         => s1_m2_axis_eth_tready , --: OUT STD_LOGIC;
    S00_AXIS_TDATA          => s0_m2_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXIS_TDATA          => s1_m2_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXIS_TLAST          => s0_m2_axis_eth_tlast  , --: IN STD_LOGIC;
    S01_AXIS_TLAST          => s1_m2_axis_eth_tlast  , --: IN STD_LOGIC;
    M00_AXIS_ACLK           => clk                   , --: IN STD_LOGIC;
    M00_AXIS_ARESETN        => port2_rst_n           , --: IN STD_LOGIC;
    M00_AXIS_TVALID         => tx2_chk_eth_tvalid    , --: OUT STD_LOGIC;
    M00_AXIS_TREADY         => tx2_axis_eth_tready   , --: IN STD_LOGIC;
    M00_AXIS_TDATA          => tx2_axis_eth_tdata    , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXIS_TLAST          => tx2_chk_eth_tlast     , --: OUT STD_LOGIC;
    S00_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    S01_ARB_REQ_SUPPRESS    => '0'                   , --: IN STD_LOGIC;
    --M00_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s00_FIFO_DATA_COUNT     => open                  , --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    s01_FIFO_DATA_COUNT     => open                  ); --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0

tx2_axis_eth_tvalid <= tx2_chk_eth_tvalid;
tx2_axis_eth_tlast  <= tx2_chk_eth_tlast;



process(clk)
begin
if rising_edge(clk) then
    if ( port0_rst_n = '0' ) then
        rx0_frm_cnt <= (others => '0');
        tx0_frm_cnt <= (others => '0');
    else
        if (rx0_frm_cnt = x"ffff") then
            rx0_frm_cnt <= (others => '0');
        else
            if (rx0_axis_eth_tvalid = '1' and rx0_axis_eth_tlast = '1') then
                rx0_frm_cnt <= rx0_frm_cnt + '1';
            end if;
        end if;

        if (tx0_frm_cnt = x"ffff") then
            tx0_frm_cnt <= (others => '0');
        else
            if (tx0_chk_eth_tvalid = '1' and tx0_chk_eth_tlast = '1') then
                tx0_frm_cnt <= tx0_frm_cnt + '1';
            end if;
        end if;
    end if;
end if;
end process;

rx0_packet_cnt  <= rx0_frm_cnt;
tx0_packet_cnt  <= tx0_frm_cnt;

process(clk)
begin
if rising_edge(clk) then
    if ( port1_rst_n = '0' ) then
        rx1_frm_cnt <= (others => '0');
        tx1_frm_cnt <= (others => '0');
    else
        if (rx1_frm_cnt = x"ffff") then
            rx1_frm_cnt <= (others => '0');
        else
            if (rx1_axis_eth_tvalid = '1' and rx1_axis_eth_tlast = '1') then
                rx1_frm_cnt <= rx1_frm_cnt + '1';
            end if;
        end if;

        if (tx1_frm_cnt = x"ffff") then
            tx1_frm_cnt <= (others => '0');
        else
            if (tx1_chk_eth_tvalid = '1' and tx1_chk_eth_tlast = '1') then
                tx1_frm_cnt <= tx1_frm_cnt + '1';
            end if;
        end if;
    end if;
end if;
end process;

rx1_packet_cnt  <= rx1_frm_cnt;
tx1_packet_cnt  <= tx1_frm_cnt;

process(clk)
begin
if rising_edge(clk) then
    if ( port2_rst_n = '0' ) then
        rx2_frm_cnt <= (others => '0');
        tx2_frm_cnt <= (others => '0');
    else
        if (rx2_frm_cnt = x"ffff") then
            rx2_frm_cnt <= (others => '0');
        else
            if (rx2_axis_eth_tvalid = '1' and rx2_axis_eth_tlast = '1') then
                rx2_frm_cnt <= rx2_frm_cnt + '1';
            end if;
        end if;

        if (tx2_frm_cnt = x"ffff") then
            tx2_frm_cnt <= (others => '0');
        else
            if (tx2_chk_eth_tvalid = '1' and tx2_chk_eth_tlast = '1') then
                tx2_frm_cnt <= tx2_frm_cnt + '1';
            end if;
        end if;
    end if;
end if;
end process;

rx2_packet_cnt  <= rx2_frm_cnt;
tx2_packet_cnt  <= tx2_frm_cnt;


--ila_inter : entity work.ila_inter
--
--port map(
--	clk             => clk                   , --: IN STD_LOGIC;
--	probe0(0)       => port2_rst_n           , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe1(0)       => rx0_axis_eth_tvalid   , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe2(0)       => rx0_axis_eth_tlast    , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe3(0)       => rx1_axis_eth_tvalid   , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe4(0)       => rx1_axis_eth_tlast    , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe5(0)       => rx2_axis_eth_tvalid   , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe6(0)       => rx2_axis_eth_tlast    , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe7(0)       => s0_m1_axis_eth_tvalid , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe8(0)       => s0_m1_axis_eth_tlast  , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe9(0)       => s1_m0_axis_eth_tvalid , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe10(0)      => s1_m0_axis_eth_tlast  , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe11(0)      => s2_m0_axis_eth_tvalid , --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe12         => rx0_axis_eth_tdata    , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--	probe13         => rx1_axis_eth_tdata    , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--	probe14         => s1_m0_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--	probe15         => s0_m1_axis_eth_tdata  , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--	probe16         => rx0_da                , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0);
--	probe17         => rx0_sa                , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe18         => rx1_da                , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe19         => rx1_sa                , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe20         => port0_mac_table(0)    , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe21         => port0_mac_table(1)    , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe22         => port1_mac_table(0)    , --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)
--	probe23         => port2_mac_table(0)    ); --: IN STD_LOGIC_VECTOR(47 DOWNTO 0)


end data;