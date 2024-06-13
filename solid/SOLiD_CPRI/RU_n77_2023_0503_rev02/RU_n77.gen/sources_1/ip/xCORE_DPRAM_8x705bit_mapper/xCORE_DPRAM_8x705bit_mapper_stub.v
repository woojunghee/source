// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (lin64) Build 3865809 Sun May  7 15:04:56 MDT 2023
// Date        : Thu Jul  6 19:17:47 2023
// Host        : ubuntu-B550M-SILVER running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ubuntu/work/uq/N77_dpd_14p0/N77L_RU_solid_no_ltm_soft_fec-/Sources/solid/SOLiD_CPRI/RU_n77_2023_0503_rev02/RU_n77.gen/sources_1/ip/xCORE_DPRAM_8x705bit_mapper/xCORE_DPRAM_8x705bit_mapper_stub.v
// Design      : xCORE_DPRAM_8x705bit_mapper
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2023.1" *)
module xCORE_DPRAM_8x705bit_mapper(a, d, dpra, clk, we, qdpo_clk, qdpo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[704:0],dpra[3:0],we,qdpo[704:0]" */
/* synthesis syn_force_seq_prim="clk" */
/* synthesis syn_force_seq_prim="qdpo_clk" */;
  input [3:0]a;
  input [704:0]d;
  input [3:0]dpra;
  input clk /* synthesis syn_isclock = 1 */;
  input we;
  input qdpo_clk /* synthesis syn_isclock = 1 */;
  output [704:0]qdpo;
endmodule
