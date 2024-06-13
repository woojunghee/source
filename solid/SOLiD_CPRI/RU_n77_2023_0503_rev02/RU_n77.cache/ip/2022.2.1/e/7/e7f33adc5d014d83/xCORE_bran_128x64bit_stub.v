// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Thu Dec 29 23:22:48 2022
// Host        : SUPERK2-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xCORE_bran_128x64bit_stub.v
// Design      : xCORE_bran_128x64bit
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
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
