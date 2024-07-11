
%% Basic configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'MVPA';

var_loc = {'demand','category','feature'};

cfg.location = ['Z:/paula/inst-comp-eeg/EEG/results/mvpa_' var_loc{1,var} '/']; % WHERE RESULTS ARE SAVED

dir.der = 'Z:/paula/derivatives/';

% Select conditions  (one variable per row)
cond = [{'INT'},{'SEL'};{'ANIM'},{'INAN'};...
    {'COLOR'},{'SHAPE'}];

% Indicate derivatives path and condition identifieR
cfg.study.dataPaths{1,1} = dir.der;
cfg.study.dataPaths{1,2} = dir.der;
cfg.study.conditionIdentifier{1,1} = char(cond(var,1));
cfg.study.conditionIdentifier{1,2} = char(cond(var,2));


% Subject list
subjects = [1:15,17:22,24:41];

% Name of data files
for l = 1:length(subjects)
    if l < 10

        cfg.study.dataFiles{1,1}(l) = {['sub-00' num2str(subjects(l)) '/eeg/conditions/sub-00' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(var,1)) '.mat']};
        cfg.study.dataFiles{1,2}(l) = {['sub-00' num2str(subjects(l)) '/eeg/conditions/sub-00' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(var,2)) '.mat']};

    else
        cfg.study.dataFiles{1,1}(l) = {['sub-0' num2str(subjects(l)) '/eeg/conditions/sub-0' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(var,1)) '.mat']};
        cfg.study.dataFiles{1,2}(l) = {['sub-0' num2str(subjects(l)) '/eeg/conditions/sub-0' ...
            num2str(subjects(l)) '_task-inst-comp_eeg_' char(cond(var,2)) '.mat']};

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

% cfg.powenv.uplow = 'upper' - SELect upper envelope.
% cfg.powenv.uplow = 'lower' - SELect lower envelope.

%% TRIAL AVERAGE:

cfg.trialaver.flag     = false;
% cfg.trialaver.ntrials  = 4;
% cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:

cfg.classsize.match = true;
cfg.classsize.matchkfold = true;

%% DIMENSION REDUCTION:

% cfg.dimred.method = 'none' - Diemnsion reduction disabled.
% cfg.dimred.method = 'pca'  - Principal Component Analysis.
cfg.dimred.flag    = false;
cfg.dimred.method = 'none';
% cfg.dimred.ncomp  = 10;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 4; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'     - Data smooth disabled.
% cfg.smoothdata.method = 'moving'   - Moving average method.
% cfg.smoothdata.method = 'gaussian' - Gaussian kernel.

cfg.smoothdata.method   = 'moving';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

% Train window:
cfg.tm.tpstart   = -200;
cfg.tm.tpend     = 7000;

% Test window:
cfg.tm.tpstart_  = -200;
cfg.tm.tpend_    = 7000;

% Step size (time points)
cfg.tm.tpsteps   = 5;

%% CLASSIFICATION ALGORITHM:

% cfg.classmodel.method = 'svm' - Support Vector Machine.
% cfg.classmodel.method = 'da'  - Linear Discriminant Analysis.

% cfg.classmodel.kernel = 'linear'     - Support Vector Machine.
% cfg.classmodel.kernel = 'gaussian'   - Support Vector Machine.
% cfg.classmodel.kernel = 'rbf'        - Support Vector Machine.
% cfg.classmodel.kernel = 'polynomial' - Support Vector Machine.

% cfg.classmodel.kernel = 'linear' - Discriminant Analysis.
% cfg.classmodel.kernel = 'quadratic' - Discriminant Analysis.

cfg.classmodel.method = 'da';
cfg.classmodel.kernel = 'linear';

%% PERFORMANCE METRICS:

cfg.classmodel.roc       = false;
cfg.classmodel.acc       = false;
cfg.classmodel.auc       = true;
cfg.classmodel.confmat   = false;
cfg.classmodel.precision = false;
cfg.classmodel.recall    = false;
cfg.classmodel.f1score   = false;
cfg.classmodel.wvector   = false;

%% EXTRA CONFIGURATION:

cfg.classmodel.tempgen = true;
cfg.classmodel.extdiag = false;
cfg.classmodel.permlab = false;

% Enable parallel computation by default if the Distrib_Computing_Toolbox 
% is installed: 
if license('test','Distrib_Computing_Toolbox')
    cfg.classmodel.parcomp = true;
else
    cfg.classmodel.parcomp = false;
end

%% CROSS-VALIDATIONN PROCEDURE:

% cfg.cv.method = 'kfold' - K-Fold cross-validation.
% cfg.cv.method = 'loo'   - Leave-one-out cross-validation.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;

%% PERMUTATION TEST

cfg.stats.flag   = 0;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 10000;
cfg.stats.pgroup = 95;
cfg.stats.pclust = 95;
cfg.stats.tails  = 1;
cfg.stats.shownulldis = 0;
