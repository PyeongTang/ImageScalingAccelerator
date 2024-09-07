// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Feb 18 18:42:06 2024
// Host        : LeeJaePyeong-DESKTOP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_top_0_0_stub.v
// Design      : design_1_top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "top,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, rst_n, start_i, run_o, done_o, done_led_o, 
  ram_addr_o, ram_dout_o, ram_en_o, ram_wr_en_o, test_us_data, test_us_data_valid)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,start_i,run_o,done_o,done_led_o,ram_addr_o[31:0],ram_dout_o[31:0],ram_en_o,ram_wr_en_o[3:0],test_us_data[23:0],test_us_data_valid" */;
  input clk;
  input rst_n;
  input start_i;
  output run_o;
  output done_o;
  output done_led_o;
  output [31:0]ram_addr_o;
  output [31:0]ram_dout_o;
  output ram_en_o;
  output [3:0]ram_wr_en_o;
  output [23:0]test_us_data;
  output test_us_data_valid;
endmodule
