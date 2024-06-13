library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_interconnect_tb is
end;

architecture bench of axis_interconnect_tb is

COMPONENT axis_interconnect_eth
  PORT (
    ACLK                 : IN STD_LOGIC;
    ARESETN              : IN STD_LOGIC;
    S00_AXIS_ACLK        : IN STD_LOGIC;
    S01_AXIS_ACLK        : IN STD_LOGIC;
    S00_AXIS_ARESETN     : IN STD_LOGIC;
    S01_AXIS_ARESETN     : IN STD_LOGIC;
    S00_AXIS_TVALID      : IN STD_LOGIC;
    S01_AXIS_TVALID      : IN STD_LOGIC;
    S00_AXIS_TREADY      : OUT STD_LOGIC;
    S01_AXIS_TREADY      : OUT STD_LOGIC;
    S00_AXIS_TDATA       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXIS_TDATA       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXIS_TLAST       : IN STD_LOGIC;
    S01_AXIS_TLAST       : IN STD_LOGIC;
    M00_AXIS_ACLK        : IN STD_LOGIC;
    M00_AXIS_ARESETN     : IN STD_LOGIC;
    M00_AXIS_TVALID      : OUT STD_LOGIC;
    M00_AXIS_TREADY      : IN STD_LOGIC;
    M00_AXIS_TDATA       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXIS_TLAST       : OUT STD_LOGIC;
    S00_ARB_REQ_SUPPRESS : IN STD_LOGIC;
    S01_ARB_REQ_SUPPRESS : IN STD_LOGIC
  );
END COMPONENT;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal ACLK                 : STD_LOGIC;
  signal ARESETN              : STD_LOGIC;

  signal S0_AXIS_TVALID      : STD_LOGIC;
  signal S1_AXIS_TVALID      : STD_LOGIC;
  signal S0_AXIS_TREADY      : STD_LOGIC;
  signal S1_AXIS_TREADY      : STD_LOGIC;
  signal S0_AXIS_TDATA       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal S1_AXIS_TDATA       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal S0_AXIS_TLAST       : STD_LOGIC;
  signal S1_AXIS_TLAST       : STD_LOGIC;

  signal S00_AXIS_TVALID      : STD_LOGIC;
  signal S01_AXIS_TVALID      : STD_LOGIC;
  signal S00_AXIS_TREADY      : STD_LOGIC;
  signal S01_AXIS_TREADY      : STD_LOGIC;
  signal S00_AXIS_TDATA       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal S01_AXIS_TDATA       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal S00_AXIS_TLAST       : STD_LOGIC;
  signal S01_AXIS_TLAST       : STD_LOGIC;
  signal M00_AXIS_TVALID      : STD_LOGIC;
  signal M00_AXIS_TREADY      : STD_LOGIC;
  signal M00_AXIS_TDATA       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal M00_AXIS_TLAST       : STD_LOGIC;
  signal S00_FIFO_DATA_COUNT  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal S01_FIFO_DATA_COUNT  : STD_LOGIC_VECTOR(31 DOWNTO 0);

  signal cnt       : integer range 0 to 63 := 63;

begin

your_instance_name : axis_interconnect_eth
  PORT MAP (
    ACLK                 => ACLK,
    ARESETN              => ARESETN,
    S00_AXIS_ACLK        => ACLK,
    S01_AXIS_ACLK        => ACLK,
    S00_AXIS_ARESETN     => ARESETN,
    S01_AXIS_ARESETN     => ARESETN,
    S00_AXIS_TVALID      => S00_AXIS_TVALID,
    S01_AXIS_TVALID      => S01_AXIS_TVALID,
    S00_AXIS_TREADY      => S00_AXIS_TREADY,
    S01_AXIS_TREADY      => S01_AXIS_TREADY,
    S00_AXIS_TDATA       => S00_AXIS_TDATA,
    S01_AXIS_TDATA       => S01_AXIS_TDATA,
    S00_AXIS_TLAST       => S00_AXIS_TLAST,
    S01_AXIS_TLAST       => S01_AXIS_TLAST,
    M00_AXIS_ACLK        => ACLK,
    M00_AXIS_ARESETN     => ARESETN,
    M00_AXIS_TVALID      => M00_AXIS_TVALID,
    M00_AXIS_TREADY      => M00_AXIS_TREADY,
    M00_AXIS_TDATA       => M00_AXIS_TDATA,
    M00_AXIS_TLAST       => M00_AXIS_TLAST,
    S00_ARB_REQ_SUPPRESS => '0',
    S01_ARB_REQ_SUPPRESS => '0'
  );

   clk_process : process
   begin
   ACLK <= '1';
   wait for clk_period/2;
   ACLK <= '0';
   wait for clk_period/2;
   end process clk_process;

   ARESETN  <=  '0' after      0 ns,
                '1' after     1000 ns;


process(aclk)
begin
if rising_edge(aclk) then
    if (ARESETN = '0') then
        cnt <= 0;
    else
       if ( S0_AXIS_TREADY = '1' ) then
            if (cnt = 63) then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
       end if;
    end if;
end if;
end process;


process(aclk)
begin
if rising_edge(aclk) then
    if (ARESETN = '0') then
        M00_AXIS_TREADY <= '0';
    else
        M00_AXIS_TREADY <= not M00_AXIS_TREADY;
    end if;
end if;
end process;


process(aclk)
begin
if rising_edge(aclk) then
    if (ARESETN = '0') then
        S0_AXIS_TVALID <= '0';
        S1_AXIS_TVALID <= '0';
        S0_AXIS_TLAST  <= '0';
        S1_AXIS_TLAST  <= '0';
        S0_AXIS_TDATA  <= x"00";
        S1_AXIS_TDATA  <= x"00";
    else
        case (cnt) is
            when  0  => S0_AXIS_TVALID <= '0';
                        S1_AXIS_TVALID <= '0';
                        S0_AXIS_TLAST  <= '0';
                        S1_AXIS_TLAST  <= '0';
                        S0_AXIS_TDATA  <= x"00";
                        S1_AXIS_TDATA  <= x"00";
            when  1  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"02";
                        S1_AXIS_TDATA  <= x"03";
            when  2  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"04";
                        S1_AXIS_TDATA  <= x"05";
            when  3  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"06";
                        S1_AXIS_TDATA  <= x"07";
            when  4  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"08";
                        S1_AXIS_TDATA  <= x"09";
            when  5  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"0a";
                        S1_AXIS_TDATA  <= x"0b";
            when  6  => S0_AXIS_TVALID <= '1';
                        S1_AXIS_TVALID <= '1';
                        S0_AXIS_TDATA  <= x"0c";
                        S1_AXIS_TDATA  <= x"0d";
                        S0_AXIS_TLAST  <= '1';
                        S1_AXIS_TLAST  <= '1';
            when  7  => S0_AXIS_TVALID <= '0';
                        S1_AXIS_TVALID <= '0';
                        S0_AXIS_TDATA  <= x"00";
                        S1_AXIS_TDATA  <= x"00";
            when others => null;

        end case;
    end if;
end if;
end process;



fifo0 : entity work.fifo_axi
  port map(
    wr_rst_busy     => open            , --: OUT STD_LOGIC;
    rd_rst_busy     => open            , --: OUT STD_LOGIC;
    s_aclk          => aclk            , --: IN STD_LOGIC;
    s_aresetn       => ARESETN         , --: IN STD_LOGIC;
    s_axis_tvalid   => S0_AXIS_TVALID  , --: IN STD_LOGIC;
    s_axis_tready   => S0_AXIS_TREADY  , --: OUT STD_LOGIC;
    s_axis_tdata    => S0_AXIS_TDATA   , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tlast    => S0_AXIS_TLAST   , --: IN STD_LOGIC;
    m_axis_tvalid   => S00_AXIS_TVALID , --: OUT STD_LOGIC;
    m_axis_tready   => S00_AXIS_TREADY , --: IN STD_LOGIC;
    m_axis_tdata    => S00_AXIS_TDATA  , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tlast    => S00_AXIS_TLAST  ); --: OUT STD_LOGIC

fifo1 : entity work.fifo_axi
  port map(
    wr_rst_busy     => open            , --: OUT STD_LOGIC;
    rd_rst_busy     => open            , --: OUT STD_LOGIC;
    s_aclk          => aclk            , --: IN STD_LOGIC;
    s_aresetn       => ARESETN         , --: IN STD_LOGIC;
    s_axis_tvalid   => S1_AXIS_TVALID  , --: IN STD_LOGIC;
    s_axis_tready   => S1_AXIS_TREADY  , --: OUT STD_LOGIC;
    s_axis_tdata    => S1_AXIS_TDATA   , --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tlast    => S1_AXIS_TLAST   , --: IN STD_LOGIC;
    m_axis_tvalid   => S01_AXIS_TVALID , --: OUT STD_LOGIC;
    m_axis_tready   => S01_AXIS_TREADY , --: IN STD_LOGIC;
    m_axis_tdata    => S01_AXIS_TDATA  , --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tlast    => S01_AXIS_TLAST  ); --: OUT STD_LOGIC

end;
