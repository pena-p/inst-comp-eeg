function [] = rsa_plotcr(graph,cfg,data,stats)
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Calculate the mean for each timepoint:
datamean = squeeze(mean(data,3));
chancelevel = zeros(1,length(datamean));

%% Smooth the data for the representation if needed:
if graph.smoothdata
    datamean = smooth(datamean,graph.smoothdata);
    for subject = 1 : size(data,3) 
        data(1,:,subject) = smooth(data(1,:,subject));
    end
end

%% Compute the STD/SEM:
if graph.stdsem
    stdsem = nanstd(data,[],3);
else
    stdsem = nanstd(data,[],3)/sqrt(size(data,3));
end


%% Plots:
if  exist('stats','var')
    if graph.sigmode.shade
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            [.7 .7 .7], 'FaceAlpha',...
            .5,'linestyle','none');
        
        significant_vector = logical(...
            ~stats.sigmask * graph.stats.above + ...
            ~stats.sigmask_* graph.stats.below);
        
        segments = bwconncomp(significant_vector);
        
        for i = 1 : segments.NumObjects
            times = cfg.tm.times(segments.PixelIdxList{i});
            values = datamean(segments.PixelIdxList{i});
            var = stdsem(segments.PixelIdxList{i});
            
            if significant_vector(segments.PixelIdxList{i})
                fill(...
                    [times fliplr(times)],...
                    [values'+var fliplr(values'-var)],...
                    graph.shadecolor, 'FaceAlpha',...
                    graph.shadealpha,'linestyle','none');
            end
        end
    end
    if graph.sigmode.points
        
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            graph.shadecolor, 'FaceAlpha',...
            graph.shadealpha,'linestyle','none');
        
        
        stpoints = ones(1,length(datamean))*graph.sigh;
        times = cfg.tm.times(logical(~stats.sigmask  * graph.stats.above ...
            + ~stats.sigmask_ * graph.stats.below));
        points = stpoints(logical(~stats.sigmask  * graph.stats.above ...
            + ~stats.sigmask_ * graph.stats.below));
        scatter(times,points,80,graph.sigc,'filled','s');
        %scatter(cfg.tm.times,stpoints,80,'k','s');
    end
    
else
    fill(...
        [cfg.tm.times fliplr(cfg.tm.times)],...
        [datamean'+stdsem fliplr(datamean'-stdsem)],...
        graph.shadecolor,...
        'FaceAlpha',graph.shadealpha,'linestyle','none');
end

if graph.plotmean
    plot(cfg.tm.times,datamean,...
        'color',graph.shadecolor,...
        'linewidth',graph.linewidth,...
        'linestyle',graph.linestyle);
end

plot(cfg.tm.times,chancelevel,'k','LineWidth',.5,'LineStyle',':');

%%  Graph configuration:
set(gca,'Color','w')
set(gca,'XGrid','on');
set(gca,'YAxisLocation','origin');
set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'XTickLabelRotation',90);
set(gca,'XTick',0:500:graph.xlim(2));
set(gca,'YTick',graph.ylim(1):.5:graph.ylim(2));
set(gca,'FontSize',graph.fontsize);
set(gcf,'color', 'w');

xlabel(graph.xlabel,'FontWeight','bold');
ylabel(graph.ylabel,'FontWeight','bold');
ylim(graph.ylim);
xlim(graph.xlim);
title(graph.title);
set(gca,'Layer','top')
end

