connect -url tcp:127.0.0.1:3121
source C:/Users/qwer/Desktop/DSD_2022/termp_bundle/vivado/termp_template/termp_template.sdk/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo Z7 210351B7BEACA"} -index 0
loadhw -hw C:/Users/qwer/Desktop/DSD_2022/termp_bundle/vivado/termp_template/termp_template.sdk/design_1_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo Z7 210351B7BEACA"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo Z7 210351B7BEACA"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo Z7 210351B7BEACA"} -index 0
dow C:/Users/qwer/Desktop/DSD_2022/termp_bundle/vivado/termp_template/termp_template.sdk/ds_us_run/Debug/ds_us_run.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo Z7 210351B7BEACA"} -index 0
con
