read_verilog "main.v"
read_verilog ../../005-button_modes/button_modes.v

read_xdc "pinout.xdc"
set_property PROCESSING_ORDER EARLY [get_files pinout.xdc]

# synth
synth_design -top "top" -part "xc7a100tcsg324-1"

# place and route
opt_design
place_design

route_design

# write bitstream
write_bitstream -force "./build/out.bit"