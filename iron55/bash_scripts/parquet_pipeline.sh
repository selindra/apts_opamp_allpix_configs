#!/bin/bash
DIR=""

python3  parquet_pipeline/preprocessing/extract_root.py $DIR/Tree.root APTS_OPAMP --multiple_files #--process_batch -bi 41 -bs 18
python3  parquet_pipeline/preprocessing/merge_parquet.py $DIR/parquet/
python3  parquet_pipeline/preprocessing/extract_seed_pixel_data.py --input $DIR/parquet/merged/PixelPulse_merged.parquet

#######check whats in it#######
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/pdata/leading_edge_all.parquet
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/DepositedCharge_merged.parquet
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/PixelHit_merged.parquet
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/pdata/cluster_size_gt1_central.parquet
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/pdata/seed_pixels.parquet
# python3  parquet_pipeline/inspect_parquet.py $DIR/parquet/merged/pdata/leading_edge_all_waveform.parquet

##########Analysis###########

python3  parquet_pipeline/analysis/calibration.py --pdata-dir $DIR/parquet/merged/pdata/
python3  parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/merged/PixelPulse_merged.parquet --input-type pulse
python3  parquet_pipeline/analysis/pixel_amplitude_hist.py $DIR/parquet/merged/PixelCharge_merged.parquet --input-type charge

python3  parquet_pipeline/analysis/leading_edge_extract.py --pdata-dir $DIR/parquet/merged/pdata/ 
python3  parquet_pipeline/analysis/leading_edge_plot.py --pdata-dir $DIR/parquet/merged/pdata/
python3  parquet_pipeline/analysis/deposition_map_vs_falltime.py $DIR/parquet/merged/DepositedCharge_merged.parquet
python3  parquet_pipeline/analysis/cluster_size.py $DIR/parquet/merged/pdata/leading_edge_all_waveform.parquet

python3  parquet_pipeline/plot_waveforms_range.py --file $DIR/parquet/merged/pdata/cluster_size1.parquet
