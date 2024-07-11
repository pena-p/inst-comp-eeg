%% MVPA TOOLBOX 
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: % cgpenalver@ugr.es (Chema G. Peñalver)

% All code has been adapted from the "rsa_time analyses" scripts on Peñalver et
% al.(2023) by Paula Pena ( paulapena@ugr.es)
% -------------------------------------------------------------------------
clear

%% Initialize project and configure analysis:
addpath ('src/');
addpath(genpath('Z:/paula/toolbox/eeglab-eeglab2022.1'));
addpath(genpath('Z:/paula/toolbox/mvpalab-master'));


cfg = mvpalab_init(); % mvpalab toobox. Importing is made through it. 
run cfg_rsa.m; % modified from mvpa scripts, may have irrelevant info. 

%% Load data, generate conditions, feature extraction and RDMs:
[cfg,data,fv] = mvpalab_import_rsa(cfg);
run RSA_cv_pearson % Generates RDMs

%% Compute correct rate and permuted maps:
[~, betas, tvalues, cfg] = rsa_ModelComp(cfg,fv,RDMs,0,'content'); %compare to other RDMs (theoretical, empirical...)
[~, permuted_betas, permuted_tvalues, cfg] = rsa_ModelComp_perm(cfg,fv,RDMs,1,'complete'); %run permutations for statistical analyses

%% Save results
if ~exist(cfg.location, 'dir')
    mkdir(cfg.location);
end
save([cfg.location '/result'], 'tvalues', 'permuted_tvalues', 'RDMs', 'cfg');

%% Run statistical analysis:

if cfg.classmodel.regress
    % 1 = demand, 2 = category, 3 = feature
    result = tvalues(1,:,:);   %tvalues demand model
    permuted_maps = permuted_tvalues(1,:,:,:); %cluster based permutations
    stats.model1.tvalues = permtest_rsa(cfg,result,permuted_maps);
    result = tvalues(2,:,:);    %tvalues category model
    permuted_maps = permuted_tvalues(2,:,:,:);
    stats.model2.tvalues = permtest_rsa(cfg,result,permuted_maps);
    result = tvalues(3,:,:);    %tvalues feature model
    permuted_maps = permuted_tvalues(3,:,:,:);
    stats.model3.tvalues = permtest_rsa(cfg,result,permuted_maps);
end

%% Save stats:

save([cfg.location '/stats'],'cfg', 'stats');%'stats'

%% Plot results - Figure 2D

run rsa_plot.m
