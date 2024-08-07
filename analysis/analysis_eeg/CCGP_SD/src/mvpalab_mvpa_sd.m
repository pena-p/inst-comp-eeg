function [res,cfg] = mvpalab_mvpa_sd(cfg,fv)

%% Script slightly altered for Shattering Dimensionality Analysis from Mvpalab toolbox

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

fprintf('<strong> > Computing MVPA analysis: </strong>\n');

%% Initialization
nSubjects = length(cfg.study.dataFiles{1,1});

nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.sf.filesLocation filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : nSubjects
    tic;
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
    
    if cfg.sf.flag
        fprintf(' Frequency bands - ');
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
        nfreq = length(cfg.sf.freqvec);
    end
    
    %% Frequencies loop:
    for freq = 1 : nfreq
        
        %% Load data if needed:
        if cfg.sf.flag
            mvpalab_pcounter(freq,length(files));
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            X = fv.X.a; Y = fv.Y.a;
        else
            X = fv{sub}.X.a; Y = fv{sub}.Y.a;
        end
        
        %% Stratified partition for cross validation:
        if strcmp(cfg.cv.method,'loo')
            cfg.cv.nfolds = cfg.cv.loo(sub);
        end
        
        strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);
        
        %% Electrode selection:
        [X,cfg] = mvpalab_chanselection(X,cfg);
        
        %% Timepoints loop
        if cfg.classmodel.parcomp
            parfor tp = 1 : cfg.tm.ntp
                [...
                    x{sub,tp,freq},...
                    y{sub,tp,freq},...
                    t{sub,tp,freq},...
                    auc(tp,:),...
                    acc(tp,:),...
                    confmat{sub,tp,freq},...
                    precision{sub,tp,freq},...
                    recall{sub,tp,freq},...
                    f1score{sub,tp,freq},...
                    w{1,tp,sub,freq}...
                    ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
            end
        else
            for tp = 1 : cfg.tm.ntp
                [...
                    x{sub,tp,freq},...
                    y{sub,tp,freq},...
                    t{sub,tp,freq},...
                    auc(tp,:),...
                    acc(tp,:),...
                    confmat{sub,tp,freq},...
                    precision{sub,tp,freq},...
                    recall{sub,tp,freq},...
                    f1score{sub,tp,freq},...
                    w{1,tp,sub,freq}...
                    ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
            end
        end
        
        % Reestructure result:
        if cfg.classmodel.tempgen
%             res.acc(:,:,sub,freq) = acc;
            if cfg.classmodel.auc
                res.auc(:,:,sub,freq) = auc;
            end
        else
%             res.acc(:,:,sub,freq) = acc';
            if cfg.classmodel.auc
                res.auc(:,:,sub,freq) = auc';
            end
        end
    end
    toc;
end

fprintf('\n');

% Return confusion ROC values and AUC if needed:
if cfg.classmodel.roc
    res.roc.x =  mvpalab_reorganize_(cfg,x); 
    res.roc.y =  mvpalab_reorganize_(cfg,y); 
    res.roc.t =  mvpalab_reorganize_(cfg,t);
end

% Return confusion matrix if needed:
if cfg.classmodel.confmat
    res.confmat = mvpalab_reorganize_(cfg,confmat);
end 

% Return precision if needed:
if cfg.classmodel.precision
    res.precision = mvpalab_reorganize(cfg,precision);
end 

% Return recall if needed:
if cfg.classmodel.recall
    res.recall = mvpalab_reorganize(cfg,recall);
end 

% Return f1score if needed:
if cfg.classmodel.f1score
    res.f1score = mvpalab_reorganize(cfg,f1score);
end 

% Return wvector if needed:
if cfg.classmodel.wvector
    res.wvector = mvpalab_reorganize_weights(w);
end

% Save result
if ~cfg.sf.flag, mvpalab_save_ccgp(cfg,res,'res'); end

end



