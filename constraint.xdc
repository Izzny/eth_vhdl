## Optimized Constraints for Ethernet on Arty A7-100T

# Clock signal (Moved to match RX/TX clocks)
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

# Reset Signal (Commented out until correct pin is verified)
# set_property -dict { PACKAGE_PIN C3    IOSTANDARD LVCMOS33 } [get_ports { rst }];

# Ethernet RX Interface
set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { rx_clk }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { rx_dv }];
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { rx_data[0] }];
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { rx_data[1] }];
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { rx_data[2] }];
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { rx_data[3] }];

# Ethernet TX Interface
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { tx_clk }];
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { tx_en }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { tx_data[0] }];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { tx_data[1] }];
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { tx_data[2] }];
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { tx_data[3] }];

# Valid Frame Output (Moved to match TX signals)
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { valid_frame }];

# Allow Packet Output (Moved to match TX signals)
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { allow_packet }];

# Debug Output for Frame Data (Disabled temporarily)
# set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { frame_data_debug }];

# Input Delay Constraints to Help Clock Placement
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.5 [get_ports rx_clk]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.5 [get_ports tx_clk]
