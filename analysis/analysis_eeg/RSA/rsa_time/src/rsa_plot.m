
%% CODE TO PLOT RSA RESULTS, FIGURE 2D

%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 
% Load results and and statistics if needed:
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_time/result.mat')
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_time/stats.mat')

%% Mean accuracy plot (statistical significance)
% Axis limits:
graph.xlim = [-200 7000];
 graph.ylim = [-1 3.5];
 graph.fontsize = 17;

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'T-values';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 1.5;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;
graph.shadealpha = 0.3;
% Title:
graph.title = '';

% Plot results:
fig = figure;
set(fig,'Position', [144,365,883,387]);
hold on ;
set(gcf,'color','w');


result = tvalues(1,:,:); % TASK DEMAND
 stat = stats.model1.tvalues;
graph.shadecolor = [0.54,0.08,0.18];
graph.sigc = [0.54,0.08,0.18];
graph.sigh = 3.45;
rsa_plotcr(graph,cfg,result,stat);%,stat


result = tvalues(2,:,:); % TARGET CATEGORY
 stat = stats.model2.tvalues;
graph.shadecolor = [0.00,0.45,0.74];
graph.sigc = [0.00,0.45,0.74];
graph.sigh = 3.32;
rsa_plotcr(graph,cfg,result,stat);%,stat

result = tvalues(3,:,:); % TARGET RELEVANT FEATURE
stat = stats.model3.tvalues;
graph.shadecolor = [0.47,0.67,0.19];
graph.sigc = [0.47,0.67,0.19];
graph.sigh = 3.19;
rsa_plotcr(graph,cfg,result,stat);%,stat

set(get(gca,'YLabel'),'Position',[-648,0.04765,1],'Rotation',90);



