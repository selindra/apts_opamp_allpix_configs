

######for tcad to grd-dat conversion use this at tcad server: 
######tdx -dd -M 0 -S 0 /data/alice/mselina/tcad_alpide/3d/blancket_for_aptsoa12nov/results/nodes/317/n317_des.tdr sub1e19_gap_65nm_3D_4_8V_0_4V_thick25_pitch10_blancket_for_aptsoa12nov_bl3_5
######tdx -dd -M 0 -S 0 /data/alice/mselina/tcad_alpide/3d/blancket_for_aptsoa12nov/results/nodes/320/n320_wfield.tdr wp_sub1e19_gap_65nm_3D_4_8V_0_4V_thick25_pitch10_blancket_for_aptsoa12nov_bl3_5
#########Change the dat/grd file name accordingly

DIR=
DIRWP=
source /cvmfs/clicdp.cern.ch/software/allpix-squared/latest/x86_64-el9-clang16-opt/setup.sh 
mesh_converter -c convert.conf -f $DIR
mesh_converter -c dop_convert.conf -f $DIR
mesh_converter -c ./wp_calc/wp_calc_convert.conf -f $DIR
mesh_converter -c ./wp_calc/wp_calc_convert.conf -f $DIRWP 
python3 ./wp_calc/calc.py "${DIR}_ElectrostaticPotential.init" "${DIRWP}_ElectrostaticPotential.init"
mesh_plotter -f ${DIR}_ElectricField.apf
mesh_plotter -f ${DIR}_DopingConcentration.apf -s
mesh_plotter -f wp_${DIR}_ElectrostaticPotential.init -s

