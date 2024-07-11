
%% Plot ccgp per combination

clear all; close all;
clc;

addpath(genpath('Z:/paula/toolbox/mvpalab-master'));
graph = mvpalab_plotinit();

% Mean accuracy plot (no statistical significance)
% Axis limits:
graph.xlim = [-200 7000];
graph.ylim = [.45 .62];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'AUC';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 2;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;
graph.shadealpha = 0.3;


% Significant indicator:
graph.sigh = .655;


var_combinations = [1,10,21];
colors = [0.54,0.08,0.18;0.00,0.45,0.74;0.47,0.67,0.19];
var = [{'Task Demand'},{'Target Category'},{'Relevant Feature'}];

for i = 1:length(var_combinations)

    figure(i); hold on;
    set(gcf,'Position', [623,193,757,575]);
    set(gcf,'color','w');
    graph.shadecolor = colors(i,:);
%     sgtitle([var(i)]);
    counter = 0;
    for step_a = 1:4
        for step_b = 1:4
    counter = counter + 1;
    load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/' num2str(var_combinations(i)) '/ccgp/1-1/result.mat']); % for the cfg
    graph.title = [num2str(counter)];
    subplot(4,4,counter); hold on;
    graph.fontsize =10;
    mvpalab_plotdecoding(graph,cfg,result); hold on;

        end
    end

end

%% Plot SD per dichotomy

clear all; close all;
clc;

addpath(genpath('Z:/paula/toolbox/mvpalab-master'));

graph = mvpalab_plotinit();

% Mean accuracy plot (no statistical significance)
% Axis limits:
graph.xlim = [-200 7000];
graph.ylim = [.45 .599];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'AUC';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)
graph.linewidth = 2;

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;
graph.shadealpha = 0.3;


% Significant indicator:
graph.sigh = .595;


dichot = 1:35;
var_combinations = [1,10,21];
color = [0,0,0];
colors_var = [0.54,0.08,0.18;0.00,0.45,0.74;0.47,0.67,0.19];

    figure(1); hold on;
    set(gcf,'color','w');
    sgtitle('');
    counter = 0;

    for vertical = 1:5
        for horizontal = 1:7
    counter = counter + 1;

    if counter == var_combinations(1,1)
        graph.shadecolor = colors_var(1,:);

    elseif counter == var_combinations(1,2)
         graph.shadecolor = colors_var(2,:);

    elseif counter == var_combinations(1,3)
         graph.shadecolor = colors_var(3,:);

    else
        graph.shadecolor = color;

    end

    load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/' num2str(counter) '/all_cond/result.mat']); 
    load(['Z:/paula/inst-comp-eeg/EEG/results/ccgp/' num2str(counter) '/all_cond/stats.mat']); % for the cfg
    graph.title = [num2str(counter)];
    subplot(5,7,counter); hold on;
    graph.fontsize =10;
    mvpalab_plotdecoding(graph,cfg,result,stats); hold on;

        end
    end

