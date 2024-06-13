
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
Library xpm;
use xpm.vcomponents.all;

entity eth_ctrl is
port(
    clk_12p5m           : in  std_logic;
    clk_25m             : in  std_logic;
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    gap_value           : in  std_logic_vector( 11 downto 0);
    tx_axis_eth_tready  : in  std_logic;
    tx_axis_eth_tdata   : out std_logic_vector(  7 downto  0);
    tx_axis_eth_tvalid  : out std_logic;
    tx_axis_eth_tlast   : out std_logic;
    rx_axis_eth_tready  : out std_logic;
    rx_axis_eth_tdata   : in  std_logic_vector(  7 downto  0);
    rx_axis_eth_tvalid  : in  std_logic;
    rx_axis_eth_tlast   : in  std_logic;
    eth_tx_en           : in  std_logic;
    eth_txd             : in  std_logic_vector(  7 downto  0);
    eth_rx_dv           : out std_logic;
    eth_rxd             : out std_logic_vector(  7 downto  0)
    );
end eth_ctrl;

architecture data of eth_ctrl is


type states is (idle, start);
signal tx_state                 : states   := idle;

signal s_rx_tvalid              : std_logic:='0';
signal s_rx_tdata               : std_logic_vector(7 downto 0);
signal s_rx_tlast               : std_logic:='0';
signal s_rx_tready              : std_logic;

signal eth_rx_dv_s0             : std_logic;
signal eth_rx_dv_s1             : std_logic;
signal eth_rx_dv_s2             : std_logic;

signal eth_rxd_s0				: std_logic_vector(3 downto 0);
signal eth_rxd_s1				: std_logic_vector(3 downto 0);

signal m_rx_tvalid              : std_logic:='0';
signal m_rx_tdata               : std_logic_vector(7 downto 0);
signal m_rx_tlast               : std_logic:='0';
signal m_rx_tlast_buf           : std_logic:='0';

signal m_rx_tready              : std_logic;

signal eth_tx_en_t              : std_logic:='0';
signal m_tx_tvalid              : std_logic:='0';
signal m_tx_tdata               : std_logic_vector(7 downto 0);
signal m_tx_tlast               : std_logic:='0';
signal m_tx_tready              : std_logic;

signal s_tx_tvalid              : std_logic:='0';
signal s_tx_tdata               : std_logic_vector(7 downto 0);
signal s_tx_tlast               : std_logic:='0';
signal s_tx_tready              : std_logic;

signal s_tx_tvalid_t            : std_logic:='0';
signal s_tx_tdata_t             : std_logic_vector(7 downto 0);
signal s_tx_tlast_t             : std_logic:='0';

signal s_tx_tvalid_t2           : std_logic:='0';
signal s_tx_tdata_t2            : std_logic_vector(7 downto 0);


signal tog                      : std_logic:='0';
signal tog2                     : std_logic:='0';

signal rx_w_data_count          : std_logic_vector(11 downto 0);
signal rx_w_data_count_buf      : std_logic_vector(11 downto 0);

signal rx_r_data_count          : std_logic_vector(12 downto 0);

signal tx_w_data_count          : std_logic_vector(12 downto 0);
signal tx_r_data_count          : std_logic_vector(12 downto 0);

signal cnt_rst                  : integer range 0 to 63;
signal fifo_start_rx            : std_logic:='0';
signal fifo_start_tx            : std_logic:='0';
signal fifo_start_rx_s0         : std_logic;
signal fifo_start_rx_s1         : std_logic;

signal eth_start_cnt            : integer range 0 to 3 := 3;

signal rst_n_sync               : std_logic:='0';
signal rst_n_25m                : std_logic:='0';
signal rst_n_12p5m              : std_logic:='0';

signal rx_dv_gen                : std_logic:='0';

signal test_cnt                 : integer range 0 to 1023 := 0;

signal gap_cnt                  : integer range 0 to 127;

signal gap_value_s0                     : std_logic_vector(11 downto 0);
signal gap_value_s1                     : std_logic_vector(11 downto 0);

attribute ASYNC_REG                     : string;
attribute ASYNC_REG of gap_value_s0     : signal is "true";
attribute ASYNC_REG of gap_value_s1     : signal is "true";

attribute ASYNC_REG of fifo_start_rx_s0 : signal is "true";
attribute ASYNC_REG of fifo_start_rx_s1 : signal is "true";


begin


rst_blk_368p64: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 4, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => reset_n,
     dest_clk  => clk,
     dest_arst => rst_n_sync
  );

rst_blk_25m: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 4, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => reset_n,
     dest_clk  => clk_25m,
     dest_arst => rst_n_25m
  );

rst_blk_12p5m: xpm_cdc_async_rst
generic map (
   DEST_SYNC_FF    => 4, -- integer; range: 2-10
   RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
)
port map (
   src_arst  => reset_n,
   dest_clk  => clk_12p5m,
   dest_arst => rst_n_12p5m
);

-- rx
process(clk)
begin
if rising_edge(clk) then
    if (rst_n_sync = '0') then
        fifo_start_rx   <= '0';
    else
        if ( rx_axis_eth_tdata = x"55" ) then
            fifo_start_rx   <= '1';
        else
            fifo_start_rx <= fifo_start_rx;
        end if;
    end if;
end if;
end process;

eth_rx_fifo : entity work.fifo_eth_rx
  PORT MAP (
    m_aclk               => clk_12p5m           ,   --: IN STD_LOGIC;
    s_aclk               => clk                 ,   --: IN STD_LOGIC;
    s_aresetn            => rst_n_12p5m         ,   --: IN STD_LOGIC;
    s_axis_tvalid        => s_rx_tvalid         ,   --: IN STD_LOGIC;
    s_axis_tready        => s_rx_tready         ,   --: OUT STD_LOGIC;
    s_axis_tdata         => s_rx_tdata          ,   --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tlast         => s_rx_tlast          ,   --: IN STD_LOGIC;
    m_axis_tvalid        => m_rx_tvalid         ,   --: OUT STD_LOGIC;
    m_axis_tready        => m_rx_tready         ,   --: IN STD_LOGIC;
    m_axis_tdata         => m_rx_tdata          ,   --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tlast         => m_rx_tlast          );   --: OUT STD_LOGIC;


rx_axis_eth_tready  <= s_rx_tready;

process(clk_12p5m)
begin
if rising_edge(clk_12p5m) then
    gap_value_s0     <= gap_value;
    gap_value_s1     <= gap_value_s0;
    fifo_start_rx_s0 <= fifo_start_rx;
    fifo_start_rx_s1 <= fifo_start_rx_s0;
    if (m_rx_tlast = '1') then
        gap_cnt     <= 0;
        m_rx_tready <= '0';
    else
        if (gap_cnt = conv_integer(gap_value_s1)) then
            gap_cnt <= gap_cnt;
            if (fifo_start_rx_s1 = '1') then
                m_rx_tready <= '1';
            else
                m_rx_tready <= '0';
            end if;
        else
            gap_cnt <= gap_cnt + 1;
            m_rx_tready <= '0';
        end if;
    end if;
end if;
end process;


process(clk_25m)
begin
if rising_edge(clk_25m) then
    m_rx_tlast_buf  <= m_rx_tlast;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if (rst_n_sync = '0' or s_rx_tlast= '1' or fifo_start_rx='0') then
        rx_w_data_count <= x"000";
    else
        if(s_rx_tvalid = '1') then
            rx_w_data_count <= rx_w_data_count + x"001";
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if(rst_n_sync='0' or s_rx_tready='0' or fifo_start_rx='0') then
        s_rx_tdata   <= x"00";
        s_rx_tvalid  <= '0';
        s_rx_tlast   <= '0';
    else
        s_rx_tdata   <= rx_axis_eth_tdata;
        s_rx_tvalid  <= rx_axis_eth_tvalid;
        s_rx_tlast   <= rx_axis_eth_tlast;
    end if;
end if;
end process;

rx_dv_gen   <= m_rx_tvalid and m_rx_tready;

process(clk_25m)
begin
if rising_edge(clk_25m) then
	if (rst_n_25m ='0') then
        tog <= '0';
    else
		if (rx_dv_gen='1') then
			eth_rx_dv_s0 <= '1';
			tog <= not tog;
		else
			eth_rx_dv_s0 <= '0';
		end if;
	end if;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
	eth_rx_dv_s1	<= eth_rx_dv_s0;
	eth_rx_dv	    <= eth_rx_dv_s1;
end if;
end process;


process(clk_25m)
begin
if rising_edge(clk_25m) then
    if (tog='0') then
        eth_rxd_s0 <= m_rx_tdata(3 downto 0);
    else
        eth_rxd_s0 <= m_rx_tdata(7 downto 4);
    end if;
	eth_rxd_s1          <= eth_rxd_s0;
	eth_rxd(3 downto 0) <= eth_rxd_s1;
end if;
end process;





-- tx


process(clk_25m)
begin
if rising_edge(clk_25m) then
	if (rst_n_25m='0') then
		tog2 <= '0';
	else
		if (eth_tx_en = '1') then
			tog2 <= not tog2;
		else
			tog2 <= '0';
		end if;
	end if;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
    if (eth_tx_en = '1') then
        if (tog2='0') then
            s_tx_tdata_t(3 downto 0) <= eth_txd(3 downto 0);
            s_tx_tvalid_t            <= '0';
        else
            s_tx_tdata_t(7 downto 4) <= eth_txd(3 downto 0);
            s_tx_tvalid_t            <= '1';
        end if;
    else
        s_tx_tdata_t    <= x"00";
        s_tx_tvalid_t   <= '0';
    end if;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
    if (rst_n_25m = '0') then
        fifo_start_tx   <= '0';
    else
        if ( s_tx_tdata_t = x"55" ) then
            fifo_start_tx   <= '1';
        else
            fifo_start_tx <= fifo_start_tx;
        end if;
    end if;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
    if (eth_tx_en='0' and eth_tx_en_t='1') then
        s_tx_tlast_t <= '1';
    else
        s_tx_tlast_t <= '0';
    end if;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
    eth_tx_en_t     <= eth_tx_en;
    s_tx_tdata_t2   <= s_tx_tdata_t;
    s_tx_tvalid_t2  <= s_tx_tvalid_t;
end if;
end process;

process(clk_25m)
begin
if rising_edge(clk_25m) then
    if (s_tx_tready = '0' or fifo_start_tx = '0') then
        s_tx_tdata   <= x"00";
        s_tx_tvalid  <= '0';
        s_tx_tlast   <= '0';
    else
        s_tx_tdata   <= s_tx_tdata_t2;
        s_tx_tvalid  <= s_tx_tvalid_t2;
        s_tx_tlast   <= s_tx_tlast_t;
    end if;
end if;
end process;

eth_tx_fifo : entity work.fifo_eth
  PORT MAP (
    m_aclk               => clk         		,   --: IN STD_LOGIC;
    s_aclk               => clk_25m             ,   --: IN STD_LOGIC;
    s_aresetn            => rst_n_25m           ,   --: IN STD_LOGIC;
    s_axis_tvalid        => s_tx_tvalid         ,   --: IN STD_LOGIC;
    s_axis_tready        => s_tx_tready         ,   --: OUT STD_LOGIC;
    s_axis_tdata         => s_tx_tdata          ,   --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tlast         => s_tx_tlast          ,   --: IN STD_LOGIC;
    m_axis_tvalid        => m_tx_tvalid         ,   --: OUT STD_LOGIC;
    m_axis_tready        => m_tx_tready         ,   --: IN STD_LOGIC;
    m_axis_tdata         => m_tx_tdata          ,   --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tlast         => m_tx_tlast          );   --: OUT STD_LOGIC;


    m_tx_tready          <= tx_axis_eth_tready;
    tx_axis_eth_tdata    <= m_tx_tdata;
    tx_axis_eth_tvalid   <= m_tx_tvalid;
    tx_axis_eth_tlast    <= m_tx_tlast;


end data;