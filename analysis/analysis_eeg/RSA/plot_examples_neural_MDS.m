
%% Script to plot the neural RDM of RSA analysis

%% REGULAR RSA: 3 TASK COMPONENTS
% Figure 2B

% Add color palette toolbox to path
% (https://github.com/duochanatharvard/colormap_CD)
addpath(genpath('Z:/paula/toolbox/colormap_CD-master'));
col = colormap_CD([0.16  0.89],[1 .3],[0],12);

% Load RDMs
load('Z:/paula/inst-comp-eeg/EEG/results/rsa_time/result.mat');

% Select neural RDM of one participant at one time-point (participant 30 at
% time-point 380)
a = RDMs(:,:,380,30);

% Plot Neural RDM, Figure 3B
clf;figure(2); hold on;
set(gcf,'color','w');
colormap(col);
set(gcf, 'Position', [440,471,443,326]);
title('Neural RDM','FontSize',25);

axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
xticks([]);
yticks([]);
set(gca,'CLim', [0 2]);
imagesc(a);
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on');
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');
c = colorbar('FontSize', 16, 'FontWeight', 'bold','Ticks', [0,2], 'TickLabels', [0,2], ...
    'Position', [0.85,0.11,0.044,0.776]); 
c.Label.String = 'Dissimilarity';
c.Label.FontWeight = 'normal';
c.Label.FontSize= 20;
c.Label.Position = [2.531,0.97,0];
c.Label.Rotation = 270;

%% GEOMETRY RSA: OFFSET AND ORTHOGONAL GEOMETRIES
% Figures 6B and 6C

% Add color palette toolbox to path
close all;
addpath(genpath('Z:/paula/toolbox/colormap_CD-master'));
col = colormap_CD([0.16  0.89],[1 .3],[0],12);

% Load neural RDMs and select one participant at one time-point
% participant 5 at time-point 578
load('Z:/paula/inst-comp-eeg/results/rsa_geometry/result.mat');
a = RDMs(:,:,578,5);

% Plot Neural RDM, Figure 8B
clf;figure(1); hold on;
set(gcf, 'Position', [440,471,443,326]);
set(gcf,'color','w');
title('Neural RDM','FontSize',23);
colormap(col);
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
set(gca,'CLim', [0 2]);
yticks([]);
xticks([]);
imagesc(a);
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on'); 
c = colorbar('FontSize', 14, 'FontWeight', 'bold','Ticks', [0,2], 'TickLabels', [0,2], ...
    'Position', [0.849887133182843,0.113496932515337,0.044018058690746,0.776073619631902]); 
c.Label.String = 'Dissimilarity';
c.Label.FontWeight = 'normal';
c.Label.FontSize= 20;
c.Label.Position = [2.474009397702339,1.045619705920163,0];
c.Label.Rotation = 270;
hold off;


% Plot neural RDM in 3 dimensions, with MDS. Figure 8C

% make matrix symmetric
a_low = tril(a);
a_high = triu(a)';
a_mean_low = (a_low + a_high)/2;
a_mean = a_mean_low + a_mean_low';
for i = 1:8
    for j = 1:8
        if i==j
            a_mean(i,j)=0;
        else
        end
    end
end

figure(2); hold on;
set(gcf,'color','w');
% title('','FontSize',20);
colormap(col);
b = mdscale(a_mean,3);
rotate3d on;
xlabel("dim 1",'Rotation',20,'FontSize',18);
ylabel("dim 2",'Rotation',-25,'FontSize',18);
zlabel("dim 3",'FontSize',18);

fill3([ b(1,1) b(2,1) b(4,1) b(3,1)], [b(1,2) b(2,2) b(4,2) b(3,2)],[ b(1,3) b(2,3) b(4,3) b(3,3)], col(12,:)); hold on;
fill3([ b(5,1) b(6,1) b(8,1) b(7,1)], [b(5,2) b(6,2) b(8,2) b(7,2)],[ b(5,3) b(6,3) b(8,3) b(7,3)], col(4,:)); hold on;
campos([-9.194,-5.73,4.686]);
xticklabels([]);
yticklabels([]);
zticklabels([]);
hold off;