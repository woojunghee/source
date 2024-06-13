// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Thu Dec 29 23:18:24 2022
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
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [63:0]douta;

  wire [6:0]addra;
  wire clka;
  wire [63:0]dina;
  wire [63:0]douta;
  wire ena;
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
  wire [63:0]NLW_U0_doutb_UNCONNECTED;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.931282 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
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
  (* C_MEM_TYPE = "0" *) 
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
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[63:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 31728)
`pragma protect data_block
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
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
