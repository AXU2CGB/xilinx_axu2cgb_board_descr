set_property PACKAGE_PIN AB13 [get_ports {led[3]}]
set_property PACKAGE_PIN AA12 [get_ports {led[2]}]
set_property PACKAGE_PIN Y12 [get_ports {led[1]}]
set_property PACKAGE_PIN W13 [get_ports {led[0]}]
set_property PACKAGE_PIN AA13 [get_ports rst_n]
set_property PACKAGE_PIN AB11 [get_ports sys_clk]

set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

create_clock -period 40.000 -name sys_clk -waveform {0.000 20.000} -add [get_ports sys_clk]

