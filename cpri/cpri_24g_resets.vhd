--------------------------------------------------------------------------
-- Title : Resets
-- Project : CPRI
--------------------------------------------------------------------------
-- File : cpri_resets.vhd
--------------------------------------------------------------------------

--***********************************Entity Declaration*******************************
library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity cpri_24g_resets is
    port (
      aux_clk    : in std_logic;
      reset      : in std_logic;
      qpll_reset : out std_logic
    );
end cpri_24g_resets;

architecture rtl of cpri_24g_resets is


begin
  qpll_reset <= reset;

end rtl;
