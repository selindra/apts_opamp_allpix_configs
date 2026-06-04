# APTS OPAMP Allpix² Workflow

Allpix² simulation workflows for APTS_OPAMP monolithic pixel sensors, including Fe-55 X-ray source simulations, test-beam (120 GeV π⁺) simulations, TCAD field conversion, weighting potential calculation, and test-beam analysis.

## Overview

This repository is a working analysis/configuration bundle for running Allpix² simulations with external TCAD-derived fields and post-processing scripts. It is organized around four practical tasks: detector geometry definitions, Fe-55 studies, test-beam studies, and TCAD/weighting-potential preprocessing.

| Area | Purpose |
|------|---------|
| `detector_configs/` | Defines APTS_OPAMP detector models and detector placement files.|
| `iron55/` | Runs Fe-55 source simulations and a Parquet-based pulse/charge analysis pipeline.|
| `test_beam/` | Runs pion beam simulations and downstream comparison to experimental data.|
| `tcadfields_configs/` | Converts TCAD meshes into Allpix²-readable field maps.|
| `wp_calculation/` | Inspects and computes weighting-potential `.init` files.|

```text
.
├── README.md
├── detector_configs/
├── iron55/
│   ├── allpix_configs/
│   └── bash_scripts/
├── tcadfields_configs/
├── test_beam/
│   ├── allpix_configs/
│   └── bash_scripts/
└── wp_calculation/
```

## Detector configs: different implant definition 

The detector models are all monolithic pixel sensors with `geometry = "pixel"`, `number_of_pixels = 4 4`, `pixel_size = 10um 10um`, and `sensor_thickness = 25um`.   The four variants differ by implant dimensions, as described in the dissertation while the companion `detector*.conf` files instantiate the chosen model as `APTS_OPAMP`.  

| Model | Implant size |
|------|--------------|
| `APTS_OPAMP8` | `1.2um 1.2um 1.2um`   |
| `APTS_OPAMP9` | `1.4um 1.4um 1.2um`   |
| `APTS_OPAMP10` | `1.6um 1.6um 1.4um`   |
| `APTS_OPAMP11` | `1.5um 1.5um 1.3um`   |

## Fe-55 flow

The Fe-55 workflow lives under `iron55/` and uses a Geant4 macro with two gamma lines, 5.9 keV and 6.5 keV, to simulate source illumination for calibration-style studies. The GIF-oriented variant turns on propagation plots, linegraphs, and animations and shortens integration to 1.5 ns for visualization-focused runs.  

`iron55/bash_scripts/run_sims.sh` is a batch launcher that repeats the simulation n times for statiscts, overriding the mesh filenames and output ROOT filenames from the command line.   In practice, you set `CONFIG`, `OUTPUT_DIR`, and `MESH`, then the script runs `allpix` with `DopingProfileReader.file_name`, `ElectricFieldReader.file_name`, `WeightingPotentialReader.file_name`, and `ROOTObjectWriter.file_name` overrides for each iteration.  

`iron55/bash_scripts/parquet_pipeline.sh` is the downstream analysis pipeline, but it depends on an external `parquet_pipeline` codebase that can be found in [this repo](https://github.com/selindra/parquet_pipeline).

## Test-beam flow

The test-beam workflow simulates a 120 GeV `pi+` to mimic detailed SPS-like beam conditions. 

`test_beam/bash_scripts/run_sims_efficiency.sh` performs a threshold scan across 17 values from `-3.375 mV` down to `-21.375 mV`, changing `CSADigitizer.threshold` run by run, for efficiency and cluster size studies as a function threshold.

`test_beam/bash_scripts/analysis.sh` is not self-contained: it calls many scripts from [this repo](https://gitlab.nikhef.nl/rrusso/simulation-analysis-software).   Functionally, it extracts ROOT data, clusterizes it, processes seed-pixel signals, produces residual and charge/fall-time studies, and compares simulation against an experimental CSV dataset.  

The two text files in `test_beam/` are the reference datasets for efficiency-vs-threshold and spatial-resolution studies for the experimental data for comparison.

## TCAD conversion

The `tcadfields_configs/` directory provides `mesh_converter` configuration files for converting TCAD outputs into Allpix²-readable field maps.   `convert.conf` targets `ElectricField`, `dop_convert.conf` targets `DopingConcentration`.

`convert_script.sh` contains the upstream Sentaurus `tdx` conversion fields from `.tdr` files to `.dat/.grd` and runs `mesh_converter` plus `mesh_plotter`. 

## Weighting potential


The `wp_calculation/` folder contains two small Python utilities for `.init` files.   `preview_init.py` previews the first lines of an `.init` file and reports simple column statistics, `wp_calc_convert.conf` performs `.dat/.grd` fields conversion to perfom weighting-potential calculation. And `calc.py` loads two `.init` files with 0.1V difference in biasing, checks grid consistency, subtracts the fourth column as `(data1 - data2) / 0.1V`, flags out-of-range values, and writes a new output file.  


## How it works end to end

A typical end-to-end usage pattern is: generate TCAD results externally, convert them into `.apf` maps with `mesh_converter`, prepare a weighting-potential `.init` file, choose a detector config, run Allpix² either for Fe-55 or beam conditions, and then analyze the produced ROOT data with external scripts.   The repository therefore acts mainly as a glue layer between TCAD, Allpix², and a separate analysis framework.  

## Suggested usage notes

Fill in all empty path variables in the bash scripts and update hard-coded absolute paths to your local environment.   It is also worth documenting where the external `simulation-analysis-software` and `parquet_pipeline` repositories live, because this repo depends on them for most post-processing.  
