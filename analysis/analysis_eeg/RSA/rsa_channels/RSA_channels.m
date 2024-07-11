%% MVPA TOOLBOX - (cr_analysis.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: % cgpenalver@ugr.es (Chema G. Peñalver)

% All code has been adapted from the "rsa_time analyses" scripts on Peñalver et
% al.(2023) to perform RSA on every channel (time-points as features)
% -------------------------------------------------------------------------
clear all;

%% Initialize project and configure analysis:
addpath ('src/');
addpath(genpath('Z:/paula/toolbox/mvpalab-master'))
cfg = mvpalab_init(); % mvpalab toobox. Importing is made through it. 
run cfg_rsa.m; % modified from mvpa scripts, may have irrelevant info. 

%% Load data, generate conditions, feature extraction and RDMs:
[cfg,data,fv] = mvpalab_import_rsa(cfg);
run RSA_cv_pearson % Generates RDMs

%% Compute multiple linear regression:
 
[~, betas, tvalues, cfg] = rsa_ModelComp(cfg,fv,RDMs,0,'content'); %compare to other RDMs (theoretical, empirical...)

save([cfg.location '/result'], 'tvalues', 'betas', 'cfg', 'RDMs');%'stats'

%% Plot RSA-channels results - Figure 2C

run rsa_plot.m
