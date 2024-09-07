#Buttons
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { start_button }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]

#LEDs
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { done_led }]; #IO_L23P_T3_35 Sch=led[0]