read_verilog "main.v"
read_verilog ../../008-simple_clock/simple_clock.v
read_verilog ../../008-simple_clock/decoder.v
read_verilog ../../008-simple_clock/seg_multiplexer.v
read_verilog ../../008-simple_clock/bin_to_bcd.v

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