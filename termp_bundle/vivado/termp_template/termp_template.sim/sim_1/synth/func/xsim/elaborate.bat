@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Sat Feb 17 13:35:52 +0900 2024
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 182c30917785468187287a04a66ad414 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L secureip --snapshot tb_top_func_synth xil_defaultlib.tb_top xil_defaultlib.glbl -log elaborate.log"
call xelab  -wto 182c30917785468187287a04a66ad414 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L secureip --snapshot tb_top_func_synth xil_defaultlib.tb_top xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
