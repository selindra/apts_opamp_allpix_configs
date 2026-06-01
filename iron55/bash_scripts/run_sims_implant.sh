#!/bin/bash
CONFIG="simulation_iron55.conf"
OUTPUT_DIR=""
NRUNS=4 # Number of runs
MESH=
DET=(detector8 detector9 detector10 detector11)
P=0 # Starting point for runs
for ((N=0; N<NRUNS; N++)); do
    NP=$((N + P))
    echo "=== Running AllPix iteration $NP ==="
    /allpix-squared/bin/allpix -c "$CONFIG" \
        -o number_of_events=10000 \
        -o output_directory="$OUTPUT_DIR" \
        -o root_file="plots_${DET[$N]}.root" \
        -o DopingProfileReader.file_name="${MESH}_DopingConcentration.apf" \
        -o ElectricFieldReader.file_name="${MESH}_ElectricField.apf"\
        -o WeightingPotentialReader.file_name="./wp_calc/${MESH}.init" \
        -o ROOTObjectWriter.file_name="Tree_${DET[$N]}.root" \
        -o detectors_file="${DET[$N]}.conf"

    
    # Check if run succeeded
    if [[ $? -ne 0 ]]; then
        echo "❌ Run $NP failed!"
    else
        echo "✅ Run $NP completed successfully."
    fi
    done