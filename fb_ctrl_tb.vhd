library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fb_ctrl_tb is
end;

architecture bench of fb_ctrl_tb is

  component fb_ctrl
      port (
      clk_491p52      : in std_logic;
      loc_clk         : in std_logic;
      rst             : in std_logic;
      srx_ctrl_tready : out std_logic;
      srx_ctrl_tvalid : in std_logic;
      srx_ctrl_tdata  : in std_logic_vector(7 downto 0);
      mxl_fb_sw       : in  std_logic_vector(1 downto 0);
      fb_ona          : in  std_logic;
      fb_sw_dly       : in  std_logic_vector(9 downto 0);
      fb_sw           : out std_logic_vector(1 downto 0);
      fb0_i_s0        : in std_logic_vector(15 downto 0);
      fb0_i_s1        : in std_logic_vector(15 downto 0);
      fb0_q_s0        : in std_logic_vector(15 downto 0);
      fb0_q_s1        : in std_logic_vector(15 downto 0);
      fb1_i_s0        : in std_logic_vector(15 downto 0);
      fb1_i_s1        : in std_logic_vector(15 downto 0);
      fb1_q_s0        : in std_logic_vector(15 downto 0);
      fb1_q_s1        : in std_logic_vector(15 downto 0);
      fb_in_tready    : in std_logic;
      fb_in_tdata     : out std_logic_vector(63 downto 0);
      fb_in_tuser     : out std_logic_vector(7 downto 0);
      fb_in_tvalid    : out std_logic
    );
  end component;

  -- Clock period
  constant clk_491p52_period : time := 2.034 ns;
  constant clk_100_period    : time := 10 ns;

  -- Generics

  -- ports
  signal clk_491p52      : std_logic;
  signal loc_clk         : std_logic;
  signal clk_100         : std_logic;
  signal rst             : std_logic;
  signal srx_ctrl_tready : std_logic;
  signal srx_ctrl_tvalid : std_logic:= '0';
  signal srx_ctrl_tdata  : std_logic_vector(7 downto 0) := x"00";
  signal fb_ona          : std_logic;
  signal sw_dly          : std_logic_vector(9 downto 0);
  signal fb0_i_s0        : std_logic_vector(15 downto 0);
  signal fb0_i_s1        : std_logic_vector(15 downto 0);
  signal fb0_q_s0        : std_logic_vector(15 downto 0);
  signal fb0_q_s1        : std_logic_vector(15 downto 0);
  signal fb1_i_s0        : std_logic_vector(15 downto 0);
  signal fb1_i_s1        : std_logic_vector(15 downto 0);
  signal fb1_q_s0        : std_logic_vector(15 downto 0);
  signal fb1_q_s1        : std_logic_vector(15 downto 0);
  signal fb_in_tready    : std_logic;
  signal fb_in_tdata     : std_logic_vector(63 downto 0);
  signal fb_in_tvalid    : std_logic;
  signal fb_in_tuser     : std_logic_vector(7 downto 0);
  signal fb_sw           : std_logic_vector(1 downto 0);

  signal mxl_fb_sw       : std_logic_vector(1 downto 0);


begin

  fb_ctrl_inst : fb_ctrl
    port map (
      clk_491p52      => clk_491p52,
      loc_clk         => clk_100,
      rst             => rst,
      srx_ctrl_tready => srx_ctrl_tready,
      srx_ctrl_tvalid => srx_ctrl_tvalid,
      srx_ctrl_tdata  => srx_ctrl_tdata,
      mxl_fb_sw       => mxl_fb_sw,
      fb_sw           => fb_sw,
      fb_ona          => fb_ona,
      fb_sw_dly       => sw_dly,
      fb0_i_s0        => fb0_i_s0,
      fb0_i_s1        => fb0_i_s1,
      fb0_q_s0        => fb0_q_s0,
      fb0_q_s1        => fb0_q_s1,
      fb1_i_s0        => fb1_i_s0,
      fb1_i_s1        => fb1_i_s1,
      fb1_q_s0        => fb1_q_s0,
      fb1_q_s1        => fb1_q_s1,
      fb_in_tready    => fb_in_tready,
      fb_in_tdata     => fb_in_tdata,
      fb_in_tuser     => fb_in_tuser,
      fb_in_tvalid    => fb_in_tvalid
    );


   rst <=  '1' after      0 ns,
           '0' after     100 ns;


srx_ctrl_tvalid <= '1' after   200 ns,
                   '0' after   300 ns,
                   '1' after   400 ns,
                   '0' after   500 ns,
                   '1' after   600 ns,
                   '0' after   700 ns;

srx_ctrl_tdata  <= x"01" after 200 ns,
                   x"02" after 300 ns,
                   x"00" after 500 ns;

fb_ona  <= '0';

   clk_491p52_process : process
   begin
    clk_491p52 <= '1';
   wait for clk_491p52_period/2;
    clk_491p52 <= '0';
   wait for clk_491p52_period/2;
   end process clk_491p52_process;

   clk_100_process : process
   begin
    clk_100 <= '1';
   wait for clk_100_period/2;
    clk_100 <= '0';
   wait for clk_100_period/2;
   end process clk_100_process;

process(clk_491p52)
begin
if rising_edge(clk_491p52) then
    if ( rst = '1' ) then
        fb0_i_s0     <= (others=> '0');
        fb0_i_s1     <= (others=> '0');
        fb0_q_s0     <= (others=> '0');
        fb0_q_s1     <= (others=> '0');
        fb1_i_s0     <= (others=> '0');
        fb1_i_s1     <= (others=> '0');
        fb1_q_s0     <= (others=> '0');
        fb1_q_s1     <= (others=> '0');
        sw_dly       <= "0000000000";
        fb_in_tready <= '0';
    else
        fb0_i_s0     <= x"0001";
        fb0_i_s1     <= x"0002";
        fb0_q_s0     <= x"0003";
        fb0_q_s1     <= x"0004";
        fb1_i_s0     <= x"0005";
        fb1_i_s1     <= x"0006";
        fb1_q_s0     <= x"0007";
        fb1_q_s1     <= x"0008";
        sw_dly       <= "0000010010";
        fb_in_tready <= '1';

    end if;
end if;
end process;


end;
