vlib work
vlib riviera

vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/gtwizard_ultrascale_v1_7_15
vlib riviera/xil_defaultlib
vlib riviera/ecc_v2_0_13
vlib riviera/fc32_rs_fec_v1_0_23
vlib riviera/axi_lite_ipif_v3_0_4
vlib riviera/cpri_v8_11_14

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap gtwizard_ultrascale_v1_7_15 riviera/gtwizard_ultrascale_v1_7_15
vmap xil_defaultlib riviera/xil_defaultlib
vmap ecc_v2_0_13 riviera/ecc_v2_0_13
vmap fc32_rs_fec_v1_0_23 riviera/fc32_rs_fec_v1_0_23
vmap axi_lite_ipif_v3_0_4 riviera/axi_lite_ipif_v3_0_4
vmap cpri_v8_11_14 riviera/cpri_v8_11_14

vlog -work xilinx_vip  -sv2k12 "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work gtwizard_ultrascale_v1_7_15  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
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

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/gtwizard_ultrascale_v1_7_gtye4_channel.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtye4_channel_wrapper.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtwizard_gtye4.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt_gtwizard_top.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_0/sim/xCORE_CPRI_RUn77_REC_gt.v" \

vlog -work ecc_v2_0_13  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/ecc_v2_0_vl_rfs.v" \

vlog -work fc32_rs_fec_v1_0_23  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/fc32_rs_fec_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/ip_1/sim/xCORE_CPRI_RUn77_REC_fc32_rs_fec.v" \

vcom -work axi_lite_ipif_v3_0_4 -93  \
"../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
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

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/xCORE_CPRI_RUn77_REC/example_design/gtwizard_ultrascale_v1_7_gtye4_common.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/xCORE_CPRI_RUn77_REC/example_design/xCORE_CPRI_RUn77_REC_gt_common.v" \

vcom -work xil_defaultlib -93  \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_gt_gtye4_common_wrapper.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_REC_tx_sync.vhd" \

vcom -work cpri_v8_11_14 -93  \
"../../../ipstatic/hdl/cpri_v8_11_rfs.vhd" \

vlog -work cpri_v8_11_14  -sv2k12 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/cpri_v8_11_rfs.sv" \

vcom -work xil_defaultlib -93  \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_REC/synth/xCORE_CPRI_RUn77_REC.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

