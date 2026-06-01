
DIR=""

TRH=100
EXP=/simulation-analysis-software/experimental_dataset.csv

/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Processing/ROOT_data_extraction.py $DIR/Tree_ APTS_OPAMP --multiple_files --log #--process_batch --batch_size 70 --batch_index 153
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Processing/clusterization.py $DIR/data_extraction -cthrk el --voltage_to_charge_conversion_factor 3 --clusterization_threshold_value $TRH
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Processing/seed_pixel_signal_processing.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/


/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/time_residuals_plot.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/preliminary_analysis.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/signal_charge_vs_fall_time_10_50_2D_hist_plot.py $DIR/data_extraction/no_charge_calibrated_clusterization_threshold_${TRH}_mV/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/time_residuals_distribution_shape_study.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/CFD10_hitmap.py $DIR/data_extraction/


/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/QA/display_waveforms.py $DIR/Tree_1.root APTS_OPAMP 50 -np 4000

# ######Comparizon
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/cluster_charge_distribution_comparison.py -do $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv -de $EXP
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/cluster_size_distribution_comparison.py -do $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv -de $EXP
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/time_residuals_distribution_shape_study_langauss_compar_normalized.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_100_e/simulation.csv --file_in2 $EXP -trb 0.02 --label2 "Experimental data"
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/time_residuals_comparison_new_model.py -dsn $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv -de $EXP -ds /data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/dataset_5ps_propagation_timestep_180ps_rise_time_constant.csv
#/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/inpixel_time_resolution.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/inpixel_time_residuals_and_cluster_size.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv -de $EXP
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/signal_charge_vs_fall_time_10_50_2D_hist_plot.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv
/data/alice/mselina/allpix_installation/allpix-squared/workdir/simulation-analysis-software/AllPix2/pixel_detector/Analysis/inpixel_time_resolution_smearing.py $DIR/data_extraction/charge_calibrated_clusterization_threshold_${TRH}_e/simulation.csv -de $EXP
