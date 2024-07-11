%% CODE TO PERFORM TIME-RESOLVED MVPA ANALYSIS

%% MVPAlab TOOLBOX - (mvpa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

clear all; clc;
%% Initialize project and run configuration file:

addpath(genpath('Z:/paula/toolbox/mvpalab-master'));  % path to mvpalab
addpath(genpath('Z:/paula/toolbox/eeglab2022.1')); % path to eeglab

cfg = mvpalab_init();

% Select variable to perform the analysis on: 
var = 1; % (1) Task Demand, (2) Targt Category, (3) Target Relevant Feature

run cfg_mvpa_time_res; 

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:

[result,cfg] = mvpalab_mvpa(cfg,fv);

%% Compute permutation maps and run statistical analysis:
[permaps,cfg] = mvpalab_permaps(cfg,fv);

stats = mvpalab_permtest(cfg,result,permaps);

%% Save cfg file:

mvpalab_savecfg(cfg);

%% Plot the results, FIGURE 3A
% To plot when all 3 MVPA analysis for each variable have been done

 run plot_mvpa_time_res;

