onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib xCORE_CPRI_RUn77_RE_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {xCORE_CPRI_RUn77_RE.udo}

run 1000ns

quit -force
