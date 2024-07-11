
%% Basic configuration file for MVPA analysis - Folder and data files:

%% IF Theoretical
cfg.study = [];
cfg.analysis = 'RSA_pearson_cv';
cfg.location = 'Z:/paula/inst-comp-eeg/EEG/results/rsa_geometry/';
cfg.features = 'conditions';
dir.der = 'Z:/paula/inst-comp-eeg/EEG/BIDS/derivatives/';

% Select conditions 
cond = [{'SEL_ANIM_C'},{'SEL_ANIM_S'},{'SEL_INAN_C'},{'SEL_INAN_S'},...
    {'INT_ANIM_C'},{'INT_ANIM_S'},{'INT_INAN_C'},{'INT_INAN_S'}];

% Indicate derivatives path and condition identifier
for k = 1:8
    cfg.study.dataPaths{1,k} = dir.der;
    cfg.study.conditionIdentifier{1,k} = char(cond(1,k));
end

% Subject list
subjects = [1:15,17:22,24:41];

% Name of data files
for l = 1:length(subjects)
    if l < 10
        for k = 1:8
        cfg.study.dataFiles{1,k}(l) = {['sub-00' num2str(subjects(l)) '/eeg/conditions/sub-00' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(1,k)) '.mat']};
        end
    else
        for k = 1:8
        cfg.study.dataFiles{1,k}(l) = {['sub-0' num2str(subjects(l)) '/eeg/conditions/sub-0' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(1,k)) '.mat']};
        end
    end
end

%% FEATURE EXTRACTION:

cfg.feature = 'voltage';

% cfg.feature = 'voltage'  - Raw voltage as feature.
% cfg.feature = 'envelope' - Power evelope as feature.

cfg.powenv.method = 'analytic';
cfg.powenv.uplow  = 'upper';
cfg.powenv.length = 5;

% cfg.powenv.method = 'analytic' - Envelope using the analytic signal.
% cfg.powenv.method = 'peak'     - Peak envelopes.

% cfg.powenv.uplow = 'upper' - Select upper envelope.
% cfg.powenv.uplow = 'lower' - Select lower envelope.

%% TRIAL AVERAGE:

cfg.trialaver.flag     = false;
% cfg.trialaver.ntrials  = 3;
% cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:
    cfg.classsize.match = true;
    cfg.classsize.matchkfold = false;


%% DIMENSION REDUCTION:

% cfg.dimred.method = 'none' - Diemnsion reduction disabled.
% cfg.dimred.method = 'pca'  - Principal Component Analysis.

cfg.dimred.method = 'none';
% cfg.dimred.ncomp  = 0;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 3; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'moving';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -200;
cfg.tm.tpend     = 7000;
cfg.tm.tpsteps   = 3;

%% CLASSIFICATION ALGORITHM:

% % cfg.classmodel.method = 'svm' - Support Vector Machine.
% cfg.classmodel.method = 'da'; % - Linear Discriminant Analysis.
% 
% % cfg.classmodel.kernel = 'linear'     - Support Vector Machine.
% % cfg.classmodel.kernel = 'gaussian'   - Support Vector Machine.
% % cfg.classmodel.kernel = 'rbf'        - Support Vector Machine.
% % cfg.classmodel.kernel = 'polynomial' - Support Vector Machine.
% 
% % cfg.classmodel.kernel = 'linear' - Discriminant Analysis.
% % cfg.classmodel.kernel = 'quadratic' - Discriminant Analysis.
% % 
% % cfg.classmodel.method = 'svm';
% cfg.classmodel.kernel = 'linear';

%% HYPERPARAMETERS OPTIMIZATION:

cfg.classmodel.optimize.flag = false;
cfg.classmodel.optimize.params = {'BoxConstraint'};
cfg.classmodel.optimize.opt = struct('Optimizer','gridsearch',...
    'ShowPlots',false,'Verbose',0,'Kfold', 5);

%% RSA PERFORMANCE METRICS:
cfg.classmodel.tempgen = false;
cfg.classmodel.corrspe = false;
cfg.classmodel.mahalan = false;
cfg.classmodel.regress = true;
% %% EXTRA CONFIGURATION:
% 
% cfg.classmodel.tempgen = true;
% cfg.classmodel.extdiag = true;
% cfg.classmodel.parcomp = true;
% cfg.classmodel.permlab = false;
% 
% %% CROSS-VALIDATIONN PROCEDURE:
% 
% % cfg.cv.method = 'kfold' - K-Fold cross-validation.
% % cfg.cv.method = 'loo'   - Leave-one-out cross-validation.
% 
% cfg.cv.method  = 'kfold';
% cfg.cv.nfolds  = 5;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e5;
cfg.stats.pgroup = 95;
cfg.stats.pclust = 95;
cfg.stats.shownulldis = 1;
