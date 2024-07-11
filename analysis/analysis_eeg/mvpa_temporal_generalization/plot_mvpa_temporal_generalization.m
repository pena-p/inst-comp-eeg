%% PLOT TEMPORAL GENERALIZATION MATRICES
% FIGURE 3B

clear all;
clc;

%% Initialize and configure plots:
addpath(genpath('Z:/paula/toolbox/mvpalab-master'))
graph = mvpalab_plotinit();
load('new_color_map.mat'); % in this folder

%% Set graph parameters
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_demand/results/temporal_generalization/auc/result.mat') % for the cfg file
clear result;

% Colors:
graph.colorMap = new_color_map;
graph.colors = new_color_map;


% Axis limits:
graph.xlim = [0 cfg.tm.tpend_];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .60];
graph.onscreen = [0 190];
graph.fontsize = 15;

% Axes labels and titles:
graph.xlabel = 'Test (ms)';
graph.ylabel = 'Train (ms)';

% Colors:
graph.colorMap = new_color_map;
graph.colors = new_color_map;
graph.clusterLineColor = 'k';


% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Significant indicator:
graph.sigh = .4;

% Mean accuracy plot (statistical significance)
%% Task Demand
% Load results and and statistics if needed:
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_demand/results/temporal_generalization/auc/result.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_demand/results/temporal_generalization/auc/stats.mat')

% Title:
graph.title = '';

% Plot results:
figure(1);
hold on;
set(gcf,'color','w');
mvpalab_plottempogen(graph,cfg,result,stats);
axis square; box on; colorbar;
hold off;

%% Target Category
% Load results and and statistics if needed:
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_category/results/temporal_generalization/auc/result.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_category/results/temporal_generalization/auc/stats.mat')

% Title:
graph.title = '';

% Plot results:
figure(2);
hold on;
set(gcf,'color','w');
mvpalab_plottempogen(graph,cfg,result,stats);
axis square; box on;
hold off;

%% Target Relevant Feature 
% Load results and and statistics if needed:
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_feature/results/temporal_generalization/auc/result.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_feature/results/temporal_generalization/auc/stats.mat')

% Title:
graph.title = '';

% Plot results:
figure(3);
hold on;
set(gcf,'color','w');
mvpalab_plottempogen(graph,cfg,result,stats);
axis square; box on;
hold off;
