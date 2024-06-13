----------------------------------------------------------------------------------
-- company:
-- engineer:
    --
-- create date: 2017/07/03 12:40:40
-- design name:
-- module name: clk_blk - behavioral
-- project name:
-- target devices:
-- tool versions:
-- description:
--
-- dependencies:
--
-- revision:
-- revision 0.01 - file created
-- additional comments:
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.ALL;

library unisim;
use unisim.vcomponents.all;

entity clk_blk is
port (
    loc_reset_n      : in  std_logic;
    ext_pll_lock     : in  std_logic;
    clk_100          : in  std_logic;

    cpri_ref_clk_p   : in  std_logic; -- 307.2mhz
    cpri_ref_clk_n   : in  std_logic;

    cpri_rec_clk     : in  std_logic;
    cpri_rec_clk_p   : out std_logic;
    cpri_rec_clk_n   : out std_logic;

    jesd_ref_clk_p   : in  std_logic; -- 245.76mhz
    jesd_ref_clk_n   : in  std_logic;
    gt_powergood     : in  std_logic;

    jesd_sysref_p    : in  std_logic;
    jesd_sysref_n    : in  std_logic;


    cpri_ref_clk     : out std_logic;
    jesd_ref_clk     : out std_logic;

    jesd_sysref      : out std_logic; -- 1.92mhz

    clk_491p52       : out std_logic;
    clk_245p76       : out std_logic;
    clk_122p88       : out std_logic;
    clk_7p68         : out std_logic;

    clk_368p64       : out std_logic;
	dspclk_368p64       : out std_logic;
    clk_294p912      : out std_logic;
    clk_61p44        : out std_logic;

    mmcm_jesd_locked : out std_logic;
    mmcm_cpri_locked : out std_logic
);
end clk_blk;

architecture behavioral of clk_blk is


signal cpri_ref_clk_i  : std_logic := '0';
signal jesd_ref_clk_i  : std_logic := '0';

signal cpri_clk_buf    : std_logic := '0';
signal jesd_clk_buf    : std_logic := '0';
signal jesd_sysref_buf : std_logic := '0';

signal reset_n         : std_logic := '0';

signal clk_307p2_mmcm  : std_logic := '0';


begin

reset_n <= ext_pll_lock and loc_reset_n;


--========================================================
--====================== cpri clk ========================
--========================================================

IBUFDS_GTE4_CPRI : IBUFDS_GTE4
generic map (
    REFCLK_EN_TX_PATH  => '0'             ,
    REFCLK_HROW_CK_SEL => "00"            ,
    REFCLK_ICNTL_RX    => "00"            )
port map (
    O                  => cpri_ref_clk    ,
    ODIV2              => cpri_ref_clk_i  ,
    CEB                => '0'             ,
    I                  => cpri_ref_clk_p  ,
    IB                 => cpri_ref_clk_n  );


cpri_bufg_gt : bufg_gt
port map (
    o                  => cpri_clk_buf    ,
    ce                 => '1'             ,
    cemask             => '1'             ,
    clr                => '0'             ,
    clrmask            => '1'             ,
    div                => "000"           ,
    i                  => cpri_ref_clk_i  );


CPRI1_MMCM : entity work.mmcm_cpri1
port map(
    clk_in1            => cpri_clk_buf    , --: in  std_logic;
    resetn             => reset_n         , --: in  std_logic;
    clk_368p64         => clk_368p64      , --: out std_logic;
    clk_294p912        => clk_294p912     , --: out std_logic;
    clk_61p44          => clk_61p44       , --: out std_logic;
    locked             => mmcm_cpri_locked);

OBUFDS_RECCLK : OBUFDS
  port map (
      O                => cpri_rec_clk_p  , -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB               => cpri_rec_clk_n  , -- 1-bit output: Diff_n output (connect directly to top-level port)
      I                => cpri_rec_clk    );    -- 1-bit input: Buffer input

--========================================================
--====================== jesd clk ========================
--========================================================

IBUFDS_GTE4_JESD : IBUFDS_GTE4
generic map (
    REFCLK_EN_TX_PATH  => '0'             ,
    REFCLK_HROW_CK_SEL => "00"            ,
    REFCLK_ICNTL_RX    => "00"            )
port map (
    O                  => jesd_ref_clk    ,
    ODIV2              => jesd_ref_clk_i  ,
    CEB                => '0'             ,
    I                  => jesd_ref_clk_p  ,
    IB                 => jesd_ref_clk_n  );


jesd_bufg_gt : bufg_gt
port map (
    o                  => jesd_clk_buf    ,
    ce                 => gt_powergood    ,
    cemask             => '1'             ,
    clr                => '0'             ,
    clrmask            => '1'             ,
    div                => "000"           ,
    i                  => jesd_ref_clk_i  );


JESD_MMCM : entity work.mmcm_jesd
port map(
    clk_in1            => jesd_clk_buf    , --: in  std_logic;
    resetn             => reset_n         , --: in  std_logic;
    clk_491p52         => clk_491p52      , --: out std_logic;
    clk_245p76         => clk_245p76      , --: out std_logic;
    clk_122p88         => clk_122p88      , --: out std_logic;
	clk_368p64         => dspclk_368p64,
    -- clk_61p44          => open            , --: out std_logic;
    -- clk_7p68           => clk_7p68        , --: out std_logic;
    locked             => mmcm_jesd_locked);

IBUFDS_SYSREF : IBUFDS
port map (
    O                  => jesd_sysref_buf ,
    I                  => jesd_sysref_p   ,
    IB                 => jesd_sysref_n   );

jesd_sysref        <= jesd_sysref_buf;


end behavioral;

