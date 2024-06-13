library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity GAIN_BLK_16 is
 port(
     clk            : in  std_logic                      ;
     gain           : in  std_logic_vector( 15 downto  0);
     din            : in  std_logic_vector( 15 downto  0);
     dout           : out std_logic_vector( 15 downto  0)
     );
end GAIN_BLK_16;

architecture behav of GAIN_BLK_16 is

COMPONENT mult_16x16
 PORT (
      CLK           : IN  STD_LOGIC                      ;
      A             : IN  STD_LOGIC_VECTOR( 15 DOWNTO  0);
      B             : IN  STD_LOGIC_VECTOR( 15 DOWNTO  0);
      CE            : IN  STD_LOGIC                      ;
      P             : OUT STD_LOGIC_VECTOR( 31 DOWNTO  0)
      );
END COMPONENT;


signal gain_reg          : std_logic_vector(31 downto 0);
signal gain_s0			: std_logic_vector(15 downto 0);
signal gain_s1			: std_logic_vector(15 downto 0);

attribute ASYNC_REG : string;
attribute ASYNC_REG of gain_s0	: signal is "true";
attribute ASYNC_REG of gain_s1	: signal is "true";

begin

process(clk)
begin
if rising_edge(clk)	 then
	gain_s0	<= gain;
	gain_s1	<= gain_s0;
end if;
end process;

GAIN_MULT:  mult_16x16
 port map (
      clk            => clk                              ,   --: in  std_logic                       ;
      a              => din                              ,   --: in  std_logic_vector( 15 downto  0) ;
      b              => gain_s1                          ,   --: in  std_logic_vector( 15 downto  0) ;
      ce             => '1'                              ,   --: in  std_logic                       ;
      p              => gain_reg                         );  --: out std_logic_vector( 31 downto  0)

process(clk)
begin
if rising_edge(clk) then
	dout        <= gain_reg(31) & gain_reg(25 downto 11) + gain_reg(10);
end if;
end process;


end behav;