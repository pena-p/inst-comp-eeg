%% MVPA TOOLBOX - (cr_analysis.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: % cgpenalver@ugr.es (Chema G. Peñalver)

% All code has been adapted from the "rsa_time analyses" scripts on Peñalver et
% al.(2023) by Paula Pena ( paulapena@ugr.es) to use cross-validated
% Pearson (1 - r) as distance measure
% -------------------------------------------------------------------------
% clear all;
% clc;

%% Initialize project and configure analysis:
addpath ('src/');
addpath(genpath('Z:/paula/toolbox/mvpalab-master/')) % path to toolbox
addpath(genpath('Z:/paula/toolbox/eeglab-eeglab2022.1/')); % path to eeglab, mvpalab uses it

cfg = mvpalab_init(); % mvpalab toobox. Importing is made through it. 
run cfg_rsa_geom.m; % modified from mvpa scripts, may have irrelevant info. 

%% Load data, generate conditions, feature extraction and RDMs:
[cfg,data,fv] = mvpalab_import_rsa_geom(cfg);
run RSA_cv_pearson_geom % Generates RDMs

%% Compute multiple linear regression: correct rate and permuted maps:
 
[~, betas, tvalues, cfg] = rsa_ModelComp_geom(cfg,fv,RDMs,0,'content'); %compare to other RDMs (theoretical, empirical...)

[~, permuted_betas, permuted_tvalues, cfg] = rsa_ModelComp_perm_geom(cfg,fv,RDMs,1,'complete'); %run permutations for statistical analyses
 
%% Save results
if ~exist(cfg.location, 'dir')
    mkdir (cfg.location);
end
save([cfg.location filesep 'result'], 'tvalues', 'cfg','RDMs', 'permuted_tvalues');

%% Run statistical analysis:
if cfg.classmodel.regress
    %1 = parallel, 2 = orthogonal
    result = tvalues(1,:,:);    %tvalues parallel model
    permuted_maps = permuted_tvalues(1,:,:,:); %cluster based permutations
    stats.model1.tvalues = permtest_rsa_geom(cfg,result,permuted_maps);
    result = tvalues(2,:,:);    %tvalues orthogonal model
    permuted_maps = permuted_tvalues(2,:,:,:);
    stats.model2.tvalues = permtest_rsa_geom(cfg,result,permuted_maps);
end

%% Save stats:
save([cfg.location filesep 'stats'], 'cfg', 'stats');%'stats'

%% Plot results - Figure 6

run rsa_plot_geom.m
