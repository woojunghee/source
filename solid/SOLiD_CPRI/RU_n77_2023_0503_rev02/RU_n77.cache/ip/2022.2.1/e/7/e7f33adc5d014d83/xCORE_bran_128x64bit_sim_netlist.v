// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Thu Dec 29 23:22:48 2022
// Host        : SUPERK2-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xCORE_bran_128x64bit_sim_netlist.v
// Design      : xCORE_bran_128x64bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xCORE_bran_128x64bit,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [6:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [63:0]doutb;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire clkb;
  wire [63:0]dina;
  wire [63:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [63:0]NLW_U0_douta_UNCONNECTED;
  wire [6:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "7" *) 
  (* C_ADDRB_WIDTH = "7" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.327111 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "xCORE_bran_128x64bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "128" *) 
  (* C_READ_DEPTH_B = "128" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "128" *) 
  (* C_WRITE_DEPTH_B = "128" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[63:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[6:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[6:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
bp+72lcPdMbgy2aTpZ6UANtGWwUYdSiSu9jqO6vPgn6ZjVPUwwA0/CEL9nDq3Ea2pLmI1c/gpvtz
/Yo20HN2QMbofCUYEjkA4OyWw+dzdIx7f1A7DdY1shClDXB0QH+jil0Nm0PzLCGIuv1iSrGVjJ9F
qk9texNmEYcHYna4ixI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YTIGzlJ9WlT/kpNzPlRmuNI3Y3qiYtlmxyDYZgOoWHWBDtZ1hQYB1qrOKTXVxaLwo0A61sbhulIs
C/Vni6ebQmt2HIxZgFRn9J0JH+nC13MVosJcUVrnbpQbe8zOjlAgaFdpvMMm39i+nJWnaT3Y7kmz
vFTEO5kaMED4DpqQVKqdGXM1Enjx8aqwcYhBBTen9+xOg3FDQ2iY2fvZQJ2QFKTIZz7MOpOAREzv
6Hrrcx0bmiIGCAlyUyXLrgnojuTi0Nb/X8ar+k8tS+o5SniJ2ia40SD/uYRIy0VbEZxCNktaxr0M
bmIxZwwfUFnIJi985FE/gFHteE4tlx9UZh5W2A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CH3W/MLrystpbZUK48wl2O1/His9aPfmMxOBsC/kUq/JleAlb0U/f8zEDj8HzJL3NV30mE+Npzur
HrLsIuqnt7ZhBEtAc20XoPgJhaa96rzADu40ry8y2MTLD0OOhwt3ArXSOQzOCEg5isIq766rSc/e
216eaf64DqW49NEZtsc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XTqEDXaF2PUKGn13N0YYakgNc0YwUmZ9d4za5PC2Y0N4HJ+oxkog/9zUwWcJ6begvjyXzDPLgUOs
5HH+E7KloCG+36QoHULrULictWOx+ItR0yr0myF5ydBe0Y55qs5XG9MRMiq52+jBhVvn6GxkCHYF
yFnuEWisH7xrKc6xrMO8HlFfKaa6lRYb93GmQj25E1J8CTOcINxLINw00H1JyB/drz+RfziTNMWJ
MhvXzWrvgBynHi/PEBKy2Erw97+Hesz8VhpstNUp0O4wY0TY3fDqnwuWiUTxOHTi34O70KYx3No+
Ghs45b25znGHYifZ1W755lGGwSKjbFpUfQDMdQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eO1xUvGyJBSgJECvby7ZS1hvpEGV31rPlUvjDwdffTLXR5lekCi/xZdXcKse1nkDMvODCQ5Z+3MN
c95/2anGGwEKnQ40FNOZF5fW8JthE+nRL3Q7bzAzVSseYct250bTJJFC4jjL+sYeQ8LYXlyJCsPy
6OYMAAxVEY9Onw7KBAGZrqDskXkoeCaPNsTGg+Ui51lZ7rpCulzVpTt/QOtOIDkxxNEuvQfgCz9g
l7tqua8JmgU76u3mVdS9qFIFBhkAxPejvtPPD3mVkwwTHP0ulE435uxcnpBLoDj7/Vsucwfl4mEs
1gjbUMOEnZF8hCkh1ByJyLNn2/eXUnK2JpUxCw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LBfc3sumSLI5yYvoX1CM4EN3Iw2cjdP0nh+CkdV/sd4dQoEOt2KuMvCWcdSjtPSPmFRJUPZTBHGZ
+VcXeUMtgLLOjtz00fag891cNWIkabEqFwQ8pxJppL1BgPN6XIQkb+f8P2/3p6mnSuFePdKQanCR
hdyhN89bUtgiHQKIB2IJ6Ip3wO4EgWt3wHLmT4ndw1TUQh5ko1ASsPr5YB0RqSy3mEIbzEq5Eafj
PI+lHjVti/PFmGjBTvX8iYfhwbLIS8KkqAmqM0XuNocL4pev4Y5xC0oiVoktnlG5TPBp+lzvwihz
v8MyzdInmgnzytYNoRFGbb4/A5qRRzCrbf8OOQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VWDRS+ukH6TV1l80GUWlQazLFfP2kq6a8fjFSzUTmuSKKyr5K2x6wU+rNkJWZiGVigH7vefweL00
Z5GXnxTB9J/FfRXljG2VlzEykbezedAcCUHVcLRQZ/WyCapmAwKk24GtBjVb5E0wRVUFOJVYok7Y
x6lgZm7d7j13Xp2IAA2NpPv1Z5sNtsHyrswhS9mSQZWQmc16CS3Cah9SD7vYfRtmhPeg5DkcBQhK
NKGf2YTnx+H3bHoWtttXHehTV4FWH+/qps79uWU1sq4RWbWLTj1PN6nRn0ToTvI85oYY5Kr01oYD
h0J6lNtWMsZ3ayuxPpgBBNTVfDLRTZ3jK4vVjA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
chuYO7mkqI7rU8NluQzM5W6R0HcyQxettiDmwl8GNylcspcNbRNQv33yF5vmxkgucL5HCmSs09cy
4GzsvG7rO9Y6BWhYelCXIeAl2eJFklEwmVNdiEZLcs16rRLT+pYgfA//x6npAl1efxCPMWPa7xJb
Zd+ZzVMuySPAKAgv5+MeqkmrfPX9nc6z/4/B6mfcu7WwYfibpF67wqLz9qE82VgJzLY86TZZigDv
95xt7UBv3hR4m/JZeivPkwLbRh4BO1s9xFELepxrAB8q5yR53dYNfBYMuju0KeGfgG5I8h7ojDY6
9n+WM4oihEmzdlq6u0n6zofSHo9dRIO2DRe6SHEc3hrV19uCXUzacdJmpor5+kB/5d+Yt8zZMmsa
9bEk+1E+LHq5Qqpb2M2tRoW5f8rIp0awX20tvq4/lsAPtuv/edELi67SgNrRMs+/z60JIklHBay2
JVd881MUtUxxtJc65R1FQ7SVKI26tB+pAkOSWNwuuTeA/0eAbqHF41TG

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MEGk6PuSsIJ//LRbTAuIw1mjvgGZP0PiBDG3CrCw1uhkUYYgkATt8PHzh1H5XaAsCNoDZsxL9oK1
CQiWUQSuM3HpZb2IV2O1Lopt/MK7VP5Bm5ExoldYlAPKeySqkmiy75uRpt5XqwxhIv2OYNFEFKGr
dKOmII04hCcQFQmhp5lieeDBbcfYrwoS2kSnu2DAbpqpuAk7Rijf+2qSmcML58Cpv8iqG8kFJ4Z7
DAKzsIzHsBge8r3kKyBq5nUZ22a/tz3BQVzO/Q88QhtTiuLtc/0x9/KVu7K0t1DZOfve01PiT6+U
1fDW0uy/oR9on9Ybf0L0rsX3uZFdYHVdcVeG4A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
xN3PmYa3FhtSan9smF5OAidJ3+XNdKKbebOan1VuXeMmLqFEV0H4D/5+422ccyNhtdkfQfnv32Y3
2wVRXnjA24/c6Q44McMTyIvroPB7ZPl35vaO5wqgC/mAwtFxd9ocfPP7TT3M1RrctEK1TM/8+lzR
qoPsinzXPKLfn/4O6cplA+P8IC1DGELb7GXg+5TtRMyxjRyIdh3sNloZGNjeZfbZkcsOx/faUFvB
oBqj2njRW4nTS93dUaVPIbUJz+2Yna0Qod72AIROBM9+EIant/EWWJmp9I+NHKx6DxBuq4KAZsIB
mxDukgRQQ+cy181Wn2paRkflltCkmHmTtWPk0w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XF5vWsDZEhsvGmuM6DJ+8OlG5votpsQTtd6P3C0pjZuXIeR6AOFrvUuQdlpkmN67pKgk5DK8XPCA
vRaXfj88S6ZavZca/bn5uFCGrHZ5gqI6NN6npkPlt1cvJXCywJRt3f9cFZGErUhndkQvkEGVhqrZ
2mxCiRLl9e4Uo3RFmEciRFxd1XBLxJfl0KRx9pKYZOH5gNTXG6vSgQ7sxfoDiUIrq66b+cd9SOvl
1PZbNeotQfK01URPzkSL5jbAK8NgPJOPPItPPNC0nsNCcrPt/ob+nZf/fvZDAyiGjuVwzBrDs3hf
Ru+ko1m5BEelygt9QQPMZeh5YLQixUeLSzwlZg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 32960)
`pragma protect data_block
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
oqNkvvAH/KRAaI9EzzY=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
