@ echo off
title This is batch script to create .qip by calling q2_make_qip.tcl
echo Start creating .qip ...
cd \
rem  type a full path to the folder which contains "make_qip.bat", "q2_make_qip.tcl" and files of sources: *.sv, *.svh, *.v, *.sdc, *.vhd, *.vhdl, *.tdf, *.qip
cd C:\Users\admin\Documents\github\hdl\FPGA_STD_LIBRARY\comb_gates
rem  type a full path to "quartus_sh.exe" file which located in the folder ...\quartus\bin64
C:\intelFPGA\18.1\quartus\bin64\quartus_sh.exe -t q2_make_qip.tcl
pause

