// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Mar 24 11:35:40 2023
// Host        : apus running 64-bit Ubuntu 20.04.5 LTS
// Command     : write_verilog -force -mode funcsim -rename_top xCORE_bran_128x64bit -prefix
//               xCORE_bran_128x64bit_ xCORE_bran_128x64bit_sim_netlist.v
// Design      : xCORE_bran_128x64bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xCORE_bran_128x64bit,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.1" *) 
(* NotValidForBitStream *)
module xCORE_bran_128x64bit
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
  xCORE_bran_128x64bit_blk_mem_gen_v8_4_5 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 32720)
`pragma protect data_block
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
cl0=
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
