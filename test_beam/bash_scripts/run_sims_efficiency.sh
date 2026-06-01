#!/bin/bash
CONFIG="simulation_efficiency.conf"
OUTPUT_DIR=""
NRUNS=17 # Number of runs
MESH=blancket_for_aptsoa_corentin2_65nm_3D_4_8V_0_4V_thick25_pitch10_trycor1_node213
TRH=(-3.375 -4.5 -5.625 -6.75 -7.875 -9 -10.125 -11.25 -12.375 -13.5 -14.625 -15.75 -16.875 -18 -19.125 -20.25 -21.375)
P=0 # Starting point for runs
for ((N=0; N<NRUNS; N++)); do
    NP=$((N + P))
    echo "=== Running AllPix iteration $NP ==="
    /allpix-squared/bin/allpix -c "$CONFIG" \
        -o output_directory="$OUTPUT_DIR" \
        -o root_file="plots_${NP}_thr${TRH[N]}.root" \
        -o DopingProfileReader.file_name="${MESH}_DopingConcentration.apf" \
        -o ElectricFieldReader.file_name="${MESH}_ElectricField.apf"\
        -o WeightingPotentialReader.file_name="./wp_calc/${MESH}.init" \
        -o detectors_file=""\
        -o CSADigitizer.threshold="${TRH[N]}mV"

    # Check if run succeeded
    if [[ $? -ne 0 ]]; then
        echo "❌ Run $NP failed!"
    else
        echo "✅ Run $NP completed successfully."
    fi
    done