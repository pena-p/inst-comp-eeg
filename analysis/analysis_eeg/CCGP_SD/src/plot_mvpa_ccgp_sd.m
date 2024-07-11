%% Script to plot CCGP and SD results

%% Initialize and configure plots:

clear all; close all;
clc;

% Add path to mvpalab toolbox
addpath(genpath('Z:/paula/toolbox/mvpalab-master'));

graph = mvpalab_plotinit();

var_combinations = [1,10,21];
colors = [0.54,0.08,0.18;0.00,0.45,0.74;0.47,0.67,0.19];
sign_var = [0.615;0.61;0.605];
var = [{'Task Demand'},{'Target Category'},{'Relevant Feature'}];

%% CCGP, 3 main variables. Figure 4B

% Mean accuracy plot (no statistical significance)
% Axis limits:
graph.xlim = [-200 7000];
graph.ylim = [.46 .62];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Mean AUC';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 1.5;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;
graph.shadealpha = 0.3;
graph.fontsize = 18;


% Significant indicator:
graph.sigh = .655;

% Title:
graph.title = '';

clf;figure(1);
set(gcf,'color','w');
set(gcf,'Position', [144,365,883,387]);
hold on;

for i = 1:length(var_combinations)

% Load results and and statistics if needed:
load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/' num2str(var_combinations(i)) '/mean_ccgp/stats.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/'  num2str(var_combinations(i)) '/mean_ccgp/mean_dichot.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/' num2str(var_combinations(i)) '/ccgp/1-1/result.mat']); % for the cfg only
clear result;

graph.shadecolor = colors(i,:);
graph.sigc = colors(i,:);
graph.sigh = sign_var(i,:);


% Plot results:
mvpalab_plotdecoding(graph,cfg,res_dichot,stats); hold on;
end
set(get(gca,'YLabel'),'Position',[-700.6,0.537,1]);

%% Plot Shattering Dimensionality results - Figure 4B

load('Z:/paula/inst-comp-eeg/EEG/results/ccgp/sd/sd_results.mat');
load('Z:/paula/inst-comp-eeg/EEG/results/ccgp/sd/stats.mat');
load('Z:/paula/inst-comp-eeg/EEG/results/ccgp/1/ccgp/1-1/result.mat'); % for the cfg
clear result;

graph.title = '';

% Mean accuracy plot (no statistical significance)
% Axis limits:
graph.xlim = [0 7000];
graph.ylim = [.48 .525];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Shattering Dimensionality';
graph.fontsize = 17;

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 1.5;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;
graph.shadealpha = 0.3;


% Significant indicator:
graph.sigh = .524;

figure; hold on;
set(gcf,'color','w');
set(gcf,'Position', [144,365,883,387]);
graph.shadecolor = 'k';
graph.sigc = 'k';
mvpalab_plotdecoding(graph,cfg,res_sd,stats),


%% Plot count and proportion of decodable dichotomies - Figure 4C

load('Z:/paula/inst-comp-eeg/EEG/results/ccgp/sd/decoded_dichot.mat');
load('Z:/paula/inst-comp-eeg/EEG/results/ccgp/1/ccgp/1-1/result.mat'); % for the cfg
clear result;

% Plot count of dichotomies above 0.5
figure; hold on;
set(gcf,'color','w','Position', [144,365,883,387]);
bar(cfg.tm.times,decoded_dichot,'FaceColor',[0.4940 0.1840 0.5560],'BarWidth',1.5);
xlim([0,7000]);
x = xlabel('Time (ms)');
xticks(0:500:7000);
set(gca,'XTickLabelRotation',90);
set(gca,'Layer','top');
set(gca,'XGrid','on');
ylim([0 35]);
y = ylabel('Nº of dichotomies above chance');
title('');
set(gca,'FontSize',18,'FontName','helvetica');
set(y,'FontSize',18,'FontName','helvetica','FontWeight','bold');
set(x,'FontSize',18,'FontName','helvetica','FontWeight','bold');





