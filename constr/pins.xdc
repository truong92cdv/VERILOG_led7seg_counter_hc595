set_property PACKAGE_PIN A8 [get_ports {rst_n}]
set_property PACKAGE_PIN F7 [get_ports {SER}]
set_property PACKAGE_PIN F8 [get_ports {SRCLK}]
set_property PACKAGE_PIN D6 [get_ports {RCLK}]

set_property IOSTANDARD LVCMOS18 [get_ports {rst_n}]
set_property IOSTANDARD LVCMOS18 [get_ports {SER}]
set_property IOSTANDARD LVCMOS18 [get_ports {SRCLK}]
set_property IOSTANDARD LVCMOS18 [get_ports {RCLK}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rst_n]