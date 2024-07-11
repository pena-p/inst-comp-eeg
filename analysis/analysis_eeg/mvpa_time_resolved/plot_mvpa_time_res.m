%% CODE TO PLOT TIME-RESOLVED MVPA RESULTS
% Figure 3A

%% Initialize and configure plots:
addpath(genpath('Z:/paula/toolbox/mvpalab-master'));
graph = mvpalab_plotinit();

%% Mean accuracy plot (statistical significance)

% Axis limits:
graph.xlim = [-200 7000];
graph.ylim = [.46 .70];
% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'AUC';
graph.title = '';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 1.5;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;
graph.shadealpha = 0.3;


% Load results and  statistics Task Demand:
% cfg.location = 'Z:/paula/results/int_sel';
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_demand/results/time_resolved/auc/stats.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_demand/results/time_resolved/auc/result.mat')

% Significant indicator:
graph.sigh = .697;
graph.fontsize = 17;
graph.shadecolor = [0.54,0.08,0.18];
graph.sigc = [0.54,0.08,0.18];

% Plot results:
f = figure;
set(f,'Position', [144,365,883,387]);
hold on;
set(gcf,'color','w');
mvpalab_plotdecoding(graph,cfg,result,stats); hold on;

% Load results and  statistics Target Category:
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_category/results/time_resolved/auc/stats.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_category/results/time_resolved/auc/result.mat')

% Significant indicator:
graph.sigh = .690;

graph.shadecolor = [0.00,0.45,0.74];
graph.sigc = [0.00,0.45,0.74];

% Plot results:
mvpalab_plotdecoding(graph,cfg,result,stats); hold on;


% Load results and statistics Relevant Feature:
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_feature/results/time_resolved/auc/stats.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/mvpa_feature/results/time_resolved/auc/result.mat')

% Significant indicator:
graph.sigh = .683;

graph.shadecolor = [0.47,0.67,0.19];
graph.sigc = [0.47,0.67,0.19];

% Plot results:
mvpalab_plotdecoding(graph,cfg,result,stats); hold on;

set(get(gca,'YLabel'),'Position',[-700.6,0.537,1]);
