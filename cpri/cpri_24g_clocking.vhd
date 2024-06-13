--------------------------------------------------------------------------
-- Title      : Clocking
-- Project    : cpri_v8_11_13
--------------------------------------------------------------------------
-- File       : cpri_clocking.vhd
-- Author     : Xilinx
--------------------------------------------------------------------------
-- Description: This file contains all the clocking required for sharing
--              clocks with other cores.
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_13;
use cpri_v8_11_13.all;

entity cpri_24g_clocking is
  port (
    reset                 : in  std_logic;
    stable_clk            : in  std_logic;
    txresetdone_in        : in  std_logic;
    speed_select          : in  std_logic_vector(14 downto 0);
    reset_phalignment_out : out std_logic);
end cpri_24g_clocking;

architecture rtl of cpri_24g_clocking is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component cpri_24g_reset_synchronizer is
    port (
      reset_in  : in  std_logic;
      clk       : in  std_logic;
      reset_out : out std_logic);
  end component;

  -------------- Signals Declaration --------------

  signal txresetdone_in_sync      : std_logic;
  signal rxusrclk2                : std_logic;

begin


  txresetdone_in_sync_i : cpri_24g_reset_synchronizer
    port map (
      reset_in  => txresetdone_in,
      clk       => stable_clk,
      reset_out => txresetdone_in_sync);

  process(stable_clk)
  begin
    if rising_edge(stable_clk) then
      if speed_select(14 downto 7) /= "00000000" then
        reset_phalignment_out <= '1';
      else
        reset_phalignment_out <= not(txresetdone_in_sync);
      end if;
    end if;
  end process;

end rtl;
