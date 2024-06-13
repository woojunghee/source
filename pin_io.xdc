#set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
#set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
#set_property BITSTREAM.GENERAL.UNCONSTRAINEDPINS Allow [current_design]


set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {SFP_INSERT[0]}]
set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS33} [get_ports {SFP_INSERT[1]}]
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS33} [get_ports {SFP_INSERT[2]}]
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports {SFP_INSERT[3]}]

set_property -dict {PACKAGE_PIN P13 IOSTANDARD LVCMOS33} [get_ports {SFP_DIS[0]}]
set_property -dict {PACKAGE_PIN N10 IOSTANDARD LVCMOS33} [get_ports {SFP_DIS[1]}]
set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVCMOS33} [get_ports {SFP_DIS[2]}]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {SFP_DIS[3]}]

set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {SFP_LOS[0]}]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports {SFP_LOS[1]}]
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports {SFP_LOS[2]}]
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS33} [get_ports {SFP_LOS[3]}]

set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {SFP_SCL[0]}]
set_property -dict {PACKAGE_PIN N12 IOSTANDARD LVCMOS33} [get_ports {SFP_SCL[1]}]
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS33} [get_ports {SFP_SCL[2]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {SFP_SCL[3]}]

set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {SFP_SDA[0]}]
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports {SFP_SDA[1]}]
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS33} [get_ports {SFP_SDA[2]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {SFP_SDA[3]}]


set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports RFU_ATT_CLK]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports RFU_ATT_DATA]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS33} [get_ports {RFU_ATT_LE[0]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports {RFU_ATT_LE[1]}]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {RFU_ATT_LE[2]}]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS33} [get_ports {RFU_ATT_LE[3]}]

set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS33} [get_ports {RFU_TX_EN[0]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33} [get_ports {RFU_TX_EN[1]}]
set_property -dict {PACKAGE_PIN F8 IOSTANDARD LVCMOS33} [get_ports {RFU_TX_EN[2]}]
set_property -dict {PACKAGE_PIN E9 IOSTANDARD LVCMOS33} [get_ports {RFU_TX_EN[3]}]

set_property -dict {PACKAGE_PIN H8 IOSTANDARD LVCMOS33} [get_ports {RFU_RX_EN[0]}]
set_property -dict {PACKAGE_PIN F7 IOSTANDARD LVCMOS33} [get_ports {RFU_RX_EN[1]}]
set_property -dict {PACKAGE_PIN G8 IOSTANDARD LVCMOS33} [get_ports {RFU_RX_EN[2]}]
set_property -dict {PACKAGE_PIN F9 IOSTANDARD LVCMOS33} [get_ports {RFU_RX_EN[3]}]

set_property -dict {PACKAGE_PIN J9 IOSTANDARD LVCMOS33} [get_ports {RFU_ORX[0]}]
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {RFU_ORX[1]}]

set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVCMOS33} [get_ports RFU_FRS]



set_property -dict {PACKAGE_PIN G7 IOSTANDARD LVCMOS33} [get_ports RFU_INSERT]


set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports RFU_DL_TDD_SYNC]
set_property -dict {PACKAGE_PIN J8 IOSTANDARD LVCMOS33} [get_ports RFU_UL_TDD_SYNC]

set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS33} [get_ports RFU_TEMP_SCL]
set_property -dict {PACKAGE_PIN C8 IOSTANDARD LVCMOS33} [get_ports RFU_TEMP_SDA]


set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports L1_RESET]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports ONE_PPS]

set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports ONE_PPS_MON]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports TDD_MON]


set_property -dict {PACKAGE_PIN BB5 IOSTANDARD LVCMOS18} [get_ports {LED_R[0]}]
set_property -dict {PACKAGE_PIN BA6 IOSTANDARD LVCMOS18} [get_ports {LED_R[1]}]
set_property -dict {PACKAGE_PIN BA8 IOSTANDARD LVCMOS18} [get_ports {LED_R[2]}]

set_property -dict {PACKAGE_PIN BB4 IOSTANDARD LVCMOS18} [get_ports {LED_G[0]}]
set_property -dict {PACKAGE_PIN BB6 IOSTANDARD LVCMOS18} [get_ports {LED_G[1]}]
set_property -dict {PACKAGE_PIN BA7 IOSTANDARD LVCMOS18} [get_ports {LED_G[2]}]


set_property -dict {PACKAGE_PIN AJ14 IOSTANDARD LVCMOS18} [get_ports {PLL_LOCK[0]}]
set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVCMOS18} [get_ports {PLL_LOCK[1]}]
set_property -dict {PACKAGE_PIN AM13 IOSTANDARD LVCMOS18} [get_ports {PLL_LOCK[2]}]

#set_property -dict {PACKAGE_PIN AT15 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports PTP_CLK_P]
#set_property -dict {PACKAGE_PIN AU15 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports PTP_CLK_N]


set_property -dict {PACKAGE_PIN AM14 IOSTANDARD LVCMOS18} [get_ports OPTIC_SW]
set_property -dict {PACKAGE_PIN AR13 IOSTANDARD LVCMOS18} [get_ports FPGA_25MHZ]

set_property -dict {PACKAGE_PIN AW15 IOSTANDARD LVDS} [get_ports CPRI_REC_CLK_P]
set_property -dict {PACKAGE_PIN AW14 IOSTANDARD LVDS} [get_ports CPRI_REC_CLK_N]


set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS18} [get_ports MXL_RST_N]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS18} [get_ports {MXL_CHIP_MODE[0]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS18} [get_ports {MXL_CHIP_MODE[1]}]

set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS18} [get_ports {MXL_CLK_SEL[0]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS18} [get_ports {MXL_CLK_SEL[1]}]
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS18} [get_ports {MXL_CLK_SEL[2]}]


# port change
# 0 -> 2
# 1 -> 3
# 2 -> 0
# 3 -> 1

set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS18} [get_ports {MXL_TX_EN[2]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports {MXL_TX_EN[3]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS18} [get_ports {MXL_TX_EN[0]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports {MXL_TX_EN[1]}]

set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS18} [get_ports {MXL_RX_EN[2]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS18} [get_ports {MXL_RX_EN[3]}]
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS18} [get_ports {MXL_RX_EN[0]}]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS18} [get_ports {MXL_RX_EN[1]}]

# port change
# 0 -> 1

set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports {MXL_FB_EN[1]}]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS18} [get_ports {MXL_FB_EN[0]}]

#set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB1_ID0]
#set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB0_ID0]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB1_ID0]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB0_ID0]

#set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB0_ID1]
#set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS18} [get_ports MXL_RXFB1_ID1]

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS18} [get_ports MXL_FBRX_CAL]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS18} [get_ports MXL_PAP]

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS18} [get_ports MXL_MGAIN_CLK]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS18} [get_ports MXL_MGAIN_STB]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS18} [get_ports {MXL_MGAIN_DATA[0]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS18} [get_ports {MXL_MGAIN_DATA[1]}]

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS18} [get_ports MXL_RSSI_CLK]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS18} [get_ports MXL_RSSI_STB]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS18} [get_ports MXL_RSSI_DATA]

set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS18} [get_ports MXL_TX_FAULT]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS18} [get_ports MXL_INTR]

set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS18} [get_ports MXL_IO1]
#set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS18} [get_ports MXL_IO5]


set_property IOSTANDARD LVDS [get_ports JESD_SYS_REF_P]
#set_property DIFF_TERM_ADV TERM_100 [get_ports JESD_SYS_REF_P]
set_property PACKAGE_PIN G17 [get_ports JESD_SYS_REF_P]
set_property PACKAGE_PIN F17 [get_ports JESD_SYS_REF_N]
set_property IOSTANDARD LVDS [get_ports JESD_SYS_REF_N]
#set_property DIFF_TERM_ADV TERM_100 [get_ports JESD_SYS_REF_N]

#set_property -dict  {PACKAGE_PIN M17  IOSTANDARD LVCMOS18} [get_ports JESD_RX_SYNC]
#set_property -dict  {PACKAGE_PIN L17  IOSTANDARD LVCMOS18} [get_ports JESD_TX_SYNC]



set_property -dict {PACKAGE_PIN BB15 IOSTANDARD LVCMOS18} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN BA15 IOSTANDARD LVCMOS18} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN AW16 IOSTANDARD LVCMOS18} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN AW17 IOSTANDARD LVCMOS18} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN BB16 IOSTANDARD LVCMOS18} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN BA16 IOSTANDARD LVCMOS18} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN BA17 IOSTANDARD LVCMOS18} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN AY17 IOSTANDARD LVCMOS18} [get_ports {LED[7]}]




