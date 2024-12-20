function [permaps,cfg] = mvpalab_cpermaps_ccgp(cfg,fv)
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.

% Script slightly altered from the mvpalab toolbox, we are only interested in
% direction A-B

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

fprintf('<strong> > Computing permuted maps (MVCC): </strong>\n');

% Enable statistics:
cfg.stats.flag = 1;

nSubjects = length(cfg.study.dataFiles{1,1});
nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.sf.filesLocation filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : nSubjects
    
    if cfg.sf.flag
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
        nfreq = length(cfg.sf.freqvec);
    end
    
    for freq = 1 : nfreq
        tic;
        fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
        % fprintf([' Bands - ' int2str(freq) '/' int2str(length(files)) ' >> ']);
        fprintf('- Permutation: ');
        %% Load data if needed:
        if cfg.sf.flag
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            train_X = fv.X.a; test_X = fv.X.b;
            train_Y = fv.Y.a; test_Y = fv.Y.b;
        else
            train_X = fv{sub}.X.a; test_X = fv{sub}.X.b;
            train_Y = fv{sub}.Y.a; test_Y = fv{sub}.Y.b;
        end
        
        %% Generate permuted labels
        for per = 1 : cfg.stats.nper
            cfg.classmodel.permlab = true;
            mvpalab_pcounter(per,cfg.stats.nper);
            if cfg.classmodel.parcomp
                %% Timepoints loop
                parfor tp = 1 : cfg.tm.ntp
                    % Direction A - B:
                    [~,~,~,...
                        auc_ab(tp,:),...
                        acc_ab(tp,:),...
                        ~,...
                        precision_ab{sub,tp,freq,per},...
                        recall_ab{sub,tp,freq,per},...
                        f1score_ab{sub,tp,freq,per},...
                        ~] = mvpalab_mvcceval(train_X,train_Y,test_X,test_Y,tp,cfg);
                    
%                     % Direction B - A:
%                     [~,~,~,...
%                         auc_ba(tp,:),...
%                         acc_ba(tp,:),...
%                         ~,...
%                         precision_ba{sub,tp,freq,per},...
%                         recall_ba{sub,tp,freq,per},...
%                         f1score_ba{sub,tp,freq,per},...
%                         ~] = mvpalab_mvcceval(test_X,test_Y,train_X,train_Y,tp,cfg);
                end
            else
                for tp = 1 : cfg.tm.ntp
                    % Direction A - B:
                    [~,~,~,...
                        auc_ab(tp,:),...
                        acc_ab(tp,:),...
                        ~,...
                        precision_ab{sub,tp,freq,per},...
                        recall_ab{sub,tp,freq,per},...
                        f1score_ab{sub,tp,freq,per},...
                        ~] = mvpalab_mvcceval(train_X,train_Y,test_X,test_Y,tp,cfg);
                    
%                     % Direction B - A:
%                     [~,~,~,...
%                         auc_ba(tp,:),...
%                         acc_ba(tp,:),...
%                         ~,...
%                         precision_ba{sub,tp,freq,per},...
%                         recall_ba{sub,tp,freq,per},...
%                         f1score_ba{sub,tp,freq,per},...
%                         ~] = mvpalab_mvcceval(test_X,test_Y,train_X,train_Y,tp,cfg);
                end
            end
            
            if cfg.classmodel.tempgen
                permaps.acc.ab(:,:,sub,per,freq) = acc_ab;
%                 permaps.acc.ba(:,:,sub,per,freq) = acc_ba;
%                 permaps.acc.mean(:,:,sub,per,freq) = mean(cat(3,acc_ab,acc_ba),3);
                if cfg.classmodel.auc
                    permaps.auc.ab(:,:,sub,per,freq) = auc_ab;
%                     permaps.auc.ba(:,:,sub,per,freq) = auc_ba;
                    permaprs.auc.mean(:,:,sub,per,freq) = mean(cat(3,auc_ab,auc_ba),3);
                end
            else
%                 permaps.acc.ab(:,:,sub,per,freq) = acc_ab';
%                 permaps.acc.ba(:,:,sub,per,freq) = acc_ba';
%                 permaps.acc.mean(:,:,sub,per,freq) = mean([acc_ab,acc_ba],2)';
                if cfg.classmodel.auc
                    permaps.auc.ab(:,:,sub,per,freq) = auc_ab';
%                     permaps.auc.ba(:,:,sub,per,freq) = auc_ba';
%                     permaps.auc.mean(:,:,sub,per,freq) = mean([auc_ab,auc_ba],2)';
                end
            end
        end
        fprintf(' >> ');
        toc;
    end
end

fprintf('\n');

% Return precision if needed:
if cfg.classmodel.precision
    permaps.precision = mvpalab_reorganize(cfg,precision_ab,precision_ba);
end

% Return recall if needed:
if cfg.classmodel.recall
    permaps.recall = mvpalab_reorganize(cfg,recall_ab,recall_ba);
end

% Return f1score if needed:
if cfg.classmodel.f1score
    permaps.f1score = mvpalab_reorganize(cfg,f1score_ab,f1score_ba);
end


cfg.classmodel.permlab = false;

if ~cfg.sf.flag, mvpalab_save_ccgp(cfg,permaps,'permaps'); end

end

