#!/bin/bash
DIR=""


python3 /parquet_pipeline/preprocessing/extract_root.py $DIR/Tree_detector APTS_OPAMP --multiple_files 
python3 /parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/PixelCharge_extractedROOT_8.parquet --input-type charge --show-peak
python3 /parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/PixelCharge_extractedROOT_9.parquet --input-type charge --show-peak
python3 /parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/PixelCharge_extractedROOT_10.parquet --input-type charge --show-peak
python3 /parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/PixelCharge_extractedROOT_11.parquet --input-type charge --show-peak

# #######check whats in it#######
# # python3 /parquet_pipeline/inspect_parquet.py $DIR/parquet/PixelPulse_extractedROOT_0.parquet



