# EEG ANALSYSIS
This folder contains the scripts to perform each EEG analysis.  

**Notes:** 
 - The pre-processing of the EEG data needs to be done beforehand (see "preproc_eeg" in "preproc" folder).
 - You will need to to download the mvpalab toolbox (https://github.com/dlopezg/mvpalab)

# To perform the analysis of:

### Representational Similarit Analysis (RSA) of the 3 main task components time-wise:
 - Go to the "rsa_time" folder inside the "RSA" folder.
 - Run the script RSA_time.m
 - All the functions used are inside the "src" folder, as well as the configuration file (cfg_rsa.m).
 - To obtain the plot of figure 2D, you can run the script rsa_plot.m
 - To obtain figure 2A of the theoretical models, run plot_model_rsa.m within the "RSA" folder
 - To obtain the figure 2B of the neural RDM, run plot_examples_neural_MDS.m within the "RSA" folder.
 
### RSA of the 3 main task components per channel (orientative):
 - Go to the "rsa_channels" folder inside the "RSA" folder.
 - Run the script RSA_channels.m
 - All the functions used are inside the "src" folder, as well as the    configuration file (cfg_rsa.m).
 - To obtain the plot of figure 2C, you can run the script rsa_plot.m
 
### Time-resolved Multivariate Pattern Analysis (MVPA):
 - Go to the "mvpa_time_resolved" folder.
 - Run the script decoding_mvpa_time_res.m
 - The configuration file is called cfg_mvpa_time_res.m 
 - To obtain the plot of Figure 3A, run plot_mvpa_time_res.m

### Temporal Generalization Analysis:
 - Go to the "mvpa_temporal_generalization" folder.
 - Run the script decoding_mvpa_temporal_generalization.m
 - The configuration file is called cfg_mvpa_temporal_generalization.m 
 - To obtain the plot of Figure 3B, run plot_mvpa_temporal_generalization.m

### Cross-Condition Generalization Performance (CCGP) and Shattering Dimensionality (SD) analyses :
 - Go to the "CCGP_SD" folder.
 - Run the script ccgp_sd.m 
 - All the functions used are inside the "src" folder.
 - To plot the main results of CCGP (Figure 4B) and SD (Figure 5C and 5C) run the script plot_mvpa_ccgp_sd.m 
 - To plot the Supplementary Materials of this analyses run plot_per_dichot.m

### Temporal Generalization Analysis with Cross-classification:
 - Go to the "mvcc_temporal_generalization" folder.
 - Run the script decoding_mvcc_tempgen.m
 - The configuration file is called cfg_mvcc_tempgen.m 
 - To obtain the plot of Figure 4C, 4D, 4E, run plot_mvpcc_tempgen.m

### Geometry RSA:
 - Go to the "rsa_geometry" folder inside the "RSA" folder.
 - Run the script RSA_geom.m
 - All the functions used are inside the "src" folder, as well as the configuration file (cfg_rsa_geom.m).
 - To obtain the plot of figure 6D, you can run the script rsa_plot_geom.m
 - To obtain figure 6A of the theoretical models, run plot_model_rsa.m within the "RSA" folder
 - To obtain the figure 6B and 6C (neural RDM and MDS plots), run plot_examples_neural_MDS.m within the "RSA" folder.
