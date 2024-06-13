
library ieee;
use ieee.std_logic_1164.all;

entity d_sync is
generic (
    bits    : natural := 16 );       -- number of bit.
port (
    in_clk  : in  std_logic;
    out_clk : in  std_logic;
    d_in    : in  std_logic_vector(bits-1 downto 0);
    d_out   : out std_logic_vector(bits-1 downto 0)
);
end d_sync;

-------------------------------------------------------------------------------

architecture rtl of d_sync is

 signal din_reg : std_logic_vector(bits-1 downto 0);
 signal din_s0  : std_logic_vector(bits-1 downto 0);
 signal din_s1  : std_logic_vector(bits-1 downto 0);

attribute ASYNC_REG : string;
attribute ASYNC_REG of din_reg	: signal is "true";
attribute ASYNC_REG of din_s0	: signal is "true";
attribute ASYNC_REG of din_s1	: signal is "true";


begin

    -- Synchronizer process.

process(in_clk)
begin
if rising_edge(in_clk)	 then
	din_reg	<= d_in;
end if;
end process;

process(out_clk)
begin
if rising_edge(out_clk)	 then
	din_s0	<= din_reg;
	din_s1	<= din_s0;
end if;
end process;

d_out   <= din_s1;


end rtl;

