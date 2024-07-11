%% SCRIPT TO PLOT THEORETICAL RDM FOR RSA ANALYSIS
clear all;
clc;

% Add color palette to path
addpath(genpath('/home/paula/Documents/colormap_CD-master'));
col = colormap_CD([0.16  0.89],[1 .3],[0],12);

%% Regular RSA: of 3 task-relevant components. Figure 2A


% Set the theoretical RDMs for the 3 main task-relevant components:
% TASK DEMAND
Y_matrix_dem = [  ...
     0     0     0     0     2     2     2     2;
     0     0     0     0     2     2     2     2;
     0     0     0     0     2     2     2     2;
     0     0     0     0     2     2     2     2;
     2     2     2     2     0     0     0     0;
     2     2     2     2     0     0     0     0;
     2     2     2     2     0     0     0     0;
     2     2     2     2     0     0     0     0];

% TARGET CATEGORY
 Y_matrix_cat = [  ...
     0     0     2     2     0     0     2     2;
     0     0     2     2     0     0     2     2;
     2     2     0     0     2     2     0     0;
     2     2     0     0     2     2     0     0;
     0     0     2     2     0     0     2     2;
     0     0     2     2     0     0     2     2;
     2     2     0     0     2     2     0     0;
     2     2     0     0     2     2     0     0];

 % TARGET RELEVANT FEATURE
 Y_matrix_feat = [ ...
     0     2     0     2     0     2     0     2;
     2     0     2     0     2     0     2     0;
     0     2     0     2     0     2     0     2;
     2     0     2     0     2     0     2     0;
     0     2     0     2     0     2     0     2;
     2     0     2     0     2     0     2     0;
     0     2     0     2     0     2     0     2;
     2     0     2     0     2     0     2     0;];


clf;figure(1); hold on;
set(gcf,'color','w','Position',[255,484,1134,296]);
colormap(col);

% Plot thoeretical RDM of Task Demand
h = subplot(1,4,1);hold on;
set(h,'Position',[0.13 0.16 0.1566 0.8027])
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
yticks([1:1:8.5]);
yticklabels({'SEL-ANIM-C','SEL-ANIM-S','SEL-INAN-C', ...
'SEL-INAN-S','INT-ANIM-C','INT-ANIM-S','INT-INAN-C', ...
'INT-INAN-S'});
xticks([1:1:8.5]);
xticklabels({'SEL-ANIM-C','SEL-ANIM-S','SEL-INAN-C', ...
'SEL-INAN-S','INT-ANIM-C','INT-ANIM-S','INT-INAN-C', ...
'INT-INAN-S'});
xtickangle(90);
imagesc(Y_matrix_dem);
set(gca, 'YDir','reverse');
set(gca,'FontSize',12);
title('Task Demand','FontSize',18);
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');


% Plot Target Category
b = subplot(1,4,2); hold on;
set(b,'Position',[0.31 0.16 0.1566 0.8027]);
title('Target Category','FontSize',18);
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
xticks([]);
yticks([]);
imagesc(Y_matrix_cat);
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on');
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');

% Plot Relevant Feature
z = subplot(1,4,3); hold on;
set(z,'Position',[0.49 0.16 0.1566 0.8027]);
title('Relevant Feature','FontSize',18);
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
xticks([]);
yticks([]);
imagesc(Y_matrix_feat)
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on');
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-'); 

c = colorbar('FontSize', 14, 'FontWeight', 'bold','Ticks',[0,2], 'TickLabels', [0,2] , ...
    'Position',[0.660,0.256,0.0155,0.606]);
c.Label.String = 'Dissimilarity';
c.Label.FontWeight = 'normal';
c.Label.FontSize= 18;
c.Label.Position = [2.64,1.018,0];
c.Label.Rotation = 270;

%% RSA Geometry 2 models. Figure 6A


% Set the theoretical RDMs for the 2 geometries:

% Offset model
 Y_matrix_parallel = [...
    0	  0.4   0.4   0.8   0.8   1.6   1.6	  2;
    0.4	  0	    0.8	  0.4   1.6   0.8   2	  1.6;
    0.4	  0.8	0	  0.4	1.6   2	    0.8	  1.6;
    0.8	  0.4   0.4	  0	    2	  1.6   1.6	  0.8;
    0.8	  1.6   1.6   2	    0	  0.4   0.4	  0.8;
    1.6	  0.8   2	  1.6	0.4   0     0.8	  0.4;
    1.6	  2     0.8	  1.6	0.4   0.8   0	  0.4;
    2	  1.6   1.6   0.8	0.8   0.4   0.4	  0];

 % Orthogonal model
 Y_matrix_ortho = [...
    0     0.8   0.8   2     0.4   1     0.4   1;
    0.8   0     2     0.8   1     0.4   1     0.4;
    0.8   2     0     0.8   0.4   1     0.4   1;
    2     0.8   0.8   0     1     0.4   1     0.4;
    0.4   1     0.4   1     0     0.8   0.8   2;
    1     0.4   1     0.4   0.8   0     2     0.8;
    0.4   1     0.4   1     0.8   2     0     0.8;
    1     0.4   1     0.4   2     0.8   0.8   0];




figure(2); hold on;
set(gcf,'color','w');
set(gcf,'Position',[497,147,547,524]);
colormap(col);

% Plot theoretical RDM Offset model
subplot(2,2,1), hold on;
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
yticks([1:1:8.5]);
yticklabels({'SEL-ANIM-C (a)','SEL-ANIM-S (b)','SEL-INAN-C (c)', ...
'SEL-INAN-S (d)','INT-ANIM-C (e)','INT-ANIM-S (f)','INT-INAN-C (g)', ...
'INT-INAN-S (h)'});
xticks([1:1:8.5]);
xticklabels({'SEL-ANIM-C','SEL-ANIM-S','SEL-INAN-C', ...
'SEL-INAN-S','INT-ANIM-C','INT-ANIM-S','INT-INAN-C', ...
'INT-INAN-S'});
xtickangle(90);
set(gca,'CLim', [0 2]);
imagesc(Y_matrix_parallel);
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on'); 
set(gca,'FontSize',11);
title('Offset Model','FontSize',16);
hold off;

% Plot MDS visualization in 3 dimensions of Offset model
zeta = subplot(2,2,3); hold on;
a = mdscale(Y_matrix_parallel,3);
xlim([-1 1]);
xlabel("dim 1",'Rotation',-5,'FontSize',12);
ylim([-1 1]);
ylabel("dim 2",'Rotation',17,'FontSize',12);
zlim([-1 1]);
zlabel("dim 3",'FontSize',12);
xticklabels([]);
yticklabels([]);
zticklabels([]);
fill3([ a(1,1) a(2,1) a(4,1) a(3,1)], [a(1,2) a(2,2) a(4,2) a(3,2)],[ a(1,3) a(2,3) a(4,3) a(3,3)], col(12,:)); hold on;
fill3([ a(5,1) a(6,1) a(8,1) a(7,1)], [a(5,2) a(6,2) a(8,2) a(7,2)],[ a(5,3) a(6,3) a(8,3) a(7,3)], col(4,:)); 
campos([-4.025,7.619,0.867]);
xt = [a(1,1) a(2,1) a(3,1) a(4,1) a(5,1) a(6,1) a(7,1) a(8,1)];
yt = [a(1,2) a(2,2) a(3,2) a(4,2) a(5,2) a(6,2) a(7,2) a(8,2)];
zt = [a(1,3) a(2,3) a(3,3) a(4,3) a(5,3) a(6,3) a(7,3) a(8,3)];
letters = {'a','b','c','d','e','f','g','h'};
t = text(xt,yt,zt,letters,'FontWeight','bold','Visible','on','FontSize',12); 

% Plot RDM Orthogonal model
plot_b = subplot(2,2,2); hold on;
set(plot_b,'Position', [0.54,0.6405,0.3035,0.2845]);
title('Orthogonal Model','FontSize',16);
axis square
xlim([0.5 8.5]);
ylim([0.5 8.5]);
yticks([]);
xticks([]);
set(gca,'CLim', [0 2]);
imagesc( Y_matrix_ortho );
rectangle('Position',[0.5 0.5 8 8],...
         'LineWidth',2,'LineStyle','-');
set(gca, 'YDir','reverse');
set(gca, 'XGrid', 'on','GridAlpha', 0.7 , 'YGrid', 'on'); hold off;

% Add RDM COLORBAR
u = colorbar('Limits', [0 2]);
c = colorbar('FontSize', 14, 'FontWeight', 'bold', 'Limits',[0,2],'Ticks', [0,2], 'TickLabels', [0,2],...
    'Position', [0.88,0.64,0.026,0.287],'FontSize', 14, 'FontWeight', 'bold');
c.Label.String = 'Dissimilarity';
c.Label.FontWeight = 'normal';
c.Label.FontSize= 17;
c.Label.Position = [2.84,1.02,0];
c.Label.Rotation = 270;

% Plot MDS visualization in 3 dimensions of Orthogonal model
plot_b = subplot(2,2,4); hold on;
set(plot_b,'Position', [0.56,0.1667,0.3035,0.2845]);
clear a;
a = mdscale(Y_matrix_ortho,3);
xlim([-1 1]);
xlabel("dim 1",'Rotation',17,'FontSize',12);
ylim([-1 1]);
ylabel("dim 2",'FontSize',12);
zlim([-1 1]);
zlabel("dim 3",'FontSize',12);
xticklabels([]);
yticklabels([]);
zticklabels([]);
fill3([ a(1,1) a(2,1) a(4,1) a(3,1)], [a(1,2) a(2,2) a(4,2) a(3,2)],[ a(1,3) a(2,3) a(4,3) a(3,3)], col(12,:)); hold on;
fill3([ a(5,1) a(6,1) a(8,1) a(7,1)], [a(5,2) a(6,2) a(8,2) a(7,2)],[ a(5,3) a(6,3) a(8,3) a(7,3)], col(4,:)); hold off
campos([-8.063,-3.039,0.867])
xt = [a(1,1) a(2,1) a(3,1) a(4,1) a(5,1) a(6,1) a(7,1) a(8,1)];
yt = [a(1,2) a(2,2) a(3,2) a(4,2) a(5,2) a(6,2) a(7,2) a(8,2)];
zt = [a(1,3) a(2,3) a(3,3) a(4,3) a(5,3) a(6,3) a(7,3) a(8,3)];
letters = {'a','b','c','d','e','f','g','h'};
t = text(xt,yt,zt,letters,'FontWeight','bold','Visible','on','FontSize',12);
hold off; 


