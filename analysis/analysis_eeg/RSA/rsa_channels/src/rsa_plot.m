%% CODE TO PLOT RESULTS OF CHANNEL RSA
% FIGURE 2C

%% Initialize and configure plots:
clear all;
close all;

addpath('Z:/paula/toolbox/eeglab2022.1/');
eeglab;

% Load tvalues of channel RSA 
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_channels/result.mat');
tvalues_mean = nanmean(tvalues,3);

% Load any condition file to obtain the channel locations
load('Z:/paula/inst-comp-eeg/EEG/BIDS/derivatives/sub-001/eeg/conditions/sub-001_task-inst-comp_eeg_ANIM.mat'); % for the channel locations
chanloc = data_.chanlocs;
clear result cfg;

% Add color palette toolbox to path
addpath(genpath('Z:/paula/toolbox/colormap_CD-master/'));
col= colormap_CD([ 0.45 0.7; 0.08 0.95],[1 .35],[0 0],10);
new_color_map = col(6:20,:);

%% Plot the topographies
fig = figure(1); hold on;set(gcf,'color','w');
set(fig,'Position',[36,383,796,225]);

% Plot Task Demand
    a = subplot(1,3,1);
   set(a,'Position',[0.130 0.08  0.2134 0.8150]);
   set(get(a,'Title'),'String','Task Demand','FontSize',15);
    weights_to_plot = tvalues_mean(1,:);
topoplot(weights_to_plot,chanloc,...
            'colormap',new_color_map,...
            'whitebk','on',...
            'maplimits',[-1 2],...
            'electrodes','labels'); 



% Plot Target Category
b =  subplot(1,3,2);
   set(b,'Position',[0.350 0.08  0.2134 0.8150]);
   set(get(b,'Title'),'String','Target Category','FontSize',15);
    weights_to_plot = tvalues_mean(2,:);
topoplot(weights_to_plot,chanloc,...
            'colormap', new_color_map,...
            'whitebk','on',...
            'maplimits',[-1 2],...
            'electrodes','labels'); hold off;

% Plot Relevant Feature
c =  subplot(1,3,3);
set(c,'Position',[0.570 0.08  0.2134 0.8150]);
set(get(c,'Title'),'String','Relevant Feature','FontSize',15);
weights_to_plot = tvalues_mean(3,:);
topoplot(weights_to_plot,chanloc,...
            'colormap', new_color_map,...
            'whitebk','on',...
            'maplimits',[-1 2],...
            'electrodes','labels'); 


d = colorbar('Position',[0.807,0.15,0.0186,0.694], 'FontSize', 13);
d.Label.String = 'T-values';
d.Label.FontWeight = 'normal';
d.Label.FontSize= 18;
d.Label.Position = [3.588,0.972,0];
d.Label.Rotation = 270;
 hold off;



