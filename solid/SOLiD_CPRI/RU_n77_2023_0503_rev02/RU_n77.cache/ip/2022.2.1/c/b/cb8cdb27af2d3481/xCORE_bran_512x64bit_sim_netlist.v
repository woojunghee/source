// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Thu Dec 29 22:48:08 2022
// Host        : SUPERK2-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xCORE_bran_512x64bit_sim_netlist.v
// Design      : xCORE_bran_512x64bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xCORE_bran_512x64bit,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.1" *) 
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [8:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [63:0]doutb;

  wire [8:0]addra;
  wire [8:0]addrb;
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
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
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
  (* C_INIT_FILE = "xCORE_bran_512x64bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
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
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 33088)
`pragma protect data_block
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
aC1n/+PCcgqH6NU5muOPCDpOvrqwQ9sCUkyNFg==
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
