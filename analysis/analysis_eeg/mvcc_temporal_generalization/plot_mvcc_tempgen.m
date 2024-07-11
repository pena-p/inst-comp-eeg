%% CODE TO PLOT RESULTS OF TEMPORAL GENERALIZATION ANALYSIS WITH CROSS-CLASSIFICATION
% Figures 4C, 4D, 4E and Supplementary Figures

%% Initialize and configure plots:
clc;
clear all;
addpath(genpath('Z:/paula/toolbox/mvpalab-master'));

graph = mvpalab_plotinit();
load('new_color_map.mat'); % in this folder

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;

% Colors:
graph.colorMap = new_color_map;
graph.colors = new_color_map; 
graph.fontsize= 16;


%% PLOT MEAN RESULTS. Fig. 4C

%% Task Demand across difererent contexts

clf; f =figure(1);
set(f,'Position', [212 369 942 460]);
hold on;
set(gcf,'color','w');
sgtitle('Task Demand across different contexts','FontSize',19,'FontWeight','bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/' ...
    'across_category/results/temporal_generalization/auc/mean/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

graph.xlabel = 'Test (ms)';
graph.ylabel = 'Train (ms)';

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category' ...
    '/results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

a = subplot(1,2,1);
box on;
graph.title = 'Mean across different Categories';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square;

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

b = subplot(1,2,2);
box on;
graph.title = 'Mean across different Features';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square;
set(b,'Position',[0.5703 0.1070 0.3347 0.7857]);

%% Target Category across difererent contexts. Fig 4D

f =figure(2);
set(f,'Position', [212 369 942 460]);
hold on;
set(gcf,'color','w');
sgtitle('Target Category across different contexts','FontSize',19,'FontWeight','bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/mean/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

graph.xlabel = 'Test (ms)';
graph.ylabel = 'Train (ms)';

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

subplot(1,2,1);
box on;
graph.title = 'Mean across different Demands';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square; 

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

b = subplot(1,2,2);
box on;
graph.title = 'Mean across different Features';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square;
set(b,'Position',[0.5703 0.1070 0.3347 0.7857]);

%% Relevant Feature across difererent contexts. Fig 4E
f = figure(3);
set(f,'Position', [212 369 942 460]);
hold on;
set(gcf,'color','w');
sgtitle('Relevant Feature across different contexts','FontSize',19,'FontWeight','bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/mean/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

graph.xlabel = 'Test (ms)';
graph.ylabel = 'Train (ms)';

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

subplot(1,2,1);
box on;
graph.title = 'Mean across different Demands';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square;

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/mean/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/mean/stats.mat'])

b = subplot(1,2,2);
box on;
graph.title = 'Mean across different Categories';
mvpalab_plottempogen(graph,cfg,result,stats);
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
axis square;
set(b,'Position',[0.5703 0.1070 0.3347 0.7857]);


%% Plot both directions as Supplementary Material

%% Task Demand - SM
% Figure 4 - Figure Supplement 5

graph.fontsize= 14;
f = figure(4);
set(f,'Position',[352 95 860 702]);
% hold on;
set(gcf,'color','w');
sgtitle('Task Demand Cross-classification','FontSize',19,'FontWeight','bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/ab/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

subplot(2,2,1);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test inanimate (ms)';
graph.ylabel = 'Train animate (ms)';
graph.title = 'Direction Animate > Inanimate';
mvpalab_plottempogen(graph,cfg,result,stats); axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


b = subplot(2,2,2);
set(b,'Position',[0.501 0.5838 0.3347 0.3412]);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_category/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test animate (ms)';
graph.ylabel = 'Train inanimate (ms)';
graph.title = 'Direction Inanimate > Animate';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


subplot(2,2,3);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test shape (ms)';
graph.ylabel = 'Train color (ms)';
graph.title = 'Direction Color > Shape';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


d = subplot(2,2,4);
set(d,'Position',[0.501  0.1100  0.3347  0.3412] );
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_demand/across_feature/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test color (ms)';
graph.ylabel = 'Train shape (ms)';
graph.title = 'Direction Shape > Color';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);
% hold off;

set(f, 'PaperPositionMode', 'auto');
set(b,'Position',[0.51 0.5640 0.3347 0.3296]);
set(d,'Position',[0.51  0.1063  0.3347  0.3296]);


%% Target Category - SM
% Figure 4 - Figure Supplement 6

graph.fontsize= 14;
f = figure(5);
set(f,'Position', [352 95 860 702]);

hold on;
set(gcf,'color','w');
sgtitle('Target Category Cross-classification','FontSize',19, 'FontWeight', 'bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/ab/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

a = subplot(2,2,1);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test selection (ms)';
graph.ylabel = 'Train integration (ms)';
graph.title = 'Direction Integration > Selection';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


b = subplot(2,2,2);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_demand/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test integration (ms)';
graph.ylabel = 'Train selection (ms)';
graph.title = 'Direction Selection > Integration';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


c = subplot(2,2,3);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test shape (ms)';
graph.ylabel = 'Train color (ms)';
graph.title = 'Direction Color > Shape';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);


d = subplot(2,2,4);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_category/across_feature/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test color (ms)';
graph.ylabel = 'Train shape (ms)';
graph.title = 'Direction Shape > Color';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]); hold off;

set(b,'Position',[0.51 0.5640 0.3347 0.3296]);
set(d,'Position',[0.51  0.1063  0.3347  0.3296] );


%% Relevant Feature - SM
% Figure 4 - Figure Supplement 7

graph.fontsize= 14;
f = figure(6);
set(f,'Position', [352 95 860 702]);
hold on;
set(gcf,'color','w');
sgtitle('Relevant Feature Cross-classification','FontSize',19, 'FontWeight', 'bold');

load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/ab/result_1.mat']);

% Axis limits:
graph.xlim = [0 cfg.tm.tpend];
graph.ylim = [0 cfg.tm.tpend];
graph.caxis = [.50 .55];
graph.onscreen = [0 190];

subplot(2,2,1);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test selection (ms)';
graph.ylabel = 'Train integration (ms)';
graph.title = 'Direction Integration > Selection';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);

b = subplot(2,2,2);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_demand/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test integration (ms)';
graph.ylabel = 'Train selection (ms)';
graph.title = 'Direction Selection > Integration';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);

subplot(2,2,3);
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/ab/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/ab/stats.mat'])

graph.xlabel = 'Test inanimate (ms)';
graph.ylabel = 'Train animate (ms)';
graph.title = 'Direction Animate > Inanimate';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);

d = subplot(2,2,4);
set(d,'Position',[0.501  0.1100  0.3347  0.3412] );
box on;
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/ba/result.mat']);
load(['Z:/paula/inst-comp-eeg/EEG/results/mvcc_temp_gen/classify_feature/across_category/' ...
    'results/temporal_generalization/auc/ba/stats.mat'])

graph.xlabel = 'Test animate (ms)';
graph.ylabel = 'Train inanimate (ms)';
graph.title = 'Direction Inanimate > Animate';
mvpalab_plottempogen(graph,cfg,result,stats);axis square;
xticks([0,1000,2000,3000,4000,5000,6000,7000]);

set(b,'Position',[0.51 0.5640 0.3347 0.3296]);
set(d,'Position',[0.51  0.1063  0.3347  0.3296] );



