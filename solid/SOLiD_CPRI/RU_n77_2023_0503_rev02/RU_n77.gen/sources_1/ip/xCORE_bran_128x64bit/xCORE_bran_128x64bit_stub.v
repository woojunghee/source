// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Mar 24 11:35:40 2023
// Host        : apus running 64-bit Ubuntu 20.04.5 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top xCORE_bran_128x64bit -prefix
//               xCORE_bran_128x64bit_ xCORE_bran_128x64bit_stub.v
// Design      : xCORE_bran_128x64bit
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.1" *)
module xCORE_bran_128x64bit(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[6:0],dina[63:0],clkb,enb,addrb[6:0],doutb[63:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [6:0]addra;
  input [63:0]dina;
  input clkb;
  input enb;
  input [6:0]addrb;
  output [63:0]doutb;
endmodule
