%% CODE TO PERFORM TEMPORAL GENERALIZATION ANALYSIS WITH CROSS-CLASIFICATION

%% MVPAlab TOOLBOX - 
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

clear; clc;

%% Initialize project and run configuration file:

    addpath(genpath('Z:/paula/toolbox/mvpalab-master'));
    cfg = mvpalab_init();

    % Select variable to perform classification on: 
    var_class = 3; % 1 : Task Demand (classify INTEGRATION vs SELECTION), 
                   % 2 : Target Category (ANIMATE vs INANIMATE)
                   % 3 : Target Relevant Feature (COLOR vs SHAPE)

    % Select variable to divide as training and testing sets
    % It cannot be the same as var_class !!!
    var_across = 2; % Across the different levels of: (1) Task Demand, (2) Target Category, (3) Target Relevant Feature

    % Stop execution if var_class = var_across
    if var_class == var_across
        disp('Error! var_class and var_across cannot be the same number');
        input("Please press Ctrl+C")
    end

    run cfg_mvcc_tempgen;
    
    %% Load data, generate conditions and feature extraction:
    
    [cfg,data,fv] = mvpalab_import(cfg);
    
    %% Compute MVPA analysis:
     [result,cfg] = mvpalab_mvcc(cfg,fv);
    
    %% Compute permutation maps and run statistical analysis:
    
    [permaps,cfg] = mvpalab_cpermaps(cfg,fv);

    stats = mvpalab_permtest(cfg,result,permaps);

%% Plot results
% Figures 4C, 4D, 4E

% Plot after having all the results, or decide what to plot inside script
 run plot_mvcc_tempgen.m