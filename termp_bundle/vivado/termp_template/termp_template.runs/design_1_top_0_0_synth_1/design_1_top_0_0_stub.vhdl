-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sun Feb 18 18:42:06 2024
-- Host        : LeeJaePyeong-DESKTOP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_top_0_0_stub.vhdl
-- Design      : design_1_top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    start_i : in STD_LOGIC;
    run_o : out STD_LOGIC;
    done_o : out STD_LOGIC;
    done_led_o : out STD_LOGIC;
    ram_addr_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ram_dout_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ram_en_o : out STD_LOGIC;
    ram_wr_en_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    test_us_data : out STD_LOGIC_VECTOR ( 23 downto 0 );
    test_us_data_valid : out STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst_n,start_i,run_o,done_o,done_led_o,ram_addr_o[31:0],ram_dout_o[31:0],ram_en_o,ram_wr_en_o[3:0],test_us_data[23:0],test_us_data_valid";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "top,Vivado 2019.1";
begin
end;
