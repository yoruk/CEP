#!/bin/sh
# file: implement.sh

#-----------------------------------------------------------------------------
# Script to synthesize and implement the RTL provided for the clocking wizard
#-----------------------------------------------------------------------------

# Clean up the results directory
rm -rf results
mkdir results

# Copy unisim_comp.v file to results directory
cp $XILINX/verilog/src/iSE/unisim_comp.v ./results/

# Synthesize the Verilog Wrapper Files
echo 'Synthesizing Clocking Wizard design with XST'
xst -ifn xst.scr
cp clk_wiz_v1_8_exdes.ngc results/

#  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../clk_wiz_v1_8.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -uc clk_wiz_v1_8.ucf clk_wiz_v1_8_exdes

echo 'Running map'
map -timing clk_wiz_v1_8_exdes -o mapped.ncd

echo 'Running par'
par -w mapped.ncd routed mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level model for the clocking wizard example design'
netgen -ofmt vhdl -sim -tm clk_wiz_v1_8_exdes -w routed.ncd routed.vhd
cd ..
