%% INST_COMP_EEG: Behavioral analysis
%  This script preprocess and sort behavioral data from the INST_COMP_EEG 
%  experiment.
%  It filters out behavioral and RT data, computes conditon-wise means both
%  for paired-sample t tests and repeated measures ANOVA.
%
%  v0: 16.02.2023
%  Code by Ana F. Palenciano (palencianoap@ugr.es) 
% 
%  v2: 
%  Changes by Paula Pena (paulapena@ugr.es)
%%
clear all
warning('OFF','MATLAB:table:RowsAddedExistingVars');
clc
%% Define basic parameters:
casa = '/Volumes/Data/paula/behavioral';
cd(casa);
sub_list = [[1:15],[17:22],[24:41]];
nruns = 16;
nruns_Loc = 8;
% Initalize results variable
results = table;

%% Subject loop
for s = sub_list
    % Initialize subject data variable
    data = table;
    % Load all runs' datafiles and append them
    for r = 1:nruns
        load(['sub_' num2str(s) '_run_' num2str(r) '.mat']);
        data = [data;block];
    end
    % Store basic variables in the results table:
    results.ID(s)  = data.Subject_ID(1);
    results.Age(s) = data.Age(1);
    results.mean_acc(s)       = nanmean(data.acc(data.Catch==0));
    results.mean_acc_Catch(s) = nanmean(data.acc(data.Catch==1));
    
    %% Fix RT variable: 
    % Take 1st (min) RT in catch trials
    index = find(cellfun(@length,data.RT)>1)';
    for i = index
        data.RT{i} = min(data.RT{i});
    end
    clear index i
    % Set omission errors RT at 2
    index = find(cellfun(@isempty,data.RT))';
    for i = index
        data.RT{i} = nan;
    end
    clear index i
    % Convert cell into double variable:
    data.RT = cell2mat(data.RT);
    
    % Compute mean RT in regular and catch trials:    
    results.mean_RT(s) = nanmean(data.RT(and(data.acc==1,data.Catch==0)));
    results.mean_RT_Catch(s) = nanmean(data.RT(and(data.acc==1,data.Catch==1)));
    
    % Compute mean % of omission error (regular trials only):
    results.omissionsErrors(s) = length(find(isnan(data.RT)&data.Catch==0 ...
        &data.acc==0))*100/length(find(data.Catch==0));
    
    %% Code target congruency
        
    %% code target congruence
    % 1 = congruent, 0: incongruent.
    data.cong = nan(height(data),1);
    data.cong(strcmp(data.attention,'SEL')&data.Target==1&data.TargetConf ==1) = 1;
    data.cong(strcmp(data.attention,'SEL')&data.Target==0&data.TargetConf ==2) = 1;    
    data.cong(strcmp(data.attention,'SEL')&data.Target==1&data.TargetConf ==2) = 0;
    data.cong(strcmp(data.attention,'SEL')&data.Target==0&data.TargetConf ==1) = 0;
    data.cong(strcmp(data.attention,'INT')&data.Target==1) = 1;
    data.cong(strcmp(data.attention,'INT')&data.Target==0&data.TargetConf ==1) = 1;
    data.cong(strcmp(data.attention,'INT')&data.Target==0&data.TargetConf ==2) = 0;  

    %%  Data filtering
    % By rt 
    mean_rt = nanmean(data.RT(data.acc==1&data.Catch==0));
    std_rt  = nanstd(data.RT(data.acc==1&data.Catch==0));
    data.RT_filt = data.RT;
    data.RT_filt(data.RT >(mean_rt+2*std_rt))= nan;
    data.RT_filt(data.RT <(mean_rt-2*std_rt))= nan;
    data.RT_filt(data.Catch==1) = nan;
    data.RT_filt(data.acc==0) = nan;
    data.RT_filt(data.RT<0) = nan; % Temporary solution to issue with negative RT
    % By acc
    data.acc_filt = double(data.acc);
    data.acc_filt(data.RT >(mean_rt+2*std_rt))= nan;
    data.acc_filt(data.RT <(mean_rt-2*std_rt))= nan;
    data.acc_filt(data.Catch==1) = nan;    
    results.mean_acc_filt(s) = nanmean(data.acc_filt);
    
    % General performance over time
    for run = 1:nruns
        results.(['mean_acc_block' num2str(run)])(s) = ...
            nanmean(data.acc_filt(data.runID==run));
        results.(['mean_rt_block' num2str(run)])(s) = ...
            nanmean(data.RT_filt(data.runID==run));
    end

    %% Accuracy mean by condition
    results.acc_SEL(s) = nanmean(data.acc_filt(strcmp(data.attention,'SEL')));
    results.acc_INT(s) = nanmean(data.acc_filt(strcmp(data.attention,'INT')));
    results.acc_ANIM(s) = nanmean(data.acc_filt(strcmp(data.category,'ANIM')));
    results.acc_INAN(s) = nanmean(data.acc_filt(strcmp(data.category,'INAN')));    
    results.acc_COLOR(s) = nanmean(data.acc_filt(strcmp(data.task,'C')));
    results.acc_SHAPE(s) = nanmean(data.acc_filt(strcmp(data.task,'S')));
    results.acc_CONG(s) = nanmean(data.acc_filt(data.cong==1));
    results.acc_INCONG(s) = nanmean(data.acc_filt(data.cong==0)); 
    
    %% RT mean by condition
    results.rt_SEL(s) = nanmean(data.RT_filt(strcmp(data.attention,'SEL')));
    results.rt_INT(s) = nanmean(data.RT_filt(strcmp(data.attention,'INT')));
    results.rt_ANIM(s) = nanmean(data.RT_filt(strcmp(data.category,'ANIM')));
    results.rt_INAN(s) = nanmean(data.RT_filt(strcmp(data.category,'INAN')));    
    results.rt_COLOR(s) = nanmean(data.RT_filt(strcmp(data.task,'C')));
    results.rt_SHAPE(s) = nanmean(data.RT_filt(strcmp(data.task,'S')));  
    results.rt_CONG(s) = nanmean(data.RT_filt(data.cong==1));
    results.rt_INCONG(s) = nanmean(data.RT_filt(data.cong==0));
    

 %% 2[Attention] * 2 [Task] * 2 [Category] rmANOVA, accuracy rates
    results.acc_SEL_C_ANIM(s) = nanmean(data.acc_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'C')&strcmp(data.category,'ANIM')));
    results.acc_SEL_C_INAN(s) = nanmean(data.acc_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'C')&strcmp(data.category,'INAN')));  
    results.acc_SEL_S_ANIM(s) = nanmean(data.acc_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'S')&strcmp(data.category,'ANIM')));
    results.acc_SEL_S_INAN(s) = nanmean(data.acc_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'S')&strcmp(data.category,'INAN')));
    results.acc_INT_C_ANIM(s) = nanmean(data.acc_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'C')&strcmp(data.category,'ANIM')));
    results.acc_INT_C_INAN(s) = nanmean(data.acc_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'C')&strcmp(data.category,'INAN')));  
    results.acc_INT_S_ANIM(s) = nanmean(data.acc_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'S')&strcmp(data.category,'ANIM')));
    results.acc_INT_S_INAN(s) = nanmean(data.acc_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'S')&strcmp(data.category,'INAN')));

    

        %% 2[Attention] * 2 [Task] * 2 [Category]  rmANOVA, response speed
     results.rt_SEL_C_ANIM(s) = nanmean(data.RT_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'C')&strcmp(data.category,'ANIM')));
    results.rt_SEL_C_INAN(s) = nanmean(data.RT_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'C')&strcmp(data.category,'INAN')));  
    results.rt_SEL_S_ANIM(s) = nanmean(data.RT_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'S')&strcmp(data.category,'ANIM')));
    results.rt_SEL_S_INAN(s) = nanmean(data.RT_filt(strcmp(data.attention,'SEL')...
        &strcmp(data.task,'S')&strcmp(data.category,'INAN')));
    results.rt_INT_C_ANIM(s) = nanmean(data.RT_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'C')&strcmp(data.category,'ANIM')));
    results.rt_INT_C_INAN(s) = nanmean(data.RT_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'C')&strcmp(data.category,'INAN')));  
    results.rt_INT_S_ANIM(s) = nanmean(data.RT_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'S')&strcmp(data.category,'ANIM')));
    results.rt_INT_S_INAN(s) = nanmean(data.RT_filt(strcmp(data.attention,'INT')...
        &strcmp(data.task,'S')&strcmp(data.category,'INAN')));

   %% ADDITIONAL RESULT MEASURES NOT NEEDED FOR THE BEHAVIORAL ANALYSIS
    
    %% Target congruence - SELECTION trials
    % Overall congurence effect
    % - accuracy
    results.acc_Cong_sel(s)   = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.cong==1));
    results.acc_Incong_sel(s) = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.cong==0));
    % - rt
    results.rt_Cong_sel(s)    = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.cong==1));
    results.rt_Incong_sel(s)  = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.cong==0));
    
    % Matching (responding "yes") / non-matching (responding "no") probes
    % - accuracy
    results.acc_Cong_Match_sel(s) = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.Target==1&data.cong ==1));    
    results.acc_Incong_Match_sel(s) = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.Target==1&data.cong ==0));
    results.acc_Cong_NonMatch_sel(s) = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.Target==0&data.cong ==1));
    results.acc_Incong_NonMatch_sel(s) = nanmean(data.acc_filt(...
        strcmp(data.attention,'SEL')&data.Target==0&data.cong ==0));
    % - rt
    results.rt_Cong_Match_sel(s) = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.Target==1&data.cong ==1));
    results.rt_Incong_Match_sel(s) = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.Target==1&data.cong ==0));
    results.rt_Cong_NonMatch_sel(s) = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.Target==0&data.cong ==1));
    results.rt_Incong_NonMatch_sel(s) = nanmean(data.RT_filt(...
        strcmp(data.attention,'SEL')&data.Target==0&data.cong ==0));
   

    %% code switch vs repeat transitions
    %  Order: ATTENTION + TASK + CAT (e.g.: repeat repeat repeat, switch
    %  repeat repeat, etc)
    switch_condition = cell(height(data),1);  
    switch_condition_att_task = cell(height(data),1); 
    switch_condition_att  = cell(height(data),1); 
    switch_condition_task = cell(height(data),1); 
    switch_condition_cat  = cell(height(data),1); 
    switch_condition_resp = cell(height(data),1); 
    for t = 2:height(data)
        if strcmp(data.attention(t),data.attention(t-1))
            switch_condition_att{t,1} = 'Rep';
            if strcmp(data.task(t),data.task(t-1))
                switch_condition_task{t,1} = 'Rep';
                switch_condition_att_task{t,1} = 'Rep_Rep';
                if strcmp(data.category(t),data.category(t-1))
                    switch_condition_cat{t,1} = 'Rep';
                    switch_condition{t,1} = 'Rep_Rep_Rep';
                elseif ~strcmp(data.category(t),data.category(t-1)) 
                    switch_condition_cat{t,1} = 'Swit';
                    switch_condition{t,1} = 'Rep_Rep_Swit';
                end
            elseif ~strcmp(data.task(t),data.task(t-1)) 
                switch_condition_task{t,1} = 'Swit';
                switch_condition_att_task{t,1} = 'Rep_Swit';
                if strcmp(data.category(t),data.category(t-1))
                    switch_condition_cat{t,1} = 'Rep';
                    switch_condition{t,1} = 'Rep_Swit_Rep';
                elseif ~strcmp(data.category(t),data.category(t-1)) 
                    switch_condition_cat{t,1} = 'Swit';
                    switch_condition{t,1} = 'Rep_Swit_Swit';
                end
            end
        elseif ~strcmp(data.attention(t),data.attention(t-1))
            switch_condition_att{t,1} = 'Swit';
            if strcmp(data.task(t),data.task(t-1))
                switch_condition_task{t,1} = 'Rep';
                switch_condition_att_task{t,1} = 'Swit_Rep';
                if strcmp(data.category(t),data.category(t-1))
                    switch_condition_cat{t,1} = 'Rep';
                    switch_condition{t,1} = 'Swit_Rep_Rep';
                elseif ~strcmp(data.category(t),data.category(t-1)) 
                    switch_condition_cat{t,1} = 'Swit';
                    switch_condition{t,1} = 'Swit_Rep_Swit';
                end
            elseif ~strcmp(data.task(t),data.task(t-1)) 
                switch_condition_task{t,1} = 'Swit';
                switch_condition_att_task{t,1} = 'Swit_Swit';
                if strcmp(data.category(t),data.category(t-1))
                    switch_condition_cat{t,1} = 'Rep';
                    switch_condition{t,1} = 'Swit_Swit_Rep';
                elseif ~strcmp(data.category(t),data.category(t-1)) 
                    switch_condition_cat{t,1} = 'Swit';
                    switch_condition{t,1} = 'Swit_Swit_Swit';
                end
            end
        end
        if strcmp(data.Resp{t},data.Resp{t-1})
            switch_condition_resp{t,1} = 'Rep';
        elseif ~strcmp(data.Resp{t},data.Resp{t-1})
            switch_condition_resp{t,1} = 'Swit';
        end
    end
    
    %% PARTIAL PRIMING COST
    %% 2[Attention] * 2 [Task] * 2 [Category] rmANOVA, accuracy rates
    results.acc_Rep_Rep_Rep(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Rep_Rep_Rep')));
    results.acc_Rep_Rep_Swit(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Rep_Rep_Swit')));
    results.acc_Rep_Swit_Rep(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Rep_Swit_Rep')));
    results.acc_Rep_Swit_Swit(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Rep_Swit_Swit')));
    results.acc_Swit_Rep_Rep(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Swit_Rep_Rep')));
    results.acc_Swit_Rep_Swit(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Swit_Rep_Swit')));
    results.acc_Swit_Swit_Rep(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Swit_Swit_Rep')));
    results.acc_Swit_Swit_Swit(s) = nanmean(data.acc_filt(...
        strcmp(switch_condition,'Swit_Swit_Swit')));
    
    %% 2[Attention] * 2 [Task] * 2 [Category] rmANOVA, response speed 
    results.rt_Rep_Rep_Rep(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Rep_Rep_Rep')));
    results.rt_Rep_Rep_Swit(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Rep_Rep_Swit')));
    results.rt_Rep_Swit_Rep(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Rep_Swit_Rep')));
    results.rt_Rep_Swit_Swit(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Rep_Swit_Swit')));
    results.rt_Swit_Rep_Rep(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Swit_Rep_Rep')));
    results.rt_Swit_Rep_Swit(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Swit_Rep_Swit')));
    results.rt_Swit_Swit_Rep(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Swit_Swit_Rep')));
    results.rt_Swit_Swit_Swit(s) = nanmean(data.RT_filt(...
        strcmp(switch_condition,'Swit_Swit_Swit')));
   
    clearvars -except casa data_all results s sbj observations nruns test
end

%% Outliers
% 1st filter : 2std dev below sample mean in overall accuracy
outlier_R = mean(results.mean_acc_filt)-2*std(results.mean_acc_filt);
% 2nd filter : performance on catch trials below chance level
outlier_C = 0.5;
results.OUTLIER = or(results.mean_acc_filt<outlier_R, ...
    results.mean_acc_Catch<outlier_C);


%% Store dataset
writetable(results,['Z:/results/behavioral/behav_data_preprocessed.csv']);

