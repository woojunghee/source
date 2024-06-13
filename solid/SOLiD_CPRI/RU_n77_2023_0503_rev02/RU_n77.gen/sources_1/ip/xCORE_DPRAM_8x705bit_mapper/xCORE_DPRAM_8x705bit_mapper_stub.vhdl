-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (lin64) Build 3865809 Sun May  7 15:04:56 MDT 2023
-- Date        : Thu Jul  6 19:17:47 2023
-- Host        : ubuntu-B550M-SILVER running 64-bit Ubuntu 18.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ubuntu/work/uq/N77_dpd_14p0/N77L_RU_solid_no_ltm_soft_fec-/Sources/solid/SOLiD_CPRI/RU_n77_2023_0503_rev02/RU_n77.gen/sources_1/ip/xCORE_DPRAM_8x705bit_mapper/xCORE_DPRAM_8x705bit_mapper_stub.vhdl
-- Design      : xCORE_DPRAM_8x705bit_mapper
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu11eg-ffvc1760-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xCORE_DPRAM_8x705bit_mapper is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 704 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    qdpo_clk : in STD_LOGIC;
    qdpo : out STD_LOGIC_VECTOR ( 704 downto 0 )
  );

end xCORE_DPRAM_8x705bit_mapper;

architecture stub of xCORE_DPRAM_8x705bit_mapper is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[3:0],d[704:0],dpra[3:0],clk,we,qdpo_clk,qdpo[704:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_13,Vivado 2023.1";
begin
end;
