%% Script adapted from Cross-Condition Generalization Performance (CCGP)
% and Shattering Dimensionality (SD) analyses on Bernardi et al.(2020)

clear all;
clc;

fprintf('Starting analyses \n');

addpath ('src/');

addpath(genpath('Z:/paula/toolbox/mvpalab-master'));

% Indicate conditions 
conditions = {'INT_ANIM_C','INT_ANIM_S','INT_INAN_C','INT_INAN_S',...
    'SEL_ANIM_C','SEL_ANIM_S','SEL_INAN_C','SEL_INAN_S'};

% Subject list
subjects = [1:15,17:22,24:41];

% Directories
dir.der = 'Z:/paula/inst-comp-eeg/EEG/BIDS/derivatives/';
dir.res = 'Z:/paula/inst-comp-eeg/EEG/results/ccgp/';

% Obtain all possible dichotomies of 4 and 4, based on our 8 conditions,
% and find the dichotomies corresponding to our main variables
[dichot,var_index] = obtain_dichotomy_possibilities(conditions);

%%  Loop on each of the 35 possible combinations 
for combination = 1: size(dichot,1)
    
    fprintf(['Starting combination nº ' num2str(combination) '/' num2str(size(dichot,1)) '\n']);
 
    % the conditions to classify on this dichotomy (a vs b)
    cond_a = conditions(dichot(combination,1:4));
    cond_b = conditions(dichot(combination,5:8));

   %% Prepare data for MVPA analysis on each combination

  fprintf('Preparing data... \n');
  
   for sub = subjects

        if sub < 10
            dir.cond = [dir.der 'sub-00' num2str(sub) '/eeg/ccgp/'];
        else 
            dir.cond = [dir.der 'sub-0' num2str(sub) '/eeg/ccgp/'];
        end

        if ~exist(dir.cond)
            mkdir(dir.cond);
        end
        
        prepare_data_sd(sub,cond_a,cond_b,dir,combination);

    end

   %% Perform MVPA analysis on each of the 35 combinations to later extract
   % the Shattering Dimensionality index

          fprintf('Performing MVPA analysis... \n');
          
        % Initialize project and run configuration file:
        cfg = mvpalab_init();
        run cfg_mvpa_sd.m

        % Load data, generate conditions and feature extraction:
        [cfg,~,fv] = mvpalab_import(cfg);

        % Compute MVCA analysis:
        mvpalab_mvpa_sd(cfg,fv);

        % Compute permutation maps:
        mvpalab_permaps_sd(cfg,fv);
        

        clear fv data cfg

   %% Loop on every possible train and test combination of our main variables. 
   % Always 6 conditions will be used on training 
   % (classify 3 from 3), and 2 will be left out for testing (classify 1 from 1) 

   % Find the dichotomies corresponding to our variables
   if (combination == var_index.demand) || (combination == var_index.categ)...
           || (combination == var_index.feat) 
       
    fprintf('Starting CCGP \n');
    count = 0;       
    for step_a = 1:length(cond_a)
        for step_b = 1:length(cond_b)
            
            count = count +1;
            
            %% Loop on each subject to prepare the data
           
            fprintf('Preparing data... \n');
            
            for sub = subjects
                      
                if sub < 10
                    dir.cond = [dir.der 'sub-00' num2str(sub) '/ccgp/'];
                else 
                    dir.cond = [dir.der 'sub-0' num2str(sub) '/ccgp/'];
                end


                %% Function to prepare train and test data sets according to the
                % combination of train (3 vs 3) and test conditions (1 vs
                % 1)
                prepare_train_test_ccgp(sub,step_a,step_b,cond_a,cond_b,dir,combination);
              
            end
                
                fprintf(['Performing MVCC: Step ' num2str(count) '/16 \n']);

                %% MVPA analysis
                % Initialize project and run configuration file:                
                cfg = mvpalab_init();
                run cfg_mvcc_ccgp.m
     
                % Load data, generate conditions and feature extraction:
                [cfg,data,fv] = mvpalab_import(cfg);

                % Compute MVCC analysis, 
                % only on direction A:
                mvpalab_mvcc_ccgp(cfg,fv);

                % Compute permutation maps, 
                % only on direction A:
                mvpalab_cpermaps_ccgp(cfg,fv);

                clear fv data cfg

            end
        end
  

    %% Obtain mean results and mean permutation maps per dichotomy and run statistical analyses
     fprintf(['Calculating mean CCGP of combination nº' num2str(combination) '\n']);
    
    % Stats
    cfg = mvpalab_init();
    run cfg_mvcc_ccgp.m
    
    cfg.location = [dir.res num2str(combination) '/mean_ccgp/'];
    if ~exist(cfg.location)
        mkdir(cfg.location)
    end
    
    [res_dichot,perm_dichot] = mean_res_dichot(conditions,combination,dir);
    stats = mvpalab_permtest(cfg,res_dichot,perm_dichot);

   end

end

%% Calculate Shattering Dimensionality of data per time point
% Mean decoding results and permaps of all dichotomies, then compare against
% chance (permutations). 

fprintf(['Calculating Shattering Dimensionality \n']);

% Obtain Stats
cfg = mvpalab_init();
run cfg_mvpa_sd.m

cfg.location = [dir.res 'sd'];
if ~exist(cfg.location)
    mkdir(cfg.location)
end

[res_sd,perm_sd] = compute_sd(conditions,dichot,dir);
stats = mvpalab_permtest(cfg,res_sd,perm_sd);


%% Calculate Proportion of Decodable Dichotomies per Time Point
% Obtain per time point the number of dichotomies that are signficiantly decodable

fprintf('Calculating Proportion of Decodable Dichotomies \n');
decoded_dichot = zeros(1,369);

% Obtain Stats per Dichotomy see if they are signficiantly decoded
% Loop on each of the 35 possible combinations 
for combination = 1: size(dichot,1)

    cfg = mvpalab_init();
    run cfg_mvpa_sd.m

    % Load mvpa results and permaps of the dichotomy
    load([cfg.location 'result.mat']);
    load([cfg.location 'permaps.mat']);

    % Obtain stats
    stats = mvpalab_permtest(cfg,result,permaps);
    
    % Change zeroes to ones
    dec_time_points=zeros(1,369);
    dec_time_points(1,find(stats.sigmask == 0)) = 1;
    
    % Add up the time points of significant decodable dichotomies
    decoded_dichot = decoded_dichot + dec_time_points;
    

    clear result permaps stats
end

    % Save count of significantly decodable dichotomies
    save([dir.res 'sd/decoded_dichot.mat'],'decoded_dichot');


 %% Plot the results

 % To plot the CCGP and SD mean results - Figures 4B, 5B, 5C
 run plot_mvpa_ccgp_sd.m 

 % To plot supplementary figures: Figure 4 - Supplementary 2,3,4
                                % Figure 5 - Supplementary 2
run plot_per_dichot.m
