#!/bin/bash
CONFIG="simulation_iron55.conf"
OUTPUT_DIR=""

NRUNS=70 # Number of runs
MESH=
P=0 # Starting number for runs
for ((N=0; N<NRUNS; N++)); do
    NP=$((N + P))
    echo "=== Running AllPix iteration $NP ==="
    allpix-squared/bin/allpix -c "$CONFIG" \
        -o output_directory="$OUTPUT_DIR" \
        -o root_file="plots_${NP}.root" \
        -o DopingProfileReader.file_name="${MESH}_DopingConcentration.apf" \
        -o ElectricFieldReader.file_name="${MESH}_ElectricField.apf"\
        -o WeightingPotentialReader.file_name="./wp_calc/{MESH}.init" \
        -o ROOTObjectWriter.file_name="Tree_${NP}.root" \
        -o detectors_file=""

    
    # Check if run succeeded
    if [[ $? -ne 0 ]]; then
        echo "❌ Run $NP failed!"
    else
        echo "✅ Run $NP completed successfully."
    fi
    done