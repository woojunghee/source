onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc "  -L xilinx_vip -L xpm -L gtwizard_ultrascale_v1_7_15 -L xil_defaultlib -L ecc_v2_0_13 -L fc32_rs_fec_v1_0_23 -L axi_lite_ipif_v3_0_4 -L cpri_v8_11_14 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.xCORE_CPRI_RUn77_RE xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {xCORE_CPRI_RUn77_RE.udo}

run 1000ns

quit -force
