%% CODE TO PLOT GEOMETRY RSA RESULTS
% Figure 6D

%% Initialize and configure plots:
clear all;
clc;
addpath(genpath('Z:/paula/toolbox/mvpalab-master'));
graph = mvpalab_plotinit();

%% Load results: 
% Load results and and statistics if needed:
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_geometry/result.mat');
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_geometry/stats.mat');

%% Mean accuracy plot 

% Axis limits:
graph.xlim = [-170 7000];
 graph.ylim = [-1.5 2.2];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'T-values';
graph.title = '' ;
graph.fontsize = 17;

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 1.5;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;
graph.shadealpha = 0.3;
% Title:
graph.title = '';

% Plot results:
figure;
hold on ;
set(gcf,'Position', [144,365,883,387]);
set(gcf,'color','w');
result = tvalues(1,:,:); % parallel
stat = stats.model1.tvalues;
graph.shadecolor = 'g';
graph.sigc = 'g';
graph.sigh = 2.15;
rsa_plotcr_geom(graph,cfg,result, stat);

result = tvalues(2,:,:); % orthogonal
stat = stats.model2.tvalues;
graph.shadecolor = 'r';
graph.sigc = 'r';
graph.sigh = 2.0;
rsa_plotcr_geom(graph,cfg,result,stat);%stat

set(get(gca,'YLabel'),'Position',[-648,0.04765,1]);



