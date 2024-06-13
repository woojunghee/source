library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library xpm;
use xpm.vcomponents.all;
library unisim;
use unisim.vcomponents.all;

entity delay_blk_uram_s2 is
port(
    clk	            	: in  std_logic;
    valid               : in  std_logic;
    rst_n             	: in  std_logic;
    din_i_m0           	: in  std_logic_vector(15 downto 0);
    din_q_m0           	: in  std_logic_vector(15 downto 0);
    din_i_m1           	: in  std_logic_vector(15 downto 0);
    din_q_m1           	: in  std_logic_vector(15 downto 0);
    din_user            : in  std_logic_vector( 7 downto 0);
    delay_parameter   	: in  std_logic_vector(14 downto 0);
    dout_i_m0         	: out std_logic_vector(15 downto 0);
    dout_q_m0         	: out std_logic_vector(15 downto 0);
    dout_i_m1         	: out std_logic_vector(15 downto 0);
    dout_q_m1         	: out std_logic_vector(15 downto 0);
    dout_user           : out std_logic_vector( 7 downto 0)
);

end entity delay_blk_uram_s2;

architecture rtl of delay_blk_uram_s2 is


signal delay_s0     : std_logic_vector(14 downto 0);
signal delay_s1     : std_logic_vector(14 downto 0);
signal wr_add_cnt   : integer range 0 to 12287;
signal wr_add       : std_logic_vector(14 downto 0);

signal DIN_A        : std_logic_vector(71 downto 0);
signal DOUT_B       : std_logic_vector(71 downto 0);
signal BWE_A        : std_logic_vector(8 downto 0);

signal rd_add_cnt   : integer range 0 to 12287;
signal rd_add       : std_logic_vector(14 downto 0);

signal rst_n_sync   : std_logic;
signal rst_b        : std_logic;

attribute ASYNC_REG    : string;
attribute ASYNC_REG of delay_s0      : signal is "true";
attribute ASYNC_REG of delay_s1      : signal is "true";

begin

rst_blk_wr: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst_n,
     dest_clk  => clk,
     dest_arst => rst_n_sync
  );

rst_b <= not rst_n_sync;

xpm_memory_uram : xpm_memory_sdpram
   generic map (
      ADDR_WIDTH_A            => 15                    , -- DECIMAL
      ADDR_WIDTH_B            => 15                    , -- DECIMAL
      AUTO_SLEEP_TIME         => 0                     , -- DECIMAL
      BYTE_WRITE_WIDTH_A      => 8                     , -- DECIMAL
      CASCADE_HEIGHT          => 0                     , -- DECIMAL
      CLOCKING_MODE           => "common_clock"        , -- String
      ECC_MODE                => "no_ecc"              , -- String
      MEMORY_INIT_FILE        => "none"                , -- String
      MEMORY_INIT_PARAM       => "0"                   , -- String
      MEMORY_OPTIMIZATION     => "true"                , -- String
      MEMORY_PRIMITIVE        => "ultra"               , -- String
      MEMORY_SIZE             => 884736                , -- DECIMAL
      MESSAGE_CONTROL         => 0                     , -- DECIMAL
      READ_DATA_WIDTH_B       => 72                    , -- DECIMAL
      READ_LATENCY_B          => 2                     , -- DECIMAL
      READ_RESET_VALUE_B      => "0"                   , -- String
      RST_MODE_A              => "SYNC"                , -- String
      RST_MODE_B              => "SYNC"                , -- String
      SIM_ASSERT_CHK          => 0                     , -- DECIMAL; 0=disable simulation messages                               , 1=enable simulation messages
      USE_EMBEDDED_CONSTRAINT => 0                     , -- DECIMAL
      USE_MEM_INIT            => 1                     , -- DECIMAL
      USE_MEM_INIT_MMI        => 0                     , -- DECIMAL
      WAKEUP_TIME             => "disable_sleep"       , -- String
      WRITE_DATA_WIDTH_A      => 72                    , -- DECIMAL
      WRITE_MODE_B            => "read_first"         , -- String
      WRITE_PROTECT           => 1                     ) -- DECIMAL
   port map (
      dbiterrb                => open                  , -- 1-bit output: Status signal to indicate double bit error occurrence on the data output of port B.
      doutb                   => DOUT_B                , -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      sbiterrb                => open                  , -- 1-bit output: Status signal to indicate single bit error occurrence on the data output of port B.
      addra                   => wr_add                , -- ADDR_WIDTH_A-bit input: Address for port A write operations.
      addrb                   => rd_add                , -- ADDR_WIDTH_B-bit input: Address for port B read operations.
      clka                    => CLK                   , -- 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".
      clkb                    => CLK                   , -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is  "independent_clock". Unused when parameter CLOCKING_MODE is "common_clock".
      dina                    => DIN_A                 , -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      ena                     => '1'                   , -- 1-bit input: Memory enable signal for port A. Must be high on clock cycles when write operations are initiated. Pipelined internally.
      enb                     => '1'                   , -- 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read operations are initiated. Pipelined internally.
      injectdbiterra          => '0'                   , -- 1-bit input: Controls double bit error injection on input data when ECC enabled (Error injection capability is not available in "decode_only" mode).
      injectsbiterra          => '0'                   , -- 1-bit input: Controls single bit error injection on input data when ECC enabled (Error injection capability is not available in "decode_only" mode).
      regceb                  => '1'                   , -- 1-bit input: Clock Enable for the last register stage on the output data path.
      rstb                    => RST_B                 , -- 1-bit input: Reset signal for the final port B output register stage. Synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.
      sleep                   => '0'                   , -- 1-bit input: sleep signal to enable the dynamic power saving feature.
      wea                     => BWE_A                     -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1 bit wide when word-wide writes are used. In byte-wide write configurations, each bit controls the
   );



process(clk)
begin
if rising_edge(clk) then
	delay_s0		<= delay_parameter;
	delay_s1		<= delay_s0;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
   if(rst_n_sync = '0' ) then
      wr_add_cnt <= 0;
   elsif ( valid = '1' ) then
      if (wr_add_cnt = 12287) then
         wr_add_cnt  <= 0;
      else
         wr_add_cnt  <= wr_add_cnt + 1;
      end if;
      DIN_A	<=  din_user & din_q_m1 & din_i_m1 & din_q_m0 & din_i_m0;
      BWE_A <= "111111111";
   else
      BWE_A <= "000000000";
   end if;
end if;
end process;

wr_add     <= conv_std_logic_vector(wr_add_cnt,15);

process(clk)
begin
if rising_edge(clk) then
   if(rst_n_sync = '0' ) then
      rd_add_cnt <= 0;
      dout_q_m1 <= x"0000";
      dout_i_m1 <= x"0000";
      dout_q_m0 <= x"0000";
      dout_i_m0 <= x"0000";
   elsif ( valid = '1' ) then
      if (rd_add_cnt = 12287) then
         rd_add_cnt  <= 0;
      elsif (wr_add_cnt = delay_s1) then
         rd_add_cnt  <= 0;
      else
         rd_add_cnt  <= rd_add_cnt + 1;
      end if;

      dout_user <= DOUT_B(71 downto 64);
      dout_q_m1 <= DOUT_B(63 downto 48);
      dout_i_m1 <= DOUT_B(47 downto 32);
      dout_q_m0 <= DOUT_B(31 downto 16);
      dout_i_m0 <= DOUT_B(15 downto 0);
   end if;
end if;
end process;


rd_add     <= conv_std_logic_vector(rd_add_cnt,15);


end rtl;




