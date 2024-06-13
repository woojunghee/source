-makelib xcelium_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/gtwizard_ultrascale_v1_7_15 \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_bit_sync.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gte4_drp_arb.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_delay_powergood.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_delay_powergood.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cpll_cal.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cal_freqcnt.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_rx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_tx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cal_freqcnt.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_rx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_tx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cal_freqcnt.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_rx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_tx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_reset.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_rx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_tx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_rx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_tx.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_sync.v" \
  "../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_inv_sync.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/gtwizard_ultrascale_v1_7_gtye4_channel.v" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtye4_channel_wrapper.v" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtwizard_gtye4.v" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtwizard_top.v" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt.v" \
-endlib
-makelib xcelium_lib/ecc_v2_0_13 \
  "../../../ipstatic/hdl/ecc_v2_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fc32_rs_fec_v1_0_23 \
  "../../../ipstatic/hdl/fc32_rs_fec_v1_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_1/sim/xCORE_CPRI_RUn77_REC_fc32_rs_fec.v" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/xCORE_CPRI_RUn77_REC_block.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_reset_synchronizer.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_synchronizer.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/axi/xCORE_CPRI_RUn77_REC_axi_lite_ipif_wrapper.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_watchdog.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/xCORE_CPRI_RUn77_REC_drp_arbiter.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_block_sync_sm.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_gt_and_clocks.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_speed_change.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_support.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_resets.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_clocking.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_tx_alignment.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/xCORE_CPRI_RUn77_REC/example_design/gtwizard_ultrascale_v1_7_gtye4_common.v" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/xCORE_CPRI_RUn77_REC/example_design/xCORE_CPRI_RUn77_REC_gt_common.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_gt_gtye4_common_wrapper.vhd" \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_tx_sync.vhd" \
-endlib
-makelib xcelium_lib/cpri_v8_11_14 \
  "../../../ipstatic/hdl/cpri_v8_11_rfs.vhd" \
-endlib
-makelib xcelium_lib/cpri_v8_11_14 -sv \
  "../../../ipstatic/hdl/cpri_v8_11_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/xCORE_CPRI_RUn77_REC.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

