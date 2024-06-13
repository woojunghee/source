// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Mar 24 11:35:33 2023
// Host        : apus running 64-bit Ubuntu 20.04.5 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top xCORE_DPRAM_8x704bit -prefix
//               xCORE_DPRAM_8x704bit_ xCORE_DPRAM_8x704bit_stub.v
// Design      : xCORE_DPRAM_8x704bit
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2.1" *)
module xCORE_DPRAM_8x704bit(a, d, dpra, clk, we, qdpo_clk, qdpo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[703:0],dpra[3:0],clk,we,qdpo_clk,qdpo[703:0]" */;
  input [3:0]a;
  input [703:0]d;
  input [3:0]dpra;
  input clk;
  input we;
  input qdpo_clk;
  output [703:0]qdpo;
endmodule
