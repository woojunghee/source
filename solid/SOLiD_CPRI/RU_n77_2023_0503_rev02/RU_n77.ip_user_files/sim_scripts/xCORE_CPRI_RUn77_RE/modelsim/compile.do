vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/gtwizard_ultrascale_v1_7_15
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/ecc_v2_0_13
vlib modelsim_lib/msim/fc32_rs_fec_v1_0_23
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/cpri_v8_11_14

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap gtwizard_ultrascale_v1_7_15 modelsim_lib/msim/gtwizard_ultrascale_v1_7_15
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap ecc_v2_0_13 modelsim_lib/msim/ecc_v2_0_13
vmap fc32_rs_fec_v1_0_23 modelsim_lib/msim/fc32_rs_fec_v1_0_23
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap cpri_v8_11_14 modelsim_lib/msim/cpri_v8_11_14

vlog -work xilinx_vip  -incr -mfcu  -sv -L cpri_v8_11_14 "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L cpri_v8_11_14 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work gtwizard_ultrascale_v1_7_15  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
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

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_0/sim/gtwizard_ultrascale_v1_7_gtye4_channel.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_0/sim/xCORE_CPRI_RUn77_RE_gt_gtye4_channel_wrapper.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_0/sim/xCORE_CPRI_RUn77_RE_gt_gtwizard_gtye4.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_0/sim/xCORE_CPRI_RUn77_RE_gt_gtwizard_top.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_0/sim/xCORE_CPRI_RUn77_RE_gt.v" \

vlog -work ecc_v2_0_13  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/ecc_v2_0_vl_rfs.v" \

vlog -work fc32_rs_fec_v1_0_23  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/fc32_rs_fec_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/ip_1/sim/xCORE_CPRI_RUn77_RE_fc32_rs_fec.v" \

vcom -work axi_lite_ipif_v3_0_4  -93  \
"../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/xCORE_CPRI_RUn77_RE_block.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_reset_synchronizer.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_synchronizer.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/axi/xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_watchdog.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/xCORE_CPRI_RUn77_RE_drp_arbiter.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_block_sync_sm.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_gt_and_clocks.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_speed_change.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_support.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_resets.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_clocking.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_tx_alignment.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/xCORE_CPRI_RUn77_RE/example_design/gtwizard_ultrascale_v1_7_gtye4_common.v" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/xCORE_CPRI_RUn77_RE/example_design/xCORE_CPRI_RUn77_RE_gt_common.v" \

vcom -work xil_defaultlib  -93  \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_gt_gtye4_common_wrapper.vhd" \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/gtye4_and_clocks/xCORE_CPRI_RUn77_RE_tx_sync.vhd" \

vcom -work cpri_v8_11_14  -93  \
"../../../ipstatic/hdl/cpri_v8_11_rfs.vhd" \

vlog -work cpri_v8_11_14  -incr -mfcu  -sv -L cpri_v8_11_14 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl_cpri_hard_fec" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/cpri_v8_11_rfs.sv" \

vcom -work xil_defaultlib  -93  \
"../../../../RU_n77.gen/sources_1/ip/xCORE_CPRI_RUn77_RE/synth/xCORE_CPRI_RUn77_RE.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

