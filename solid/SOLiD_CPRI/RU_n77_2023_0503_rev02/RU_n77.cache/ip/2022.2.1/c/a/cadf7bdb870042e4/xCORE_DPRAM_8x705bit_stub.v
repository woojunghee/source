// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Thu Dec 29 18:55:49 2022
// Host        : SUPERK2-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xCORE_DPRAM_8x705bit_stub.v
// Design      : xCORE_DPRAM_8x705bit
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(a, d, dpra, clk, we, qdpo_clk, qdpo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[704:0],dpra[3:0],clk,we,qdpo_clk,qdpo[704:0]" */;
  input [3:0]a;
  input [704:0]d;
  input [3:0]dpra;
  input clk;
  input we;
  input qdpo_clk;
  output [704:0]qdpo;
endmodule
