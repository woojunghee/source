-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
-- Date        : Fri Mar 24 11:35:33 2023
-- Host        : apus running 64-bit Ubuntu 20.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub -rename_top xCORE_DPRAM_8x704bit -prefix
--               xCORE_DPRAM_8x704bit_ xCORE_DPRAM_8x704bit_stub.vhdl
-- Design      : xCORE_DPRAM_8x704bit
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu11eg-ffvc1760-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xCORE_DPRAM_8x704bit is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 703 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    qdpo_clk : in STD_LOGIC;
    qdpo : out STD_LOGIC_VECTOR ( 703 downto 0 )
  );

end xCORE_DPRAM_8x704bit;

architecture stub of xCORE_DPRAM_8x704bit is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[3:0],d[703:0],dpra[3:0],clk,we,qdpo_clk,qdpo[703:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_13,Vivado 2022.2.1";
begin
end;
